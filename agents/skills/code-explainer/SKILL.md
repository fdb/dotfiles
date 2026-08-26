---
name: code-explainer
description: Use when the user asks to create an interactive HTML explainer, visual walkthrough, or "making of" page for a codebase, feature, protocol, spec, architecture, commit history, board design, or technical documentation. Triggered by requests like "explain this code visually", "create an explainer", "make an interactive walkthrough", "explain this protocol", "visualize the architecture". Produces a long-form, top-to-bottom scrolling page in which figures carry the explanation and prose threads them together.
---

# Code Explainer

**First, read `../explainer-common/core.md`** (fallback: `~/dotfiles/agents/skills/explainer-common/core.md`). It holds the voice, figure rules, style, and verification checklist. This file adds only what is specific to technical artifacts.

One self-contained HTML page that explains how a system works. Figures carry each section. Prose connects them. The reader builds from primitives up.

## When to use

- The user asks for a walkthrough, explainer, "why page", or making-of for a codebase, protocol, board, or architecture.
- A README or spec is too dry for its audience.

Not for API reference, changelogs, or marketing (`landing-page`). Not for civic, scientific, or social topics (`explorable-explanations`).

## Process

1. **Read the source.** Code, specs, commits, schematics, docs. Spend more time here than feels comfortable.
2. **Collect real values.** Run the code. Read test fixtures. Log a trace. Measure sizes and timings. Every number in a figure comes from this step.
3. **Build the concept-dependency map** (see core). Put it in a comment at the top of the HTML.
4. **Pick each section's figure.** Static by default. Apply the three interaction questions from core before adding a control.
5. **Write top to bottom.** Question, figure, pointing paragraph, bridge.
6. **Verify.** Run the full "Verify before hand-off" list from core, including the browser pass and the cold-reader test.

## Sections

Pick what the artifact needs. Typical spine:

| Section | Shows |
|---|---|
| The question | The problem the system solves, in the reader's words |
| First primitive | The smallest concept the rest builds on |
| Next primitives | One per section, each unlocking the next |
| Composition | Where two or three primitives combine |
| The full system | The whole, now readable because every part is known |
| Edge cases | One or two that illuminate the design |
| Where to go next | Source links, related reading |

Add artifact-specific sections where the map demands them: "Power tree" for a board, "Wire format" for a protocol.

## Figure picker

| Shape of the thing | Figure | Interaction only if |
|---|---|---|
| Mechanism with moving parts | Annotated SVG | A parameter has a knee the reader should find |
| State machine | Nodes and edges | A simulation drives the current state; never buttons that tint a node |
| Algorithm over a structure | Sequence of stills over real data | More than ~6 steps; then a stepper |
| Wire format | Byte-grid HTML table | Never |
| Distribution | Histogram, density (Plot) | Never |
| Time-based events | Sequence diagram, timeline | Many intermediate states; then a scrubber |
| Hierarchy | Indented tree, treemap (D3) | Never |
| Network / flow | DAG, sankey, force layout (D3) | The reader places a node and sees the effect |
| Performance breakdown | Stacked bar, flamegraph | Never |
| 3D assembly | Three.js mesh | One viewpoint hides geometry; then a rotation handle |

## Code listings

Rare and short: five to fifteen lines. Use a listing when the mechanism *is* those lines. Otherwise draw what the lines do. Style per core (`figure.listing`, no window chrome).

## Extra checks

In addition to the core list:

- [ ] Every value in every figure traces to step 2 of the process.
- [ ] Each "we chose X" names what X is worse at.
- [ ] Listings are ≤ 15 lines and each has a caption.
