# Design: `explorable-explanations` skill

**Date:** 2026-04-27
**Author:** Frederik De Bleser (with Claude)
**Status:** Design approved, ready for plan

## Summary

A Claude Code skill that guides authors through making interactive scrollytelling pages — "explorable explanations" — for concepts, phenomena, societal issues, geopolitical situations, scientific research, or other public-interest themes.

Rather than templating a single output shape, this skill runs a **multi-round AskUserQuestion dialogue**, recommends a genre and mechanic stack with reasoning, enforces editorial integrity through a **three-tier gate model** (warn-and-log / pause-for-reframe / hard-stop), and drives the build through **five explicit phases** with checkpoints, ending in a Playwright E2E pass.

The standard for "good" is calibrated against a 20-piece random sample of `explorabl.es` and named exemplars (Polygons, Outbreak, Ciechanowski, Mathigon, ETFs Bloomberg, Sight & Light, Ballot, Something Fishy In American Politics, What Happens Next?).

## Motivation

The existing `code-explainer` skill produces excellent technical walkthroughs but is shaped wrong for explorables: it enforces a single dark warm-cool palette, a 68ch column, and a "describe each part of the system" structure. Explorables don't describe — they **let the reader produce the phenomenon**, and the design language must match the topic (Polygons is bright/playful; ETFs is Bloomberg-serif; Ciechanowski is reverent-scientific).

A separate skill is warranted because:

1. **Different success metric.** Code-explainer succeeds when the reader understands the system. Explorables succeed when the reader has personally caused the phenomenon and can no longer dismiss the conclusion.
2. **Different editorial process.** Explorables require multi-round design work (genre → mechanic → stand-in → narrative → ethics check) before any code. Code-explainer can largely template.
3. **Different ethical weight.** Explorables persuade. A flawed explorable is propaganda. The skill must enforce evidence-traceability and abstraction-ethics in ways code-explainer doesn't need to.

A predecessor skill exists (`~/.claude/skills/explorable-explanations/SKILL.md`, written by ChatGPT Codex). It captures useful editorial concerns but lacks the dialogue structure, taxonomy, mechanic ladder, and phased build that the 20-sample analysis showed are necessary. This design supersedes it; selected content is salvaged (see §13).

## Research base

- **Wikipedia: Parable of the Polygons** — Schelling segregation model, four-phase reveal, demand-diversity inversion, reception.
- **ncase.me/polygons live read** — opening hook, rule introduction, six-section interactive progression, conclusion structure.
- **20-piece random sample of `explorabl.es`** (sampled deterministically from the 152 playable entries; see appendix A). Each piece analyzed by a parallel agent against a fixed structured schema (title, URL, genre, mechanic, stand-in, self-implication, inevitability, length, audience, tone, design, strongest move, weakness).

Key empirical findings:

- **Self-implication predicts success.** 17 of 20 pieces have a clear "reader produces the phenomenon" moment. The 3 that don't (NPR Jobs lookup, Trolley single keypress, Complexity Explorables index) are the weakest in the sample.
- **Multi-mechanic composition is the norm.** Successful pieces stack 2–4 rungs of the mechanic ladder, often in canonical order (drag → live-sim → slider → toggle → sandbox).
- **Stand-in vs. domain-faithful is more predictive than genre.** Stand-in pieces (shapes for people, sushi for candidates, balance beam for arbitrage) tend to persuade on civic/economic topics. Domain-faithful pieces (waveforms as themselves, vectors as themselves) tend to teach math/science.
- **Genre is real and tractable.** Five genres cover ≥85% of the sample with one hybrid escape hatch.

## Design decisions

### D1 — Scope: general explorable-explanations, not Polygons-clone factory

The skill targets all five genres in the taxonomy. Polygons is the canonical exemplar but not the template.

### D2 — Genre handling: skill recommends, user overrides

The skill asks about topic, audience, and goal, then proposes one genre with reasoning and one alternative. User can pick, override, or request a different genre. (Not: a flat picker upfront.)

### D3 — Editorial gates use a three-tier enforcement model

