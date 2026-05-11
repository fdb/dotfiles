# Explorable-Explanations Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Codex-authored `explorable-explanations` skill with a v2 implementation that follows the design at `docs/superpowers/specs/2026-04-27-explorable-explanations-design.md`, then validate the new skill end-to-end by using it to build a Dutch-language explainer about the Belgian Jeugdzorg crisis.

**Architecture:** The skill is a small repo (`SKILL.md` + `presets/*.css`). `SKILL.md` drives a 6-round `AskUserQuestion` dialogue, then a 5-phase build with checkpoints, ending in a Playwright E2E verification pass. CSS presets are read at P4 (design pass) and inlined into the generated single-file HTML.

**Tech Stack:** Markdown (SKILL.md), OKLCH-based CSS (presets). Generated explorables use vanilla HTML + ESM imports (D3, Observable Plot, Three.js, etc.) and Playwright for E2E.

**Source of truth:** `/Users/fdb/dotfiles/claude/skills/explorable-explanations/` — symlinked to `~/.claude/skills/explorable-explanations/` via `install.sh`. Editing in dotfiles takes effect immediately at runtime.

**Commit policy:** Per user instruction, **do not auto-commit** any file in this plan. The user will review and commit manually.

---

## Phase 1 — Build the skill (Tasks 1–13)

### Task 1: Backup the Codex SKILL.md

**Files:**
- Copy from: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.md`
- Copy to: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.bak`

- [ ] **Step 1: Copy the existing SKILL.md to SKILL.bak**

```bash
cp /Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.md \
   /Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.bak
```

- [ ] **Step 2: Verify the backup**

```bash
ls -la /Users/fdb/dotfiles/claude/skills/explorable-explanations/
```

Expected: both `SKILL.md` and `SKILL.bak` present, same byte size.

- [ ] **Step 3: Add SKILL.bak to .gitignore (if not already)**

The user does not want SKILL.bak committed. Check the dotfiles `.gitignore` and add the pattern if missing:

```bash
grep -E "^SKILL\.bak|skills/.*\.bak" /Users/fdb/dotfiles/.gitignore || \
  echo "claude/skills/*/SKILL.bak" >> /Users/fdb/dotfiles/.gitignore
```

Do not commit the .gitignore change in this task — bundle with later commits if user requests.

---

### Task 2: Create the presets directory

**Files:**
- Create: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/presets/`

- [ ] **Step 1: Create the directory**

```bash
mkdir -p /Users/fdb/dotfiles/claude/skills/explorable-explanations/presets
```

- [ ] **Step 2: Verify**

```bash
ls -d /Users/fdb/dotfiles/claude/skills/explorable-explanations/presets/
```

Expected: directory exists.

---

### Task 3: Write `presets/playful-illustrated.css`

**Files:**
- Create: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/presets/playful-illustrated.css`

Used for: parameter-driven essays (Polygons, Outbreak, ETFs, Ballot, Taxicab style). Bright, flat, chunky type, illustrated affect.

- [ ] **Step 1: Write the preset**

```css
/*
 * Playful-illustrated preset
 * For: parameter-driven essays — Polygons, Outbreak, ETFs, Ballot, Taxicab
 * Mood: bright, flat, chunky, hand-drawn affect
 *
 * Inlined into the generated HTML's :root{} block at P4 (design pass).
 */
:root {
  /* surfaces — warm off-whites, never pure */
  --bg:         oklch(0.98 0.012 85);    /* page background, warm cream */
  --surface:    oklch(0.95 0.018 85);    /* figures, cards */
  --surface-2:  oklch(0.91 0.022 85);    /* code, inset blocks */
  --rule:       oklch(0.84 0.020 85);    /* borders */

  /* text — warm darks, never pure black */
  --ink:        oklch(0.22 0.02 250);    /* primary text */
  --ink-muted:  oklch(0.42 0.02 250);    /* secondary */
  --ink-faint:  oklch(0.58 0.015 250);   /* tertiary, axis labels */

  /* two vivid accents (one warm, one cool) — used sparingly */
  --accent:      oklch(0.72 0.18 50);    /* vivid orange */
  --accent-bg:   oklch(0.92 0.06 50);    /* soft orange wash */
  --deep:        oklch(0.62 0.16 220);   /* clear blue */
  --deep-bg:     oklch(0.92 0.06 220);

  /* extended palette for two-group stand-ins (Polygons-style) */
  --hue-a:       oklch(0.72 0.18 50);    /* group A — orange */
  --hue-b:       oklch(0.62 0.16 220);   /* group B — blue */
  --hue-c:       oklch(0.70 0.16 150);   /* group C — green (third party) */
  --hue-warn:    oklch(0.72 0.18 25);    /* unhappy/wrong state */

  /* type scale — chunky display */
  --font-display: 'Inter', system-ui, -apple-system, 'Segoe UI', sans-serif;
  --font-body:    var(--font-display);
  --font-mono:    ui-monospace, 'SF Mono', Menlo, monospace;

  --h1-size: clamp(2.4rem, 5vw + 1rem, 3.6rem);
  --h1-weight: 800;
  --h1-tracking: -0.025em;

  --h2-size: 1.8rem;
  --h2-weight: 700;

  --body-size: 18px;
  --body-leading: 1.65;

  /* spacing rhythm — generous */
  --section-gap: 5rem;
  --para-gap: 1.25rem;
  --content-max: 64ch;

  /* motion — playful but disciplined */
  --transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1);
  --transition-slow: 350ms cubic-bezier(0.4, 0, 0.2, 1);
}

@media (prefers-reduced-motion: reduce) {
  :root {
    --transition-fast: 0ms;
    --transition-slow: 0ms;
  }
}
```

- [ ] **Step 2: Sanity check**

Open the file. Confirm: no hex `#000` or `#fff` anywhere; all color values are OKLCH; reduced-motion override present; preset is genuinely "bright, flat, chunky" and not just a copy of code-explainer's dark palette.

---

### Task 4: Write `presets/reverent-scientific.css`

**Files:**
- Create: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/presets/reverent-scientific.css`

Used for: walkthroughs (Bartosz Ciechanowski, Sight & Light, Log-spherical). Whiteground, restrained, technical.

- [ ] **Step 1: Write the preset**

```css
/*
 * Reverent-scientific preset
 * For: walkthroughs — Ciechanowski, Sight & Light, Log-spherical
 * Mood: whiteground, restrained single-accent, technical figure captions
 */
