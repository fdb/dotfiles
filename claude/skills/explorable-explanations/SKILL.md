---
name: explorable-explanations
description: Use when creating interactive scrollytelling pages, playable essays, model-driven explanations, or explorable explanations for concepts, phenomena, societal issues, geopolitical situations, scientific research, or public-interest themes. Triggered by "make an explorable explanation", "build a playable essay", "explain this interactively", "scrollytelling piece for X", references to Parable of the Polygons, Bret Victor, Nicky Case, or explorabl.es.
---

# Explorable Explanations

Build a single self-contained interactive web page that helps a reader understand a concept by **producing the phenomenon themselves** — not by passively reading a polished essay. The reader performs the mechanism with their own hands, sees the result emerge, then understands the lesson with less defensiveness and more confidence than any prose argument could deliver.

## What you are producing

One `.html` file. All CSS inline. All page logic inline (`<script type="module">`). External libraries only via ESM imports or import maps — no build step, no React, no Vite, no webpack. Total reading time ≤1 hour.

The visual register is a **1970s engineering textbook**: cream paper, dark warm-gray ink, one bold accent for emphasis, no decoration that doesn't earn its place. Diagrams look like figures from a service manual or a physics text — flat, labelled, technical, no glow, no glassmorphism, no drop shadows.

## A note on scope

The standard-bearing pieces in this register — long-form interactive essays where every figure is bespoke and every paragraph compounds on the last — take their authors months per piece, with deep research, hand-tuned figures, and dozens of revisions. Those pieces are a craft tradition; do not pretend a model can match them in one sitting. **The skill borrows the structural choices that make that tradition work — concept-dependency ordering, reader-manipulable figures, prose that points at each figure, vocabulary introduced in passing — and applies them honestly to a one-sitting artifact.** Tell the user up front: this is a structurally faithful first draft in the same family, not a finished piece in the lineage.

## When to use

- The user asks for an explorable explanation, playable essay, interactive scrollytelling page, interactive simulation, or "something like Parable of the Polygons."
- The topic is conceptual, scientific, social, political, geopolitical, environmental, economic, cultural, historical, or otherwise public-interest.
- The goal is learning, persuasion through transparent modeling, or scenario exploration.

**Defer to other skills when:**

- Topic is a codebase, protocol, or technical architecture → `code-explainer`
- Output is marketing or a single landing page → `landing-page`
- Need is an interview to gather a spec → `interview`
- User describes a multi-session workshop or 3-day facilitated event → decline; this skill builds single-page artifacts only

## Core principle

Every interaction must answer: **what can the reader now prove, challenge, or understand that static prose could not give them?** If the answer is "it looks engaging," cut the interaction.

## The voice (do not skip this section)

This is what separates a real explainer from a generic AI writeup.

- **Collaborative first-person plural for the system, second-person for the reader.** "Our model has three knobs, and the first one is the share of neighbours who agree." "Drag the slider — the population starts to clump." The author and reader are on the same side, examining the phenomenon together.
- **Address the diagram as if pointing at it.** "As you can see, two reds among neighbours is enough to flip the centre cell." "Notice that the curve barely moves until the threshold passes 0.4." After every interactive figure there is a paragraph that says, in effect, *here is what to look at, and here is what it means*. The figure does not stand alone.
- **Reintroduce vocabulary in passing the first time it's used.** "As the name implies, a *cellular automaton* is a grid of cells whose state at the next time step is set by a small rule applied to its neighbours." Fold the definition into the line that first uses the term, not into a sidebar.
- **Answer the reader's actual question first.** The opening sentence of every section names the question that section will answer.
- **Name the trade-off when there is one.** "A higher threshold makes the segregation tip earlier, but it also makes the model more brittle to small changes — that's the price of the sharper effect."
- **Numbers carry units.** "27% of households," not "27." "0.6 kg/m³," not "0.6."
- **Bold sparingly, italics for emphasis only.** Titles of things go in quotes or `<code>`.
- **Forbidden phrases.** "Let's dive in," "In this article," "It's important to note," "As we all know," "Without further ado." They add nothing.

## Audience

Assume a reader who is **knowledgeable but not intimately familiar** with the topic. They've read journalism in the area, they've followed the headlines, they understand the rough shape — but they haven't lived inside the model. The task they've set themselves on is a notch too challenging for cold comprehension; the explainer is there to break it down. Don't talk down to them; don't pretend the topic is easy; pace them with structure.

## Process: 6 dialogue rounds, then 5 build phases

Run the rounds **in order** before any code. Use `AskUserQuestion` with concrete options where the choice space is enumerable. Accept short free-text only for genuinely free-form fields (the central claim, the success-criterion sentence, source notes, paths to user-supplied papers/data/images). Every free-text request must name what the field is for and offer a one-sentence example. Never ask "tell me about your topic" without scaffolding.

