---
name: explorable-explanations
description: Use when creating interactive scrollytelling pages, playable essays, model-driven explanations, or explorable explanations for concepts, phenomena, societal issues, geopolitical situations, scientific research, or public-interest themes. Triggered by "make an explorable explanation", "build a playable essay", "explain this interactively", "scrollytelling piece for X", references to Parable of the Polygons, Bret Victor, Bartosz Ciechanowski, Nicky Case, or explorabl.es.
---

# Explorable Explanations

Build a single self-contained interactive web page that helps a reader understand a concept by **producing the phenomenon themselves** — not by passively reading a polished essay.

The standard is `Parable of the Polygons`: the reader performs the mechanism with their own hands, sees the counterintuitive result emerge, then understands the lesson with less defensiveness and more confidence than any prose argument could deliver.

## What you are producing

One `.html` file. All CSS inline. All page logic inline (`<script type="module">`). External libraries only via ESM imports or import maps — no build step, no React, no Vite, no webpack. Total reading time ≤1 hour.

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

## Process: 6 dialogue rounds, then 5 build phases

Run the rounds **in order** before any code. Use `AskUserQuestion` with concrete options where the choice space is enumerable. Accept short free-text only for genuinely free-form fields (the central claim, success-criterion sentence, source notes, paths to user-supplied papers/data/images). Every free-text request must name what the field is for and offer a one-sentence example. Never ask "tell me about your topic" without scaffolding.

**Subagent-routing rule** (load-bearing when this skill is invoked through `subagent-driven-development` or any pipeline where a subagent runs the rounds). The dialogue rounds belong to **the end user**, not to a subagent's internal decision log. When a subagent encounters Round 2/3/4/5/6, it must:

- Surface the choice back to the controlling agent as a structured question (genre options, audience tier, mechanic stack, stand-in candidates, etc.)
- Wait for the controlling agent to invoke `AskUserQuestion` with the end user
- Receive the user's answer back and proceed only then

A subagent that *silently picks* the audience tier, the genre, the stand-in lane, or the device candidates is bypassing the skill's editorial review — even if its choice is reasonable. The point of these rounds is collaboration with the user, not internal documentation. If you are the controlling agent and you dispatch a subagent for the rounds, instruct it explicitly to surface choices, not to decide.

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

### Round 3 — Genre recommendation

Propose **one genre** with a one-paragraph rationale tied to topic + audience tier, plus **one alternative**. User picks or overrides via `AskUserQuestion`.

| Genre | Default arc | Default mechanic stack | Aesthetic preset | Exemplars |
|---|---|---|---|---|
| **Parameter-driven essay** | Hook → drag → auto-sim → slider → twist → sandbox | drag + live-sim + slider + sandbox | playful-illustrated | Polygons, Outbreak, ETFs, Ballot, Taxicab |
| **Walkthrough with diagrams** | Wrong-solution-first → corrected → generalized | live-sim with mouse-as-input + before/after toggle | reverent-scientific | Sight & Light, Ciechanowski, Log-spherical |
| **Scrollytelling data story** | Lede → hook → guided steps over persistent dataset → personal verdict | step-stepper + persistent canvas + one slider | editorial | NPR Jobs, Something Fishy, Social Security |
| **Textbook with interactives** | Define → demonstrate → exercise → recap | live figures (each section gets self-contained interactive) | academic | Mathigon, Sines & Signals, Immersive Math |
| **Game-with-explanatory-frame** | Setup → choice → consequence → meta-reflection | minigame core + variant runs | gamified | District, Ballot |
| **Hybrid** | User-defined | multi-mechanic explicit | user-picks-or-blends | What Happens Next?, Crowds |

Each genre carries a known failure mode (see Genre Failure Modes section below).

### Round 4 — Stand-in vs. domain-faithful — and which device

This round has two halves. The first picks the lane. The second proposes specific device candidates and asks the user to pick.

**4a. Pick the lane** (`AskUserQuestion`):

- **Stand-in (metaphor-driven)** — the rendering is *not* the thing; it's a substitute that lets the reader manipulate the system without confronting raw subject matter. Defuses defensiveness; useful for civic/political/economic topics.
- **Domain-faithful (literal)** — the rendering *is* the explanation. Vectors as vectors, waveforms as waveforms, dots-on-a-grid as actual people in actual housing. Useful when the math is the point.

