---
name: explorable-explanations
description: Use when creating interactive scrollytelling pages, playable essays, model-driven explanations, or explorable explanations for concepts, phenomena, societal issues, geopolitical situations, scientific research, or public-interest themes. Triggered by "make an explorable explanation", "build a playable essay", "explain this interactively", "scrollytelling piece for X", or references to authors and projects in the lineage — Bartosz Ciechanowski, Nicky Case, Vi Hart, Bret Victor, Parable of the Polygons, Distill, Mathigon, explorabl.es.
---

# Explorable Explanations

**First, read `../explainer-common/core.md`** (fallback: `~/dotfiles/agents/skills/explainer-common/core.md`). It holds the voice, figure rules, style, and verification checklist. This file adds the editorial process, the gates, and the mechanic design.

One self-contained HTML page in which the reader **produces the phenomenon** with their own hands, then understands it with more confidence than prose could give. Reading time ≤ 1 hour.

## When to use

- The user asks for an explorable explanation, playable essay, scrollytelling piece, or "something like Parable of the Polygons".
- The topic is conceptual, scientific, social, political, economic, historical, or public-interest.

Defer: codebase or protocol → `code-explainer`. Marketing → `landing-page`. Multi-session workshop → decline; this skill builds one page.

## Core principle

Every interaction must answer: **what can the reader now prove, challenge, or understand that prose could not give them?** The figure rules in core apply. In this skill one figure, the core mechanic, must be interactive. The rest are static unless they pass the three questions.

## Process: 6 rounds, then 5 build phases

Run the rounds in order before any code. Draft every answer yourself, then ask the user to confirm or change it. Offer concrete options where the choice is enumerable. Never ask "tell me about your topic" without a draft.

When a subagent runs these rounds, it surfaces each choice to the controlling agent, which asks the user. A subagent that picks silently bypasses the editorial review.

### Round 1 — Decode the topic

Read every source the user supplies. Write a scratch file with: claims and counterclaims, causal mechanisms, variables and constraints, stakeholders and incentives, time scales, evidence quality, likely misconceptions, and any harm, identity, or trauma sensitivity.

If the topic cannot honestly support a deterministic model, say so. Offer scenario comparison, uncertainty ranges, timelines, or trade-off exploration instead. Do not force a model.

If the topic is sensitive, flag it now. This triggers the intimate overlay and gate G4.

### Round 2 — Audience tier

| Tier | Time | Disposition |
|---|---|---|
| Layperson, viral-share | 5–15 min | Wants the punchline |
| Adjacent, deep-read | 15–60 min | Will follow nuance |
| Expert, reference-toy | 5–60 min | Already convinced; wants the knobs |

Draft a pick and ask. If the user picks expert, warn: expert-tier pieces are the weakest standalone explorables.

### Round 3 — Concept-dependency map

Per core. Section order follows the map.

### Round 4 — Stand-in or domain-faithful, and which device

**Lane.** *Stand-in*: the rendering is a metaphor (shapes for people). Defuses defensiveness on civic topics. *Domain-faithful*: the rendering is the thing (vectors as vectors). Best when the math is the point.

**Device.** Propose 2–4 concrete candidates, for example: crowd-as-queue (shape of the mass carries the weight, no individual depicted), dot-on-a-grid (Polygons; G4 risk when dots are vulnerable people), balance beam (force balance), accumulating stack (growth over time), network as constellation (relations), literal charts (always available). For each, name what it implies, which gate it risks, and one published exemplar.

**Check.** Stand-in → run G4. Domain-faithful → can the tier from Round 2 read the rendering cold? If not, add a primitives section or a "how to read this figure" preamble.

### Round 5 — Mechanic

The mechanic ladder, strongest implication first:

```
1. drag-and-arrange    reader places the inputs that yield the result
2. parameter-slider    reader turns a knob, watches the consequence
3. live-simulation     reader seeds it, emergence follows
4. step-stepper        reader advances a simulation over a persistent canvas
5. scrubbable-timeline reader moves through real data
6. before-after-toggle reader switches two full states
7. minigame            reader plays a mechanic with a moral payload
8. audio-trigger       reader triggers sound as the evidence
9. freeform-sandbox    closer only, after the argument lands
```

Pick the **core mechanic from rungs 1–4**. Add lower rungs only where they pass the three questions in core. One strong mechanic beats four weak ones.

