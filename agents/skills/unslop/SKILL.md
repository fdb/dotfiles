---
name: unslop
description: Clean up an AI-generated ("vibecoded") interface in measured passes - spacing scale, color drain, one icon set, shared edges, copy, meaningful color and honest charts, ornament, emphasis, numeric alignment, card nesting, contrast - with a browser script that counts the problems before and after. Use when the user says "unslop", "deslop", "this looks AI-generated", "vibecoded", "clean up this UI", "make this look designed", or asks for a design pass on a generated dashboard, page, or component.
---

# Unslop

A generated screen is a stack of plausible defaults that were never chosen against each other: a 26 px gap next to a 44 px gap, a gradient on every surface, an emoji for an icon, "Welcome back!" for a heading. Unslopping asks of every visual property where it came from. A gap comes from a spacing scale, a text edge matches another text edge, a hue stands for a thing, a word tells the person something. Properties that can't answer get snapped to a rule or deleted.

Visual explainer with before/after pairs: https://claude.ai/artifact/4SH7e6XGLePN7VnBUdQMhF

## Before changing anything

State the stopping condition: the screen's measure report at the target values agreed below, plus screenshots you inspected at desktop width, 375 px, and in both themes if the product has them.

Take a baseline with this skill's `scripts/measure.py` (it drives the installed Chrome). Screenshot the screen in each state that matters (menu open, empty, error), and save a report:

```sh
uv run ~/.agents/skills/unslop/scripts/measure.py http://localhost:5173/dashboard --root main --out before.json --screenshot before.png
```

With an agent browser tool instead, evaluate the contents of `scripts/measure.js` as a function: `(<file>)({root: 'main'})`.

Find the existing design system first: tokens, a theme file, Tailwind config, the repo's AGENTS.md. The user's words win over the repo's system, and the repo's system wins over this skill. If the repo has a spacing scale, it replaces the default one below.

Decide what keeps the product's character before you strip anything: one typeface, one color, or one kind of image. Write it down; ask the user when it isn't obvious. Every pass below removes or regularises, and with nothing kept the result converges on near-black or white, one sans, a mono for metadata and grey everywhere. That look is the next default, and a screen in it is still generic.

Scope is the visual layer and the words. Changing what the screen shows, its data, or its flow is a separate decision for the user.

## The passes, in order

The order removes noise before adding anything back. Spacing is easiest to judge while the screen is still loud; color goes next so later passes are judged on structure; color returns in pass 6 only where it carries meaning; type comes last when everything else has settled. Details, fixes and pitfalls for each pass are in [passes.md](passes.md).

| # | Pass | Report fields that should drop |
|---|------|------|
| 1 | Snap spacing to a scale, and group by proximity | `gapsOffScale`, `gapDistinct` |
| 2 | Drain the color: gradients, glows, tinted surfaces | `gradients`, `gradientText`, `glows`, `hues` |
| 3 | One icon set, one size, one stroke | `emoji` |
| 4 | Put text on shared edges | `edgeNearMisses` |
| 5 | Rewrite the copy | `multiExclamation`, `uppercaseLabels`, the `copy` examples |
| 6 | Give color a job; draw charts to scale | each entry in `hues` maps to a named meaning |
| 7 | Earn the ornament or cut it | judged on the screenshot |
| 8 | One loud thing per region | `fontWeights`, `fontSizes` |
| 9 | Line up the numbers | `numericCellsMisaligned` |
| 10 | Cards by role, radii that nest | `nestedShadows`, `radii` |
| 11 | Contrast and affordance | `lowContrastText` |

Passes 1–7 follow Damir Sokolovsky's "Unslopping a vibecoded dashboard"; 8–11 extend it. Skip a pass the screen doesn't need and say why.

Work one pass at a time. Re-run the report after each pass and look at a screenshot; a pass that improves its own metric and breaks another one is not done.

## Rules

- Fix values at their source. Generated code sets values per element; replace them with tokens or scale classes so the fix holds when the next component is added.
- Never invent data to improve copy. "+3 vs week 43" needs the week-43 number from the product. If the product doesn't have it, leave the number bare and list it for the user.
- Copy changes that need domain knowledge (which comparison matters, what a unit is called in the field) are proposals; list them for the user to confirm.
- The metrics are evidence for your eye. An icon sitting 2 px off a text edge may be optical alignment that you intend, and four hues may be the right number. Explain each metric you leave above zero.
- Contrast is measured against solid backgrounds only. `contrastUnknownOnGradient` counts text the script could not check; check those by eye or drain the gradient first.

## Finish

Re-measure with `--compare before.json`, screenshot the same states as the baseline, and report the summary numbers before → after. Then list what you left alone and why, the copy that needs the user's confirmation, and where the product's character now lives.
