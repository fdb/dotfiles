---
name: explainer
description: Use when the user asks for a visual explainer, interactive walkthrough, explorable explanation, playable essay, or scrollytelling page. Covers two kinds of subject. Technical artifacts — a codebase, feature, protocol, spec, architecture, board design, commit history. Concepts and phenomena — scientific, social, political, economic, historical, or public-interest topics. Triggered by "explain this code visually", "create an explainer", "make an interactive walkthrough", "visualize the architecture", "make an explorable explanation", "build a playable essay", "scrollytelling piece for X", or references to Bartosz Ciechanowski, Nicky Case, Bret Victor, Parable of the Polygons, Distill, Mathigon, explorabl.es. Produces one self-contained HTML page in which figures carry the explanation and prose threads them together.
---

# Explainer

One self-contained HTML page that explains how something works. Figures carry each section. Prose connects them. The reader builds from primitives up.

## Pick the track

Read this file fully. Then read one track file from this directory:

- **`technical.md`** — the subject is a codebase, protocol, spec, architecture, board, or other artifact with source you can read and run.
- **`concept.md`** — the subject is a concept or phenomenon: scientific, social, political, economic, historical, or public-interest. The reader should produce the phenomenon with a model.

Not for API reference, changelogs, or marketing pages (`landing-page`).

## Output

One `.html` file. Inline CSS in `<style>`. Inline logic in `<script type="module">`. Libraries only via pinned ESM imports from a CDN. No build step. No framework.

Visual register: **1970s engineering textbook**. Off-white paper, off-black ink, sans-serif body, one red accent. Figures look like they were printed by offset lithography: flat, labelled, 1 px strokes. No shadows, gradients, glow, or glassmorphism.

## Audience

The reader is knowledgeable but has not lived inside this subject. Do not talk down. Define each new term in the sentence that first uses it. Explain *why*, not only *what*.

## Voice

- "We" for the author and system. "You" for the reader. "Our parser walks the tokens." "Drag the slider."
- After every figure, one paragraph points at it: "Notice that the curve barely moves until 0.4." This paragraph is mandatory.
- Open each section with the question it answers.
- Name the trade-off for every choice. Say what the chosen option is worse at.
- Numbers carry units. "150 µs", not "150".
- One `<strong>` per section at most. Italics for emphasis only.
- Never write: "let's dive in", "in this article", "it's important to note", "as we all know", "without further ado".

## Concept-dependency map

Before any HTML, list every concept the reader needs. Mark what each depends on. Sort topologically. Section order follows this sort.

```
1. one LED + digitalWrite        (depends on: nothing)
2. current-limiting resistor     (depends on: 1)
3. row × column matrix           (depends on: 1)
4. multiplexing                  (depends on: 3)
```

Keep the map in a comment block at the top of the HTML. More than ~15 concepts: narrow the topic. When a section feels hard to write, a primitive is missing earlier.

## Figures

The figure is the explanation. Prose connects figures. Most sections have one figure. A section with no figure is fine when the topic is textual (a definition, a trade-off list).

Rules for every figure:

- **One figure, one idea.** If a figure needs two captions, split it.
- **Labels are the terms the prose uses.** Same words, same case.
- **Values are real.** Run the code, read the fixtures, log a trace, or cite the paper. Never invent numbers. Label estimates `(assumption)`.
- **Comparisons sit side by side in one figure**, at the same scale. Never "scroll to see the alternative".
- **Comprehensible cold.** A reader who only looks at figures gets the spine.

### Static is the default

A labelled still is the normal figure. Pick from:

| Static pattern | Use when |
|---|---|
| Annotated diagram | One mechanism, labelled parts, one accent on the part to notice |
| Side-by-side pair | Two states or two designs, same scale, hairline between them |
| Sequence of stills | A process with 3–6 stages that fit on the page together |
| Table | Enumerated items: levels, fields, options, byte layouts |
| Chart | One relationship in real data, with axes and units |

### When interaction earns its place

Add a control only if all three answers are yes:

1. **Does the figure change state?** The control changes content, values, or geometry. Not emphasis. A highlight, a colour change, or a scroll is not state.
2. **Does the new state carry information?** The reader learns something the old state did not show.
3. **Would the static version lose something?** Lay every state side by side. If that teaches the same thing, use the stills.

Rules that follow:

- **Highlight is not state.** No buttons whose only effect is to highlight a visible element. Point with prose instead: "look at the second row".
- **Enumeration is not interaction.** A control that walks a fixed list of N items is a list of N items. Show them.
- **One control, one consequence.** Each control changes one thing, and the figure shows the consequence.

Bad: a four-level quality ladder with four buttons. Each button tints one row. All four rows are already visible. The buttons add a step and nothing else.

Good: the same ladder as a four-row figure. The prose says "the third row is where most arguments stop." No controls.

Good: a slider for cache size over a plot of hit ratio. Moving the slider recomputes the curve (state changes), the knee of the curve moves (information), and no set of stills shows the continuous knee (static loses).

| Interactive pattern | Use when |
|---|---|
| Parameter slider | A value with threshold behaviour; the reader finds the knee |
| Scrub through time | A process whose intermediate states matter and are many |
| Step / play / pause | An algorithm or simulation the reader should run at their pace |
| Drag to place | The reader sets an input; the system computes a consequence |
| Before/after toggle | Two full states of one large figure that cannot fit side by side |
| Rotation handle | 3D geometry where one viewpoint hides essential structure |