Most editorial failures (missing self-implication, decorative interaction, unclear stand-in choice) are **warn-and-log**: the skill names the failure mode, cites a sample piece that fell into it, allows override, and logs the waiver as an HTML comment. Some failures (cute stand-ins for trauma/oppression, manipulative framing) are **pause-for-reframe**: the skill proposes a concrete alternative before continuing, with override only after explicit user reasoning. A few failures (would require fabricating a citation, would directly contradict source material) are **hard-stop**: no override; user must change input. Process invariants (phase order) and output-format constraints (single HTML, no frameworks) are not gates — they are non-negotiable workflow and output rules; if the user wants something else, the skill defers to a different skill or declines the task.

### D4 — Design system: inherit code-explainer's technical scaffolding, override aesthetics per genre

Single self-contained HTML, ESM imports, no build step, OKLCH colors, accessibility defaults — all inherited. Color palette, typography, and spacing — overridden per genre via aesthetic presets (playful-illustrated, reverent-scientific, editorial, academic, gamified, intimate).

### D5 — Build phasing: five explicit passes with checkpoints, plus Playwright E2E

Each phase has a checkpoint question that must be answered honestly before advancing. Phase 2 — "the mechanic actually proves the phenomenon in isolation, with no narrative" — is the load-bearing checkpoint. It is the equivalent of TDD's red step.

### D6 — Skill layout: SKILL.md + presets/*.css

The skill is a small repo, not a single file. Layout:

```
~/.claude/skills/explorable-explanations/
├── SKILL.md
└── presets/
    ├── playful-illustrated.css
    ├── reverent-scientific.css
    ├── editorial.css
    ├── academic.css
    ├── gamified.css
    └── intimate.css        # cross-cutting overlay
```

Aesthetic preset CSS lives in separate files so they can be read, copied, and tuned independently of the SKILL.md prose. The skill instructs Claude to read the matching preset file when starting P4 (design pass) and inline the CSS variables into the generated HTML.

### D7 — No reference HTML scaffolds

The skill ships **no per-genre HTML scaffold templates**. Most of the code in any explorable is genuinely topic-specific (the mechanic, the prose, the data) — a scaffold would either be empty boilerplate or constrain the design in ways the genre table already covers. The skill points at canonical exemplar URLs (§12) and asks the user to read them as references; it does not start from a fill-in-the-blanks template.

### D8 — Single-page scope only, ≈1 hour max reading time

The skill builds single self-contained HTML files for ≤1-hour reading experiences. Multi-session workshops, multi-page courses, classroom curricula, and 3-day facilitated events are out of scope; the skill declines and suggests a different tool when asked for them.

## §1 Frontmatter and trigger

```yaml
name: explorable-explanations
description: Use when creating interactive scrollytelling pages, playable
  essays, model-driven explanations, or explorable explanations for concepts,
  phenomena, societal issues, geopolitical situations, scientific research,
  or public-interest themes. Triggered by "make an explorable explanation",
  "build a playable essay", "explain this interactively", "scrollytelling
  piece for X", references to Parable of the Polygons, Bret Victor, Bartosz
  Ciechanowski, Nicky Case, or explorabl.es.
```

The description is broader than `code-explainer` because explorables span domains code-explainer doesn't (civics, sociology, ethics, public health). It names canonical authors so the skill activates when users invoke them.

**Defers to other skills when:**
- Topic is a codebase, protocol, or technical architecture → `code-explainer`
- Output is marketing or a single landing page → `landing-page`
- Need is an interview to gather a spec → `interview`

## §2 Workflow shape

The skill runs as **6 conversational rounds** before any code, then **5 build passes** plus a Playwright E2E verification pass.

Dialogue rounds use `AskUserQuestion` with concrete options **where the choice space is enumerable** — genre selection, audience tier, mechanic ladder position, stand-in vs domain-faithful. For inputs that are genuinely free-form (the central claim, the success-criterion sentence, source-material notes, paths to user-supplied papers/data/images), the skill accepts short free-text. The discipline is *no vague open-ended prompts* — every free-text request must name what the field is for and offer a one-sentence example. The skill never asks "tell me about your topic" without scaffolding.

### Round 1 — Decode the topic

Skill asks: do you have source material (papers, articles, dataset, your own notes, images)? What's the central claim or phenomenon? What does the reader currently believe that you want to change?

Skill extracts (and writes to a working scratch file):

- Claims and counterclaims
- Causal mechanisms
- Variables and constraints
- Stakeholders and incentives
- Time scales and geography
- Evidence quality and uncertainty
- Likely misconceptions
- Harm, identity, trauma, or political sensitivity

