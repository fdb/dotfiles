---
name: code-explainer
description: Use when the user asks to create an interactive HTML explainer, visual walkthrough, or "making of" page for a codebase, feature, protocol, spec, architecture, commit history, board design, or technical documentation. Triggered by requests like "explain this code visually", "create an explainer", "make an interactive walkthrough", "explain this protocol", "visualize the architecture". Defaults to a long-form scrolling layout with inline SVG; supports a slideshow mode when the user explicitly asks for slides.
---

# Interactive Code Explainer

Generate a self-contained HTML file that visually explains how a system works — a codebase, a protocol, a board design, an architecture — with diagrams, optional animations, and a clear narrative a non-expert reader can follow top to bottom.

## What you're producing

One `.html` file. All CSS inline. All JS inline except CDN imports. No build step. No external fonts unless the "Typography: polished mode" block is explicitly enabled. Still readable in a decade, still printable, still searchable.

## When to use

- The user asks for a "walkthrough," "explainer," "why page," "making-of," or visual teaching document.
- The user has written down a set of decisions (README, docs, commits, spec) and wants them illustrated for a broader audience.
- A README is too dry for the audience (non-engineers, new teammates, investors, interns, curious users).

Do **not** use for API reference pages, changelogs, or pure marketing pages — those have their own skills (see `landing-page`).

## Process

1. **Read the source thoroughly** — code, specs, protocol docs, commit history, architecture docs, README, or whatever the user points you at. Spend more time here than feels comfortable.
2. **Pick the layout mode**: scroll (default) or slides (only when user explicitly asks for a presentation).
3. **Identify sections** from the source material (see Sections table). Pick only what fits — not every section applies to every explainer.
4. **Write the page**, section by section, in the voice below.

## Audience

Target audience baseline: a reader who understands the domain (networking, electronics, web, whatever) at a conceptual level but doesn't live in this particular code day-to-day. Think: a technical product manager, a new teammate in their first week, a bright undergrad who hasn't taken the specific course yet.

Implications:
- Lead with **diagrams and data**, not code listings.
- Show code snippets only when they clarify a concept (a key struct, an enum of message types, a 5-line algorithm). Never dump full functions.
- Explain *why* things are designed a way, not just *what* they are.
- Every section states the question before answering it.

## The voice (most important section)

This is what separates a skill-driven explainer from a generic AI writeup. Follow it exactly.

- **Second person, present tense.** "You plug in USB, the charger wakes up…"
- **Answer the reader's actual question first.** "Why this chip?" is answered in the first paragraph, not the fourth.
- **Name the trade-off explicitly.** Every "we chose X" section contains a sentence of the form "X is worse at Y but the cost was worth it."
- **State the problem in the reader's words before jargon.** Define any term the reader might not know, inline, the first time it appears.
- **Forbidden phrases.** "Let's dive in," "In this article," "It's important to note," "As we all know." They add nothing. Cut them.
- **Use footnotes sparingly.** If it matters, it's in a `<details>` block or a callout; if it doesn't, delete it.
- **Numbers need units.** "15 mm," not "15." "300 mAh," not "300 mA." Ambiguity dissolves confidence.
- **Address mistakes.** A single "this is where first-time <role> get burned" per page earns trust.
- **Bold sparingly.** Use `<strong>` for the one sentence in a paragraph the reader must not miss. If everything is bold, nothing is.
- **Italics for emphasis only**, not for titles of things. Titles go in quotes or `<code>`.
- **Collapsibles reward curiosity without punishing the reader who just wants the story.** Pull formulas, edge cases, and "what-if" variants behind `<details>` blocks.

## Page skeleton (scroll mode, default)