Controls sit below or beside the stage, never over it. Every control works with the keyboard. Text that changes with interaction lives in a fixed-`min-height` box so the figure does not jump.

## Renderers

Inline SVG first. Then, by need:

| Need | Library (pinned ESM) |
|---|---|
| > ~200 moving elements, pixel work | `<canvas>` + vanilla JS |
| Scales, axes, force, hierarchy, sankey, geo | `https://cdn.jsdelivr.net/npm/d3@7/+esm` |
| Declarative charts | `https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6/+esm` |
| 10 000+ sprites at 60 fps | `https://cdn.jsdelivr.net/npm/pixi.js@8/+esm` |
| 3D that the mechanic needs | `https://cdn.jsdelivr.net/npm/three@0.160/+esm` |
| Sketch-quality generative figures | `https://cdn.jsdelivr.net/npm/p5@1/+esm` |
| 2D rigid-body physics | `https://cdn.jsdelivr.net/npm/matter-js@0.19/+esm` |
| Scroll-driven choreography | GSAP + ScrollTrigger, or Scrollama for the light case |
| Sound as evidence | Tone.js, reader-triggered only |
| Real basemaps | MapLibre GL JS |
| Sequence/state diagrams as support figures | `https://cdn.jsdelivr.net/npm/mermaid@11/+esm` |

Do not import React, Vue, Svelte, jQuery, Tailwind, Bootstrap, Lottie, or Moment.

## Layout and style

Inline the `:root{}` block from `engineering-textbook.css` (this directory). Then:

- Prose column `max-width: 68ch`, centred. Figures may widen to `84ch`.
- Section gap `4.5rem`. Hairlines `1px solid var(--rule)`.
- Never `#000` or `#fff`. `--ink` on `--bg` is about 9:1. `--ink-muted` is about 3.8:1: captions and labels only, never body text.
- Body: system sans, `1.2em / 1.6em`. Headings: `Inter Tight` fallback stack, weight 600. Code: `ui-monospace`.
- Google Fonts only if the user opts in.
- SVG: `viewBox="0 0 700 N"`. Every label is a live `<text>` element. Strokes `1.25px var(--ink)`; `2px` for the one element to notice. Most shapes unfilled. Colour carries meaning: `--accent` for "notice this", `--secondary` for a second thread.
- Figure stage: `background: var(--surface); border: 1px solid var(--rule); padding: 1rem`.
- Code listings: `figure.listing` with a 3 px left rule on `--surface-2`. No window chrome. Five to fifteen lines. Longer code needs a diagram, not a listing.
- Exactly one `<h1>`. Heading order correct. No horizontal scroll at 360 px.

Page shape: header (kicker, h1 as the question, one-sentence lede) → numbered TOC → sections in map order → closing that returns to the question → footer with date and source links.

Section shape: `h2` as a question → framing paragraph → `<figure>` with stage, controls, one-sentence `figcaption` → pointing paragraph → bridge to the next section.

## Do not build

- `<details>` or click-to-reveal for body content. Tangents only.
- Quizzes, progress bars, completion indicators, percent-read.
- Decorative animation. Motion shows state change, transformation, or traversal, or it does not exist.
- Autoplay audio.
- A story-mode/explorer-mode toggle. One reading path.

## Verify before hand-off

Automated checks miss perceptual and pedagogical failures. Do all three parts. The track file may add more.

**Look at it.** Open the page in a browser.

- [ ] No console errors.
- [ ] Click every control. Say what changed. If the answer is "a highlight" or "it scrolled", remove the control and lay the states out statically.
- [ ] Drag every slider end to end. The figure and controls do not move on the page.
- [ ] Every colour word in the prose ("the red line") is visible in the figure.
- [ ] Every legend entry has a swatch that matches its mark.
- [ ] Width 360 px: no horizontal scroll.
- [ ] Keyboard only: every control reachable and operable.
- [ ] `prefers-reduced-motion: reduce`: page still works and reads.

**Cold-reader test.** Give the page to a fresh subagent that has not seen the source. Ask what it understood after 60 seconds. If it cannot state the central idea in its own words, fix the figures, not the prose.

**Text checks.**

- [ ] Section order matches the dependency map in the header comment.
- [ ] Every figure has a pointing paragraph after it.
- [ ] Voice: "we" for the system, "you" for the reader. Forbidden phrases absent.
- [ ] Terms defined at first use. Numbers carry units.
- [ ] At most one `<strong>` per section.
- [ ] No `#000`, no `#fff`. All SVG text is `<text>`.
- [ ] Footer has date and source links.

## Exemplars

Read one before you start if the register is unfamiliar.

- Bartosz Ciechanowski, https://ciechanow.ski/ — *Mechanical Watch*, *GPS*, *Sound*. The bar for compounding figures.
- Distill, https://distill.pub/ — the same register for research papers.
- Mathigon, https://mathigon.org/ — textbook as interactive primitives.
- Nicky Case, https://ncase.me/ — *Parable of the Polygons*, *To Build a Better Ballot*. The reader produces the phenomenon.
