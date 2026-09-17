---
name: hardware-design
description: Design, review, or order a PCB with an agent. Covers requirements, part selection, datasheet-grounded values, KiCad boards generated from code, independent review, JLCPCB ordering, and bring-up. Use when the user starts or changes a board, schematic, BOM, or layout, asks for a design review, prepares a fab or assembly order, or plans measurements on a new board.
---

# Hardware design

A mistake on a board costs a new order and a few weeks of waiting. ERC and DRC will not catch most mistakes, because they only check connectivity and geometry; they have passed a board whose inductor was outside the range in the datasheet. An agent also makes its own kinds of mistakes, which are listed below. The gates in this skill are there to catch both kinds. Use the ones that fit the job. For a simple breakout board, gates 2, 5 and 8 are enough.

For the traps in KiCad generation, freerouting and JLCPCB ordering, read [references/kicad-generated.md](references/kicad-generated.md). For a design review, read [references/review.md](references/review.md).

## Mistakes an agent makes on hardware work

These all happened on a real project, some of them more than once.

**Values and part numbers from memory.** You will remember a catalogue number, a reference voltage, a pin function or an allowed inductor range with full confidence, and some of them will be wrong. Put the datasheet PDFs in the repo before you select parts. For every value that a resistor or capacitor sets, write down the equation from the datasheet, the constants as the datasheet prints them, and the page number. Look up every catalogue number in the live catalogue. When you check a pinout, check it against the pin table in the PDF, because the symbol file may have been made from the same wrong memory.

**Preferring the smallest change.** When a requirement arrives late, your first proposal will be a patch that leaves the existing design alone. Before you propose anything, ask the user whether boards have been ordered. If nothing has been ordered, a redesign costs nothing, so work out what you would build if you started from zero with this requirement, and compare the patch with that.

**Trusting inherited values.** A BOM or a schematic from an earlier session can contain errors that nobody has looked at since. Before you build on it, work out its values again from the datasheets without looking at the old numbers, and then compare. Where the two disagree, you have found something that needs attention.

**Reviewing your own work.** You will make the same assumptions in the review that you made in the design. Start a fresh agent, give it the datasheet of one IC and the part of the netlist around that IC, leave out your reasoning, and ask it what goes against the datasheet. Do not decide by reading whether two netlists are the same. Compare them with code.

**Reporting a check that you did only in part.** If you say that the silkscreen shows the right revision, you must have rendered both sides of the board and read them. In every report, say what you checked, what you did not check, and why. An area that nobody checked has not passed.

**Judging geometry.** You are weak at spatial reasoning. Write placement as explicit coordinates in code, and base it on the block plan that the user gives you. Leave routing to a router and to DRC. Do not judge the quality of a layout from a picture. Measure distances and loop areas in the board file and compare them with the layout figure in the datasheet.

The user knows things that you cannot find out alone, such as how the device will be used, what the enclosure allows, and how much a second order would hurt. Ask about these things early. Expect the user to disagree with you sometimes, and take the objection seriously, because on the project behind this skill the user's objections were right most of the time.

## Gates

1. **Situations.** Interview the user about every situation the device will be in. Include development and misuse, for example on the desk with a cable and no cell, worn on the body, charging in a bag, with an empty cell, with a cell plugged in backwards, or stored for three months. Write a table with the behaviour that is required in each situation, and check the power tree against every row. Also write down what may differ between the prototype and the product. For a prototype that exists to measure things, it must use exactly the parts of the product, and only the board size and the bench features may differ.

2. **Budgets.** Count the pins you need, the strapping pins you should avoid, and the pins that stay spare. If fewer than three are spare, propose the next larger part. Make a power budget with the current of each part in each operating mode, with datasheet pages, and calculate the runtime from it. Calculate the worst-case heat in each part and the temperature rise on the real board area. For anything that is worn or sits in a case, draw the mechanical stack-up in millimetres before you fix the board outline.

3. **Parts.** Check stock, assembly class and price in the live catalogue for every BOM line. For a part with low stock, find a second source or ask the user to accept the risk. Commit the symbols, footprints and 3D models to the repo. Keep parts and nets in one file that is the source of truth.

4. **Breadboard.** Some risks can be removed with a dev kit and breakout modules before any order, such as the pin map, the bus addresses, the firmware and the radio topology. Other risks need the real board, such as the power path, the layout and the antenna. Tell the user which is which, and propose to test the first group on a breadboard.

5. **Design.** Generate or draw the board. After every change, run ERC, DRC, the unconnected check and the schematic parity check with `--exit-code-violations`, and do not continue until all of them are at zero. Only one session writes to a board file at a time, and parallel sessions use separate worktrees. When the user makes a decision, write it into the README or the spec within the hour, in the user's words and with the date.

6. **Hazards.** List every way in which a person, a cable or a cell can damage the board, and every way in which the board can hurt a person. Think about ESD on everything that people touch, reverse polarity, short circuits, the cell temperature during charging (measured at the cell), skin temperature, the transport rules for lithium cells, and CE and RED when the device is sold or worn by other people. For each item, say whether it is protected, accepted with a reason, or still open.

7. **Independent review.** First run the fresh-agent check for each IC. Then compare the layout with the layout figure in each datasheet. Then ask a human engineer to review the board that will be ordered. A review of an earlier version does not count, because the design has changed since. Give the reviewer the schematic PDF, the value tables, the renders, and a list of the five things you are least sure about.

8. **Order.** Keep the revision string in one place in the source. Tag the commit and archive the uploaded files with their checksums. Render both sides of the board and read the silkscreen. At the factory, check that the number of assembled parts equals the number in the BOM, check pin 1 of every polarised part in the placement preview, and compare the production file that the factory returns with the files you uploaded. Stop before the payment step, because the user pays.

9. **Bring-up plan.** Write this before the boards arrive. For each open question, name the measurement that answers it, the instrument, and the result that would change the design. Give the order of the first power-up, with a current limit on the supply. Say what the prototype cannot show. For example, a larger board stays cooler than the product will.

## Report format for a review

Give each finding a severity (blocking, should fix, or note), a confidence level, and the evidence. The confidence level says whether the finding was calculated, comes from a datasheet page, or is a rule of thumb. End the report with a list of the analyses that you did not do. Sign off only when there are no blocking findings and the user has accepted every area that was not checked.

## Tools

Run KiCad without its GUI. Use `kicad-cli` for ERC, DRC, parity, renders and exports. For generation, use the Python that ships with KiCad (`pcbnew`) or write the files directly. A tool that drives the KiCad GUI does not fit a design whose source of truth is code. Prefer what ships with KiCad over a third-party framework, because such projects are often abandoned within months. Pin the version of every outside tool that the pipeline calls. Call copyleft tools as programs and do not copy their code.