```
┌─────────────────────────────────────────┐
│  HEADER                                 │
│  · mono kicker (topic · date)           │
│  · h1 (full thesis of the page)         │
│  · p.lede (1–2 sentences, who it's for) │
├─────────────────────────────────────────┤
│  NAV.TOC  (numbered anchor links)       │
├─────────────────────────────────────────┤
│  SECTION 1 — glossary                   │
│  · 4–8 terms the reader will need       │
│                                         │
│  SECTION 2 — the big picture            │
│  · one SVG of the whole system          │
│  · a table mapping its parts            │
│                                         │
│  SECTIONS 3–N — one topic each          │
│  · h2 + mono subtitle                   │
│  · plain-English framing of the problem │
│  · inline SVG or chart                  │
│  · explanation prose                    │
│  · optional <details class="deeper">    │
│  · optional <div class="callout">       │
├─────────────────────────────────────────┤
│  FOOTER                                 │
│  · provenance, companion files, date    │
└─────────────────────────────────────────┘
```

Scroll-mode requirements:
- **Single column, centred, `max-width: 68ch`.** Lines must not exceed ~80 characters.
- **Anchor links in the TOC** with `scroll-behavior: smooth`.
- **No horizontal scroll at any viewport ≥ 360 px.**
- SVG figures scale via `max-width: 100%; height: auto`.
- Sections separated by `margin: 4rem 0` and optional `<hr class="divider">`.

## Sections (pick what fits)

| Section | What it shows | Usually scroll position |
|---|---|---|
| **Glossary** | 4–8 terms the reader will need repeatedly, as `<dl>`. Always near the top. | 1 |
| **Big picture** | One diagram of the whole system, labelled, with a table mapping its parts. | 2 |
| **Data model** | Core types/interfaces, annotated; ER diagram if applicable. | body |
| **Data flow** | How data moves through the system — sankey, sequence diagram, or step-by-step annotated pipeline. | body |
| **Components / architecture** | Component tree, module diagram, or layer diagram. | body |
| **Protocol / wire format** | Packet structure, message type tables, handshake sequences. | body |
| **Timeline / history** | For commit-based or changelog-based explainers, a visual timeline. | body |
| **Design system / style** | Colour swatches, type scale, spacing system, annotated component showcase. | body |
| **Validation / testing** | Test map (unit/integration/E2E), clickable paths through the system. | body |
| **Decisions** | One section per non-obvious design choice, in the voice above. | body (often the bulk of the page) |
| **Summary / next steps** | Key decisions as a card grid; "reversibility notes" pointing to what would change if you changed your mind. | last |

Add project-specific sections when warranted (e.g., "Dialog Tree" for a Yarn Spinner app, "API Routes" for a backend, "State Machine" for complex state, "Power Tree" for a board).

## Design system

### Palette (OKLCH, dark mode, warm-cool tension)

Copy this block into `:root` verbatim. It's tuned: warm text on cool dark surfaces, two accent families (one warm, one cool), never pure black or white.

```css
:root {
  /* surfaces (cool, almost-neutral) */
  --bg:         oklch(0.18 0.008 250);   /* page background */
  --surface:    oklch(0.22 0.010 250);   /* figures, cards */
  --surface-2:  oklch(0.26 0.012 250);   /* code, inline chips, inset blocks */
  --rule:       oklch(0.32 0.010 250);   /* borders, hairlines */

  /* text (warm off-whites — never pure #fff) */
  --ink:        oklch(0.94 0.006 85);    /* primary text */
  --ink-muted:  oklch(0.74 0.010 85);    /* secondary text, captions */
  --ink-faint:  oklch(0.58 0.010 85);    /* tertiary — labels, axis ticks */

  /* accent — warm, for highlights, kicker, the one emotional beat per section */
  --accent:      oklch(0.80 0.16 50);    /* vivid warm orange */
  --accent-bg:   oklch(0.30 0.08 50);    /* dark orange wash for callouts */

  /* deep — cool, for "go deeper" content, secondary highlight */
  --deep:        oklch(0.80 0.10 200);   /* muted cyan */
  --deep-bg:     oklch(0.28 0.05 200);   /* dark teal wash */

  /* extended palette — use one at a time for data series, never all at once */
  --hue-green:   oklch(0.80 0.14 150);
  --hue-pink:    oklch(0.78 0.14 0);
  --hue-purple:  oklch(0.75 0.15 300);
  --hue-yellow:  oklch(0.85 0.14 90);
  --hue-red:     oklch(0.72 0.18 25);

  /* semantic */
  --warn:        oklch(0.82 0.14 85);

  /* syntax highlighting */
  --syn-keyword: oklch(0.75 0.15 300);
  --syn-type:    oklch(0.80 0.10 200);
  --syn-string:  oklch(0.80 0.14 150);
  --syn-number:  oklch(0.80 0.16 50);
  --syn-comment: oklch(0.58 0.010 85);
  --syn-func:    oklch(0.78 0.14 0);
}
```