**4b. Propose 2–4 specific device candidates** (`AskUserQuestion`).

Don't stop at "stand-in" or "domain-faithful" — those are categories, not devices. The skill must offer concrete candidates the user can pick from, with reasoning for each. Examples of devices that could fit a topic about a queue or wait:

- **Crowd-as-queue** (aggregate-as-visual-form) — a literal mass of figures arranged in a winding line; the SHAPE of the queue carries the visual weight, not individual figures. Does NOT depict any one person, so doesn't violate G4b for sensitive topics. Often more emotionally honest than dot-charts.
- **Dot-on-a-grid** (Polygons-style) — abstract shapes for individuals. Powerful but G4b risk: if the topic is vulnerable people (children, refugees, patients), each dot becomes a person you're moving around — wrong for trauma topics.
- **Balance-beam / fulcrum** (ETFs-style) — a physical metaphor for a force-balance. Works when the topic has a center-of-mass dynamic.
- **Layered cake / accumulating mass** — a vertical stack that grows; works for accumulation-over-time topics.
- **Network as constellation** — nodes-and-edges where positions matter; for relational topics.
- **Literal rendering** (domain-faithful default) — dot-charts, line-charts, choropleths. Always available as an alternative if no metaphor lands ethically.

For each candidate the skill proposes, name: (1) what it implies metaphorically, (2) which gate risks it carries (especially G4b for sensitive topics), (3) one published exemplar that uses something similar.

**4c. Run the chosen lane's check.**

- If **stand-in**: run gate G4 (abstraction-ethics). Severe cases (cute stand-ins for war/oppression/trauma/identity/death) trigger pause-for-reframe; mild cases (metaphor flattens nuance) trigger warn-and-log.
- If **domain-faithful**: run the literacy check. Does the audience tier from Round 2 understand the literal rendering without scaffolding? If not, propose: (a) glossary section as Section 1, (b) "you'll see X — here's how to read it" preamble per new figure type, or (c) fallback to stand-in.

### Round 5 — Mechanic selection

Walk the mechanic ladder (see Mechanic Ladder section below). Recommend 2–3 rungs to compose. Name the canonical sequence (drag → sim → slider → toggle → sandbox) when it applies.

Surface composite device classes when topic shape suggests them:
- **Map** — place or geography is central
- **Timeline** — sequence or history is central
- **Network/flow** — contagion, supply, money, trust, or information moves through a graph
- **Ladder of abstraction** (Bret Victor) — concrete examples + aggregate patterns side by side
- **Role-based negotiation** — multi-stakeholder tradeoff

After mechanic + device selection, also propose **2–4 presentation techniques from the Toolbox section** (e.g., sticky-visual scrollytelling, inline interactives, big-number callouts, layered reveal). The mechanic and the toolbox are orthogonal — the same parameter-slider mechanic can sit in three very different presentation shells. Pick what serves *this* topic; don't grab everything.

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

This single-paragraph artifact captures the design decisions in one place. Save it to a working file and reference it during the build phases.

## Genre failure modes

Each genre has a characteristic failure mode. Surface the relevant one as a warning during Round 3.

| Genre | Tends to fail by... | Counter-move |
|---|---|---|
| **Parameter-driven essay** | Cute aesthetic + simple model lets critics dismiss the moral conclusion as a toy | Explicit "model limits" section; link to source paper; one paragraph on "what this model doesn't show" |
| **Walkthrough with diagrams** | Assumes technical fluency the reader doesn't have | Open with the consequence or failure that motivates the technique, not the technique itself |
| **Scrollytelling data story** | Becomes a guided lookup rather than a model | At least one parameter the reader controls; one moment where input changes the conclusion (not just personalizes it) |
| **Textbook with interactives** | LMS chrome flattens voice; gating turns to friction when reader knows the answer | Distinct chapter voice; optional skip-to-mastery; no progress-bar fetishism |
| **Game-with-explanatory-frame** | Symbolic-only action — moral weight collapses to one keypress | Vary parameters across runs; force confronting edge cases of the rule |
| **Hybrid** | Misses the spine of any one genre, ends up structurally muddled | Even a hybrid has one dominant arc; identify it explicitly before composing |

## Mechanic ladder (ordered by implication strength)

Implication strength = how directly the reader's own action produces the phenomenon being explained. The ladder is ordered by this dimension because it's the strongest predictor of whether a piece lands.

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