Composite devices when the topic has the shape: map, timeline, network/flow, ladder of abstraction (concrete and aggregate side by side), role-based negotiation.

Then pick 1–3 presentation techniques from the Toolbox below.

### Round 6 — Self-implication and model contract

Draft the sentence *"the reader produces the phenomenon by doing X"* and confirm it with the user. This is gate G1. Then write the model contract next to the dependency map:

```
Claim:
Mechanism:
Reader action:
Visible consequence:
Evidence or assumption:
Limit:
```

## Gates

| Tier | Behaviour |
|---|---|
| warn-and-log | Name the failure. Ask the user to confirm. Log the waiver as an HTML comment at the top of the file: `<!-- WAIVED: G1 — user confirmed YYYY-MM-DD -->` |
| pause-for-reframe | Stop. Propose a concrete alternative framing. The user accepts it, keeps the original with a logged reason, or abandons. |
| hard-stop | Refuse. No override. |

| Gate | Question | Tier |
|---|---|---|
| G1 Self-implication | Where does the reader produce the phenomenon? | warn-and-log |
| G2 Mechanic on ladder | Is the core mechanic on rungs 1–4? Does every other control pass the three questions? | warn-and-log |
| G3 Lane declared | Stand-in or domain-faithful, not mixed? | warn-and-log |
| G4a Abstraction, mild | Does the metaphor imply things you do not intend, or erase nuance? | warn-and-log |
| G4b Abstraction, severe | Cute stand-ins for war, oppression, trauma, identity, or death? | pause-for-reframe |
| G5 Anti-patterns | Any item from the list below present? | warn-and-log |
| G6 Inevitability | Can a skeptical reader finish and shrug it off? | warn-and-log |
| G7a Provenance, soft | Every claim and parameter traces to a source or is labelled `(assumption)`? | warn-and-log |
| G7b Provenance, hard | Would you need to invent a citation? | hard-stop |
| G8 Limits visible | Are model limits in the page, not a footnote? | warn-and-log |
| G9 Manipulative framing | Contested claim shown as physics? Value judgments hidden behind chrome? Symmetric visuals implying symmetric power? | pause-for-reframe |

Process order (rounds before code, P2 before P3) and output format (one HTML file, ESM only) are not gates. They are fixed.

## Ethics

Explorables persuade because they feel self-evident. So: say "here is what this model shows", never "this proves". Show limits on the page. Do not present contested history as certainty. Do not build a proof when the evidence supports scenarios. For sensitive topics, apply `../explainer-common/intimate.css` after the base preset, add a content warning near the top, and add a skip-to-summary link.

## Patterns

- **Reader as cause** — drag or place produces the phenomenon (Polygons, Ballot)
- **Persistent canvas** — one visual stays; each section transforms it (Social Security)
- **Wrong solution first** — show the broken approach, then the fix (Sight & Light)
- **One knob per section** — build the model parameter by parameter (Outbreak)
- **Strip the loaded label** — sushi for candidates, shapes for people (Polygons)
- **Claim paired with a sim** — every assertion has a reproducible model (What Happens Next?)
- **Sandbox closer** — free play only after the argument lands
- **Personal verdict** — the reader is the input (Social Security)

## Toolbox: presentation

Orthogonal to the mechanic. Use 1–3 per piece. Overdoing it is worse than underdoing it.

- **Sticky-visual scrollytelling** — `position: sticky` visual; prose steps update it via `IntersectionObserver`. When one canvas tells the whole story. Once per piece.
- **Inline interactive** — a draggable number or sparkline inside a sentence. Makes one sentence inspectable.
- **Scroll-driven state morph** — interpolate between two states on scroll. Only for transformation that is not itself the mechanic.
- **Big-number callout** — one number, tiny attribution, whitespace. Never three in a row.
- **Isotype** — repeated unit shapes for counting. Watch G4b with human units.
- **Layered reveal** — the figure builds as the prose introduces each layer. When the finished figure would overwhelm.
- **Deliberate silence** — one empty beat. Once per piece.

Native primitives: `IntersectionObserver`, `position: sticky`, `prefers-reduced-motion`. Avoid scroll-snap unless the piece is slide-like.

## Anti-patterns