**Rules:**
- Only **two** accents in active use for narrative (`--accent` and `--deep`). The extended hues are for multi-series charts, not prose callouts.
- `--accent` is the single emotional beat per section: the answer, the pick, the warning.
- `--deep` is for optional / deeper content — its muted-cool tone signals "not the main thread."
- Never pure `#000` or `#fff`. Contrast `--ink` on `--bg` is ~14:1; that's the comfort zone for long reads.

### Typography (the feature)

Default stack — system fonts, no downloads, instant:

```css
body {
  font-family:
    'Inter', -apple-system, BlinkMacSystemFont,
    'Segoe UI Variable Text', 'Segoe UI',
    'Helvetica Neue', Helvetica, Arial, sans-serif;
  font-size: 17px;
  line-height: 1.65;
  color: var(--ink);
  background: var(--bg);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-rendering: optimizeLegibility;
  font-feature-settings: "ss01", "cv11", "kern";
}

code, kbd, .mono {
  font-family:
    ui-monospace, 'SF Mono', 'JetBrains Mono',
    Menlo, Consolas, monospace;
  font-size: 0.92em;
}
```

**Polished mode** (opt-in, only when the user explicitly wants web fonts and accepts the CDN dependency): add to `<head>`:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
```

### Type scale

| Element | Size | Line-height | Weight | Letter-spacing |
|---|---|---|---|---|
| `h1` | `clamp(2rem, 4vw + 1rem, 2.75rem)` | 1.1 | 700 | `-0.02em` |
| `h2` | `1.65rem` | 1.2 | 600 | `-0.015em` |
| `h3` | `1.2rem` | 1.3 | 600 | `-0.01em` |
| body `p` | 17px | 1.65 | 400 | normal |
| `.kicker`, `.subtitle`, `.tag` (small mono labels) | 12px | 1.4 | 600 | `0.12em`, uppercase |
| `figcaption` | 15px | 1.5 | 400, italic | normal |

### Rhythm

- Section margin: `4rem 0`.
- `<hr class="divider">`: 1px, `var(--rule)`, `margin: 3rem 0`.
- First line of every paragraph carries the weight — the reader should be able to skim just the openers.
- Bold and italics are sparing; the type hierarchy carries most of the emphasis.

## Section template (scroll mode)

```html
<section id="slug">
  <h2>N. The concrete question, as a human asks it</h2>
  <p class="section-subtitle">one-line sub-hook, same voice as the kicker</p>

  <p>Open with the problem from the reader's perspective, in one paragraph.
     Define any term the reader might not know, inline.</p>

  <figure>
    <svg viewBox="0 0 700 240" role="img" aria-label="…">
      <!-- labelled diagram; see SVG Conventions -->
    </svg>
    <figcaption>One sentence. Say what the picture is showing.</figcaption>
  </figure>

  <p>Walk through the picture. Use <strong>bold</strong> only for the one
     sentence the reader must not miss.</p>

  <details class="deeper">
    <summary>Deeper: the formula / the edge case</summary>
    <p>Hidden by default. Rewards curiosity without punishing the reader
       who just wants the story.</p>
  </details>

  <div class="callout">
    <div class="tag">Tune this to your situation</div>
    <p>Use callouts for "you might do this differently" notes. Warm accent
       on the left edge.</p>
  </div>
