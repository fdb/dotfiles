---
name: code-explainer
description: Use when the user asks to create an interactive HTML explainer, visual walkthrough, or "making of" page for a codebase, feature, protocol, spec, architecture, commit history, board design, or technical documentation. Triggered by requests like "explain this code visually", "create an explainer", "make an interactive walkthrough", "explain this protocol", "visualize the architecture". Produces a long-form, top-to-bottom scrolling page in which interactive diagrams carry the explanation and prose threads them together.
---

# Interactive Code Explainer

Generate a self-contained HTML file that explains how a system works — a codebase, a protocol, a board design, an architecture — by building the reader's understanding from primitives upward, with diagrams the reader can manipulate as the load-bearing element of each section.

## What you are producing

One `.html` file. All CSS inline. All JS inline except CDN imports. No build step, no framework. Still readable in a decade, still printable, still searchable.

The visual register is a **1970s engineering textbook**: cream paper, dark warm-gray ink, one bold accent for emphasis, no decoration that doesn't earn its place. Diagrams look like figures from a service manual — flat, labelled, technical. No drop shadows, no gradients, no glassmorphism, no glow.

## A note on scope

Long-form interactive technical writing at its best takes its authors months per piece — bespoke renderers, hand-tuned typography, dozens of revisions per figure, real research into the artifact. Those pieces are a craft tradition; do not pretend a model can match them in one sitting. **The skill borrows the structural choices that make that tradition work — concept-dependency ordering, figures the reader can manipulate, prose that points at the figures, vocabulary introduced in passing — and applies them honestly to a one-sitting artifact.** Tell the user up front: this is a structurally faithful first draft in the same family, not a finished piece in the lineage.

## When to use

- The user asks for a "walkthrough," "explainer," "why page," "making-of," or visual teaching document for a technical artifact.
- The user has written down a set of decisions (README, docs, commits, spec) and wants them illustrated for a broader audience.
- A README is too dry for the audience (non-engineers, new teammates, investors, interns, curious users).

Do **not** use for API reference pages, changelogs, or marketing pages — those have their own skills (see `landing-page`). For non-code conceptual topics (civic, scientific, social, geopolitical), use `explorable-explanations`.

## Audience

Assume a reader who is **knowledgeable but not intimately familiar** with the artifact at hand. They've shipped code, soldered a board, used networking protocols at a conceptual level — but they haven't lived inside *this* particular system. The task they've set themselves on is a notch too challenging for cold comprehension; the explainer is there to break it down.

Implications:
- Don't talk down. No "don't worry if this seems complex." Trust the reader.
- Lead with diagrams the reader can poke at. Code listings are rare and short.
- Define new terms inline, in the sentence that first uses them, not in a glossary box.
- Explain *why* things are the way they are, not only *what* they are.

## The voice (most important section)

This is what carries the explainer above a generic AI writeup. Follow it exactly.

- **Collaborative first-person plural for the system, second-person for the reader.** "Our parser walks the token stream and emits..." "We're going to use a hash map to..." "Drag the slider and watch the buffer fill." The author and reader are on the same side, examining the artifact together.
- **Address the diagram as if pointing at it.** "As you can see, the request stops at the auth middleware — the token expired ten seconds ago." "Notice how this branch never fires until the queue saturates." "Drag the slider and watch the hit ratio climb as the working set shrinks below the cache size." After every interactive figure there is a paragraph that says, in effect, *here is what to look at and what it means*.
- **Reintroduce vocabulary in passing the first time it's used.** Fold the definition into the sentence: "As the name implies, a *circular buffer* uses a fixed-size array as if its end joined back to its beginning, with two pointers tracking where to read and where to write." "The *epoll* call hands the kernel a list of file descriptors we care about and waits until at least one is ready." Don't break flow with a glossary unless the term will appear many sections away from where it was introduced.
- **Answer the reader's actual question first.** "Why this chip?" is answered in the first paragraph of the section, not the fourth. The opening line of every section names the question the section will answer.
- **Name the trade-off.** Every "we chose X" passage says, in plain words, what X is worse at. "A linked list trades random access for cheap insertion at any point — for our journal, where appends dominate, that's the right side of the trade."
- **Numbers carry units.** "15 mm," not "15." "300 mAh," not "300 mA." "150 µs round-trip," not "150 µs." Ambiguity dissolves trust.
- **Bold sparingly.** Use `<strong>` for the one sentence in a section the reader must not miss.
- **Italics for emphasis only.** Titles of things go in quotes or `<code>`.
- **Forbidden phrases.** "Let's dive in," "In this article," "It's important to note," "As we all know," "Without further ado." They add nothing.