**Role in the piece is a separate axis.** Drag and step-stepper often serve as **setup**; live-sim and slider as **exploration**; toggle and hover as **reveal**; sandbox and minigame as **closer** or **standalone**. A mature piece composes 2–4 rungs across multiple roles.

Default recommendation: pick the core mechanic from rungs 1–4 (high implication), with lower rungs as supporting moves.

## Editorial gates (three-tier enforcement)

Editorial failures are not equivalent. The skill uses three tiers:

| Tier | Behavior |
|---|---|
| **warn-and-log** | Name the failure mode; cite a known sample piece that fell into it; ask the user to confirm override; if user proceeds, log the waiver as an HTML comment at the top of the generated file (`<!-- WAIVED: G1 self-implication — user confirmed YYYY-MM-DD -->`). |
| **pause-for-reframe** | Stop. Propose an explicit alternative framing. User can: (a) accept the reframe, (b) keep original — drops to warn-and-log behavior with override reasoning required, or (c) abandon the design. Do not silently proceed. |
| **hard-stop** | Refuse to proceed. Explain why. No override. Reserved for failures that would require fabrication or directly contradict source material. |

**Not a gate (handled differently):**

- **Process invariants** — phase order is fixed; the 6 rounds happen before any code; P2 checkpoint precedes P3. Skipping a phase changes what this skill *is*. Not negotiable.
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

The mechanic ladder is about *what the reader does*. The patterns library is about *named editorial moves*. The toolbox is about *how the surrounding presentation behaves* — orthogonal to both. A parameter-slider mechanic can sit in a sticky-visual scrollytelling layout, or in inline-interactive form, or as a standalone figure. Same mechanic, very different reader experience.

Pick techniques that serve the topic. **Overdoing it is a worse failure than underdoing it** — three sticky-scrollytelling sections in one piece is fatiguing; one well-placed one is memorable. Most explorables use 2–4 toolbox items total.

The skill consults this during Round 5 (after picking mechanics, also consider presentation techniques) and P3 (narrative wiring decides where each technique sits).

### Scroll-driven presentation

- **Sticky-visual scrollytelling** — pin a visual element (`position: sticky; top: 10vh`) while prose scrolls past it; each text "step" updates the visual (adds/removes elements, scales them up/down, recolors, swaps datasets) via `IntersectionObserver` triggers. The visual carries the through-line; the prose layers commentary. Use when **one canvas tells the whole story and the prose annotates it stepwise** (NYT-style data stories, Pudding-style narratives). Don't use when there are multiple distinct visuals to show — sticky carries one canvas, not three.
- **Inline interactives** — embed a tiny widget in prose flow: a draggable number, a hover-revealing sparkline, a one-button toggle inline with the sentence ("...the rate has risen to **[•sparkline•]** since 2019..."). Bret Victor's reactive-document pattern. Use to make a single sentence inspectable. Don't use when the widget exceeds 1–2 lines of text — at that size it's a figure, not an inline.
- **Scroll-driven state morph** — the visual smoothly interpolates between two named states as the reader scrolls (D3 transitions, FLIP technique, or `view-timeline` where supported). Use to show *transformation* in the abstract (before → after, then → now). Don't use when the transformation is the *mechanic itself* — that should be reader-driven, not scroll-driven.

### Quantitative punctuation

- **Big-number callout** — one giant number, tiny attribution underneath, generous whitespace around it ("**9.194** kinderen op de wachtlijst"). Use as section opener for a single load-bearing fact. Don't string three big numbers in a row — each loses weight; if you have three numbers that matter equally, that's a small chart, not three callouts.
- **Isotype** (unit-as-quantity) — repeated unit shape where each unit = N entities. Otto Neurath / *Gerd Arntz* lineage. Use when scale matters and the reader needs to *count* rather than *read* numerals. **Watch G4b** — anthropomorphic units (little person silhouettes) re-introduce the ethical problem stand-ins were meant to defuse for vulnerable populations; use abstract shapes for sensitive topics.
- **Inline sparkline** — micro-chart inside prose flow, often hand-drawn-feeling SVG. Use when a trend is a side-fact reinforcing prose, not the central argument.

### Pacing and focus

