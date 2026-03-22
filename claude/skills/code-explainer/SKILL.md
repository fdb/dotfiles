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
- **D3.js** — custom interactive visualizations when Mermaid isn't expressive enough
- **Prism.js** or **highlight.js** — syntax highlighting (alternative to manual span classes)

Load via `<script type="module">` with esm.sh imports or `<script src="https://unpkg.com/...">`.

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

Include at least 2-3 of these per explainer:

- **Animated data flow**: Pipeline boxes that light up sequentially on button click
- **Clickable component/module tree**: Click a node to show its code signature in a side panel
- **Color swatch grid**: Hover reveals usage context
- **Test path animation**: Click a path to animate traversal through nodes
- **Node graph**: Hover to highlight connected edges and neighbors (for tree/graph structures)
- **Annotated code blocks**: macOS-style header with filename, syntax-highlighted with `<span>` classes or a highlighting library

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
- [ ] At least 2 interactive/animated elements
- [ ] Cards have hover effects (lift + glow)
- [ ] Background has subtle radial gradient texture + grid overlay
- [ ] No horizontal scrolling at 1024px+ viewport width