## Process

1. **Read the source thoroughly.** Code, specs, protocol docs, commit history, architecture docs, README, schematics — whatever the user pointed at. Spend more time here than feels comfortable.
2. **Build a concept-dependency map.** This is the load-bearing planning step. (See next section.)
3. **Decide which concepts deserve a diagram.** Many will. Some won't — when prose carries the weight better than a picture would, use prose. Don't force a diagram into a section it doesn't fit.
4. **Write the page top to bottom.** Each section: name the question, show the diagram, walk the reader through it, point at the next concept the section unlocks.
5. **Verify the dependency chain.** A reader who has read sections 1 through N must be able to follow section N+1 with no outside reference. If they can't, an earlier primitive is missing.

## The concept-dependency map

Before writing any HTML, list every concept the reader needs to follow the piece end-to-end. For each concept, mark what it depends on. Topologically sort. The result is the spine of the page.

The goal: by paragraph 40 the reader is manipulating something that would have been incomprehensible at paragraph 1, and the build-up feels effortless because every primitive got its own short, illustrated section earlier.

A concrete shape (for an explainer about driving an LED matrix from a microcontroller):

```
1.  one LED + digitalWrite                 (depends on: nothing)
2.  current-limiting resistor              (depends on: 1)
3.  a row of LEDs on shared pins           (depends on: 1)
4.  the row × column matrix layout         (depends on: 3)
5.  multiplexing — one row lit at a time   (depends on: 4)
6.  the framebuffer in RAM                 (depends on: 5)
7.  a timer interrupt that drives the scan (depends on: 5, 6)
8.  PWM brightness per pixel               (depends on: 7)
9.  smooth scrolling text                  (depends on: 6, 8)
...
```

Save the map as a working scratch artifact (a comment block at the top of the HTML, or a separate `outline.md`). It's the answer to the question "why does the page have these sections in this order?" — and it's what you check against when a section feels like it's working too hard.

If the dependency map produces more than ~15 top-level concepts, the piece is too ambitious for one page. Either narrow the topic or split into multiple pages.

## Diagrams are the core, not the illustration