- **Layered reveal** — a complex visual builds up layer-by-layer as the prose introduces each layer (axis → data → reference line → annotations → conclusion). Use when the finished diagram would be overwhelming if shown all at once. Don't use when the reader will jump around — layered reveal punishes non-linear reading.
- **Camera moves** — zoom in on a focal point as the story narrows, zoom out as it widens (Mapbox-style on geographic data; SVG `viewBox` animation on abstract figures). Use sparingly to mirror the prose's rhetorical scope-change. Don't use as decoration — every camera move should track a sentence-level scope shift.
- **Deliberate silence** — a large empty space between sections, or a section that is just a single short blockquote on white. Use to mark a beat the reader needs to feel before moving on. Don't use more than once per piece — it stops working.

### Reader orientation (long pieces only)

- **Section anchor nav** — a small floating list of section titles that tracks the current position (highlights the section the reader is currently in). Use for pieces over 30 minutes. Don't use for short pieces; the nav becomes more visual weight than the content can support.
- **Progress indicator** — thin progress bar at top, or a percent-read in the corner. Less invasive than an anchor nav. Use when the piece is long and the reader benefits from a "how much further?" signal.

### Native primitives worth reaching for

- **`<details>` for "go deeper"** — progressive disclosure for footnotes, derivations, edge cases. Reward curiosity without punishing the reader who just wants the spine. Use generously.
- **`<dialog>` for content warnings or definitional asides** — native modal with accessible focus management, escape-to-close, backdrop styling.
- **`IntersectionObserver` API** — the engine behind sticky-visual scrollytelling and reveal-on-scroll. Set thresholds, fire callbacks; do not poll scroll position manually.
- **CSS `position: sticky`** — the layout primitive for pinned visuals. Honors the parent's bounding box.
- **CSS scroll-snap** — step-based scrolling (one section per snap point). Powerful but invasive — fights the browser's natural feel. Use only when the explorable is genuinely slide-like, not for editorial scroll narratives.
- **`prefers-reduced-motion`** — every motion technique above must check this. Animations skip; transitions become instant; `IntersectionObserver`-driven state changes still happen but without the smooth interpolation.

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
16. **Visual reference, no visual evidence** — prose names a visual element ("the red line", "the highlighted region", "the dashed indicator") that the rendering doesn't actually deliver. Causes (in diagnostic order from most-to-least nasty): (a) **CSS variable resolution failure** — the variable resolves to an empty string (often from a self-referencing redeclaration like `--accent: oklch(from var(--accent) ...)`); diagnose by reading `getComputedStyle(:root).getPropertyValue('--accent')` directly — if empty, the var is invalid-at-computed-value-time and *every* consumer falls back; (b) overlay desaturation collapsing distinct accents into one tone (the gentler failure where colors are present but converged); (c) SVG strokes referencing undefined CSS variables in markup that doesn't propagate; (d) missing legend swatches. Playwright testing for the readout number passes silently while the *thing the reader is told to look at* is invisible.
17. **Layout shift in the interactive zone** — variable-length text above or within a mechanic's container causes the controls and chart to shift position as the user interacts (scrubbing a timeline whose label text changes length, toggling a state whose explanation grows or shrinks). The reader's pointer is mid-action and their eye is anchored to the chart; both lose their target. Worse than page-load CLS because it interrupts the reader's interaction loop.

## Build phases

Five build phases (P1–P5), then a Playwright E2E verification pass. Phase order is a process invariant — not negotiable.

