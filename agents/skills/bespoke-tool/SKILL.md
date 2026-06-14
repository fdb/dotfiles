---
name: bespoke-tool
description: Build a throwaway single-file tool for a specific use case — runs on file://, persists to localStorage, no build step. Stack scales from static HTML to React-via-CDN based on interaction complexity.
---
You are building a **single-file, throwaway, single-user tool** for the user to play with for roughly an hour. Functionality over polish. No empty states, no loading states, no accessibility beyond what the markup gives you. Permission to skip the usual hygiene is granted explicitly.

## Workflow

1. **Parse the request + conversation context** for three things: primary interaction, rough data shape, and at least one component. Conversation context counts — if the user already described the data or showed example JSON earlier, use it. Only if any of the three is genuinely missing or ambiguous, ask once with this batched message and stop until answered:

   1. One-sentence purpose
   2. Primary interaction (view / edit / explore / plan / compose)
   3. Data shape (list, nested tree, grid, freeform)
   4. Starting data (blank / paste / `./data.json` / bake from your knowledge)
   5. Components needed (map, timeline, canvas, list, form, …)
   6. Output beyond JSON state? (none / what)

   State sensible defaults so the user can reply "defaults except X." Never ask for clarification on anything else — make reasonable choices and bake your assumptions into SPEC.md so the user can correct on iteration.

2. **Derive a kebab-case `{slug}`** from the request (e.g. `sri-lanka-travel-planner`). If `./{slug}/` already exists, append `-2`, `-3`, etc. Don't ask.

3. **Write `./{slug}/SPEC.md`** using the template below. Don't show it to the user; just write it.

4. **Write `./{slug}/index.html`** as a single self-contained file. Bake realistic starting data from your own knowledge — never leave placeholders, TODOs, or "fill this in" comments. Use web_search only if the data is genuinely recent/live and outside your knowledge. Aim for enough seed data to demonstrate the tool (15-30 items for most cases), not exhaustive coverage.

5. **Hand off with exactly one line** after writing both files:

   `` Built `./{slug}/index.html`. Open directly, or run `npx serve {slug}` if fetch is needed. Tell me what to change to iterate. ``

   No recap of what was built. No marketing copy. The user will see the tool when they open it.

## Iteration

After the initial build, subsequent messages in the same conversation that don't re-invoke `/bespoke-tool` are iterations on the most-recently-built tool in this conversation. On each iteration:

- Re-read SPEC.md and index.html before patching so you don't contradict earlier decisions.
- Keep the same `localStorage` key. Preserve the schema where possible so the user's in-progress state survives.
- Append a dated bullet to SPEC.md's Decisions Log (never rewrite earlier entries).
- Patch the HTML; don't regenerate from scratch unless the user says "start over."
- Don't create a new folder.

If the user re-invokes `/bespoke-tool` explicitly, treat it as a new tool with a new slug.

## Stack levels

Pick the lowest level that fits the data and interactions. When genuinely between two, go up.

- **L1** — no state, no interactivity: static HTML.
- **L2** — flat or nested object + simple views, event handlers, no derived/reactive state: vanilla JS with template strings or direct DOM. No framework.
- **L3** — complex state, derived state, multiple components sharing state, edit tools, anything reactive: React 18 + ReactDOM + Babel standalone via CDN, JSX in `<script type="text/babel">`. No build step. No ES module imports.

Don't worry about perf at 10k items — virtualization is YAGNI.

## File layout

```
./{slug}/
  SPEC.md
  index.html
```

Single HTML file unless physically impossible. Inline `<style>` and `<script>` (or `<script type="text/babel">` for L3) — no separate CSS or JS files, no `<link rel="stylesheet">` to local files.

## Persistence

- **Initial data load** (in this order):
  1. Try `fetch('./data.json')` wrapped in try/catch. Use it if it resolves.
  2. Else, fall through to `localStorage` for key `{slug}:v1:state`.
  3. Else, fall through to baked-in `initialData` constant (the data you populated from your knowledge).
  4. Else, blank slate.

   All four paths are valid; never throw or block on a failed fetch.

- **State persistence**: `localStorage` keyed `{slug}:v1:state`. Sync on every change (debounce 200ms if writes are frequent). Slug-namespacing avoids cross-tool collisions on Firefox `file://`.

- **Schema-drift safety**: wrap the top-level render in try/catch. On error, replace the page body with a banner: "data incompatible — click Reset in debug drawer." Never attempt migration logic.

## Debug drawer (required for L2 and L3)

Every tool includes a `<details>` element fixed to the bottom-right corner with `<summary>debug</summary>` containing:

- Textarea showing current state as pretty-printed JSON (read-only display, updates on state change)
- **Copy** — copies JSON to clipboard
- **Paste & replace** — replaces state from a separate input textarea
- **Download JSON** — downloads as `{slug}-{ISO-timestamp}.json` via `URL.createObjectURL` + `<a download>`
- **Reset** — clears localStorage for this slug and reloads

This is the import/export surface. Don't build a separate import UI unless the SPEC explicitly calls for one.

## `file://` constraints

