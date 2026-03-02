---
name: code-explainer
description: Use when the user asks to create an interactive HTML explainer, visual code walkthrough, or "making of" page for a codebase or feature. Triggered by requests like "explain this code visually", "create an explainer", "make an interactive walkthrough".
---

# Interactive Code Explainer

Generate a self-contained HTML file that visually explains how a codebase works — with animations, interactive diagrams, and step-by-step navigation.

## Process

1. **Read the source code** thoroughly — every file that matters
2. **Identify sections** from the code (see Section Template below)
3. **Generate a single HTML file** with all CSS/JS inline — zero dependencies

## Required Sections

Analyze the codebase and create slides for each applicable section:

| Section | What to show |
|---------|-------------|
| **Title** | Project name, tech stack badges, nav instructions |
| **Data Model** | Core types/interfaces with annotated code blocks; entity relationship diagrams if applicable |
| **Data Flow** | How data moves through the system — animated pipeline diagram with "Animate" button |
| **Components / Architecture** | Interactive component tree (click to inspect), module diagram, or layer diagram |
| **Design System / Style** | Color swatches (hover for usage), typography scale, spacing system, component showcase with annotated classes |
| **Validation / Testing** | Test map (unit vs E2E vs integration), clickable test paths through the system |
| **Summary** | Key architectural decisions in card grid |

Skip sections that don't apply. Add project-specific sections when the code warrants it (e.g., "Dialog Tree" for a Yarn Spinner app, "API Routes" for a backend, "State Machine" for complex state).

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
- **Annotated code blocks**: macOS-style header with filename, syntax-highlighted with `<span>` classes

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

- [ ] Single HTML file, no external dependencies (except Google Fonts)
- [ ] All CSS inline in `<style>`, all JS inline in `<script>`
- [ ] Every slide has `data-section` attribute
- [ ] Keyboard (arrows, space), mouse (nav dots), and touch (swipe) navigation all work
- [ ] Code blocks use syntax highlighting spans, not plain text
- [ ] At least 2 interactive/animated elements
- [ ] Cards have hover effects (lift + glow)
- [ ] Background has subtle radial gradient texture + grid overlay
- [ ] No horizontal scrolling at 1024px+ viewport width