:root {
  --bg:         oklch(0.99 0.004 240);   /* near-white, faint cool cast */
  --surface:    oklch(0.97 0.005 240);
  --surface-2:  oklch(0.94 0.006 240);
  --rule:       oklch(0.86 0.006 240);

  --ink:        oklch(0.18 0.012 250);
  --ink-muted:  oklch(0.40 0.010 250);
  --ink-faint:  oklch(0.60 0.008 250);

  /* single muted accent — slate blue, technical */
  --accent:      oklch(0.50 0.10 240);
  --accent-bg:   oklch(0.94 0.04 240);
  --deep:        var(--accent);          /* same accent in this preset */
  --deep-bg:     var(--accent-bg);

  /* sparing semantic colors */
  --hue-a:       oklch(0.55 0.12 240);
  --hue-b:       oklch(0.58 0.12 30);
  --hue-warn:    oklch(0.62 0.16 25);

  --font-display: 'Inter Tight', 'Inter', system-ui, sans-serif;
  --font-body:    'Inter', system-ui, sans-serif;
  --font-mono:    ui-monospace, 'SF Mono', 'JetBrains Mono', Menlo, monospace;

  --h1-size: clamp(2rem, 4vw + 0.5rem, 2.75rem);
  --h1-weight: 600;
  --h1-tracking: -0.02em;

  --h2-size: 1.5rem;
  --h2-weight: 600;

  --body-size: 17px;
  --body-leading: 1.7;

  --section-gap: 4.5rem;
  --para-gap: 1.1rem;
  --content-max: 68ch;

  --transition-fast: 120ms ease;
  --transition-slow: 260ms ease;

  /* figure caption styling — small, technical */
  --caption-size: 13px;
  --caption-leading: 1.5;
  --caption-color: var(--ink-faint);
}

@media (prefers-reduced-motion: reduce) {
  :root {
    --transition-fast: 0ms;
    --transition-slow: 0ms;
  }
}
```

- [ ] **Step 2: Sanity check**

Confirm: tone is restrained, not playful; single accent (no second decorative color); figure-caption variables present.

---

### Task 5: Write `presets/editorial.css`

**Files:**
- Create: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/presets/editorial.css`

Used for: scrollytelling data stories (NPR Jobs, Bloomberg ETFs, Lewis Lehe Social Security). Large display serif, single accent, generous whitespace.

- [ ] **Step 1: Write the preset**

```css
/*
 * Editorial preset
 * For: scrollytelling data stories — NYT/NPR/Bloomberg sensibility
 * Mood: large display serif, single accent, generous whitespace
 */
:root {
  --bg:         oklch(0.99 0.003 80);    /* warm near-white */
  --surface:    oklch(0.97 0.005 80);
  --surface-2:  oklch(0.93 0.006 80);
  --rule:       oklch(0.84 0.006 80);

  --ink:        oklch(0.16 0.010 50);    /* near-black warm */
  --ink-muted:  oklch(0.40 0.008 50);
  --ink-faint:  oklch(0.58 0.006 50);

  /* single brand-style accent — editorial red or NYT blue, picked per piece */
  --accent:      oklch(0.55 0.18 25);    /* default: editorial red */
  --accent-bg:   oklch(0.94 0.05 25);
  --deep:        var(--accent);
  --deep-bg:     var(--accent-bg);

  --hue-a:       oklch(0.55 0.16 25);
  --hue-b:       oklch(0.50 0.14 230);

  /* serif display, sans body — the editorial signature */
  --font-display: 'Lora', 'Source Serif Pro', Georgia, 'Times New Roman', serif;
  --font-body:    'Inter', system-ui, sans-serif;
  --font-mono:    ui-monospace, Menlo, monospace;

  --h1-size: clamp(2.5rem, 5.5vw + 0.5rem, 4rem);
  --h1-weight: 700;
  --h1-tracking: -0.03em;

  --h2-size: 1.75rem;
  --h2-weight: 600;

  --body-size: 18px;
  --body-leading: 1.7;

  --section-gap: 5rem;
  --para-gap: 1.3rem;
  --content-max: 62ch;

  --transition-fast: 150ms ease;
  --transition-slow: 300ms ease;

  /* deck/lede styling — the oversized intro paragraph */
  --lede-size: 22px;
  --lede-leading: 1.55;
  --lede-color: var(--ink-muted);
}

@media (prefers-reduced-motion: reduce) {
  :root {
    --transition-fast: 0ms;
    --transition-slow: 0ms;
  }
}
```

- [ ] **Step 2: Sanity check**

Confirm: serif display, sans body (the editorial pairing); lede variables present; single accent (editorial red); content max narrower than reverent-scientific (62ch vs 68ch — for a more dramatic column).

---

### Task 6: Write `presets/academic.css`

**Files:**
- Create: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/presets/academic.css`

Used for: textbook-with-interactives (Mathigon, Sines & Signals, Immersive Math). Serif body, numbered figures, glossary chrome, textbook sensibility.

- [ ] **Step 1: Write the preset**

```css
/*
 * Academic preset
 * For: textbook-with-interactives — Mathigon, Sines & Signals, Immersive Math
 * Mood: serif body, numbered figures, deep glossary, textbook chrome
 */