</section>
```

## SVG conventions

- `viewBox="0 0 700 N"` — 700 wide fits the 68 ch content column. Vary N.
- **Labels are real `<text>` elements**, not paths. Uses `.svg-label` class for readability, search, translation, and accessibility.
- Rectangles for components, labelled in centre. Rounded corners `rx="6"` for chips, `rx="2"` for boards.
- **Arrows carry meaning through colour**: neutral (`--ink`) for "flow of stuff," `--accent` for "the answer/highlight," `--deep` for "secondary concern/deeper."
- Never use shadows or gradients. Flat, technical, blueprint-like.
- Two-pane "before/after" or "option A vs B" should be visible in a single figure, side-by-side, both drawn at the same scale.

Minimum SVG styles to include:

```css
svg { display: block; margin: 0 auto; max-width: 100%; height: auto; }
.svg-label       { font-family: ui-monospace, 'SF Mono', monospace; font-size: 11px; fill: var(--ink); }
.svg-label-small { font-size: 9px; }
.svg-faint       { fill: var(--ink-faint); }
.svg-muted       { fill: var(--ink-muted); }
.svg-accent      { fill: var(--accent); stroke: var(--accent); }
.svg-deep        { fill: var(--deep); stroke: var(--deep); }
```

Give the SVG a background matching `--surface` so the figure frame looks intentional, and draw strokes against that, not against the page.

## External libraries (CDN-only, optional)

Everything still ships as **one `.html` file** with no build step.

Recommended:
- **Mermaid** — sequence diagrams, flowcharts, ER diagrams, state machines.
- **Observable Plot** — declarative charts (histograms, scatterplots, bar, density, timelines). Good default for one-off data viz.
- **D3.js** — custom interactive viz when Mermaid + Plot aren't enough (sankey, chord, sunburst, force-directed).
- **Prism.js** or **highlight.js** — syntax highlighting when you'd rather not hand-annotate spans.

### Mermaid dark-theme init

```html
<script type="module">
  import mermaid from 'https://esm.sh/mermaid@11';
  mermaid.initialize({
    startOnLoad: true,
    theme: 'dark',
    themeVariables: {
      primaryColor: 'oklch(0.22 0.010 250)',
      primaryBorderColor: 'oklch(0.32 0.010 250)',
      primaryTextColor: 'oklch(0.94 0.006 85)',
      lineColor: 'oklch(0.80 0.16 50)',
      secondaryColor: 'oklch(0.26 0.012 250)',
      tertiaryColor: 'oklch(0.18 0.008 250)'
    }
  });
</script>
```

### Observable Plot dark-theme example

```html
<div id="plot"></div>
<script type="module">
  import * as Plot from "https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6/+esm";
  const chart = Plot.plot({
    style: { background: "transparent", color: "oklch(0.94 0.006 85)" },
    marks: [ Plot.rectY({length: 10000}, Plot.binX({y: "count"}, {x: Math.random})) ]
  });
  document.querySelector("#plot").append(chart);
