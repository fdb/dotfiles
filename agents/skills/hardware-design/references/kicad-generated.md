# Traps in a generated KiCad board

These were seen with KiCad 9 and 10 on macOS, freerouting 2.4.1 and JLCPCB. Tools change, so check a line against the installed version before you depend on it.

## How the pipeline is built

One file holds the parts, the catalogue numbers, the pin tables and the map from pins to nets. Separate scripts write the schematic, write the board, and run the checks and produce the factory files. Nobody edits the generated `.kicad_*` files by hand, and a comment at the top of each file says so. The routing session is committed, so that an import gives the same board again without a new routing run.

A working example is in `~/Projects/hands-badge/hardware/` (`circuit.py`, `design.py`, `pcb.py`, `export.py`, `jlc.py`).

## How KiCad decides what is connected

KiCad builds a net from two things. The first is position: wire ends, pins and junctions that share one exact (x, y) are connected, and a wire that ends on the middle of another wire needs a junction. The second is name: labels and power symbols with the same name are connected wherever they are on the page. When one connected group ends up with two names, ERC reports `multiple_net_names`. Two pins that touch without a wire between them are not connected.

The pin of a `PWR_FLAG` symbol must have the name `~`. If it has a real name, every flag joins through that name, and all the flagged rails are shorted together.

A generator can make shorts that are invisible on screen. It happened when two stub ends landed on the same coordinate, and when one stub crossed another at the same height. Choose a stub spacing that is not a multiple of the pin pitch, keep everything on the 2.54 mm grid, and run ERC after every generation.

## Symbols and pin types

Symbols that easyeda2kicad fetches from the catalogue have every pin set to `unspecified`, which means ERC cannot find anything. Keep the pin types in an override table next to the generator. Attach the overrides in a way that fails loudly when a symbol is renamed, and treat an override that matches no part as an error. It happened once that a renamed module lost all 53 of its pin types without any message.

When several power output pins are connected in parallel, make one of them `power_out` and the others `passive`, or ERC reports a conflict. Catalogue symbols are sometimes wrong, for example in a pin function or in the pad numbering of an LED or diode. When the symbol and the datasheet disagree, follow the datasheet.

Commit the fetched symbols, footprints and 3D models. The fetch service limits the request rate (it answers HTTP 403 after too many requests), and it may not exist for ever.

## Board scripts with `pcbnew`

- Run the scripts with the Python that ships inside KiCad. The system Python does not have `pcbnew`.
- Set the net classes on a loaded board through `m_NetSettings` and then call `SaveProject()`. KiCad rewrites the `.kicad_pro` file and removes classes that were written into it by hand.
- After `Board.Remove()`, the list from `GetTracks()` is no longer valid. Save and reload the board between two removal passes.
- Keep a reference to every board object until the function ends. If an earlier board object is freed while the function still runs, KiCad 10 crashes.
- Local labels get a `/` prefix in the net names on the board. Pins that are not connected need a net named `unconnected-(REF-PIN-PadN)`, or the parity check fails.
- Place the ground stitching vias before routing. After routing, the dense fan-outs leave no room for them.
- For a via inside a pad, a 0.6 mm ring with a 0.3 mm hole is the smallest size that keeps the default clearance to tracks. An open via inside a pad draws solder away during reflow, so either order filled and capped vias or write down that you accept the risk.
- Silkscreen text smaller than 0.8 mm fails DRC.
- Keep the revision string in one constant, and let the export fail when any silkscreen text shows a different revision. A board was once ordered twice because the back side still showed the old letter.
- KiCad rewrites the `.kicad_pro` file while the project is open. Close the GUI before you regenerate, or the diff will contain changes that you did not make.

## freerouting

- Run it without a window and with the optimiser switched off: `FREEROUTING__ROUTER__OPTIMIZER__ENABLED=false java -Djava.awt.headless=true -jar freerouting.jar -de in.dsn -do out.ses -mp 40 -mt 1`. With a window, it shows error dialogs for custom pad shapes, and the optimiser can hang. The names of the settings are not in the help text. They are in the jar under `app/freerouting/settings/`. The environment variables use the prefix `FREEROUTING__`, and `__` stands for a dot.
- Mark the plane layers as `(type power)` in the DSN file. If you do not, the router puts signal tracks through the planes.
- Each run gives a different result. When a run leaves connections open, rebuild the board and route again from the start. A second run on a board that is already partly routed made the result worse.
- A pin at 0.4 mm or 0.5 mm pitch sometimes cannot be reached by the router. Give each such pin a short locked track as a starting point. After the import, delete every starting track that the router did not use. To find them, test whether the track end lies inside a pad shape, because a test against the pad centre misses some.
- Do not rely on the router's own report. The checks that count are KiCad's DRC, the number of unconnected items and the schematic parity check.
- A board that passes DRC can still have a poor layout. Compare the placement and the important current loops with the layout figure in each datasheet.

## JLCPCB

- Look up every part number. `jlc.py` sends a POST request to `jlcpcb.com/api/overseas-pcb-order/v1/shoppingCart/smtGood/selectSmtComponentList` for the assembly class, the stock and the price. `easyeda.com/api/products/<C>/components` shows which part a C-number really is. Lists of Basic parts on other websites are often out of date.
- Every Extended BOM line costs a loading fee on every order. Move the passives, switches and LEDs to Basic parts. When the circuit allows it, change a value to the nearest Basic value, and write down the new result of the calculation.
- The Economic assembly line removes parts that are only available on the Standard line, and it does not warn you. Many modules and LGA sensors are in that group. Compare the number of assembled parts with the number in the BOM.
- Leave through-hole bench headers out of the BOM and the CPL and solder them yourself. This avoids the fee for hand soldering.
- Choose ENIG for packages with 0.4 mm pitch or with pads under the body. HASL is too uneven for them.
- KiCad and JLCPCB use different rotation conventions for some footprints. Check pin 1 of every IC, diode, LED and connector in the placement preview. Check again when the factory sends its question about polarity.
- The bottom side looks mirrored in the factory's viewer. This is correct, because the viewer shows the bottom as seen through the board from the top.
- Ask for confirmation of the production file and of the parts placement. Compare the Gerber files that come back with the ones you uploaded, and count the holes.
- Before the user pays, tag the commit, archive the uploaded zip file with its checksums, and read both silkscreen sides in a render.
