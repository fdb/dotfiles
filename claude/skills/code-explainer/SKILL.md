---
name: code-explainer
description: Use when the user asks to create an interactive HTML explainer, visual walkthrough, or "making of" page for a codebase, feature, protocol, spec, architecture, commit history, or technical documentation. Triggered by requests like "explain this code visually", "create an explainer", "make an interactive walkthrough", "explain this protocol", "visualize the architecture".
---

# Interactive Code Explainer

Generate a self-contained HTML file that visually explains how a system works — with animations, interactive diagrams, and step-by-step navigation.

## Process

1. **Read the relevant source** thoroughly — code, specs, protocol docs, commit history, architecture docs, or whatever the user points you at
2. **Identify sections** from the source material (see Section Template below)
3. **Generate a single HTML file** with all CSS/JS inline — external libraries allowed only via CDN

## Audience

Target audience: a technical product manager who understands networking/systems concepts but doesn't live in the code day-to-day.

Implications:
- Lead with **diagrams and data structures**, not code listings
- Show code snippets only when they clarify a concept (e.g., a key struct definition, an enum of message types)
- Never dump full functions or files — extract the 5-10 lines that matter
- Explain *why* things are designed a way, not just *what* they are

## Sections

Analyze the source material and create slides for each applicable section. **Pick what fits** — not every section applies to every explainer:

| Section | What to show |
|---------|-------------|
| **Title** | Project name, tech stack badges, nav instructions |
| **Data Model** | Core types/interfaces with annotated code blocks; entity relationship diagrams if applicable |
| **Data Flow** | How data moves through the system — animated pipeline diagram with "Animate" button |
| **Components / Architecture** | Interactive component tree (click to inspect), module diagram, or layer diagram |
| **Protocol / Wire Format** | Packet structure diagrams, message type tables, sequence diagrams for handshakes/exchanges |
| **Timeline / History** | For commit-based or changelog-based explainers, a visual timeline of changes |
| **Design System / Style** | Color swatches (hover for usage), typography scale, spacing system, component showcase with annotated classes |
| **Validation / Testing** | Test map (unit vs E2E vs integration), clickable test paths through the system |
| **Summary** | Key architectural decisions in card grid |

Add project-specific sections when the material warrants it (e.g., "Dialog Tree" for a Yarn Spinner app, "API Routes" for a backend, "State Machine" for complex state).

## External Libraries

CDN-loaded libraries are permitted via `esm.sh` or `unpkg`. Everything still ships as **one `.html` file** with no build step.

Recommended libraries:

- **Mermaid** — sequence diagrams, flowcharts, entity-relationship diagrams, state machines
- **Observable Plot** — fast, declarative charts (histograms, scatterplots, bar charts, density plots, timelines). Great default for one-off data visualizations.
- **D3.js** — custom interactive visualizations when Mermaid + Plot aren't expressive enough (sankey, chord, sunburst, force-directed graphs, custom layouts)
- **Prism.js** or **highlight.js** — syntax highlighting (alternative to manual span classes)

Load via `<script type="module">` with esm.sh / jsdelivr imports or `<script src="https://unpkg.com/...">`.

### Observable Plot example

A minimal Plot chart fits in a few lines. Drop it into any slide:

```html
<div id="myplot"></div>
<script type="module">
  import * as Plot from "https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6/+esm";
  const plot = Plot.rectY({length: 10000}, Plot.binX({y: "count"}, {x: Math.random})).plot();
  document.querySelector("#myplot").append(plot);
</script>
```

Style Plot output to match the dark theme by passing `{style: {background: "transparent", color: "#e8e8f0"}}` to `.plot()`, or override via CSS on `svg` inside the container.

### Mermaid Integration

Initialize Mermaid with the dark theme to match the explainer design system:

```html
<script type="module">
  import mermaid from 'https://esm.sh/mermaid@11';
  mermaid.initialize({
    startOnLoad: true,
    theme: 'dark',
    themeVariables: {
      primaryColor: '#1a1a26',
      primaryBorderColor: '#3a3a52',
      primaryTextColor: '#e8e8f0',
      lineColor: '#fb923c',
      secondaryColor: '#22222e',
      tertiaryColor: '#12121a'
    }
  });
</script>
```

Useful diagram types:

- **Sequence diagrams** — protocol flows, API call chains, handshake sequences
- **Flowcharts** — decision logic, state transitions, request routing
- **ER diagrams** — data models, table relationships, struct hierarchies
- **State diagrams** — lifecycle states, connection states, mode transitions

Mermaid renders into SVG automatically. Override `.mermaid svg` styles as needed to fit the dark theme.

## Design System

Use this exact design system for the explainer itself:

```
Fonts: Outfit (display), JetBrains Mono (code) — Google Fonts
Background: #0a0a0f (deep), #12121a (surface), #1a1a26 (card), #22222e (elevated)
Borders: #2a2a3a (default), #3a3a52 (bright)
Text: #e8e8f0 (primary), #9898b0 (secondary), #5e5e78 (muted)
Accents: orange-400 #fb923c, orange-500 #f97316, cyan-400 #22d3ee, green-400 #4ade80, pink-400 #f472b6, purple-400 #c084fc, yellow-400 #facc15, red-400 #f87171
Syntax: keyword=#c084fc, type=#22d3ee, string=#4ade80, number=#fb923c, comment=#5e5e78, function=#f472b6
```

## Slide Engine Requirements

The HTML must include:

- **Slide navigation**: Arrow keys, click nav dots, touch/swipe
- **Section grouping**: `data-section` attributes on slides, section label in top-right, slide counter in top-left
- **Staggered entrance**: Children of `.stagger` containers animate in sequentially
- **Slide transitions**: Active slide fades in from direction of travel; exiting slide fades out in opposite direction
- **Nav dots**: Bottom-center, grouped by section with spacers between groups
- **Responsive**: Works at 900px+ (two-col/three-col grids collapse to single column below)

## Interactive Elements

Include at least 2-3 of these per explainer — but follow the rule below first.

### Animations must be functional, not decorative

**Decorative animations are forbidden.** An animation that only sequentially highlights a row of boxes is noise — it tells the viewer nothing they couldn't learn by reading the labels. Don't ship it.

A functional animation must reveal *something about the behavior* of the system:

- **State change** — show values transforming (e.g., a text field growing as tokens stream in, a counter incrementing, an array filling up, a buffer draining)
- **Data transformation** — show input → output side by side as a process runs (e.g., raw JSON on the left being compressed on the right, a tokenizer splitting text into tokens)
- **Causality** — show which node triggers which (e.g., a message traveling along an edge, a request fanning out to workers)
- **Comparison** — show two or more approaches running side-by-side so the viewer can see the difference (e.g., sync vs async timing, with vs without caching)

  **Critical rule for comparison animations**: both panes must render *visibly different content* at every step. If your two panes look identical at some point, the comparison isn't working — you're showing the common outcome twice instead of the differing inputs or operations.

  Before building a comparison, identify the exact axis where the two approaches differ:
  - If the final result is the same but the *process* differs → show the intermediate state that diverges (e.g., "what the API yields at each tick", "what the accumulator variable holds", "which branch runs")
  - If the process is the same but the *inputs* differ → show both inputs distinctly, not just the identical output they produce
  - If both process and output differ → show both, clearly labeled

  Each pane should have at minimum: (1) an "input" row showing what arrived or was given this step, and (2) an "output" row showing what the code produced. The input row is where the divergence must be visible.
- **Traversal** — walk through a real data structure in the order the algorithm would visit it (e.g., BFS vs DFS on a tree, not just lighting up nodes in arbitrary sequence)

Rule of thumb: if you can remove the animation and replace it with a single static diagram without losing information, the animation was decorative. Cut it.