1. **Lookup, not model** — reader inputs themselves but learns no mechanism
2. **Decorative interaction** — highlight-only buttons, steppers over a visible list, motion without state change
3. **Symbolic action** — the interaction collapses to one keypress
4. **On-rails stepper** — the reader cannot author or stress-test
5. **Closed simulation** — nothing to explore after the guided beats
6. **Toys without a through-line** — no argument
7. **Hidden affordance** — the control exists but the reader cannot find it
8. **No on-ramp** — sliders that teach nothing without prior fluency
9. **Metaphor over-flattens** — abstraction erases the contested thing
10. **Parable clone** — copying Polygons' shape instead of finding this topic's device
11. **False neutrality** — value judgments hidden behind interactive chrome
12. **A page whose lesson is one paragraph**
13. **A simulation whose assumptions the reader cannot inspect**
14. **Sandbox without thesis**
15. **Sliders that imply precision the evidence lacks**
16. **Colour named in prose but absent on screen.** Check in this order: a CSS variable that resolves to empty (`getComputedStyle(root).getPropertyValue('--accent')`); the intimate overlay desaturating two accents into one tone; SVG strokes referencing undefined variables; missing legend swatches.
17. **Layout shift under interaction** — variable-length text moves the figure. Fixed `min-height`.
18. **Click-to-reveal on the spine**

## Build phases

Order is fixed.

| Phase | Output | Checkpoint |
|---|---|---|
| P1 Scaffold | Skeleton; one stub section per map concept; mechanic stub unwired; preset CSS inlined | Renders top to bottom without errors; section order matches the map |
| P2 Core mechanic alone | The mechanic produces the phenomenon with crude visuals and minimal labels; no narrative | **Can a cold reader, with only the labels needed to operate it, produce the phenomenon? If not, fix the mechanic, not the prose.** |
| P3 Narrative | Prose in every section; pointing paragraph after every figure; toolbox techniques wired | Does it read top to bottom without touching the mechanic? Does the mechanic alone carry the spine? |
| P4 Design | Preset applied; figures styled; responsive | Could it have been printed by offset lithography in 1973? |
| P5 Polish | Reduced motion, keyboard, mobile, state on scroll-back, content warning if needed, sources section, limits section | Will a first-time reader hit any UX bug? |

P2 is the red step. Narrative persuasion must not do the mechanic's work.

## Verification

**Playwright.** `package.json` is one line: `{ "devDependencies": { "@playwright/test": "^1" } }`. Install with `npm install --no-package-lock --no-audit --no-fund`. Run `npx playwright test`. Tree: `index.html`, `tests/e2e.spec.ts`, `package.json`, `.gitignore` (with `node_modules`). Nothing else.

Tests:

- No console errors on load
- Exercise every slider, button, drag target, toggle, reset
- The mechanical twist is visible; the conclusion is reachable
- 360 px: no horizontal scroll
- Keyboard operation
- `prefers-reduced-motion`
- Citations, assumptions, limits visible
- Colour-claim audit: for every colour word in prose, an SVG element with a matching computed `stroke` or `fill` exists
- Layout stability: drag each slider through its range; a reference element's `top` varies by a few pixels at most
- Contrast: render each colour to a 1×1 canvas and read sRGB back (do not regex-parse oklch); ≥ 4.5:1 body, ≥ 3:1 large text

**Then the full "Verify before hand-off" list from core**, plus:

- [ ] Waiver comments at the top of the file list every override taken.
- [ ] Every number in prose cites a source or is labelled `(assumption)`.
- [ ] Sources section, limits section, and a closing section on what the reader can do next are present.
- [ ] Audio, if any, is reader-triggered.

## Exemplars

Beyond the core list: Parable of the Polygons (https://ncase.me/polygons/), Outbreak (https://meltingasphalt.com/interactive/outbreak/), What Happens Next? (https://ncase.me/covid-19/), How ETFs Work (https://www.bloomberg.com/features/2016-etf-files/toy/), Something Fishy in American Politics (https://johnaustin.io/articles/2018/voting-systems), To Build a Better Ballot (https://ncase.me/ballot/), Sight & Light (https://ncase.me/sight-and-light/), Social Security Explained Visually (https://lewis500.github.io/socialsecurity/), Ladder of Abstraction (http://worrydream.com/LadderOfAbstraction/), Vi Hart (https://vihart.com/).

Name the closest exemplar to the user before you start: "for this topic, read X first."
