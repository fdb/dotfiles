# The passes

Each pass: what to look for, what to change, and what goes wrong.

## 1. Snap spacing to a scale

Look for gaps that differ between siblings of the same role, and for an element that sits as close to the next group as to its own. `detail.offScale` names the pairs.

Use the repo's scale, or 2, 4, 8, 12, 16, 24, 32, 48. Lay out siblings with flex or grid `gap` and remove per-element margins. Grouping is the second half of the pass: a label sits close to its list (8), sections sit apart (24 or more), list rows share one value. Row padding inside a list is part of the same decision.

A screen can be on the scale and still badly grouped; a uniform 16 everywhere passes the metric and reads as one undivided column.

## 2. Drain the color

Remove gradients, glows (colored shadows with a large blur), gradient text, tinted glass surfaces and colored borders. Set surfaces to the product's neutrals. Keep only semantic color: status (good, warning, critical), a delta's direction, a category the user already knows (train lines, kiln A/B/C, calendar colors).

Write the inventory down: for each entry in `detail.hues`, what it stands for. An entry with nothing written next to it goes. Expect the screen to look dull at this point; pass 6 brings back color with a job.

## 3. One icon set

Emoji render at different optical sizes and differently per platform, so a column of them never aligns. Replace them with one family the project already uses (lucide, Phosphor, Heroicons, an in-house set) at one size and one stroke width, colored one step quieter than the label. Category markers that were emoji become a neutral dot or nothing. Items that are recognisable without an icon get none.

Don't mix families to find a missing glyph; draw it in the family's grid or leave it out.

## 4. Shared edges

Text in a column should start on one x; boxes in a column should start on one x, with their content one fixed inset further in. `detail.nearMiss` lists edges 2–8 px away from a busier edge, which is where the eye sees wobble. Fix with one inset token for boxes (nav items, inputs, cards) and margin zero for plain text, so both land on the same line.

Icons in a nav are a deliberate exception when they hang left of the text edge; say so when you leave them.

## 5. Rewrite the copy

- Headings name the content: "Week 44", "3 loans due this week". No greetings.
- Every number gets a unit or a comparison: "+3 vs week 43", "1,285 °C". Use only comparisons the product has data for.
- Sentence case for labels; uppercase with tracking only for a deliberate small eyebrow, if at all.
- No exclamation marks, no emoji, no "Oops".
- Errors say what happened and what the person can do: "Couldn't renew The Dispossessed because another reader reserved it. Return it by Thursday."
- Buttons say what happens: "Renew the other 2", not "Let's go".
- Brand chatter (AI, PRO, New ✨ badges) goes unless it changes what the user can do.

## 6. Give color a job; honest charts

Reintroduce color where it encodes something, and make each hue mean one thing across the screen: if Kiln B is blue in the sidebar, it is blue in the chart and nowhere else. One accent may mark the current selection or the one value the reader came for.

Generated charts are usually decoration: rounded bars, rainbow fills, no axis, no unit, day names for data that isn't daily. Pick the chart that answers the screen's question, then add a labelled axis with a unit, a faint grid, one highlighted value with a label, and grey for the rest. Every tick label must be a value the chart reaches. If the data doesn't exist, the chart goes.

## 7. Earn the ornament

Hide each illustration, blob, sparkle and decorative image. If the screen tells you less, keep it and make it specific to the product (the video replaces clip art with the product's own card). If it tells you the same, delete it. Empty states then do two jobs: say where the person is and offer the one action that fills it, with its shortcut if there is one.

## 8. One loud thing per region

Decide what each region is for and give one element the emphasis. Values in a larger size and medium weight, labels in regular weight and a quieter color, one primary button per region with the alternative as a link or secondary button. Badges that compete with the main value go. A blurred screenshot should leave one readable thing per region. `fontSizes` and `fontWeights` show sprawl; aim for a type scale of five or six sizes and two or three weights.

## 9. Line up the numbers

Numeric columns: right-aligned, `font-variant-numeric: tabular-nums`, one format per column (same decimals, unit in the header instead of every cell), sorted in a meaningful order. Times use one format. Totals get a rule above them.

## 10. Cards by role, radii that nest

A card marks a separate object. No card with a shadow inside another card with a shadow; inner groups become rows with dividers or spacing. When rounded shapes nest, the inner radius equals the outer radius minus the padding between them (12 outer, 4 padding, 8 inner). Use two or three radii across the product.

## 11. Contrast and affordance

Body text at least 4.5:1 against its background, large text (24 px, or 18.66 px bold) and control borders at least 3:1. Labels stay visible above inputs; placeholders show an example, not the label. The primary action looks like a button. Focus is visible on every control: tab through the screen and check you can always see where you are. `detail.lowContrast` gives the ratio and the element.