### Patterns to use

- **Data-driven animation**: bind animated elements to real values from the system being explained — token counts, packet sizes, node depths, actual message contents. The viewer should learn a fact they didn't know.
- **Clickable component/module tree**: click a node to show its code signature / responsibility in a side panel
- **Node graph hover**: highlight connected edges and neighbors in a tree/graph structure
- **Before/after toggles**: one button swaps between two states of the same diagram to show what a change does
- **Parameter sliders**: move a slider to see how a parameter affects the output (e.g., chunk size vs throughput)
- **Annotated code blocks**: macOS-style header with filename, syntax-highlighted with `<span>` classes or a highlighting library

## Choose Visualizations by Data Shape

Match the chart type to the *kind* of data the concept produces. Picking the wrong shape makes the explainer look polished but teaches the wrong thing.

| Data shape | Use | Library |
|---|---|---|
| **Distribution** (how values spread across a range) | histogram, density plot, hexbin, violin plot | Observable Plot, D3 |
| **Individual points** (each item has attributes) | scatterplot, beeswarm, bubble chart, strip plot | Observable Plot, D3 |
| **Time-based events** (ordered by when they happen) | sequence diagram, timeline, event stream, gantt | Mermaid (sequence/gantt), Plot, D3 |
| **Hierarchies** (parent/child containment) | tree map, sunburst, icicle, indented tree | D3 |
| **Networks / flows** (nodes connected by edges or quantities) | DAG, sankey, chord diagram, force-directed graph | D3 |
| **State machines** (discrete states + transitions) | state diagram | Mermaid |
| **Comparisons across categories** (A vs B vs C) | bar chart, dot plot, grouped bar, slope chart | Observable Plot |
| **Correlations** (relationship between two variables) | scatterplot with regression, heatmap | Observable Plot, D3 |
| **Rankings / ordered lists** (top N, leaderboards) | horizontal bar, dot plot with labels | Observable Plot |
| **Geographic data** | choropleth, dot map | D3 + geo |

When the explainer covers *code behavior* specifically, prefer these pairings:

- **Streaming / async flows** → sequence diagram (showing actors + time axis)
- **Data pipelines** → sankey or flow diagram (showing what volume flows where)
- **Module dependencies** → DAG or indented tree
- **Performance breakdowns** → stacked bar or horizontal bar per phase
- **Request lifecycles** → timeline with phases colored
- **Algorithm steps** → snapshot animation walking the real data structure

If you can't map your concept to one of these, stop and reconsider — the concept may not warrant a chart, and a table or static diagram may serve better.

## Code Block Style

```html
<div class="code-block">
  <div class="code-header">
    <span class="code-dot red"></span>
    <span class="code-dot yellow"></span>
    <span class="code-dot green"></span>
    <span>filename.ts</span>
  </div>
  <div class="code-body"><!-- syntax highlighted with span classes: .kw .ty .st .nb .cm .fn .pr .pu .tg .at .vl --></div>
</div>
```

## Quality Checklist

- [ ] Single HTML file. External libraries allowed only via CDN (esm.sh / unpkg). No build step.
- [ ] All CSS inline in `<style>`, all JS inline in `<script>` (except CDN imports)
- [ ] Every slide has `data-section` attribute
- [ ] Keyboard (arrows, space), mouse (nav dots), and touch (swipe) navigation all work
- [ ] Diagrams preferred over code blocks for explaining flow and architecture
- [ ] Code snippets show only key data structures and signatures, not full implementations
- [ ] At least 2 interactive/animated elements, each of which is **functional** (reveals a state change, transformation, causality, comparison, or traversal) — never decorative sequential highlighting
- [ ] Visualization choices match the data shape (see Visualization Picker table)
- [ ] Cards have hover effects (lift + glow)
- [ ] Background has subtle radial gradient texture + grid overlay
- [ ] No horizontal scrolling at 1024px+ viewport width