Treat the diagram as the explanation; treat the prose around it as connective tissue. A section without a diagram is the exception, not the norm — but exceptions are fine when the topic is genuinely textual (a protocol's wire format described as a table, a tradeoff list, a piece of pseudo-code).

A good diagram in this style:

- **Is purpose-built for its prose context.** It is not reused from another section, not copied from documentation, not generic. The labels are exactly the terms the surrounding prose uses.
- **Lets the reader manipulate something.** A slider that scrubs through time. A play/pause/step button on a state machine. A handle that rotates a 3D model. A toggle that flips between two modes. The interaction reveals a fact the static diagram could not.
- **Is comprehensible cold but becomes richer with the prose.** Even without reading the surrounding paragraphs, the reader can squint at the figure and pick up its outline; reading the prose then deepens it.
- **Is built from real values from the system.** If the diagram shows packet sizes, those are the actual sizes. If it shows a token stream, those are real tokens. Synthetic stand-in values teach the wrong thing.

### Interactive patterns that earn their place

| Pattern | When to reach for it |
|---|---|
| **Parameter slider** | A value in the system that has interesting threshold behaviour: latency vs throughput, buffer size vs drop rate, sample rate vs aliasing |
| **Scrub-through-time** | A process with stages: a packet's life cycle, a request lifecycle, a build pipeline |
| **Step / play / pause** | Algorithm walkthroughs, state machines, protocol handshakes |
| **Rotation / camera handle** | 3D objects (PCB layouts, mechanical assemblies, molecular structures) where one viewpoint hides essential geometry |
| **Before/after toggle** | A single switch flips a diagram between two equally-real states (with and without an optimization, before and after a refactor) |
| **Drag-to-place** | The reader positions an input and the system computes a consequence (place a probe, place a constraint, place a node) |

Each pattern has the same test: **what does the reader now know that they couldn't have known from a static figure?** If the answer is nothing, cut the interaction or replace it with a still.

### Renderer choices

Custom-written renderers in the canonical examples are part of why those pieces take so long. **In a single-file distillation, importing libraries is fine.** Pick by capability, not brand:

- **Inline SVG** — first reach. Static labelled diagrams, two-pane comparisons, schematic figures, flowcharts, packet layouts, ER diagrams. Live `<text>` for every label.
- **`<canvas>` + vanilla JS** — when the diagram has > ~200 moving elements or pixel-level rendering matters (heatmaps, particle systems, signal traces).
- **Three.js** (`cdn.jsdelivr.net/npm/three@0.160/+esm`) — when 3D genuinely earns it: PCB layouts that need rotation, mechanical assemblies, planetary motion, molecular structures. Skip when 3D is decorative; the 2D version is more honest more often than not.
- **PixiJS** (`cdn.jsdelivr.net/npm/pixi.js@8/+esm`) — high-throughput 2D when SVG can't keep up (10,000+ elements at 60 fps).
- **p5.js** (`cdn.jsdelivr.net/npm/p5@1/+esm`) — generative or hand-drawn-feeling diagrams; sketch-quality figures where strict precision would feel wrong.
- **D3 v7** (`cdn.jsdelivr.net/npm/d3@7/+esm`) — custom data-driven viz: scales, axes, force layouts, hierarchies, sankeys, geographic projections.
- **Observable Plot** (`cdn.jsdelivr.net/npm/@observablehq/plot@0.6/+esm`) — declarative charts on top of D3. Reach before D3 when the chart fits its grammar.
- **Mermaid** (`cdn.jsdelivr.net/npm/mermaid@11/+esm`) — sequence diagrams, state machines, ER diagrams from text. Weak as a centerpiece (not reader-driven), strong as a supporting figure.

Pin versions. Don't reach for React, Vue, Svelte, or any build-step framework — single-file means single-file.

## Page skeleton

```
┌───────────────────────────────────────────────┐
│  HEADER                                       │
│  · small mono kicker (topic · date)           │
│  · h1 (the question the page answers)         │
│  · 1–2 sentence lede (who it's for, scope)    │
├───────────────────────────────────────────────┤
│  TOC (numbered anchor links)                  │
├───────────────────────────────────────────────┤
│  SECTION 1 — first primitive                  │
│  · h2 + plain-English question                │
│  · framing paragraph                          │
│  · interactive figure                         │
│  · prose pointing at the figure               │
├───────────────────────────────────────────────┤
│  SECTIONS 2..N — each builds on prior         │
│  · same shape; primitives compound            │
├───────────────────────────────────────────────┤
│  CLOSING — back to the original question      │
│  · what the reader can now do or build        │
│  · pointers to the source                     │
├───────────────────────────────────────────────┤
│  FOOTER — provenance, date, companion files   │
└───────────────────────────────────────────────┘
```

Layout requirements:

- **Single column, centred, `max-width: 68ch`** for prose. Lines must not exceed ~80 characters.
- Figures may break out wider when needed (`max-width: 84ch`), but never edge-to-edge unless the topic is geographic or a wide timeline.
- Anchor TOC links with `scroll-behavior: smooth`.
- No horizontal scroll at any viewport ≥ 360 px.
- Sections separated by `margin: 4.5rem 0`.

## Section template

```html
<section id="slug">
  <h2>N. The concrete question, as a human asks it</h2>

  <p>Open with the problem from the reader's perspective, in one paragraph.
     Define any term the reader might not know inline.</p>

  <figure>
    <div class="fig-stage" id="fig-N">
      <!-- inline SVG or canvas; controls (sliders, buttons) live next to or
           below the stage, never floating over it. -->
    </div>
    <div class="fig-controls">
      <label>Buffer size (KB)
        <input type="range" min="1" max="64" value="8" />
      </label>
      <button type="button">Play</button>
    </div>
    <figcaption>One sentence. Say what the figure is showing.</figcaption>
  </figure>

  <p>Walk the reader through the figure. <em>"As you can see..."</em>,
     <em>"Drag the slider and watch the hit ratio climb..."</em>,
     <em>"Notice that misses cluster as soon as the working set passes
     the cache size..."</em>. This paragraph is mandatory; the figure
     does not stand alone.</p>

  <p>One more paragraph if needed: the implication, the trade-off, the
     bridge to the next section's primitive.</p>
</section>
```

**No `<details>` for primary content.** Click-to-reveal as a body mechanic punishes linear reading. Use `<details>` only for true tangents — a derivation a curious reader might want, an edge-case footnote — never for the main thread.

**No quizzes, no "test your understanding" boxes, no progress bars.** The page is self-paced. The reader sees the scrollbar and that is enough.

## Visual style: 1970s engineering textbook

### Palette (OKLCH, light paper)

```css
:root {
  /* paper — warm cream, never pure white */
  --bg:        oklch(0.97 0.012 90);    /* page background */
  --surface:   oklch(0.94 0.014 90);    /* figure stage, inset blocks */
  --surface-2: oklch(0.91 0.016 90);    /* code, callouts */
  --rule:      oklch(0.30 0.020 60);    /* hairlines, axis lines, borders */

  /* ink — dark warm gray, never pure black */
  --ink:        oklch(0.22 0.018 60);   /* primary text and figure strokes */
  --ink-muted:  oklch(0.42 0.018 60);   /* secondary text */
  --ink-faint:  oklch(0.55 0.014 60);   /* captions, axis ticks */

  /* one bold accent — signal red, the emotional beat per section */
  --accent:     oklch(0.55 0.20 28);
  --accent-bg:  oklch(0.93 0.06 28);    /* tinted block for callouts */

  /* secondary accent — steel blue, for "deeper" / secondary thread */
  --secondary:    oklch(0.50 0.12 215);
  --secondary-bg: oklch(0.93 0.04 215);

  /* third tier, used at most once per page — mustard */
  --tertiary:   oklch(0.65 0.16 90);

  /* reserved data-series hues, one at a time, never all at once */
  --hue-green:  oklch(0.55 0.14 145);
  --hue-purple: oklch(0.45 0.16 305);
}
```

**Rules.**

- Ink on paper hits ~12:1 contrast — engineering-textbook readability for long sessions.
- Two accents in active narrative use: `--accent` (red) and `--secondary` (steel blue). The reserved hues are for charts with multiple series, not for prose decoration.
- One emotional beat per section. If a section has two callouts in red, split the section.
- Never `#000` or `#fff`. The cream-and-warm-ink relationship is the whole point of the look.
- No drop shadows. No gradients. No glassmorphism. No glow. Borders are 1px solid `--rule`, period.

### Typography

The textbook register is well-served by a **sans-serif heading paired with a serif body**, but a strict sans throughout is also fine and renders faster. Default to system fonts.

```css
body {
  font-family:
    'Source Serif 4', 'Source Serif Pro', Charter, 'Iowan Old Style',
    'Apple Garamond', Cambria, Georgia, serif;
  font-size: 17px;
  line-height: 1.7;
  color: var(--ink);
  background: var(--bg);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-rendering: optimizeLegibility;
}

h1, h2, h3 {
  font-family:
    'Inter Tight', 'Inter', -apple-system, BlinkMacSystemFont,
    'Segoe UI', Helvetica, Arial, sans-serif;
  font-weight: 600;
  letter-spacing: -0.015em;
}

code, kbd, .mono, .svg-label {
  font-family: ui-monospace, 'SF Mono', 'JetBrains Mono', Menlo, Consolas, monospace;
  font-size: 0.92em;
}
```

**Polished mode** (opt-in only when the user accepts CDN font dependency): add to `<head>`:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter+Tight:wght@500;600;700&family=Source+Serif+4:opsz,wght@8..60,400;8..60,600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
```

### Type scale

| Element | Size | Line-height | Weight |
|---|---|---|---|
| `h1` | `clamp(2rem, 4vw + 1rem, 2.75rem)` | 1.15 | 600 |
| `h2` | `1.6rem` | 1.25 | 600 |
| `h3` | `1.2rem` | 1.3 | 600 |
| body `p` | 17px serif | 1.7 | 400 |
| `.kicker`, `.tag` (small mono labels) | 12px | 1.4 | 600, uppercase, `0.12em` tracking |
| `figcaption` | 14px | 1.5 | 400 italic |

### Rhythm

- Section margin: `4.5rem 0`.
- `<hr class="rule">`: 1 px solid `--rule`, `margin: 3rem 0`.
- The first sentence of every paragraph carries the weight; a reader skimming only first sentences should still get the spine.

## SVG conventions

- `viewBox="0 0 700 N"` — 700 wide fits the prose column.
- **Labels are real `<text>` elements.** Never paths, never raster, never icon fonts. This buys readability, search, translation, and screen-reader support for free.
- **Strokes are the same `--rule` ink as the prose hairlines.** A 1.25 px black line on cream is the textbook default. Reserve thicker strokes (2 px) for the one element the eye should land on first.
- **Color carries meaning.** Black/`--rule` for structure, `--accent` (red) for the highlighted element or "what to notice," `--secondary` (steel blue) for a secondary thread.
- **No shadows, no gradients, no glow.** A figure in this style looks like it could have been printed by offset lithography in 1973.
- **Fills are restrained.** Most shapes are unfilled (transparent or surface-colored) with a 1.25 px stroke. Filled shapes are used only when the fill itself is the data (a heatmap cell, a state in a state diagram).
- **Side-by-side comparisons live in one figure**, drawn at the same scale, separated by a hairline rule. Never "scroll to see the alternative."

```css
svg { display: block; max-width: 100%; height: auto; background: var(--surface); }

.svg-label       { font-family: ui-monospace, 'SF Mono', monospace;
                   font-size: 11px; fill: var(--ink); }
.svg-label-small { font-size: 9px; }
.svg-faint       { fill: var(--ink-faint); }
.svg-muted       { fill: var(--ink-muted); }
.svg-accent      { fill: var(--accent); stroke: var(--accent); }
.svg-secondary   { fill: var(--secondary); stroke: var(--secondary); }
.svg-stroke      { fill: none; stroke: var(--ink); stroke-width: 1.25; }
```

The figure stage gets a hairline border — a thin black box around the whole diagram — to mirror the printed-figure look:

```css
.fig-stage {
  background: var(--surface);
  border: 1px solid var(--rule);
  padding: 1rem;
}
```

## Code block style

Avoid the macOS-window chrome of the previous version (red/yellow/green dots) — it's pure decoration and out of register with the textbook look. A code block is just a typeset listing.

```html
<figure class="listing">
  <pre><code><span class="cm">// dispatch.ts — line 42</span>
<span class="kw">function</span> <span class="fn">dispatch</span>(<span class="pr">msg</span>: <span class="ty">Message</span>) {
  <span class="kw">switch</span> (<span class="pr">msg</span>.<span class="pr">kind</span>) {
    <span class="kw">case</span> <span class="st">"open"</span>: <span class="kw">return</span> <span class="fn">handleOpen</span>(<span class="pr">msg</span>);
    <span class="kw">case</span> <span class="st">"close"</span>: <span class="kw">return</span> <span class="fn">handleClose</span>(<span class="pr">msg</span>);
  }
}</code></pre>
  <figcaption>The dispatch loop reduces to a switch on <code>msg.kind</code>.</figcaption>
</figure>
```

```css
figure.listing {
  background: var(--surface-2);
  border-left: 3px solid var(--ink);
  padding: 1rem 1.25rem;
}
.listing pre   { font-family: ui-monospace, monospace; font-size: 14px;
                 line-height: 1.55; color: var(--ink); margin: 0; overflow-x: auto; }
.listing .kw   { color: var(--accent); font-weight: 600; }
.listing .ty   { color: var(--secondary); }
.listing .fn   { color: var(--ink); font-weight: 600; }
.listing .st   { color: var(--hue-green); }
.listing .nb   { color: var(--accent); }
.listing .cm   { color: var(--ink-faint); font-style: italic; }
.listing .pr   { color: var(--ink); }
```

Listings are short. Five to fifteen lines, almost always. If you need to show 80 lines, the reader needs a diagram of what those lines do, not the lines themselves.

## Sections (pick what fits the artifact)

| Section | What it shows |
|---|---|
| **The question** | Open with the actual problem the system solves, in the reader's words |
| **First primitive** | The smallest concept the rest will build on |
| **Each subsequent primitive** | One per section, each unlocking the next |
| **Composition** | The point where two or three primitives combine into something new |
| **The full system** | A diagram of the whole, now comprehensible because every part has been introduced |
| **Edge cases worth seeing** | One or two cases that illuminate the design — not exhaustive |
| **Where to go next** | Pointers to source, related reading, the actual code |

Project-specific sections naturally appear: a "Power Tree" for a board, a "Wire Format" for a protocol, a "Dialog Tree" for a narrative-game system. Add them where the dependency map demands.

## Visualization picker (match shape to data)

| Shape of the thing | Use | Library |
|---|---|---|
| **Mechanism with moving parts** | annotated SVG with sliders/play | hand-rolled SVG, sometimes Three.js for 3D |
| **State machine** | nodes-and-edges with current-state highlight | hand-rolled SVG or Mermaid |
| **Algorithm walking a structure** | snapshot stepper over the real data | hand-rolled SVG with step button |
| **Distribution** | histogram, density, hexbin | Observable Plot |
| **Time-based events** | sequence diagram, timeline | Mermaid, Observable Plot |
| **Hierarchy** | indented tree, treemap, sunburst | D3 |
| **Network / flow** | DAG, sankey, force-directed | D3 |
| **Wire format** | byte-grid table with field labels | hand-rolled HTML table |
| **Performance breakdown** | stacked bar, flamegraph | Observable Plot or D3 |
| **Geographic** | choropleth, dot map | D3 + geo or MapLibre |
| **3D mechanism / assembly** | rotatable mesh | Three.js |

If a topic doesn't map to one of these, a still figure with strong labels often beats a forced chart.

## Pre-publish checklist

- [ ] Single HTML file. CDN libraries via ESM imports only. No build step.
- [ ] Concept-dependency map exists (in a comment block at the top of the HTML, or a sibling `outline.md`). Section order matches it.
- [ ] Every section either has an interactive figure or is a deliberate prose interlude with a clear reason.
- [ ] Every figure is followed by a paragraph that points at the figure ("as you can see," "drag the slider...," "notice that...").
- [ ] Voice: collaborative "we" / "our system," second-person "you" for the reader's actions.
- [ ] First time a term appears, it's defined in the same sentence.
- [ ] Numbers carry units. "150 µs," not "150."
- [ ] One emotional beat (red callout / `<strong>`) per section maximum.
- [ ] Forbidden phrases absent: "let's dive in," "in this article," "it's important to note."
- [ ] No `<details>` blocks holding primary content. (Tangential footnotes are fine.)
- [ ] No quizzes. No progress bars. No completion indicators.
- [ ] No decorative animation. Every motion reveals state, transformation, causality, comparison, or traversal.
- [ ] Palette is OKLCH cream-and-ink. No `#000` or `#fff`.
- [ ] Contrast: `--ink` on `--bg` ≥ 12:1; `--ink-muted` on `--bg` ≥ 7:1.
- [ ] Content column clamps at `max-width: 68ch`. No horizontal scroll at 360 px.
- [ ] All SVG text is live `<text>`, not paths.
- [ ] All sliders/play buttons/toggles are keyboard-operable. `prefers-reduced-motion` respected.
- [ ] Footer carries generation date, source link, list of companion files.

## Reference register

The shape and voice this skill targets — short, illustrated sections that compound; diagrams that reward manipulation; a tone that walks the reader through what they're looking at — is the register of long-form engineering writers who treat the figure as the explanation. We're producing a one-sitting distillation of that style, not a months-long opus. Set the user's expectations accordingly.