**Subagent-routing rule** (load-bearing when this skill is invoked through `subagent-driven-development` or any pipeline where a subagent runs the rounds). The dialogue rounds belong to **the end user**, not to a subagent's internal decision log. When a subagent encounters Round 2/3/4/5/6, it must:

- Surface the choice back to the controlling agent as a structured question (audience tier, mechanic stack, stand-in candidates, etc.)
- Wait for the controlling agent to invoke `AskUserQuestion` with the end user
- Receive the user's answer back and proceed only then

A subagent that *silently picks* the audience tier or the stand-in lane is bypassing the skill's editorial review — even if its choice is reasonable. The point of these rounds is collaboration with the user, not internal documentation.

### Round 1 — Decode the topic

Ask: do you have source material? What is the central claim or phenomenon? What does the reader currently believe that you want to change?

Read every source the user supplies. Write a working scratch file extracting:

- Claims and counterclaims
- Causal mechanisms
- Variables and constraints
- Stakeholders and incentives
- Time scales and geography
- Evidence quality and uncertainty
- Likely misconceptions
- Harm, identity, trauma, or political sensitivity

If the topic **cannot honestly support a deterministic model**, say so and offer fallbacks: scenario comparison, uncertainty ranges, timelines, maps, constraints, tradeoff exploration. Do not force a model.

If the topic surfaces harm/identity/trauma/sensitivity, flag it now — this will trigger the intimate tone overlay (see Design System) and the abstraction-ethics gate (G4).

### Round 2 — Audience tier

Three discrete archetypes. Picking on the boundary changes the build — force a choice via `AskUserQuestion`. Total reading time is capped at ≈1 hour.

| Tier | Time budget | Disposition |
|---|---|---|
| **Layperson, viral-share** | 5–15 min | Curious or skeptical, wants the punchline |
| **Adjacent, deep-read** | 15–60 min | Engaged, will follow nuance |
| **Expert, reference-toy** | 5–60 min | Already convinced; wants the fiddly knobs |

If the user picks **expert**, flag it: in published work, expert-tier pieces are the weakest as standalone explorables. Confirm intent before continuing.

If the user describes a multi-session workshop or 3-day event, decline — this skill is for single-page artifacts.

### Round 3 — Concept-dependency map

This is the load-bearing planning round. Before any genre talk, before any rendering decisions, list every concept the reader needs to follow the piece end-to-end. For each concept, mark what it depends on. Topologically sort. The result is the spine of the page.

The goal: by paragraph 40, the reader is manipulating something that would have been incomprehensible at paragraph 1, and the build-up feels effortless because every primitive got its own short, illustrated section earlier.

A concrete shape (for a piece on housing segregation):

```
1.  the grid                          (depends on: nothing)
2.  individual happiness rule         (depends on: 1)
3.  the move                          (depends on: 2)
4.  one round of moves                (depends on: 3)
5.  what equilibrium looks like       (depends on: 4)
6.  sharpening — the threshold knob   (depends on: 2, 5)
7.  the counterintuitive twist        (depends on: 6)
...
```

Save the map as a working scratch artifact (`outline.md` next to the HTML, or a comment block at the top of the file). Section order in the finished piece must match the topological order. If the dependency map produces more than ~15 top-level concepts, narrow the topic — the page is too ambitious for one sitting.

The map is what you check against when a section feels like it's working too hard: usually a primitive is being assumed, not introduced.

### Round 4 — Stand-in vs. domain-faithful — and which device

Two halves. The first picks the lane. The second proposes specific device candidates.

**4a. Pick the lane** (`AskUserQuestion`):

- **Stand-in (metaphor-driven)** — the rendering is *not* the thing; it's a substitute that lets the reader manipulate the system without confronting raw subject matter. Defuses defensiveness; useful for civic/political/economic topics.
- **Domain-faithful (literal)** — the rendering *is* the explanation. Vectors as vectors, waveforms as waveforms, dots-on-a-grid as actual people in actual housing. Useful when the math is the point.

**4b. Propose 2–4 specific device candidates** (`AskUserQuestion`).

Don't stop at "stand-in" or "domain-faithful" — those are categories, not devices. The skill must offer concrete candidates the user can pick from, with reasoning for each. Examples for a topic about a queue or wait:

- **Crowd-as-queue** (aggregate-as-visual-form) — a literal mass of figures arranged in a winding line; the SHAPE of the queue carries the visual weight, not individual figures. Does NOT depict any one person, so doesn't violate G4b for sensitive topics.
- **Dot-on-a-grid** (Polygons-style) — abstract shapes for individuals. Powerful but G4b risk: if the topic is vulnerable people, each dot becomes a person you're moving around — wrong for trauma topics.
- **Balance-beam / fulcrum** — physical metaphor for a force-balance. Works when the topic has a center-of-mass dynamic.
- **Layered cake / accumulating mass** — a vertical stack that grows; works for accumulation-over-time topics.
- **Network as constellation** — nodes-and-edges where positions matter; for relational topics.
- **Literal rendering** — dot-charts, line-charts, choropleths. Always available as alternative if no metaphor lands ethically.

