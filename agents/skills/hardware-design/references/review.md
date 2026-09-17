# Design review

## Start from an existing checklist

Work through the two lists in `github.com/azonenberg/pcb-checklist` (`schematic-checklist.md` and `layout-checklist.md`, BSD-3-Clause). Fetch the current files, because you will not remember them correctly. When an item does not apply, mark it "n/a" and give the reason. The sections below add what those lists do not cover for a battery-powered board that an agent generated and JLCPCB assembles.

## A value table for each IC

Make one row for each value that a component sets. The row has the designator, what the value does, the equation from the datasheet, the constants as the datasheet prints them (reference voltage, gain factor, bias current), the calculated result, the spread from the tolerances, and the page number. Also list the ranges that the datasheet allows for the parts around the IC, such as the inductance, the output capacitance and the ESR.

When values come from an earlier design, calculate them again without looking at the old numbers, and then compare.

Reduce the value of ceramic capacitors for DC bias. A 10 µF capacitor in 0603 with 4.2 V across it has much less than 10 µF.

## Power and battery

- Go through every row of the situations table. Check what happens with no cell, with no USB, with both, with an empty cell, and when the supply dips during a radio transmit peak.
- A charger without a power path cannot start the system when no cell is fitted. It also cannot tell the load current from the cell current, so it may never detect that the cell is full.
- Size the charge current for the smallest cell that anyone will connect. Then check the heat. A linear charger turns (V_in − V_cell) × I into heat. Calculate the temperature rise for the real board area, which for a wearable is small.
- Battery connectors have no standard polarity. Print the polarity on the silkscreen, and tell the user to measure every pack before the first connection. Write down whether reverse polarity is protected or accepted.
- A thermistor on the board measures the board. It only protects the cell when it is mounted on the cell.
- An open-drain output needs a pull-up to a rail that is present in every power state. Do not connect a strapping pin to anything that can pull it low at power-on.

## Radio and USB

- Put the antenna of a radio module outside the board edge or over a cut-out. Allow no copper, tracks or vias under or next to it on any layer. Follow the layout guide of the module vendor (for Espressif, `docs.espressif.com/projects/esp-hardware-design-guidelines`), and make the board script fail when something enters the keep-out area. The case material and the wearer's skin change the tuning of the antenna, and the certification of the module is only valid when the vendor's layout rules are followed.
- A USB-C device that only draws power needs a separate 5.1 kΩ resistor on CC1 and on CC2, an ESD array close to the receptacle, a decision about the shield connection, and D+ and D− routed together as a pair.

## Layout, after routing

A board that passes DRC can still have a poor layout. Check the following with code that reads the board file.

- Measure the distance from each decoupling capacitor to its pin, and check that there is a ground via at the capacitor pad.
- For a switching regulator, check the area of the input loop and the output loop, keep the switch node small, and keep the feedback track away from the inductor. Compare with the figure in the datasheet.
- Look for track stubs that end nowhere, vias with only one connection, and copper islands. Check that a signal that changes layers has a ground via next to it, and that the planes have no gaps under fast or sensitive tracks.
- Check that thermal pads have vias, and that the via covering for the order has been decided.
- Do not put probe pads on switching nodes, feedback nodes or nodes that carry a bias current. A pad there picks up noise and changes what you measure.
- Enter the factory limits as DRC rules, with some margin above the minimum (`jlcpcb.com/capabilities/pcb-capabilities`).
- Add fiducials and tooling holes when the assembler needs them. Check the 3D models against the footprints. Check the clearance for mating connectors and for the enclosure.

## Bench features for a prototype

A prototype for the bench is easier to work with when it has the following. Mark each one as bench-only in the source, so that the product layout leaves them out.

- A header with every rail, bus, UART and strapping pin.
- Ground pads that fit the ground spring of a scope probe.
- One 0 Ω link in each supply branch. The links are fitted, and the measuring procedure is printed on the silkscreen.
- A header where a bench supply can take the place of the cell.
- Status LEDs with their names on the silkscreen.