- **No ES module imports.** No `<script type="module">`. Use UMD/IIFE CDN builds only.
- **`fetch()` to local files** may fail on `file://` in Chrome — the fallback chain above handles this.
- **Map tiles, external APIs with CORS, and anything else needing real HTTP** require a local server. Surface this in the handoff line: ``run `npx serve {slug}` if fetch is needed``.
- **localStorage on `file://` in Firefox** is shared across all `file://` pages. The slug-namespaced key prevents collisions.

## Trusted CDN libraries

UMD/IIFE builds only. Pull in only what you need; don't add libraries speculatively.

- **L3 stack**: `react@18`, `react-dom@18`, `@babel/standalone` (UMD from unpkg or jsdelivr)
- **Maps**: Leaflet (tiles need HTTP → triggers local-server recommendation in handoff)
- **Audio waveforms**: Wavesurfer.js
- **Synthesis / timing**: Tone.js
- **Layout math**: d3 (only what you need — d3-scale, d3-force, etc. — not the whole bundle if avoidable)
- **Icons**: Lucide via CDN, or inline SVG

Don't reach for jQuery, Tailwind, shadcn, moment/dayjs, lodash, or any framework beyond React. Write what you need directly.

## CSS conventions

Inline `<style>` in `<head>`. Functionality over looks; aim for Linear's density without writing Linear's CSS.

**Palette** — define as CSS variables in `:root`. Use OKLCH for all colors. You need: a near-white background, a slightly darker elevated surface for buttons/panels, near-black foreground text, a muted gray for secondary text, a light gray border, and one accent (pick a hue that fits the tool — blue is fine when in doubt). Name them `--bg`, `--bg-elevated`, `--fg`, `--muted`, `--border`, `--accent`.

**Spacing** — define a 4px-based scale as CSS variables (`--s1` through `--s8` covering 4, 8, 12, 16, 24, 32, 48px). Only use multiples from this scale; no arbitrary pixel values in component CSS.

**Typography** — system font stack for body (`--font`), monospace stack for code and the debug drawer (`--mono`). Base size 13px, line-height 1.45. Inherit `font` and `color` on form elements so they don't reset.

**Borders & radius** — define `--radius` as 6px. Use either 0 or `var(--radius)` on any given element; never mix radii within the same tool.

**Element defaults** — minimal reset (`box-sizing: border-box`, zero body margin). Style `button`, `input`, `textarea`, `select` once at the element level with the variables above so you don't restyle them per-component. Buttons get the elevated background; inputs get the plain background. Hover state on buttons only (shift to `--border` background). Two utility classes: `.muted` for secondary text color, `.mono` for monospace.

**Debug drawer** — position fixed bottom-right with `--s3` offset, elevated background, border, radius, monospace font at 11px, max-width around 480px, high `z-index`. The internal textarea is full-width, ~200px tall, monospace.

**Forbidden** — no global transitions, no media queries unless the user explicitly asked for mobile, no `@import`, no `rem`/`em` (px throughout), no CSS resets beyond the minimal one above.

**Layout** — CSS Grid for the page shell, Flexbox for rows within panels. Two-pane (sidebar + main canvas/content) is the default shell unless the data calls for something else (single canvas, three-pane, top-bar-plus-canvas). Desktop-first; assume ≥1200px viewport.

For function declarations in L3 React: `export default function Name() {}` style isn't applicable in a no-build single-file context — use plain `function Name() { ... }` declarations and reference them directly. Hooks via `const { useState, useEffect, useMemo, useReducer } = React;` at the top of the script.

## Explicit permissions

Granted, not oversights:

- No try/catch except around `JSON.parse`, `fetch`, and the top-level render
- No empty states beyond a one-line "no data yet" message
- No loading states (everything is sync after initial fetch)
- No accessibility work beyond default keyboard tab order
- No comments except where logic is non-obvious
- No tests, no README, no build config, no package.json
- Inline styles for genuine one-offs are fine
- `const`, arrow functions, optional chaining, template strings — all modern JS is fine

## SPEC.md template

Write this to `./{slug}/SPEC.md`. Use tilde fences (~~~) around the TypeScript block so they nest inside whatever markdown wrapper.

~~~markdown
# {Tool name}

## Purpose
{One sentence.}

## Primary interaction
{view | edit | explore | plan | compose}

## Data shape
```ts
interface State {
  // your interface here
}
```

## Components & layout
{Two or three sentences sketching the screen: what's on the left, what's on the right, what's interactive. No ASCII wireframes.}

## Stack
L{1|2|3} — {one-line justification}

## Starting data
{blank | paste | ./data.json | baked-from-knowledge}

## localStorage key
`{slug}:v1:state`

## Outputs
{none | description of what gets exported beyond JSON state}

## Assumptions
{Anything you decided without asking. The user can correct these on iteration.}

## Decisions log
- {YYYY-MM-DD}: initial build
~~~

Append to Decisions log on every iteration. One bullet per iteration. Don't rewrite earlier entries.

---

Now read the user's request that follows and build. Don't narrate the workflow; just do it.