</script>
```

## Interactivity (optional, disciplined)

Interactivity should reveal something — never decorate.

### Animations must be functional, not decorative

**Decorative animations are forbidden.** An animation that only sequentially highlights a row of boxes is noise. If removing the animation and replacing it with a single static diagram loses no information, the animation was decorative — cut it.

A **functional** animation must reveal one of:
- **State change** — values transforming (text field growing, counter incrementing, buffer draining).
- **Data transformation** — input → output side by side as the process runs.
- **Causality** — which node triggers which (a message travelling along an edge, a request fanning out).
- **Comparison** — two approaches running side-by-side. *Both panes must render visibly different content at every step.* If the panes look identical at some point, you're showing the common outcome twice. Identify the exact axis of divergence before building the comparison.
- **Traversal** — walking a real data structure in the order the algorithm visits it (BFS vs DFS on a real tree, not arbitrary box-lighting).

### Interactive patterns

- **Data-driven animation** bound to real values from the system being explained — token counts, packet sizes, actual message contents. The viewer must learn a fact they didn't know.
- **Clickable component/module tree** — click a node to show its signature / responsibility in a side panel.
- **Node-graph hover** — highlight connected edges and neighbours.
- **Before/after toggle** — one button swaps between two states of the same diagram.
- **Parameter sliders** — move a slider to see how a parameter affects the output.

## Visualization picker (match chart to data shape)

Picking the wrong shape makes the explainer look polished but teaches the wrong thing.

| Data shape | Use | Library |
|---|---|---|
| **Distribution** (how values spread) | histogram, density, hexbin, violin | Observable Plot, D3 |
| **Individual points** (each item has attributes) | scatter, beeswarm, bubble, strip | Observable Plot, D3 |
| **Time-based events** | sequence diagram, timeline, event stream, gantt | Mermaid, Plot, D3 |
| **Hierarchies** | tree map, sunburst, icicle, indented tree | D3 |
| **Networks / flows** (nodes + edges + volume) | DAG, sankey, chord, force-directed | D3 |
| **State machines** | state diagram | Mermaid |
| **Comparisons across categories** | bar, dot plot, grouped bar, slope | Observable Plot |
| **Correlations** | scatter with regression, heatmap | Observable Plot, D3 |
| **Rankings / ordered lists** | horizontal bar, dot plot with labels | Observable Plot |
| **Geographic** | choropleth, dot map | D3 + geo |

Code-behaviour pairings:
- **Streaming / async flows** → sequence diagram.
- **Data pipelines** → sankey or flow diagram.
- **Module dependencies** → DAG or indented tree.
- **Performance breakdowns** → stacked or horizontal bar per phase.
- **Request lifecycles** → timeline with phases coloured.
- **Algorithm steps** → snapshot animation walking the real data structure.

If you can't map your concept to one of these, stop and reconsider — a table or static diagram may serve better than a chart.

## Code block style (macOS chrome)

```html
<div class="code-block">
  <div class="code-header">
    <span class="code-dot red"></span>
    <span class="code-dot yellow"></span>
    <span class="code-dot green"></span>
    <span>filename.ts</span>
  </div>
  <div class="code-body">
    <!-- syntax-highlighted with span classes:
         .kw (keyword) .ty (type) .st (string)
         .nb (number) .cm (comment) .fn (function)
         .pr (property) .pu (punctuation) .tg (tag)
         .at (attr) .vl (value)
    -->
  </div>
</div>
```

Colour spans via the `--syn-*` variables in the palette.

## Slideshow mode (only when user explicitly asks)

If — and only if — the user asks for "slides," "a deck," or "a presentation," switch to slideshow layout. Default is scroll.

Slideshow requirements:
- Each section becomes a `.slide` with `data-section` attribute.
- Navigation: arrow keys, `space`, click nav dots at bottom centre, touch/swipe.
- Active slide fades in from direction of travel; exiting slide fades out opposite.
- Nav dots grouped by section with visual spacers between groups.
- Slide counter top-left; section label top-right.
- `.stagger` container animates children in sequentially on entry.
- Responsive down to 900 px; two-/three-column grids collapse at that width.
- All the voice, palette, typography, and SVG rules above still apply — only the layout changes.

## Pre-publish checklist

- [ ] Single HTML file. No build step. External libs via CDN only (esm.sh / jsdelivr / unpkg).
- [ ] All CSS inline in `<style>`, all JS inline in `<script>` (except CDN imports).
- [ ] No remote fonts unless "polished mode" was explicitly enabled.
- [ ] All SVG text is live `<text>`, not paths or raster.
- [ ] Heading levels nest correctly; exactly one `<h1>`.
- [ ] Palette is OKLCH throughout. No hex `#000` or `#fff`.
- [ ] Contrast: `--ink` on `--bg` ≥ 12:1; `--ink-muted` on `--bg` ≥ 7:1.
- [ ] Content column clamps at `max-width: 68ch`. No horizontal scroll at 360 px.
- [ ] Every decision section answers the reader's actual question in its first paragraph.
- [ ] Every "we chose X" section names the tradeoff explicitly.
- [ ] Numbers have units. No "15"; always "15 mm" or "15 ms."
- [ ] Forbidden phrases absent: "let's dive in," "in this article," "it's important to note."
- [ ] One emotional beat per section. If a section has two, split it.
- [ ] Interactive elements, if present, are **functional** (state change, transformation, causality, comparison, traversal). No decorative sequential highlighting.
- [ ] Viz choices match data shape (see picker).
- [ ] Footer carries generation date and list of companion files.

## Reference examples

- `hands-badge` repo → `docs/design_choices.html` — scroll mode, pure SVG, no CDN libs, non-EE reader audience, strong use of `<details>` for depth gating.