:root {
  --bg:         oklch(0.99 0.002 90);
  --surface:    oklch(0.96 0.004 90);
  --surface-2:  oklch(0.92 0.005 90);
  --rule:       oklch(0.82 0.006 90);

  --ink:        oklch(0.18 0.008 270);   /* slight cool cast — scholarly */
  --ink-muted:  oklch(0.42 0.008 270);
  --ink-faint:  oklch(0.60 0.006 270);

  /* deeper, more saturated single accent — textbook blue */
  --accent:      oklch(0.45 0.16 250);
  --accent-bg:   oklch(0.94 0.05 250);
  --deep:        oklch(0.42 0.14 280);   /* secondary, slight purple */
  --deep-bg:     oklch(0.94 0.05 280);

  /* multi-color palette for math diagrams — RGB convention */
  --hue-x: oklch(0.55 0.20 25);          /* x-axis red */
  --hue-y: oklch(0.55 0.18 145);         /* y-axis green */
  --hue-z: oklch(0.50 0.18 250);         /* z-axis blue */

  --font-display: 'Lora', 'Source Serif Pro', Georgia, serif;
  --font-body:    'Lora', 'Source Serif Pro', Georgia, serif;  /* serif throughout */
  --font-mono:    ui-monospace, 'JetBrains Mono', Menlo, monospace;

  --h1-size: clamp(2rem, 4vw + 0.5rem, 2.75rem);
  --h1-weight: 700;
  --h1-tracking: -0.02em;

  --h2-size: 1.5rem;
  --h2-weight: 700;

  --body-size: 17px;
  --body-leading: 1.7;

  --section-gap: 4rem;
  --para-gap: 1rem;
  --content-max: 66ch;

  --transition-fast: 120ms ease;
  --transition-slow: 260ms ease;

  /* numbered figure caption — "Figure 3.1: ..." style */
  --figure-number-size: 12px;
  --figure-number-weight: 600;
  --figure-number-tracking: 0.1em;
  --figure-number-color: var(--accent);
}

@media (prefers-reduced-motion: reduce) {
  :root {
    --transition-fast: 0ms;
    --transition-slow: 0ms;
  }
}
```

- [ ] **Step 2: Sanity check**

Confirm: serif throughout (display AND body); RGB axis colors for math diagrams; figure-number styling present; no playful elements.

---

### Task 7: Write `presets/gamified.css`

**Files:**
- Create: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/presets/gamified.css`

Used for: game-with-explanatory-frame (Ballot, District, Trolley Problem). Chunky UI panels, strong feedback colors, rule-explainer chrome.

- [ ] **Step 1: Write the preset**

```css
/*
 * Gamified preset
 * For: game-with-explanatory-frame — Ballot, District, Trolley Problem
 * Mood: chunky UI panels, strong feedback (success/fail), rule-explainer chrome
 */
:root {
  --bg:         oklch(0.20 0.020 270);   /* dark slate */
  --surface:    oklch(0.26 0.022 270);   /* card panels */
  --surface-2:  oklch(0.32 0.024 270);
  --rule:       oklch(0.42 0.024 270);

  --ink:        oklch(0.94 0.008 90);    /* warm off-white */
  --ink-muted:  oklch(0.74 0.010 90);
  --ink-faint:  oklch(0.58 0.010 90);

  /* feedback colors — explicit success/fail */
  --accent:      oklch(0.78 0.16 90);    /* highlight yellow — selection/active */
  --accent-bg:   oklch(0.32 0.10 90);
  --deep:        oklch(0.70 0.14 250);   /* info blue */
  --deep-bg:     oklch(0.30 0.06 250);
  --success:     oklch(0.72 0.18 145);   /* green */
  --success-bg:  oklch(0.30 0.08 145);
  --warn:        oklch(0.72 0.18 25);    /* red */
  --warn-bg:     oklch(0.30 0.10 25);

  --hue-a:       var(--accent);
  --hue-b:       var(--deep);
  --hue-c:       var(--success);

  --font-display: 'Inter', system-ui, sans-serif;
  --font-body:    'Inter', system-ui, sans-serif;
  --font-mono:    ui-monospace, 'JetBrains Mono', Menlo, monospace;

  --h1-size: clamp(2.2rem, 5vw + 0.5rem, 3.2rem);
  --h1-weight: 800;
  --h1-tracking: -0.025em;

  --h2-size: 1.6rem;
  --h2-weight: 700;

  --body-size: 17px;
  --body-leading: 1.6;

  --section-gap: 4rem;
  --para-gap: 1rem;
  --content-max: 60ch;

  --transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1);
  --transition-slow: 280ms cubic-bezier(0.4, 0, 0.2, 1);

  /* UI panel chrome — chunky borders, strong feedback */
  --panel-radius: 12px;
  --panel-border: 2px solid var(--rule);
  --panel-shadow: 0 4px 0 oklch(0.10 0.020 270);  /* hard drop shadow, retro feel */

  /* button chrome */
  --button-radius: 10px;
  --button-padding: 0.75rem 1.25rem;
}

@media (prefers-reduced-motion: reduce) {
  :root {
    --transition-fast: 0ms;
    --transition-slow: 0ms;
  }
}
```

- [ ] **Step 2: Sanity check**

Confirm: dark background (the only dark preset — game UIs read better dark); explicit success/warn colors; UI panel chrome variables (radius, border, shadow); chunky type weights.

---

### Task 8: Write `presets/intimate.css`

**Files:**
- Create: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/presets/intimate.css`

Used as a **cross-cutting overlay** (applied on top of any genre preset) for personal/health/grief/trauma topics. Softer palette, restrained motion, generous spacing, content warnings prominent.

- [ ] **Step 1: Write the overlay**

```css
/*
 * Intimate overlay
 * Applied on top of any genre preset when the topic is personal,
 * health-related, grief-adjacent, or trauma-adjacent.
 *
 * Mood: softer palette, restrained motion, generous spacing,
 * content warnings as a default (not afterthoughts).
 *
 * Apply by appending this file's :root block AFTER the genre preset's :root.
 * The overrides desaturate accents, increase spacing, slow motion.
 */
:root {
  /* desaturate any accents that came from the base preset */
  --accent:      oklch(from var(--accent) calc(l * 0.95) calc(c * 0.6) h);
  --accent-bg:   oklch(from var(--accent-bg) l calc(c * 0.5) h);
  --deep:        oklch(from var(--deep) calc(l * 0.95) calc(c * 0.6) h);
  --deep-bg:     oklch(from var(--deep-bg) l calc(c * 0.5) h);

  /* widen rhythm */
  --section-gap: 6rem;
  --para-gap: 1.5rem;
  --body-leading: 1.8;

  /* slow motion */
  --transition-fast: 220ms ease;
  --transition-slow: 480ms ease;

  /* content warning styling — visible, not hidden */
  --cw-bg:           oklch(0.97 0.012 60);
  --cw-border:       oklch(0.80 0.05 60);
  --cw-text:         oklch(0.30 0.04 60);
  --cw-padding:      1.25rem 1.5rem;
  --cw-radius:       8px;
  --cw-icon-color:   oklch(0.62 0.14 60);  /* warm amber, not red */
}

@media (prefers-reduced-motion: reduce) {
  :root {
    --transition-fast: 0ms;
    --transition-slow: 0ms;
  }
}