For each candidate the skill proposes, name: (1) what it implies metaphorically, (2) which gate risks it carries (especially G4b), (3) one published exemplar that uses something similar.

**4c. Run the chosen lane's check.**

- If **stand-in**: run gate G4 (abstraction-ethics). Severe cases (cute stand-ins for war/oppression/trauma/identity/death) trigger pause-for-reframe; mild cases (metaphor flattens nuance) trigger warn-and-log.
- If **domain-faithful**: run the literacy check. Does the audience tier from Round 2 understand the literal rendering without scaffolding? If not, propose: (a) a primitives section near the top that introduces the rendering, (b) "you'll see X — here's how to read it" preamble per new figure type, or (c) fallback to stand-in.

### Round 5 — Mechanic selection

The default mechanic stack for this skill is a **diagram the reader can manipulate**, where the manipulation reveals the phenomenon. Walk the mechanic ladder:

```
1. drag-and-arrange            — reader places the inputs that yield the result
2. parameter-slider            — reader controls a knob, watches consequence
3. live-simulation             — reader-triggered emergence (initial action seeds it)
4. step-stepper                — reader advances pre-staged steps over a persistent canvas
5. scrubbable-timeline         — reader controls time over real data
6. before-after-toggle         — reader switches between two states
7. minigame                    — reader plays a mechanic with a moral payload
8. audio-trigger               — reader triggers sound as the evidence
9. annotated-diagram-w-hover   — reader reveals labels on demand
10. freeform-sandbox           — reader plays freely (closer; implication varies)
```

Pick the **core mechanic from rungs 1–4** (high implication strength), with lower rungs as supporting moves. A mature piece composes 2–4 rungs across multiple roles (drag/step as setup, slider/sim as exploration, toggle/hover as reveal, sandbox/minigame as closer).

Surface composite device classes when topic shape suggests them:
- **Map** — place or geography is central
- **Timeline** — sequence or history is central
- **Network/flow** — contagion, supply, money, trust, or information moves through a graph
- **Ladder of abstraction** (Bret Victor) — concrete examples + aggregate patterns side by side
- **Role-based negotiation** — multi-stakeholder tradeoff

After mechanic + device selection, also propose **2–4 presentation techniques from the Toolbox section** (e.g., sticky-visual scrollytelling, inline interactives, big-number callouts, layered reveal). The mechanic and the toolbox are orthogonal — the same parameter-slider mechanic can sit in three very different presentation shells.

### Round 6 — Self-implication moment + Model Contract

Require the user to write **one sentence**: *"the reader produces the phenomenon by doing X."* This is the most important gate (G1). If the user can't write the sentence, warn and offer patterns from the Patterns library.

Then write the **Model Contract** before build:

```
Claim:
Mechanism:
Reader action:
Visible consequence:
Evidence or assumption:
Limit:
```

This single-paragraph artifact captures the design decisions in one place. Save it next to the dependency map.

## Editorial gates (three-tier enforcement)

Editorial failures are not equivalent. The skill uses three tiers:

| Tier | Behavior |
|---|---|
| **warn-and-log** | Name the failure mode; cite a known sample piece that fell into it; ask the user to confirm override; if user proceeds, log the waiver as an HTML comment at the top of the generated file (`<!-- WAIVED: G1 self-implication — user confirmed YYYY-MM-DD -->`). |
| **pause-for-reframe** | Stop. Propose an explicit alternative framing. User can: (a) accept the reframe, (b) keep original — drops to warn-and-log behavior with override reasoning required, or (c) abandon the design. Do not silently proceed. |
| **hard-stop** | Refuse to proceed. Explain why. No override. Reserved for failures that would require fabrication or directly contradict source material. |

**Not a gate (handled differently):**

- **Process invariants** — round and phase order is fixed; the 6 rounds happen before any code; P2 checkpoint precedes P3. Skipping a phase changes what this skill *is*. Not negotiable.
- **Output-format constraints** — single HTML file, ESM only, no frameworks. If the user wants a different shape, defer to another skill or decline.

### Gate inventory