(Salvaged from Codex's version — verbatim list.)

If the topic **cannot honestly support a deterministic model**, the skill says so and offers fallbacks: scenario comparison, uncertainty ranges, timelines, maps, constraints, tradeoff exploration. (Salvaged.)

### Round 2 — Audience tier and timing

Skill asks: which of these archetypes? Three discrete archetypes, not a smooth gradient — picking on the boundary changes the build noticeably, so the skill forces a choice. **Total reading time is capped at ≈1 hour** for any tier; the skill is for single-page scrollable explorables, not multi-session workshop materials.

| Tier | Time budget | Emotional disposition |
|---|---|---|
| **Layperson, viral-share** | 5–15 min | Curious or skeptical, wants the punchline |
| **Adjacent, deep-read** | 15–60 min | Engaged, will follow nuance |
| **Expert, reference-toy** | 5–60 min (depends on use) | Already convinced; wants the fiddly knobs |

If user picks the **expert** tier, skill flags it: in the 20-sample, expert-tier pieces (Log-spherical, Enigma) are the weakest as standalone explorables. Skill confirms intent.

If the user describes a multi-session workshop, classroom curriculum, or 3-day facilitated event, the skill **declines and suggests a different tool** — this skill builds single-page artifacts that may *be used in* a workshop, but it does not author workshop curricula.

### Round 3 — Genre recommendation with reasoning

Skill proposes **one genre** with a one-paragraph rationale tied to topic + audience tier, plus **one alternative**. User picks or overrides.

| Genre | Default arc | Default mechanic stack | Aesthetic preset | Exemplars |
|---|---|---|---|---|
| **Parameter-driven essay** | Hook → drag → auto-sim → slider → twist → sandbox | drag-and-arrange + live-sim + slider + sandbox | Playful-illustrated | Polygons, Outbreak, ETFs, Ballot, Taxicab |
| **Walkthrough with diagrams** | Wrong-solution-first → corrected → generalized | live-sim with mouse-as-input + before/after toggle | Reverent-scientific | Sight & Light, Ciechanowski, Log-spherical |
| **Scrollytelling data story** | Lede → hook → guided steps over persistent dataset → personal verdict | step-stepper + persistent canvas + one slider | Editorial | NPR Jobs, Something Fishy, Social Security |
| **Textbook with interactives** | Define → demonstrate → exercise → recap | Live figures (each section gets self-contained interactive) | Academic | Mathigon, Sines & Signals, Immersive Math |
| **Game-with-explanatory-frame** | Setup → choice → consequence → meta-reflection | minigame core + variant runs | Gamified | District, Trolley (partial) |
| **Hybrid** | User-defined | multi-mechanic explicit | User-picks-or-blends | What Happens Next?, Crowds |

### Round 4 — Stand-in vs. domain-faithful fork

Skill asks which lane:

- **Stand-in (metaphor-driven)** — shapes for people, sushi for candidates, balance beam for arbitrage. Defuses defensiveness, useful for civic/political/economic topics.
- **Domain-faithful (literal rendering)** — waveforms as themselves, vectors as themselves, dots as your earnings. The rendering *is* the explanation; useful for math/science/engineering.

If **stand-in lane**, the skill runs the **abstraction-ethics check** (gates G4a/G4b in §5): does the metaphor imply things you don't intend? Does it erase nuance? Are you using cute stand-ins for war, oppression, trauma, identity, or death? Severe cases trigger pause-for-reframe; mild cases trigger warn-and-log.

If **domain-faithful lane**, the skill runs the **literacy check**: does the audience tier picked in Round 2 understand the literal rendering without scaffolding? If not, the skill proposes one of: (a) a glossary section as Section 1, (b) a "you'll see X — here's how to read it" preamble before each new figure type, (c) a domain-faithful → stand-in fallback (e.g., Polygons-style metaphor instead of literal Schelling math). The check is warn-and-log; the user can proceed without scaffolding if they accept the audience-mismatch risk.

### Round 5 — Mechanic selection

Skill walks the **mechanic ladder** (§4), recommends 2–3 rungs to compose, and names the canonical sequence (drag → sim → slider → toggle → sandbox) when applicable.

If the topic involves multiple stakeholders trading off values (policy, ethics negotiation), skill surfaces **role-based negotiation** as a device class. (Salvaged from Codex.)

If the topic involves place, history, or sequence as central, skill surfaces **map** or **timeline** as device classes. (Salvaged.)

If the topic involves contagion, supply, money, trust, or information moving through a graph, skill surfaces **network/flow**. (Salvaged.)

### Round 6 — Self-implication moment named

Skill requires the user to write **one sentence**: *"the reader produces the phenomenon by doing X."*

This is the most important gate. If the user can't write the sentence, skill warns (see §5 G1) and offers patterns from the library (§7).

The skill also asks the user to write the **Model Contract** before build (salvaged from Codex, verbatim):

```
Claim:
Mechanism:
Reader action:
Visible consequence:
Evidence or assumption:
Limit:
```

This single-paragraph artifact captures most of the design decisions in one place and travels with the project.

## §3 Genre-specific patterns

The §2 Round 3 table already names each genre's default arc, mechanic stack, aesthetic preset, and exemplars. This section adds the **failure mode each genre is most prone to**, drawn from observed weaknesses in the 20-sample analysis. The skill surfaces these as warnings during Round 3 when the user's chosen genre carries a known risk for the topic.

| Genre | Tends to fail by... | Counter-move |
|---|---|---|
| **Parameter-driven essay** | Cute aesthetic + simple model lets critics dismiss the moral conclusion as a toy. The simplification that gives clarity is the same simplification that flattens reality. | Explicit "model limits" section; link to source paper; one paragraph on "what this model doesn't show." |
| **Walkthrough with diagrams** | Assumes technical fluency the reader doesn't have. Strong on "this is how X works," weak on "why should I care." | Open with the consequence or failure that motivates the technique, not the technique itself. |
| **Scrollytelling data story** | Becomes a guided lookup rather than a model — reader sees numbers, can't test claims. | At least one parameter the reader controls; one moment where the reader's input changes the conclusion (not just personalizes it). |
| **Textbook with interactives** | LMS chrome flattens voice; progress-gating turns to friction when the reader already knows an answer. | Distinct chapter voice; optional skip-to-mastery for confident readers; no progress-bar fetishism. |
| **Game-with-explanatory-frame** | Symbolic-only action — the entire moral weight collapses to one keypress. | Vary parameters across runs; force the reader to confront edge cases of the rule, not just one instantiation. |
| **Hybrid** | Misses the spine of any one genre and ends up structurally muddled. | Even a hybrid has one dominant arc; identify it explicitly before composing. |

The skill ships with **one canonical reference example per genre** that it can point at during build ("for this topic, the closest published exemplar is X — read it before you start").

## §4 Mechanic ladder

The ladder is **ordered by implication strength** — how directly the reader's own action produces the phenomenon being explained. The 20-sample analysis shows this is the dimension that most predicts whether a piece lands; ranking by complexity, commonness, or visual sophistication would mix signals.

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
10. freeform-sandbox           — reader plays freely (closer; implication varies by setup)
```

**Role in the piece is a separate axis.** Drag and step-stepper often serve as **setup**; live-sim and slider as **exploration**; toggle and hover as **reveal**; sandbox and minigame as **closer or standalone**. A mature piece composes 2–4 rungs across multiple roles — the empirical norm in the sample.

**Composite device classes** (suggested by topic shape; each pulls multiple rungs from the ladder):
- Map (place, geography is central)
- Timeline (sequence, history is central)
- Network/flow (contagion, supply, money, trust, information)
- Ladder of abstraction (Bret Victor — concrete examples + aggregate patterns side by side)
- Role-based negotiation (multi-stakeholder tradeoff)

The skill recommends rungs and composites based on genre and topic. The default recommendation favors **higher-implication rungs** (1–4) for the core mechanic, with lower-implication rungs as supporting moves.

## §5 Editorial gates (three-tier enforcement)

Editorial failures are not all equivalent. A piece without a clear self-implication moment is weaker but publishable; a piece using cute stand-ins for genocide is reckless; a piece whose only path forward requires the skill to invent citations is propaganda. Treating these the same with a single "warn" verb produces confused agent behavior. The skill uses a three-tier taxonomy:

| Tier | Behavior |
|---|---|
| **warn-and-log** | Skill names the failure mode, cites a sample piece that fell into it, asks the user to confirm override. If user proceeds, logs the waiver as an HTML comment at the top of the generated file (`<!-- WAIVED: G1 self-implication — user confirmed YYYY-MM-DD -->`) so reviewers can see what was waived. |
| **pause-for-reframe** | Skill stops and proposes an explicit alternative framing before continuing. User can: (a) accept the reframe, (b) keep original — which then drops to warn-and-log behavior with the override reasoning required, (c) abandon the design. The skill does not silently proceed. |
| **hard-stop** | Skill refuses to proceed and explains why. The user must change input. There is no override. Reserved for failures where proceeding would require fabrication or directly contradict source material. |

What is **not** a gate (handled differently):

- **Process invariants** (e.g., "phase order is fixed", "P2 checkpoint before P3") — these are workflow rules. The skill does not negotiate these because skipping them changes what the skill *is*.
- **Output-format requirements** (e.g., single HTML file, ESM only, no frameworks) — these are §11 build constraints. If the user wants a different output shape, the skill defers to a different skill or declines the task; it does not produce a degraded output of the wrong shape.

### Gate inventory

| Gate | Question | Tier | Failure mode | Sample reference |
|---|---|---|---|---|
| **G1 — Self-implication** | Where does the reader produce the phenomenon? | warn-and-log | Lookup-not-model | NPR Jobs |
| **G2 — Mechanic on ladder** | Is your interaction on the §4 ladder at all, or is it decorative? Which rung(s)? | warn-and-log | Decorative interaction | (general) |
| **G3 — Stand-in declared** | Stand-in or domain-faithful? | warn-and-log | Mixed mode confuses readers | (general) |
| **G4a — Abstraction-ethics, mild** (stand-in only) | Does the metaphor imply things you don't intend? Erase nuance? | warn-and-log | Over-flattening | Ballot 1D opinion space |
| **G4b — Abstraction-ethics, severe** (stand-in only) | Are you using cute stand-ins for war, oppression, trauma, identity, or death? | **pause-for-reframe** | Ethics-by-cuteness | (skill proposes safer frame; see §6) |
| **G5 — Anti-pattern self-check** (before build) | Any anti-patterns from §8 present? | warn-and-log | (multiple) | (see §8) |
| **G6 — Inevitability test** | If a skeptical reader finishes this, can they shrug it off? | warn-and-log | Topic doesn't have an inevitability spine | Trolley Problem |
| **G7a — Source provenance, soft** | Each major claim or parameter traces to a source or is labeled `(assumption)` | warn-and-log | Manufactured authority | (general) |
| **G7b — Source provenance, hard** | Skill would need to invent or hallucinate a citation to fill a numeric claim | **hard-stop** | Fabrication | (no override; user must supply source or relabel as assumption) |
| **G8 — Model limits visible** | Limits in the page, not hidden in a footnote | warn-and-log | False certainty | (general) |
| **G9 — Manipulative framing** | Does the requested framing present a contested claim as physics, hide value judgments behind interactive chrome, or use symmetric visuals to imply false symmetric power? | **pause-for-reframe** | Propaganda by aesthetics | (skill proposes safer frame; see §6) |

(G7 and G8 salvaged from Codex; G4 split into mild/severe and G9 added to make the §6 ethics rules enforceable rather than aspirational.)

## §6 Ethics and Model Integrity (salvaged from Codex)

Explorable explanations are persuasive *because they feel self-evident*. That creates responsibility. Each rule below names the §5 gate tier it triggers, so enforcement is explicit rather than aspirational.

| Rule | §5 gate tier |
|---|---|
| Do not present contested history or moral judgment as mathematical certainty | G9 — **pause-for-reframe** |
| Do not use cute stand-ins for war, oppression, trauma, identity, or death unless abstraction clearly reduces harm and the user has explicitly approved the tone | G4b — **pause-for-reframe** |
| Do not create a "proof" when the evidence supports only scenarios or hypotheses | G7a — **warn-and-log** (relabel as scenario/hypothesis); escalates to G9 **pause-for-reframe** if the framing actively claims proof |
| Each major claim or parameter must trace to a source or be labeled as an assumption | G7a — **warn-and-log** |
| If the skill would have to invent a citation to support a numeric claim | G7b — **hard-stop** |
| Symmetric visuals must not imply symmetric power, agency, or harm unless that is true | G9 — **pause-for-reframe** |
| Include model limits in the page, not hidden in a footnote | G8 — **warn-and-log** |
| Prefer "here is what this model shows" over "this proves what is happening" | G9 — **pause-for-reframe** if framing crosses into the latter |

When the skill issues a pause-for-reframe, it must propose a **concrete alternative**, not just flag the problem. Example: if the user requests "a Polygons-style piece about [contested historical event]," the skill might propose: *the Schelling-shape mechanic implies the dynamic is bottom-up and emergent; if your sources say the event was top-down and engineered, the mechanic will lie. Consider a role-based negotiation device or a constrained-choice game instead.* The user can accept, override (drops to warn-and-log with required override reasoning), or rework.

For sensitive topics, the skill surfaces **content warnings** and **skip-ahead links** as defaults, not afterthoughts. The **intimate tone overlay** (see the Design System section) is the default for personal/health/grief/trauma topics.

## §7 Soft prompts: named patterns from the sample analysis

Each pattern is a short entry the skill can offer when relevant. All patterns derive from observed strongest moves in the 20-sample.

- **Reader-as-cause** — drag-or-place produces the phenomenon (Polygons, ETFs, Ballot, Taxicab)
- **Persistent canvas** — one visual stays on screen, each section transforms it (Social Security dots, ETFs balance beam, Polygons grid)
- **Wrong-solution staged first** — show broken before fixed (Sight & Light, Taxicab gut-poll, Polygons reduce-bias-fails)
- **One-knob-per-section** — build the model parameter by parameter (Outbreak)
- **Strip the loaded label** — sushi for candidates, shapes for people (Polygons, Something Fishy)
- **Pair every claim with a reproducible sim** (What Happens Next?)
- **Reciprocal closing** — sandbox after the argument (Polygons, Outbreak, Ballot)
- **Wrong intuitive fix → counterintuitive correct fix** (Polygons demand-diversity inversion)
- **Personal verdict** — make the reader the input (NPR Jobs found-your-job, Social Security build-your-career)

## §8 Anti-patterns the skill refuses (or warns about)

Drawn from observed weaknesses + Codex's list:

1. **Lookup-not-model** — reader inputs themselves but learns no causal mechanism (NPR Jobs)
2. **Decorative interaction** — moves on screen but contributes nothing (ETFs random walk drift)
3. **Symbolic-only action** — interaction collapses to a token (Trolley single keypress)
4. **On-rails stepper** — reader can't author or stress-test (Something Fishy variants)
5. **Closed simulation** — once guided beats end, exploration yields nothing (Taxicab fixed town)
6. **Index without through-line** — assemblage of toys, no argument (Complexity Explorables)
7. **Discoverability gap** — affordance is hidden (Social Security keyboard-only, Enigma zero markdown)
8. **No on-ramp for adjacent reader** — sliders look pretty, don't teach without prior fluency (Log-spherical)
9. **Metaphor over-flattens** — abstraction erases the actual contested thing (Ballot 1D opinion space)
10. **Parable clone thinking** — copying shapes instead of finding the topic's causal device (Codex)
11. **False neutrality** — hides value judgments behind interactive chrome (Codex)
12. **A beautiful page whose lesson could have been a paragraph** (Codex)
13. **A complex simulation whose assumptions readers cannot inspect** (Codex)
14. **Sandbox without thesis** (Codex)
15. **Sliders that imply precision the evidence does not support** (Codex)

## §9 Build phases

The skill executes **five build phases (P1–P5) followed by a Playwright E2E verification pass.** Each build phase has an explicit checkpoint the skill must answer honestly before advancing. Phase order is a process invariant (see §5) — not a gate, not negotiable, because skipping a phase changes what the skill is.

| Phase | Output | Checkpoint |
|---|---|---|
| **P1 — Scaffold** | HTML skeleton; sections stubbed with placeholder text; mechanic stub elements present but not wired; aesthetic preset applied | Does the page render top-to-bottom without errors? |
| **P2 — Core mechanic in isolation** | The mechanic actually produces the phenomenon. Crude visuals OK; no narrative persuasion yet. | **Can a cold reader, with only the minimal rules and labels needed to operate the model — no narrative persuasion, no framing prose — produce the phenomenon by interacting? If no, the mechanic isn't carrying its weight; fix the mechanic, not the prose, before continuing.** |
| **P3 — Narrative wiring** | Prose written/pasted into sections; mechanic-prose handoffs wired; scroll/step transitions in place | Does the piece flow if you read it top to bottom *without* touching the mechanic? Does it flow if you only touch the mechanic and never read prose? |
| **P4 — Design pass** | Color, type, spacing per genre preset; figure styling; responsive | Does the design match the genre and the topic's emotional register? |
| **P5 — Polish** | Reduced-motion, keyboard nav, mobile, state-on-scroll-back, content warnings if applicable, source/provenance section, model-limits section | Is there a single accessibility or UX bug a first-time reader will hit? |

**Verification pass — Playwright E2E** (post-build, separate from build phases): test script walks the page, fires every interaction, asserts the phenomenon is produced. Checkpoint: do the tests pass? Do they verify the *learning*, not just the DOM?

**P2 is the load-bearing checkpoint.** It is the explorable equivalent of TDD's red step. If the mechanic doesn't prove the phenomenon under minimal-rules conditions, no amount of prose or design rescues the piece. The "minimal rules" framing replaces an earlier "zero prose" formulation that was too harsh for civic, historical, or abstract topics where some labels are essential to operate the model — the test is whether *narrative persuasion* is doing the work the mechanic should be doing, not whether all text is gone.

### Playwright verification list (salvaged + extended from Codex)

- Load the page; assert no console errors
- Walk through all scrollytelling sections
- Exercise every slider, button, drag/drop target, tab, toggle, reset
- **Verify the mechanical twist is visible**
- **Verify the conclusion is reachable without getting trapped in an interaction** (Codex)
- Test at mobile width ≥ 360 px; assert no horizontal scroll
- Test keyboard operation for controls
- Check `prefers-reduced-motion` behavior if animation exists
- Confirm citations, assumptions, model limits are visible

## §10 Design system: inherited core, genre presets

**Inherited from `code-explainer`:**
- Single self-contained HTML file
- ESM imports / import maps for libraries (D3, Observable Plot, Three.js, Pixi.js, Mermaid)
- No build step, no React/Vite/etc.
- No remote fonts unless explicitly opted in
- OKLCH-only color (no hex `#000` / `#fff`)
- Inline `<style>` and inline `<script type="module">`
- All SVG text is live `<text>`, not paths
- Exactly one `<h1>`, correct heading order
- Accessibility defaults

**Genre aesthetic presets** (each ships as a CSS variable block + type scale):

1. **Playful-illustrated** — bright flat palette, chunky display type, illustrated affect (Polygons, Outbreak)
2. **Reverent-scientific** — whiteground or near-white, restrained single-accent, technical figure captions (Bartosz, Sight & Light)
3. **Editorial** — large display serif, single accent, generous whitespace, NYT/Bloomberg sensibility (NPR Jobs, ETFs, Social Security)
4. **Academic** — serif body, numbered figures, deep glossary, textbook chrome (Mathigon, Immersive Math)
5. **Gamified** — chunky UI panels, strong feedback, rule explainer (Ballot, District)

**Cross-cutting tone overlay** (applied on top of any genre preset when the topic is personal, health-related, grief-adjacent, or trauma-adjacent):

- **Intimate** (salvaged from Codex) — softer palette, restrained motion, generous spacing, content warnings as a default. The skill auto-suggests this overlay when Round 1 surfaces harm/identity/trauma sensitivity.

User can override any preset or overlay; skill suggests based on genre, topic emotional register, and Round 1 sensitivity flags.

## §11 Build requirements (hard, salvaged + extended)

- One self-contained `.html` page
- Inline CSS in `<style>`; inline page logic in `<script type="module">`
- External libraries only via ESM imports or import maps (no `<script src>`)
- No framework build step
- No decorative animation
- No horizontal scroll at 360 px viewport
- Exactly one `<h1>`; correct heading order
- **Source/provenance section near the end** (salvaged)
- **Model limits section visible to readers** (salvaged)
- **Final section connects the model to what the reader can do, decide, or question next** (salvaged — addresses the "exit / takeaway" gap)
- Override warnings (from §5) logged as HTML comments at the top of the file

## §12 Reference exemplar set

The skill carries a curated annotated list of 8–12 exemplars, with one-paragraph annotations. From the 20-sample analysis plus known canonical pieces:

- **Parable of the Polygons** — canonical parameter-driven essay; archetypal self-implication; demand-diversity inversion
- **Outbreak (Melting Asphalt)** — one-knob-per-section scaffold; didactic pacing
- **What Happens Next? (Nicky Case + Marcel Salathé)** — pair-claim-with-sim move; hybrid genre
- **How ETFs Work (Bloomberg)** — physical metaphor (balance beam) for abstract mechanism
- **Something Fishy In American Politics (John Austin)** — strip-the-loaded-label move (sushi)
- **To Build A Better Ballot (Nicky Case)** — drag-causes-pathology civic explorable
- **Sight & Light (Nicky Case)** — wrong-solution-staged-first
- **Bartosz Ciechanowski (clocks, GPS, light, sound)** — gold standard reverent-scientific (not in 20-sample but canonical)
- **Mathigon** — textbook genre canonical
- **Social Security Retirement Benefits, Explained Visually (Lewis Lehe)** — persistent-canvas scrollytelling
- **Up and Down the Ladder of Abstraction (Bret Victor)** — canonical Ladder-of-abstraction device

## §13 Migration from the Codex predecessor skill

The existing `~/.claude/skills/explorable-explanations/SKILL.md` (Codex-authored) will be replaced. Salvaged content in this design:

- **Model Contract template** (§2 Round 6) — verbatim
- **Decoding extraction checklist** (§2 Round 1) — verbatim list
- **Honest-pivot guidance** (§2 Round 1) — "if topic cannot honestly support a deterministic model" with fallback list
- **Audience archetype framing** (§2 Round 2) — three tiers; workshop mode dropped from scope
- **Role-based negotiation, map, timeline, network/flow as device classes** (§4 composite device classes)
- **Intimate tone overlay** (§10)
- **Ethics and Model Integrity rules** (§6) — verbatim where possible
- **Source-provenance + model-limits as hard build requirements** (§5 G7/G8, §11)
- **Playwright check: "verify conclusion is reachable without getting trapped"** (§9)
- **Anti-pattern additions**: Parable clone thinking, false neutrality, lesson-could-have-been-a-paragraph, assumptions-readers-cannot-inspect, sandbox-without-thesis, sliders-that-imply-fake-precision (§8)

Discarded:
- Flat-checklist structure (replaced by 6-round dialogue + 5-phase build)
- Single undifferentiated story-device table (replaced by mechanic ladder + composite device classes + multi-mechanic norm)
- Single-bullet build step (replaced by 5 explicit phases with checkpoints)
- "Baseline Failures This Skill Prevents" section (specific to Codex's testing context, not portable)

## §14 What the skill will not do

- No frameworks (React, Vue, Svelte, Vite, webpack)
- No marketing copy (defer to `landing-page`)
- No code/protocol explainers (defer to `code-explainer`)
- No autoplay audio
- No "story-mode" toggles — the piece works the same whether you scroll or interact
- No anti-pattern bypass without a logged warning comment in the HTML
- No invented citations or fabricated data — if a parameter has no source, it is labeled `(assumption)`

## Open questions

*(All previously-open questions have been resolved as design decisions D6, D7, and D8 above. This section is reserved for questions that surface during writing-plans.)*

## Appendix A — 20-sample composition

Random sample of 20 from the 152 playable explorables on `explorabl.es/all/` (excluding tools/tutorials/reading/faq/meta entries), seeded for reproducibility. Full per-piece structured analysis available in conversation transcript:

1. Seeing Circles, Sines, and Signals (math)
2. This Book Is A Planetarium (misc)
3. Parable of the Polygons (social)
4. Outbreak — Melting Asphalt (biology)
5. The Enigma Machine — Observable (misc)
6. The Taxicab Problem (math)
7. Mathigon (math)
8. Social Security Retirement Benefits, Explained Visually (economics)
9. Trolley Problem — Pippin Barr (philosophy)
10. What Happens Next? — covid-19 (biology)
11. Sight & Light — Nicky Case (programming)
12. How Exchange Traded Funds Work — Bloomberg (economics)
13. Complexity Explorables (biology/physics/math)
14. Will Your Job Be Done By A Machine? — NPR (economics/journalism)
15. Basic Beats (art)
16. Mathy Carlo — Observable (math)
17. Immersive Math (math)
18. To Build A Better Ballot — Nicky Case (civics)
19. Log-spherical Mapping in SDF Raymarching (programming/art)
20. Something Fishy In American Politics (civics)