| Phase | Output | Checkpoint |
|---|---|---|
| **P1 — Scaffold** | HTML skeleton; sections stubbed with placeholder text; mechanic stub elements present but not wired; aesthetic preset CSS inlined | Does the page render top-to-bottom without errors? |
| **P2 — Core mechanic in isolation** | The mechanic actually produces the phenomenon. Crude visuals OK; no narrative persuasion yet. | **Can a cold reader, with only the minimal rules and labels needed to operate the model — no narrative persuasion, no framing prose — produce the phenomenon by interacting? If no, fix the mechanic, not the prose, before continuing.** |
| **P3 — Narrative wiring** | Prose written into sections; mechanic-prose handoffs wired; scroll/step transitions in place; **Toolbox techniques implemented where Round 5 selected them** (sticky-visual scrollytelling, layered reveal, etc.) | Does the piece flow if you read it top to bottom *without* touching the mechanic? Does it flow if you only touch the mechanic and never read prose? Does each Toolbox technique earn its complexity (no decorative scrollytelling, no isotype that reintroduces G4b)? |
| **P4 — Design pass** | Color, type, spacing per genre preset (read from `presets/<preset>.css`); figure styling; responsive | Does the design match the genre and the topic's emotional register? |
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
- **Visual-reference audit** (anti-pattern #16): for every color word in the prose ("rode lijn", "paarse band", "orange dot"), assert at least one SVG element with a matching computed `stroke` or `fill` exists in the rendered DOM
- **Layout stability under interaction** (anti-pattern #17): drag each slider through its full range. Capture the bounding-box `top` of a reference element (the mechanic's `<svg>` container or the slider itself) at each step. Assert the y-coordinate does not vary by more than a few pixels across the range
- **Contrast audit**: enumerate every interactive element (buttons, toggles, slider thumbs) and every styled SVG node with a text label. Compute WCAG contrast between foreground and background using a canvas-based helper (parsing oklch/oklab strings via regex is unreliable — render the color to a 1×1 canvas and read the sRGB pixel values back). Assert ≥ 4.5:1 for body-sized text, ≥ 3:1 for large display text

**P2 is the load-bearing checkpoint.** It is the explorable equivalent of TDD's red step. The "minimal rules" framing means: some labels are essential to operate the model (axes, button names, units) — that's fine. What must *not* be present is narrative persuasion doing the mechanic's work. If the mechanic doesn't prove the phenomenon under minimal-rules conditions, fix the mechanic.

## Final hand-off checklist

Playwright catches functional and structural bugs. It does not catch what the rendered page actually *looks like* under interaction. Before declaring the piece done, perform these manual visual checks (or dispatch a fresh subagent that has not seen the source code, with a screenshot tool, to perform them):

- [ ] **Color-claim audit** (anti-pattern #16). For every color word in the prose ("the red line", "the orange dot", "the purple band", "de paarse gestreepte lijn"), open the page and verify the named color is *actually visible* in the rendering. Watch out: when the intimate overlay is active, base preset accents are desaturated via `oklch(from ...)`; what was vivid orange may now read as muted brown. If the prose says "red" and the chart shows muted grey, fix the chart or the prose, not both. Never paper over with darker prose.
- [ ] **Legend swatch presence**. Every chart legend item has a visible color swatch matching the line/area it labels. Missing swatches mean the reader has to guess which line is which.
- [ ] **Layout stability under interaction** (anti-pattern #17). Drag every slider end-to-end. Click every toggle. Scrub every timeline through its full range. Watch for: the chart shifting vertically, the controls moving under your pointer, the surrounding text reflowing because the variable label above grew or shrank. Use fixed-`min-height` containers for any text whose length depends on interaction state.
- [ ] **Contrast audit**. Every text-on-background combination meets WCAG AA (4.5:1 for body, 3:1 for large display). Watch out for: (a) buttons or toggles in their *active* state where designers used a dark background with the same dark text class; (b) flow-diagram nodes and chips where a default-color text sits on a heavily-styled background; (c) text inside SVG where `fill` defaults to `currentColor` against a node fill that wasn't accounted for. The most embarrassing case: black text on a black-filled node, where the node looks intentional but its label is invisible.
- [ ] **Reduced-motion render**. Enable `prefers-reduced-motion: reduce` (macOS: System Settings → Accessibility → Display → Reduce Motion) and reload. The page must still function and read cleanly without animations.
- [ ] **Dark-mode behavior** if you've shipped a dark preset (gamified) or anticipate users with system dark mode. The piece either looks intentional in both modes or you've explicitly opted out.
- [ ] **Cold-reader test**. Show the page to someone (or a fresh subagent) who hasn't read the source material. Ask them to spend 60 seconds with it and tell you what they understood. If they can't articulate the central insight in their own words, the mechanic isn't carrying its weight regardless of what the tests say.
- [ ] **Override-comment audit**. The HTML waiver comments at the top of the file (from gates that warn-and-logged) accurately list every override taken. A reviewer reading those comments alone should know what was waived and why.
- [ ] **Source provenance walk**. Every numeric claim in visible prose either cites a source by name or is labeled `(assumption)` / `(geijkt)`. No bare numbers.

This checklist is not Playwright-replaceable. The failures it catches are visual, perceptual, and pedagogical — exactly the failure modes automated DOM testing is structurally blind to.

## Design system

**Inherited core (from `code-explainer`):**

- Single self-contained HTML file
- ESM imports / import maps for libraries (D3, Observable Plot, Three.js, Pixi.js, Mermaid)
- No build step, no React/Vite/etc.
- No remote fonts unless explicitly opted in
- OKLCH-only color (no hex `#000` / `#fff`)
- Inline `<style>` and inline `<script type="module">`
- All SVG text is live `<text>`, not paths
- Exactly one `<h1>`, correct heading order
- Accessibility defaults

**Genre aesthetic presets** live in `presets/` adjacent to this SKILL.md. At P4 (design pass), read the matching preset file and inline its `:root{}` block into the generated HTML.

| Genre | Preset file |
|---|---|
| Parameter-driven essay | `presets/playful-illustrated.css` |
| Walkthrough with diagrams | `presets/reverent-scientific.css` |
| Scrollytelling data story | `presets/editorial.css` |
| Textbook with interactives | `presets/academic.css` |
| Game-with-explanatory-frame | `presets/gamified.css` |

**Cross-cutting overlay:** `presets/intimate.css` — applied AFTER the genre preset's `:root{}` block when the topic is personal, health-related, grief-adjacent, or trauma-adjacent. Auto-suggested when Round 1 surfaces harm/identity/trauma sensitivity. Desaturates accents, widens spacing, slows motion, defines content-warning chrome.

User can override any preset; recommend based on genre, topic emotional register, and Round 1 sensitivity flags.

## Build requirements (hard)

- One self-contained `.html` page
- Inline CSS in `<style>`; inline page logic in `<script type="module">`
- External libraries only via ESM imports or import maps (no `<script src>`)
- No framework build step
- **No `npm init` ceremony.** Playwright's resolver requires *some* package.json + node_modules, but keep both minimal and ephemeral:
  - `package.json` is **one line**: `{ "devDependencies": { "@playwright/test": "^1" } }` — no init bloat (no name, version, scripts, license, repository, keywords, etc.)
  - `node_modules/` is created on first run via `npm install --no-package-lock --no-audit --no-fund` and is **gitignored** — treat it as a build artifact, not a project asset
  - No `package-lock.json` (gets in the way of "minimal")
  - Tests run via `npx playwright test` (which uses the local install)
  - Project tree: `index.html`, `tests/e2e.spec.ts`, `package.json`, `.gitignore` — that's it. No config file, no scripts section, no lockfile.
- No decorative animation
- No horizontal scroll at 360 px viewport
- Exactly one `<h1>`; correct heading order
- **Source/provenance section near the end**
- **Model limits section visible to readers**
- **Final section connects the model to what the reader can do, decide, or question next**
- **Override warnings (from gates) logged as HTML comments at the top of the file**

## Reference exemplar set

Point readers at these by name. They have been hand-picked from the explorabl.es catalog plus canonical authors not in that catalog.

- **Parable of the Polygons** (https://ncase.me/polygons/) — canonical parameter-driven essay; archetypal self-implication; demand-diversity inversion
- **Outbreak** (https://meltingasphalt.com/interactive/outbreak/) — one-knob-per-section scaffold; didactic pacing
- **What Happens Next?** (https://ncase.me/covid-19/) — pair-claim-with-sim move; hybrid genre
- **How ETFs Work** (https://www.bloomberg.com/features/2016-etf-files/toy/) — physical metaphor (balance beam) for abstract mechanism
- **Something Fishy In American Politics** (https://johnaustin.io/articles/2018/voting-systems) — strip-the-loaded-label move (sushi for candidates)
- **To Build A Better Ballot** (https://ncase.me/ballot/) — drag-causes-pathology civic explorable
- **Sight & Light** (https://ncase.me/sight-and-light/) — wrong-solution-staged-first
- **Bartosz Ciechanowski** (https://ciechanow.ski/) — gold standard reverent-scientific
- **Mathigon** (https://mathigon.org/) — textbook genre canonical
- **Social Security Retirement Benefits, Explained Visually** (https://lewis500.github.io/socialsecurity/) — persistent-canvas scrollytelling
- **Up and Down the Ladder of Abstraction** (http://worrydream.com/LadderOfAbstraction/) — canonical Ladder-of-abstraction device

When recommending a genre, point at the closest exemplar: "for this topic, the closest published exemplar is X — read it before you start."

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