| Gate | Question | Tier | Failure mode |
|---|---|---|---|
| **G1 — Self-implication** | Where does the reader produce the phenomenon? | warn-and-log | Lookup-not-model |
| **G2 — Mechanic on ladder** | Is your interaction on the ladder at all, or is it decorative? Which rung(s)? | warn-and-log | Decorative interaction |
| **G3 — Stand-in declared** | Stand-in or domain-faithful? | warn-and-log | Mixed mode confuses readers |
| **G4a — Abstraction-ethics, mild** (stand-in only) | Does the metaphor imply things you don't intend? Erase nuance? | warn-and-log | Over-flattening |
| **G4b — Abstraction-ethics, severe** (stand-in only) | Are you using cute stand-ins for war, oppression, trauma, identity, or death? | **pause-for-reframe** | Ethics-by-cuteness |
| **G5 — Anti-pattern self-check** (before build) | Any anti-patterns from the list below present? | warn-and-log | (multiple) |
| **G6 — Inevitability test** | If a skeptical reader finishes this, can they shrug it off? | warn-and-log | Topic doesn't have an inevitability spine |
| **G7a — Source provenance, soft** | Each major claim or parameter traces to a source or is labeled `(assumption)` | warn-and-log | Manufactured authority |
| **G7b — Source provenance, hard** | The skill would need to invent or hallucinate a citation | **hard-stop** | Fabrication |
| **G8 — Model limits visible** | Limits in the page, not hidden in a footnote | warn-and-log | False certainty |
| **G9 — Manipulative framing** | Does the requested framing present a contested claim as physics, hide value judgments behind interactive chrome, or use symmetric visuals to imply false symmetric power? | **pause-for-reframe** | Propaganda by aesthetics |

## Ethics and Model Integrity

Explorable explanations are persuasive *because they feel self-evident*. That creates responsibility.

| Rule | Gate tier |
|---|---|
| Do not present contested history or moral judgment as mathematical certainty | G9 — pause-for-reframe |
| Do not use cute stand-ins for war, oppression, trauma, identity, or death unless abstraction clearly reduces harm and the user has explicitly approved the tone | G4b — pause-for-reframe |
| Do not create a "proof" when the evidence supports only scenarios or hypotheses | G7a — warn-and-log; escalates to G9 if framing actively claims proof |
| Each major claim or parameter must trace to a source or be labeled as an assumption | G7a — warn-and-log |
| If you would have to invent a citation to support a numeric claim | G7b — hard-stop |
| Symmetric visuals must not imply symmetric power, agency, or harm unless that is true | G9 — pause-for-reframe |
| Include model limits in the page, not hidden in a footnote | G8 — warn-and-log |
| Prefer "here is what this model shows" over "this proves what is happening" | G9 — pause-for-reframe if framing crosses into the latter |

When a pause-for-reframe is triggered, **propose a concrete alternative**, not just flag the problem.

For sensitive topics, use the **intimate tone overlay** (see Design System). Surface content warnings and skip-ahead links as defaults, not afterthoughts.

## Diagrams are the core, not the illustration

Treat the interactive figure as the explanation; treat the prose around it as connective tissue. A section without a diagram is the exception, not the norm — but exceptions are fine when the topic is genuinely textual (a definition, a contested distinction, a brief tradeoff list).

A good interactive figure in this style:

- **Is purpose-built for its prose context.** It is not reused from another section, not generic. The labels are the exact terms the surrounding prose uses.
- **Lets the reader manipulate something.** A slider, a play/pause/step button, a rotation handle, a drag-to-place handle, a scrub-through-time scrubber. The interaction reveals a fact a static diagram could not.
- **Is comprehensible cold but becomes richer with the prose.** A reader who only looks at the figures should still get the spine. A reader who only reads the prose should still understand the argument. Together they should compound.
- **Is built from real values.** If the figure shows infection rates, those are calibrated to a cited paper. If it shows ballot tallies, those are real or labeled `(assumption)`.

### Interactive patterns that earn their place

| Pattern | When to reach for it |
|---|---|
| **Parameter slider** | A value with interesting threshold behaviour — the moment where a small change tips the system |
| **Drag-to-place** | The reader sets initial conditions and watches consequence (placing households, placing voters, placing infected nodes) |
| **Step / play / pause** | A process with discrete stages: an algorithm, a contagion round, a turn-by-turn simulation |
| **Scrubbable timeline** | Real historical or simulated data that the reader can move through |
| **Rotation / camera handle** | 3D objects (planetary motion, molecular structures, geographic terrain) where one viewpoint hides essential geometry |
| **Before/after toggle** | A single switch flips a diagram between two equally-real states |
| **Sandbox** | Closer-only: after the argument lands, an open-ended playground for self-directed exploration |

Each pattern's test: **what does the reader now know that they couldn't have known from a static figure?** If the answer is nothing, cut the interaction or replace it with a still.

### Renderer choices

Custom-written renderers in the canonical examples are part of why those pieces take so long. **In a single-file distillation, importing libraries is fine.** Pick by capability, not brand:

- **Inline SVG** — first reach. Most explorable figures live here: 2D grids, schematic diagrams, flowcharts, packet layouts, sequence diagrams, two-pane comparisons.
- **`<canvas>` + vanilla JS** — when the diagram has > ~200 moving elements or pixel-level rendering matters.
- **D3 v7** — custom data-driven viz: scales, axes, force layouts, hierarchies, sankeys, geographic projections.
- **Observable Plot** — declarative charts on top of D3. Reach before D3 when the chart fits its grammar.
- **PixiJS v8** — 2D high-throughput when SVG can't keep up (Polygons with 100 shapes works in SVG; 10,000 shapes needs PixiJS).
- **Three.js** — 3D when it genuinely earns it: planetary motion, molecular structure, depth as part of the mechanic. Skip when 3D is decorative; the 2D version is more honest more often than not.
- **p5.js** — generative or hand-drawn-feeling figures; sketch-quality where strict precision would feel wrong.
- **matter-js** — 2D rigid-body physics: collisions, gravity, springs, constraints (ball-and-spring intuitions, supply-chain bottleneck metaphors).
- **GSAP + ScrollTrigger** — scroll-driven state morphs and sticky-pin choreography.
- **Scrollama** — lightweight scrollytelling driver (IntersectionObserver + sticky); reach when you don't need the rest of GSAP.
- **Tone.js** — Web Audio when the topic is music, signal processing, acoustics, rhythm.
- **MapLibre GL JS** — pannable/zoomable real basemaps for geographic explorables.
- **Cytoscape.js** — networks with rich layout algorithms beyond what D3 offers.
- **simple-statistics** / **math.js** — when the model needs more than `Math.*`.
- **Mermaid** — sequence diagrams, state machines, ER diagrams from text. Weak as a centerpiece (not reader-driven), strong as a supporting figure.

Pin versions (`@7`, `@8`, etc.). Resolve-to-latest is a future-breaking trap.

### Anti-imports