/* Recommended HTML markup for content warnings:
 *
 * <aside class="content-warning">
 *   <strong>Content note</strong>
 *   <p>This piece discusses ...</p>
 *   <p><a href="#summary">Skip to the summary</a></p>
 * </aside>
 *
 * The skill must include at least one content-warning aside near the top
 * AND a "skip to summary" anchor when this overlay is active.
 */
```

- [ ] **Step 2: Sanity check**

Confirm: uses the relative-color `oklch(from ...)` syntax to desaturate base preset accents (no hardcoded colors); widens rhythm and slows motion; defines explicit content-warning chrome; comment block documents the recommended HTML markup.

Note: relative-color OKLCH is supported in Safari 16.4+ and Chrome 119+. If targeting older browsers, the skill may need to inline absolute color overrides instead — flag this in P5 polish if it comes up.

---

### Task 9: Write SKILL.md frontmatter, intro, and trigger guidance

**Files:**
- Create: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.md` (overwrite the Codex version that's currently there — backup is in SKILL.bak)

This task writes the top of the SKILL.md only. Subsequent tasks add the workflow, gates, etc. The full file is built section by section so each can be reviewed independently.

- [ ] **Step 1: Write the frontmatter and §1 intro**

```markdown
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
```

- [ ] **Step 2: Verify against spec §1 + §2 framing + §14**

Read back the section. Confirm: name + description match spec §1 verbatim. Defer-to list matches spec §1's "Defers to other skills when" list. Single-page-only constraint matches spec D8.

---

### Task 10: Write SKILL.md §2 — the 6-round dialogue

**Files:**
- Modify: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.md` (append)

- [ ] **Step 1: Append §2 (the dialogue rounds)**

Append the following to SKILL.md (after the §1 content from Task 9):

```markdown

## Process: 6 dialogue rounds, then 5 build phases

Run the rounds **in order** before any code. Use `AskUserQuestion` with concrete options where the choice space is enumerable. Accept short free-text only for genuinely free-form fields (the central claim, success-criterion sentence, source notes, paths to user-supplied papers/data/images). Every free-text request must name what the field is for and offer a one-sentence example. Never ask "tell me about your topic" without scaffolding.

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

### Round 4 — Stand-in vs. domain-faithful

Ask which lane:

- **Stand-in (metaphor-driven)** — shapes for people, sushi for candidates, balance beam for arbitrage. Defuses defensiveness; useful for civic/political/economic topics.
- **Domain-faithful (literal)** — waveforms as themselves, vectors as themselves, dots as your earnings. The rendering *is* the explanation; useful for math/science/engineering.

If **stand-in lane**: run the abstraction-ethics check (gate G4). Severe cases (cute stand-ins for war/oppression/trauma/identity/death) trigger pause-for-reframe; mild cases (metaphor flattens nuance) trigger warn-and-log.

If **domain-faithful lane**: run the literacy check. Does the audience tier from Round 2 understand the literal rendering without scaffolding? If not, propose: (a) glossary section as Section 1, (b) "you'll see X — here's how to read it" preamble per new figure type, or (c) fallback to stand-in.

### Round 5 — Mechanic selection

Walk the mechanic ladder (see Mechanic Ladder section below). Recommend 2–3 rungs to compose. Name the canonical sequence (drag → sim → slider → toggle → sandbox) when it applies.

Surface composite device classes when topic shape suggests them:
- **Map** — place or geography is central
- **Timeline** — sequence or history is central
- **Network/flow** — contagion, supply, money, trust, or information moves through a graph
- **Ladder of abstraction** (Bret Victor) — concrete examples + aggregate patterns side by side
- **Role-based negotiation** — multi-stakeholder tradeoff

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
```

- [ ] **Step 2: Verify against spec §2**

Confirm: 6 rounds named in order; Round 2 has 3 tiers (not 4 — workshop dropped); Round 4 defines literacy check inline; Round 6 includes both self-implication sentence and Model Contract.

---

### Task 11: Write SKILL.md §3–§4 — Genre failure modes + Mechanic ladder

**Files:**
- Modify: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.md` (append)

- [ ] **Step 1: Append the genre failure modes table**

```markdown

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
```

- [ ] **Step 2: Append the mechanic ladder**

```markdown

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
```

- [ ] **Step 3: Verify**

Confirm: ladder ordered by implication strength explicitly; role axis named separately (no mixed semantics); failure modes match the spec §3 table.

---

### Task 12: Write SKILL.md §5–§6 — Editorial gates and Ethics

**Files:**
- Modify: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.md` (append)

- [ ] **Step 1: Append the gates section**

```markdown

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
```

- [ ] **Step 2: Verify**

Confirm: three tiers defined precisely; G7 split into G7a/G7b with G7b as hard-stop; G4 split into G4a/G4b with G4b as pause-for-reframe; G9 (manipulative framing) is pause-for-reframe; ethics rules each map to a tier explicitly.

---

### Task 13: Write SKILL.md §7–§14 — Patterns, anti-patterns, build phases, design system, build requirements, exemplars, what-not-to-do

**Files:**
- Modify: `/Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.md` (append)

This is the largest task because the remaining sections all need to be written before the skill is functional, and they share format conventions. Split into the steps below.

- [ ] **Step 1: Append patterns and anti-patterns**

```markdown

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
```

- [ ] **Step 2: Append build phases**

```markdown

## Build phases

Five build phases (P1–P5), then a Playwright E2E verification pass. Phase order is a process invariant — not negotiable.

| Phase | Output | Checkpoint |
|---|---|---|
| **P1 — Scaffold** | HTML skeleton; sections stubbed with placeholder text; mechanic stub elements present but not wired; aesthetic preset CSS inlined | Does the page render top-to-bottom without errors? |
| **P2 — Core mechanic in isolation** | The mechanic actually produces the phenomenon. Crude visuals OK; no narrative persuasion yet. | **Can a cold reader, with only the minimal rules and labels needed to operate the model — no narrative persuasion, no framing prose — produce the phenomenon by interacting? If no, fix the mechanic, not the prose, before continuing.** |
| **P3 — Narrative wiring** | Prose written into sections; mechanic-prose handoffs wired; scroll/step transitions in place | Does the piece flow if you read it top to bottom *without* touching the mechanic? Does it flow if you only touch the mechanic and never read prose? |
| **P4 — Design pass** | Color, type, spacing per genre preset (read from `presets/<preset>.css`); figure styling; responsive | Does the design match the genre and the topic's emotional register? |
| **P5 — Polish** | Reduced-motion, keyboard nav, mobile, state-on-scroll-back, content warnings if applicable, source/provenance section, model-limits section | Is there a single accessibility or UX bug a first-time reader will hit? |

**Verification — Playwright E2E** (post-build, separate from build phases):
- Load the page; assert no console errors
- Walk through all sections
- Exercise every slider, button, drag/drop target, tab, toggle, reset
- Verify the mechanical twist is visible
- Verify the conclusion is reachable without getting trapped in an interaction
- Test at mobile width ≥ 360 px; assert no horizontal scroll
- Test keyboard operation
- Check `prefers-reduced-motion` behavior if animation exists
- Confirm citations, assumptions, model limits are visible

**P2 is the load-bearing checkpoint.** It is the explorable equivalent of TDD's red step. The "minimal rules" framing means: some labels are essential to operate the model (axes, button names, units) — that's fine. What must *not* be present is narrative persuasion doing the mechanic's work. If the mechanic doesn't prove the phenomenon under minimal-rules conditions, fix the mechanic.
```

- [ ] **Step 3: Append design system + build requirements**

```markdown

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
- No decorative animation
- No horizontal scroll at 360 px viewport
- Exactly one `<h1>`; correct heading order
- **Source/provenance section near the end**
- **Model limits section visible to readers**
- **Final section connects the model to what the reader can do, decide, or question next**
- **Override warnings (from gates) logged as HTML comments at the top of the file**
```

- [ ] **Step 4: Append reference exemplar set + what-the-skill-will-not-do**

```markdown

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
- No marketing copy (defer to `landing-page`)
- No code/protocol explainers (defer to `code-explainer`)
- No autoplay audio
- No "story-mode" toggles — the piece works the same whether you scroll or interact
- No anti-pattern bypass without a logged warning comment in the HTML
- No invented citations or fabricated data — if a parameter has no source, it is labeled `(assumption)`
- No multi-session workshop curricula or 3-day events — single-page only
```

- [ ] **Step 5: Read back the entire SKILL.md to verify**

```bash
cat /Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.md | wc -l
```

Expected: ~280-340 lines. If wildly different, something was duplicated or omitted.

```bash
grep -n "^##" /Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.md
```

Expected sections, in order:
- ## What you are producing
- ## When to use
- ## Core principle
- ## Process: 6 dialogue rounds, then 5 build phases
- ## Genre failure modes
- ## Mechanic ladder (ordered by implication strength)
- ## Editorial gates (three-tier enforcement)
- ## Ethics and Model Integrity
- ## Patterns library (offer these when relevant)
- ## Anti-patterns (the skill warns about all of these; some block via G5)
- ## Build phases
- ## Design system
- ## Build requirements (hard)
- ## Reference exemplar set
- ## What the skill will not do

If any expected section is missing, return to the corresponding earlier task and add it.

- [ ] **Step 6: Cross-reference check**

```bash
grep -n "G1\|G2\|G3\|G4\|G5\|G6\|G7\|G8\|G9" /Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.md
```

Expected: each gate appears in both the Gate inventory table AND in at least one other reference (Round 6 references G1; Round 4 references G4; Ethics rules reference G4b/G7/G8/G9 etc.). No gate ID should appear without a definition.

---

## Phase 2 — Validate via Jeugdzorg example (Tasks 14–19)

Phase 2 builds a Dutch-language explorable explanation about the Belgian Jeugdzorg (youth care) crisis at `/Users/fdb/Experiments/explorable-explanations-example/`. This serves as the integration test for the skill — if the skill works, the example builds correctly. If the example reveals issues in the skill, return to Phase 1, fix, and resume.

The topic is **sensitive** (children, mental health, government failure). The intimate tone overlay almost certainly applies. G4 (abstraction-ethics) and G7/G9 (source provenance and manipulative framing) are likely to fire.

**Source seed (provided by user):** https://www.vrt.be/vrtnws/nl/2026/04/27/vlaanderen-veroordeeld-voor-jeugdhulp-in-crisis/ — VRT NWS article reporting that Vlaanderen (Flanders) was condemned over its youth-care system on 2026-04-27.

### Task 14: Research the topic and assemble sources

**Files:**
- Create: `/Users/fdb/Experiments/explorable-explanations-example/research/notes.md`
- Create: `/Users/fdb/Experiments/explorable-explanations-example/research/sources.md`

- [ ] **Step 1: Create the project directory**

```bash
mkdir -p /Users/fdb/Experiments/explorable-explanations-example/research
```

- [ ] **Step 2: Fetch the seed article**

Use WebFetch on https://www.vrt.be/vrtnws/nl/2026/04/27/vlaanderen-veroordeeld-voor-jeugdhulp-in-crisis/ and extract:

- The verdict: who condemned Vlaanderen, and on what grounds?
- The specific failures cited: waiting lists, capacity gaps, regions affected, age groups
- Numbers: how many children waiting, how long, how many beds short, etc.
- Quotes from affected parties (parents, providers, government)
- Timeline: when did this start, what triggered the verdict now

Write findings to `research/notes.md` in Dutch (the explainer is Dutch — keep working notes in the same language to reduce translation drift).

- [ ] **Step 3: Find 2–3 supporting sources**

The seed article alone is not enough for G7 (source provenance). Use WebSearch to find:

- Belgian/Flemish government data on Jeugdzorg waiting lists (Agentschap Opgroeien, Departement Welzijn)
- One academic or journalistic deep-dive on the structural causes
- One first-person/affected-party piece (a parent's account, a provider testimony)

For each source, write to `research/sources.md` (in Dutch):

```markdown
## Source N: [Title]

URL:
Author / publisher:
Date:
Type: (government data / news / opinion / first-person / academic)
Key claims:
- ...
Numbers extracted:
- ...
Quote(s) we may want to use:
> ...
```

- [ ] **Step 4: Run the Round 1 extraction (using the skill's framework)**

Write to `research/notes.md`:

```
## Decoding (Round 1)

Claims and counterclaims:
Causal mechanisms:
Variables and constraints:
Stakeholders and incentives:
Time scales and geography:
Evidence quality and uncertainty:
Likely misconceptions:
Harm, identity, trauma, political sensitivity:
```

Fill each in honestly. The "harm, identity, trauma" cell is non-trivial — this concerns vulnerable children. Note specifically which framings to avoid.

- [ ] **Step 5: Inevitability test (Round 1 fallback)**

Ask: can this topic honestly support a deterministic model? Or does it need scenario comparison / uncertainty ranges?

The Jeugdzorg crisis is partly a **capacity-vs-demand mismatch** (deterministic-ish) and partly a **political/structural failure** (not deterministic). Pick the lane:

- If capacity-vs-demand: the explorable can use a parameter-driven essay with sliders for capacity/demand
- If structural: the explorable should use scenario comparison or timeline

Document the choice.

---

### Task 15: Run Rounds 2–6 (decisions before build)

**Files:**
- Create: `/Users/fdb/Experiments/explorable-explanations-example/design/decisions.md`

- [ ] **Step 1: Round 2 — Audience tier**

The article is broad-public Dutch language. Recommend **layperson, viral-share (5–15 min)**. Confirm with user via `AskUserQuestion` if running interactively, or commit to it explicitly in `decisions.md`.

- [ ] **Step 2: Round 3 — Genre recommendation**

Based on Round 1 + Round 2:

- If "capacity-vs-demand" lane: **parameter-driven essay** (Polygons-style — let the reader move sliders for capacity, demand, response time, and watch the waiting list grow)
- If "structural" lane: **scrollytelling data story** (NPR-style — guide reader through the verdict's findings on a persistent dataset)

Propose one with reasoning. Provide one alternative. Document choice in `decisions.md`.

- [ ] **Step 3: Round 4 — Stand-in vs. domain-faithful**

Recommendation: **domain-faithful** rendering of the data (waiting list as a literal queue of dots; capacity as a literal capacity line). **Do not use cute stand-ins for children.** This is a G4b risk — using Polygons-style shapes for vulnerable children would be ethics-by-cuteness. Pause-for-reframe and propose: dots representing aggregate waiting children (numerical, not anthropomorphized), with the human stories in prose/quote callouts.

Document in `decisions.md`.

- [ ] **Step 4: Round 5 — Mechanic selection**

For parameter-driven lane: drag-and-arrange (place additional capacity beds) + parameter-slider (time / referral rate) + before-after toggle (status quo vs. compliant capacity).

For scrollytelling lane: step-stepper (walk the verdict's findings) + scrubbable-timeline (waiting list over years) + one parameter slider at the end.

Document.

- [ ] **Step 5: Round 6 — Self-implication + Model Contract**

Write the one-sentence self-implication: *"the reader produces the waiting-list growth by setting capacity below demand"* (or whatever the mechanic implies).

Write the Model Contract:

```
Claim:
Mechanism:
Reader action:
Visible consequence:
Evidence or assumption:
Limit:
```

Fill it in honestly. The **Limit** field is critical — name what the model does NOT show (individual suffering, structural causes beyond capacity, political dynamics).

- [ ] **Step 6: Run gate checks**

For each gate, document the answer:

- G1 self-implication: covered above. PASS.
- G2 mechanic on ladder: yes, drag/slider/toggle. PASS.
- G3 stand-in declared: domain-faithful. PASS.
- G4 abstraction-ethics: pause-for-reframe was triggered in Step 3; reframe accepted. PASS with logged reasoning.
- G5 anti-pattern check: walk the 15 anti-patterns in SKILL.md. Address each.
- G6 inevitability test: can a skeptical reader shrug this off? If yes, surface the structural lens too.
- G7 source provenance: every numeric claim has a source from `research/sources.md` or is labeled `(aanname)`.
- G8 model limits visible: confirmed in Model Contract.
- G9 manipulative framing: confirm we are not implying false symmetric power.

Any gate that triggers warn-and-log: document the override reasoning in `decisions.md` to be inlined as an HTML comment in P1.

---

### Task 16: P1 — Scaffold the HTML

**Files:**
- Create: `/Users/fdb/Experiments/explorable-explanations-example/index.html`

- [ ] **Step 1: Write the HTML skeleton**

Create `index.html` with:

- Lang attribute: `<html lang="nl">`
- Title and meta description in Dutch
- Inline CSS: load the appropriate genre preset's `:root{}` block (copy from `presets/<chosen>.css`); if intimate overlay applies (it does — sensitive topic), append `intimate.css`'s `:root{}` block AFTER
- Empty section stubs for: opening hook, model setup, exploration, twist (verdict), takeaway, source/provenance, model limits
- Mechanic stub elements: empty `<svg id="model">`, slider stubs, button stubs
- Override warning HTML comment at the top documenting any gate overrides from Task 15

Example structure:

```html
<!doctype html>
<!-- Generated by explorable-explanations skill on 2026-04-27 -->
<!-- WAIVED: G6 inevitability — partial; see model limits section -->
<html lang="nl">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Wachten op zorg — Jeugdzorg in Vlaanderen</title>
  <meta name="description" content="Een interactieve uitleg over de wachtlijsten in de Vlaamse jeugdzorg, na de veroordeling van april 2026.">
  <style>
    :root {
      /* Inlined from presets/<chosen>.css — TASK 16 */
      /* ... */
    }
    :root {
      /* Inlined intimate overlay from presets/intimate.css */
      /* ... */
    }
    body { font-family: var(--font-body); /* etc. */ }
  </style>
</head>
<body>
  <aside class="content-warning">
    <strong>Inhoudswaarschuwing</strong>
    <p>Dit verhaal gaat over kinderen in nood en falend overheidsbeleid.</p>
    <p><a href="#samenvatting">Direct naar de samenvatting</a></p>
  </aside>

  <header>
    <h1>[hook title]</h1>
    <p class="lede">[lede in Dutch, 1-2 sentences]</p>
  </header>

  <section id="setup"><!-- placeholder --></section>
  <section id="model"><svg id="model-svg"></svg></section>
  <section id="exploration"><!-- placeholder --></section>
  <section id="verdict"><!-- placeholder --></section>
  <section id="takeaway"><!-- placeholder --></section>
  <section id="sources"><!-- placeholder --></section>
  <section id="limits"><!-- placeholder --></section>
  <section id="samenvatting"><!-- placeholder --></section>

  <script type="module">
    // Mechanic stub — TASK 17 fills this in
  </script>
</body>
</html>
```

- [ ] **Step 2: Open in a browser; verify P1 checkpoint**

Open `file:///Users/fdb/Experiments/explorable-explanations-example/index.html`. Expected: page renders top-to-bottom without errors. No console errors. No mechanic yet — placeholders only.

---

### Task 17: P2 — Implement the core mechanic in isolation

**Files:**
- Modify: `/Users/fdb/Experiments/explorable-explanations-example/index.html`

- [ ] **Step 1: Build the mechanic**

Implement the mechanic chosen in Round 5 (Task 15) — for the capacity-vs-demand lane, this is a small SVG-based simulation:

- A horizontal axis = time
- A vertical axis = number of children waiting
- A slider for "capaciteit" (capacity)
- A slider for "instroom per maand" (intake per month)
- The waiting list curve animates as the user adjusts sliders

Use D3 or Observable Plot via ESM import. Crude visuals are fine in P2. No prose persuasion.

```html
<script type="module">
  import * as d3 from 'https://cdn.jsdelivr.net/npm/d3@7/+esm';
  // Implement minimal queue model:
  // wait_list[t+1] = max(0, wait_list[t] + intake - capacity)
  // ... draw on #model-svg
</script>
```

- [ ] **Step 2: P2 checkpoint — minimal-rules test**

Open the page. With ONLY the slider labels and axis labels (no narrative prose), can a cold reader move the sliders and see the waiting list grow when capacity < intake? If yes, the mechanic is carrying its weight. If no, fix the mechanic — do not move to P3 yet.

Specifically: the user must be able to **produce the phenomenon** (a waiting list that grows because capacity is insufficient) by moving the sliders. If the mechanic doesn't show this, the phenomenon can't be self-implicated and the piece won't land.

---

### Task 18: P3, P4, P5 — Narrative, design, polish

**Files:**
- Modify: `/Users/fdb/Experiments/explorable-explanations-example/index.html`

- [ ] **Step 1: P3 — Narrative wiring**

Write the Dutch prose for each section. Pull from `research/notes.md` and `research/sources.md`. Cite every number with a footnote or inline source link. Quote affected parties from the sources where appropriate.

Structure:

1. **Opening hook**: a paragraph that names what the piece is about (the verdict, what it means)
2. **Setup**: introduce the model — capacity, intake, the queue dynamic
3. **Exploration**: invite the reader to play with the sliders; ask them to find a configuration where the waiting list stays stable
4. **Verdict (twist)**: reveal the actual current numbers — show what the verdict said. The reader sees that even the most modest sliders produce a growing waiting list given the actual capacity gap.
5. **Takeaway**: what does this mean? What can the reader do, decide, or question?
6. **Sources**: full source list with URLs
7. **Model limits**: explicit "wat dit model NIET laat zien" — the human stories, the structural causes, the political dynamics. Use the **Limit** field from the Model Contract.

P3 checkpoint: piece flows reading top-to-bottom AND piece flows interacting with mechanic only.

- [ ] **Step 2: P4 — Design pass**

Apply the genre preset (decided in Round 3) + intimate overlay. Inline the CSS. Style figure captions, lede, content warning, source list per the preset variables. Make sure responsive at ≥360 px width.

P4 checkpoint: design matches genre and topic emotional register. Sensitive topic → softer palette via intimate overlay; restrained motion; generous spacing.

- [ ] **Step 3: P5 — Polish**

- `prefers-reduced-motion` honored
- Keyboard navigation works for sliders
- Mobile layout tested at 360 px
- State preserved when scrolling back
- Content warning visible at top
- Sources section cited completely
- Model limits section visible (not hidden in `<details>`)
- Override warning HTML comments at top of file accurate
- Final section answers "what can the reader do, decide, or question?"

P5 checkpoint: walk the page as a first-time reader. Any single accessibility or UX bug? Fix it.

---

### Task 19: Verification — Playwright E2E

**Files:**
- Create: `/Users/fdb/Experiments/explorable-explanations-example/tests/e2e.spec.ts`
- Create: `/Users/fdb/Experiments/explorable-explanations-example/package.json`
- Create: `/Users/fdb/Experiments/explorable-explanations-example/playwright.config.ts`

- [ ] **Step 1: Set up Playwright**

```bash
cd /Users/fdb/Experiments/explorable-explanations-example
npm init -y
npm install --save-dev @playwright/test
npx playwright install chromium
```

- [ ] **Step 2: Write the E2E test**

Create `tests/e2e.spec.ts`:

```typescript
import { test, expect } from '@playwright/test';

test.describe('Jeugdzorg explorable', () => {
  test('loads without console errors', async ({ page }) => {
    const errors: string[] = [];
    page.on('pageerror', (e) => errors.push(e.message));
    page.on('console', (msg) => {
      if (msg.type() === 'error') errors.push(msg.text());
    });
    await page.goto('file:///Users/fdb/Experiments/explorable-explanations-example/index.html');
    await page.waitForLoadState('networkidle');
    expect(errors).toEqual([]);
  });

  test('mechanical twist is visible: low capacity grows the waiting list', async ({ page }) => {
    await page.goto('file:///Users/fdb/Experiments/explorable-explanations-example/index.html');
    // Set capacity low, intake high; verify waiting-list value increases
    await page.locator('#capacity-slider').fill('100');
    await page.locator('#intake-slider').fill('500');
    // Read the displayed waiting-list count after simulation tick
    const waitingListText = await page.locator('#waiting-list-count').textContent();
    const waitingList = parseInt(waitingListText ?? '0', 10);
    expect(waitingList).toBeGreaterThan(0);
  });

  test('conclusion reachable without getting trapped in a slider', async ({ page }) => {
    await page.goto('file:///Users/fdb/Experiments/explorable-explanations-example/index.html');
    // Tab/scroll to the conclusion section
    await page.locator('#takeaway').scrollIntoViewIfNeeded();
    await expect(page.locator('#takeaway')).toBeVisible();
  });

  test('mobile width 360 px has no horizontal scroll', async ({ page }) => {
    await page.setViewportSize({ width: 360, height: 800 });
    await page.goto('file:///Users/fdb/Experiments/explorable-explanations-example/index.html');
    const bodyScrollWidth = await page.evaluate(() => document.body.scrollWidth);
    expect(bodyScrollWidth).toBeLessThanOrEqual(360);
  });

  test('content warning visible above the fold', async ({ page }) => {
    await page.goto('file:///Users/fdb/Experiments/explorable-explanations-example/index.html');
    await expect(page.locator('.content-warning')).toBeVisible();
  });

  test('sources section reachable and populated', async ({ page }) => {
    await page.goto('file:///Users/fdb/Experiments/explorable-explanations-example/index.html');
    await page.locator('#sources').scrollIntoViewIfNeeded();
    const sourceLinks = await page.locator('#sources a').count();
    expect(sourceLinks).toBeGreaterThanOrEqual(2);
  });

  test('model limits section visible (not hidden in details)', async ({ page }) => {
    await page.goto('file:///Users/fdb/Experiments/explorable-explanations-example/index.html');
    await page.locator('#limits').scrollIntoViewIfNeeded();
    await expect(page.locator('#limits')).toBeVisible();
    // Should not be inside a closed <details>
    const insideDetails = await page.locator('#limits').evaluate((el) => {
      const details = el.closest('details');
      return details ? !(details as HTMLDetailsElement).open : false;
    });
    expect(insideDetails).toBe(false);
  });

  test('reduced-motion honored', async ({ page }) => {
    await page.emulateMedia({ reducedMotion: 'reduce' });
    await page.goto('file:///Users/fdb/Experiments/explorable-explanations-example/index.html');
    // Verify any transition durations on root are 0ms
    const transitionFast = await page.evaluate(() =>
      getComputedStyle(document.documentElement).getPropertyValue('--transition-fast').trim()
    );
    expect(transitionFast).toBe('0ms');
  });
});
```

- [ ] **Step 3: Run the tests**

```bash
cd /Users/fdb/Experiments/explorable-explanations-example
npx playwright test
```

Expected: all 8 tests pass. If any fail, return to P5 (Task 18) and fix the underlying issue. Do not skip a failing test.

- [ ] **Step 4: Final review — does the test verify learning, not just DOM?**

Read each test critically. The "mechanical twist is visible" test is the most important — it asserts that the reader's slider input causes the waiting-list count to grow. That's verifying *learning*: the test fails if the mechanic doesn't actually demonstrate the phenomenon. The other tests verify accessibility, structure, and policy compliance.

If any test only checks that an element is present without checking its meaning, sharpen it. Example: don't just assert `#sources` exists — assert it contains at least 2 links to external URLs (the test above does this).

---

## Phase 3 — Handoff (Task 20)

### Task 20: User review and commit decision

**Files:**
- Already-changed:
  - `/Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.md` (rewritten)
  - `/Users/fdb/dotfiles/claude/skills/explorable-explanations/SKILL.bak` (Codex backup)
  - `/Users/fdb/dotfiles/claude/skills/explorable-explanations/presets/*.css` (6 files)
  - `/Users/fdb/dotfiles/.gitignore` (SKILL.bak pattern added)
  - `/Users/fdb/Experiments/explorable-explanations-example/` (whole project)

- [ ] **Step 1: Show the user a summary of changes**

```bash
git -C /Users/fdb/dotfiles status
ls -la /Users/fdb/dotfiles/claude/skills/explorable-explanations/
ls -la /Users/fdb/Experiments/explorable-explanations-example/
```

Report:
- New SKILL.md line count
- Number of preset files
- Example HTML page URL (file://)
- Playwright pass/fail summary

- [ ] **Step 2: Ask the user what to commit**

Per the user's earlier instruction, **do not auto-commit**. Surface options:

- (a) Commit the skill changes (SKILL.md + presets/*.css + .gitignore update) to the dotfiles repo
- (b) Leave the skill changes uncommitted; user will review and commit manually
- (c) The Jeugdzorg example is in a non-repo experiment directory; user decides separately whether to git-init it

Wait for the user's choice. Do not commit until explicitly asked.

---

## Self-review (post-plan)

Spec coverage check:

| Spec section | Implementing task |
|---|---|
| §1 Frontmatter and trigger | Task 9 |
| §2 Workflow (6 rounds) | Task 10 |
| §3 Genre failure modes | Task 11 |
| §4 Mechanic ladder | Task 11 |
| §5 Editorial gates (3-tier) | Task 12 |
| §6 Ethics (gate-mapped) | Task 12 |
| §7 Soft prompts (patterns) | Task 13 step 1 |
| §8 Anti-patterns | Task 13 step 1 |
| §9 Build phases (P1–P5 + verification) | Task 13 step 2 |
| §10 Design system + presets | Tasks 3–8 (CSS) + Task 13 step 3 (SKILL.md reference) |
| §11 Build requirements | Task 13 step 3 |
| §12 Reference exemplars | Task 13 step 4 |
| §13 Migration from Codex | Task 1 (backup) + Tasks 9-13 (replace) |
| §14 What the skill won't do | Task 13 step 4 |
| D6 Skill layout | Tasks 2–8 (presets directory + files) |
| D7 No reference HTML scaffolds | Honored — no scaffold tasks |
| D8 Single-page scope | Task 9 (defer-to list); Task 10 (Round 2 declines workshop) |

Validation coverage:

- The Jeugdzorg example exercises Rounds 1-6, all 5 build phases, the Playwright pass, and at least one of each gate tier (G4b pause-for-reframe in Task 15 Step 3; G7a warn-and-log when sources are needed; G6 partial in Task 15 Step 6 if structural complexity is acknowledged).

Placeholder scan:

- No "TBD", "TODO", "implement later" outside of stub elements that are explicitly defined as placeholders.
- Code blocks are concrete: actual CSS, actual HTML, actual TypeScript test code.
- Where the user must make a choice (e.g., "capacity-vs-demand" vs "structural" lane), the task explicitly names both options and how to document the choice.

Type/identifier consistency:

- `SKILL.bak` consistent throughout
- Preset filenames consistent: `playful-illustrated.css`, `reverent-scientific.css`, `editorial.css`, `academic.css`, `gamified.css`, `intimate.css`
- Gate IDs consistent: G1, G2, G3, G4a, G4b, G5, G6, G7a, G7b, G8, G9
- Phase IDs consistent: P1–P5 + Verification
- Round numbers consistent: Round 1–Round 6

No issues found. Plan is ready.