- **React / Vue / Svelte / SolidJS** — frameworks. Single HTML + ESM means no virtual DOM. Use vanilla DOM or web components.
- **jQuery** — solved problem. `document.querySelector` and `addEventListener` exist.
- **Tailwind / Bootstrap / Bulma** — competing design system; the engineering-textbook preset is *the* design system.
- **Lottie-web** — fine for hand-tuned designer animations, never for data-driven motion (it's not parametric).
- **Moment.js** — deprecated. Use Day.js or date-fns if you genuinely need date logic.

## Patterns library (offer these when relevant)

- **Reader-as-cause** — drag-or-place produces the phenomenon (Polygons, ETFs, Ballot, Taxicab)
- **Persistent canvas** — one visual stays on screen; each section transforms it (Social Security dots, ETFs balance beam, Polygons grid)
- **Wrong-solution staged first** — show broken before fixed (Sight & Light, Taxicab gut-poll, Polygons reduce-bias-fails)
- **One-knob-per-section** — build the model parameter by parameter (Outbreak)
- **Strip the loaded label** — sushi for candidates, shapes for people (Polygons, Something Fishy)
- **Pair every claim with a reproducible sim** (What Happens Next?)
- **Reciprocal closing** — sandbox after the argument (Polygons, Outbreak, Ballot)
- **Wrong intuitive fix → counterintuitive correct fix** (Polygons demand-diversity inversion)
- **Personal verdict** — make the reader the input (NPR Jobs, Social Security build-your-career)

## Toolbox: presentation techniques

The mechanic ladder is about *what the reader does*. The patterns library is about *named editorial moves*. The toolbox is about *how the surrounding presentation behaves* — orthogonal to both.

Pick techniques that serve the topic. **Overdoing it is a worse failure than underdoing it.** Three sticky-scrollytelling sections in one piece is fatiguing; one well-placed one is memorable. Most explorables use 2–4 toolbox items total.

### Scroll-driven presentation

- **Sticky-visual scrollytelling** — pin a visual element (`position: sticky; top: 10vh`) while prose scrolls past it; each text "step" updates the visual via `IntersectionObserver`. Use when **one canvas tells the whole story and the prose annotates it stepwise**.
- **Inline interactives** — embed a tiny widget in prose flow: a draggable number, a one-button toggle inline with the sentence ("...the rate has risen to **[•sparkline•]** since 2019..."). Use to make a single sentence inspectable.
- **Scroll-driven state morph** — the visual smoothly interpolates between two named states as the reader scrolls. Use to show *transformation* in the abstract (before → after, then → now). Don't use when the transformation is the *mechanic itself* — that should be reader-driven.

### Quantitative punctuation

- **Big-number callout** — one giant number, tiny attribution underneath, generous whitespace. Use as section opener for a single load-bearing fact. Don't string three big numbers in a row — each loses weight.
- **Isotype** (unit-as-quantity) — repeated unit shape where each unit = N entities. Use when scale matters and the reader needs to *count* rather than *read* numerals. **Watch G4b** — anthropomorphic units for vulnerable populations re-introduce the ethical problem stand-ins were meant to defuse.
- **Inline sparkline** — micro-chart inside prose flow. Use when a trend is a side-fact reinforcing prose, not the central argument.

### Pacing and focus

- **Layered reveal** — a complex visual builds up layer-by-layer as the prose introduces each layer (axis → data → reference line → annotations → conclusion). Use when the finished diagram would be overwhelming if shown all at once.
- **Camera moves** — zoom in on a focal point as the story narrows, zoom out as it widens. Use sparingly to mirror the prose's rhetorical scope-change.
- **Deliberate silence** — a large empty space between sections, or a section that is just a single short blockquote on the cream paper. Use to mark a beat the reader needs to feel before moving on. Don't use more than once per piece — it stops working.

### What we don't use

- **Click-to-reveal as primary mechanic.** `<details>` is fine for tangents (a derivation, an edge-case footnote) but never for body content the reader needs to follow the spine.
- **Quizzes / "test your understanding".** This is an explainer, not a course.
- **Progress bars / completion indicators / percent-read.** The reader sees the scrollbar; that is enough orientation.
- **Section anchor nav** unless the piece is over 30 minutes — the floating nav becomes more visual weight than short content can support.

### Native primitives worth reaching for

- **`IntersectionObserver`** — the engine behind sticky-visual scrollytelling and reveal-on-scroll. Set thresholds, fire callbacks; do not poll scroll position manually.
- **CSS `position: sticky`** — the layout primitive for pinned visuals. Honors the parent's bounding box.
- **CSS scroll-snap** — step-based scrolling. Powerful but invasive; use only when the explorable is genuinely slide-like, not for editorial scroll narratives.
- **`prefers-reduced-motion`** — every motion technique above must check this. Animations skip; transitions become instant; `IntersectionObserver`-driven state changes still happen but without smooth interpolation.

## Anti-patterns (the skill warns about all of these; some block via G5)

1. **Lookup-not-model** — reader inputs themselves but learns no causal mechanism (NPR Jobs)
2. **Decorative interaction** — moves on screen but contributes nothing
3. **Symbolic-only action** — interaction collapses to a token (Trolley single keypress)
4. **On-rails stepper** — reader can't author or stress-test
5. **Closed simulation** — once guided beats end, exploration yields nothing
6. **Index without through-line** — assemblage of toys, no argument (Complexity Explorables)
7. **Discoverability gap** — affordance is hidden (Social Security keyboard-only)
8. **No on-ramp for adjacent reader** — sliders look pretty, don't teach without prior fluency
9. **Metaphor over-flattens** — abstraction erases the actual contested thing
10. **Parable clone thinking** — copying shapes instead of finding the topic's causal device
11. **False neutrality** — hides value judgments behind interactive chrome
12. **A beautiful page whose lesson could have been a paragraph**
13. **A complex simulation whose assumptions readers cannot inspect**
14. **Sandbox without thesis**
15. **Sliders that imply precision the evidence does not support**
16. **Visual reference, no visual evidence** — prose names a visual element ("the red line", "the highlighted region") that the rendering doesn't actually deliver. Diagnose in this order: (a) **CSS variable resolution failure** — the variable resolves to an empty string (often from a self-referencing redeclaration like `--accent: oklch(from var(--accent) ...)`); diagnose by reading `getComputedStyle(:root).getPropertyValue('--accent')` directly — if empty, the var is invalid-at-computed-value-time and *every* consumer falls back; (b) overlay desaturation collapsing distinct accents into one tone; (c) SVG strokes referencing undefined CSS variables in markup that doesn't propagate; (d) missing legend swatches.
17. **Layout shift in the interactive zone** — variable-length text above or within a mechanic's container causes the controls and chart to shift position as the user interacts. The reader's pointer is mid-action and their eye is anchored to the chart; both lose their target. Use fixed-`min-height` containers for any text whose length depends on interaction state.
18. **Click-to-reveal as the spine** (new) — body content hidden behind `<details>` or "click to expand" affordances on the main reading path. Forces hunting for the next idea. Reserved for true tangents only.

## Build phases

Five build phases (P1–P5), then a Playwright E2E verification pass. Phase order is a process invariant — not negotiable.

| Phase | Output | Checkpoint |
|---|---|---|
| **P1 — Scaffold** | HTML skeleton; sections stubbed (one per concept in the dependency map) with placeholder text; mechanic stub elements present but not wired; aesthetic preset CSS inlined | Does the page render top-to-bottom without errors? Does the section order match the dependency map? |
| **P2 — Core mechanic in isolation** | The mechanic actually produces the phenomenon. Crude visuals OK; no narrative persuasion yet. | **Can a cold reader, with only the minimal rules and labels needed to operate the model — no narrative persuasion, no framing prose — produce the phenomenon by interacting? If no, fix the mechanic, not the prose, before continuing.** |
| **P3 — Narrative wiring** | Prose written into sections; mechanic-prose handoffs wired; **every figure has a paragraph after it that points at the figure**; scroll/step transitions in place; **Toolbox techniques implemented where Round 5 selected them** | Does the piece flow if you read it top to bottom *without* touching the mechanic? Does it flow if you only touch the mechanic and never read prose? Does each Toolbox technique earn its complexity? |
| **P4 — Design pass** | Engineering-textbook preset applied (cream paper, ink strokes, one accent, no decoration); figure styling; responsive | Do the figures look like they could have been printed by offset lithography in 1973? |
| **P5 — Polish** | Reduced-motion, keyboard nav, mobile, state-on-scroll-back, content warnings if applicable, source/provenance section, model-limits section | Is there a single accessibility or UX bug a first-time reader will hit? |

**Verification — Playwright E2E** (post-build, separate from build phases):

Run via `npx playwright test`. First-time setup is two commands: write the one-line `package.json` (`{ "devDependencies": { "@playwright/test": "^1" } }`), then `npm install --no-package-lock --no-audit --no-fund`. After that `node_modules/` exists but is gitignored; subsequent runs are `npx playwright test`. No init ceremony, no scripts section, no lockfile, no config file required.

- Load the page; assert no console errors
- Walk through all sections
- Exercise every slider, button, drag/drop target, tab, toggle, reset
- Verify the mechanical twist is visible
- Verify the conclusion is reachable without getting trapped in an interaction
- Test at mobile width ≥ 360 px; assert no horizontal scroll
- Test keyboard operation
- Check `prefers-reduced-motion` behavior if animation exists
- Confirm citations, assumptions, model limits are visible
- **Visual-reference audit** (anti-pattern #16): for every color word in the prose ("red line", "blue band", "orange dot"), assert at least one SVG element with a matching computed `stroke` or `fill` exists in the rendered DOM
- **Layout stability under interaction** (anti-pattern #17): drag each slider through its full range. Capture the bounding-box `top` of a reference element at each step. Assert the y-coordinate does not vary by more than a few pixels
- **Contrast audit**: enumerate every interactive element and every styled SVG node with a text label. Compute WCAG contrast between foreground and background using a canvas-based helper (parsing oklch/oklab strings via regex is unreliable — render the color to a 1×1 canvas and read the sRGB pixel values back). Assert ≥ 4.5:1 for body-sized text, ≥ 3:1 for large display text

**P2 is the load-bearing checkpoint.** It is the explorable equivalent of TDD's red step. The "minimal rules" framing means: some labels are essential to operate the model (axes, button names, units) — that's fine. What must *not* be present is narrative persuasion doing the mechanic's work. If the mechanic doesn't prove the phenomenon under minimal-rules conditions, fix the mechanic.

## Final hand-off checklist

Playwright catches functional and structural bugs. It does not catch what the rendered page actually *looks like* under interaction. Before declaring the piece done:

- [ ] **Color-claim audit** (anti-pattern #16). For every color word in the prose, open the page and verify the named color is *actually visible* in the rendering. Watch out: when the intimate overlay is active, base accents are desaturated; what was vivid red may now read as muted brown. If the prose says "red" and the chart shows muted grey, fix the chart or the prose, not both.
- [ ] **Legend swatch presence**. Every chart legend item has a visible color swatch matching the line/area it labels.
- [ ] **Layout stability under interaction** (anti-pattern #17). Drag every slider end-to-end. Click every toggle. Watch for: the chart shifting vertically, the controls moving under your pointer, the surrounding text reflowing because the variable label above grew or shrank. Use fixed-`min-height` containers.
- [ ] **Contrast audit**. Every text-on-background combination meets WCAG AA (4.5:1 for body, 3:1 for large display). Watch for: buttons in active state with the same dark-on-dark; flow-diagram nodes where default-color text sits on a heavily-styled background; SVG text where `fill` defaults to `currentColor` against a node fill that wasn't accounted for.
- [ ] **Reduced-motion render**. Enable `prefers-reduced-motion: reduce` and reload. The page must still function and read cleanly without animations.
- [ ] **Cold-reader test**. Show the page to a fresh subagent who hasn't read the source material. Ask them to spend 60 seconds with it and tell you what they understood. If they can't articulate the central insight in their own words, the mechanic isn't carrying its weight regardless of what the tests say.
- [ ] **Override-comment audit**. The HTML waiver comments at the top of the file (from gates that warn-and-logged) accurately list every override taken.
- [ ] **Source provenance walk**. Every numeric claim in visible prose either cites a source by name or is labeled `(assumption)`. No bare numbers.
- [ ] **No click-to-reveal on the spine.** Every primary concept is reachable by scrolling alone. `<details>` blocks contain only tangents.
- [ ] **No quizzes, no progress bars, no completion indicators** anywhere in the piece.

This checklist is not Playwright-replaceable. The failures it catches are visual, perceptual, and pedagogical — exactly the failure modes automated DOM testing is structurally blind to.

## Design system

**Default visual register: 1970s engineering textbook.** Cream paper, dark warm-gray ink, one bold accent, no decoration that doesn't earn its place. Inline `presets/engineering-textbook.css` as the `:root{}` block at P4 (design pass).

**Cross-cutting overlay:** `presets/intimate.css` — applied AFTER the base preset's `:root{}` block when the topic is personal, health-related, grief-adjacent, or trauma-adjacent. Auto-suggested when Round 1 surfaces harm/identity/trauma sensitivity. Desaturates accents, widens spacing, slows motion, defines content-warning chrome.

The shared shape across both presets:

- Single self-contained HTML file
- ESM imports / import maps for libraries
- No build step, no React/Vite/etc.
- No remote fonts unless explicitly opted in
- OKLCH-only color (no hex `#000` / `#fff`)
- Inline `<style>` and inline `<script type="module">`
- All SVG text is live `<text>`, not paths
- Exactly one `<h1>`, correct heading order
- Accessibility defaults

User can override the preset; if the topic genuinely demands a different register (an explorable about, say, a 1990s video-game subculture) suggest an inline override, not a separate preset file.

## Build requirements (hard)

- One self-contained `.html` page
- Inline CSS in `<style>`; inline page logic in `<script type="module">`
- External libraries only via ESM imports or import maps (no `<script src>`)
- No framework build step
- **No `npm init` ceremony.** Playwright's resolver requires *some* package.json + node_modules, but keep both minimal and ephemeral:
  - `package.json` is **one line**: `{ "devDependencies": { "@playwright/test": "^1" } }` — no init bloat
  - `node_modules/` is created on first run via `npm install --no-package-lock --no-audit --no-fund` and is **gitignored**
  - No `package-lock.json`
  - Tests run via `npx playwright test`
  - Project tree: `index.html`, `tests/e2e.spec.ts`, `package.json`, `.gitignore` — that's it
- No decorative animation
- No horizontal scroll at 360 px viewport
- Exactly one `<h1>`; correct heading order
- **Source/provenance section near the end**
- **Model limits section visible to readers**
- **Final section connects the model to what the reader can do, decide, or question next**
- **Override warnings (from gates) logged as HTML comments at the top of the file**

## Reference exemplar set

Point readers at these by name. They have been hand-picked from the explorabl.es catalog plus canonical authors not in that catalog. The register this skill targets is closest to the long-form, figure-rich, slowly-compounding pieces in the second group.

- **Parable of the Polygons** (https://ncase.me/polygons/) — canonical parameter-driven essay; archetypal self-implication
- **Outbreak** (https://meltingasphalt.com/interactive/outbreak/) — one-knob-per-section scaffold; didactic pacing
- **What Happens Next?** (https://ncase.me/covid-19/) — pair-claim-with-sim move
- **How ETFs Work** (https://www.bloomberg.com/features/2016-etf-files/toy/) — physical metaphor (balance beam) for abstract mechanism
- **Something Fishy In American Politics** (https://johnaustin.io/articles/2018/voting-systems) — strip-the-loaded-label move (sushi for candidates)
- **To Build A Better Ballot** (https://ncase.me/ballot/) — drag-causes-pathology civic explorable
- **Sight & Light** (https://ncase.me/sight-and-light/) — wrong-solution-staged-first
- **Mathigon** (https://mathigon.org/) — textbook-with-interactives canonical
- **Social Security Retirement Benefits, Explained Visually** (https://lewis500.github.io/socialsecurity/) — persistent-canvas scrollytelling
- **Up and Down the Ladder of Abstraction** (http://worrydream.com/LadderOfAbstraction/) — canonical Ladder-of-abstraction device
- **Long-form interactive science writing** in the engineering-textbook register — bespoke figures, slow concept compounding, every section building on primitives the reader saw earlier. The published examples in this lineage are the work of writers who spend months per piece on hand-tuned figures and prose; this skill borrows the *structure* and the *voice*, not the polish. Don't promise the user a piece at that level.

When recommending a starting point for the user, point at the closest exemplar: "for this topic, the closest published exemplar is X — read it before you start."

## What the skill will not do

- No frameworks (React, Vue, Svelte, Vite, webpack)
- No `npm init` ceremony, no scripts section, no lockfile — `package.json` is one line declaring `@playwright/test` as a devDep; `node_modules` is gitignored ephemera
- No marketing copy (defer to `landing-page`)
- No code/protocol explainers (defer to `code-explainer`)
- No autoplay audio
- No "story-mode" toggles — the piece works the same whether you scroll or interact
- No anti-pattern bypass without a logged warning comment in the HTML
- No invented citations or fabricated data — if a parameter has no source, it is labeled `(assumption)`
- No multi-session workshop curricula or 3-day events — single-page only
- No quizzes, progress bars, or click-to-reveal on the spine — those belong to a different teaching tradition
