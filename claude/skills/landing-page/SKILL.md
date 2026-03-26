---
name: landing-page
description: Use when the user asks to create or update a self-contained landing page, single-page website, conference site, event page, portfolio page, or any static single-HTML-file site. Triggered by "make a landing page", "create a website for...", "build a one-page site", or when the user points to a directory containing an index.html they want to modify.
---

# Self-Contained Landing Page

Create fast, elegant, self-contained single-page websites. One HTML file, all CSS/JS inline, no build tools, no frameworks. Optimized for clarity, performance, and beautiful typography.

## Modes

**Create mode**: User describes what the site is for. Interview, design, build.
**Update mode**: User points to an existing directory with `index.html`. Read it, understand the design system, make targeted changes.

## Create Mode

### 1. Interview

Before writing any code, ask the user these questions using AskUserQuestion. Ask them in batches of 2-3 to keep the conversation flowing.

**Content questions:**
- What is this site for? (event, product, portfolio, announcement, etc.)
- What sections do you need? (hero, about, speakers, schedule, pricing, contact, etc.)
- Do you have specific copy/text, or should I draft placeholder content?
- Any specific CTAs? (register, buy, subscribe, contact)

**Design questions:**
- What mood/tone? (academic/refined, bold/modern, warm/organic, minimal/stark, playful, luxurious)
- Light or dark hero? Light or dark body?
- Any font preferences? (serif headings + sans body is the default, but ask)
- Any color preferences? (offer to suggest a palette based on the mood)
- Any reference sites you like the feel of?

**Technical questions:**
- Will you self-host fonts (woff2 files in a `fonts/` dir) or use Google Fonts?
- Any images to include? (or should the layout work without photos?)
- Need a contact form, or just a mailto link?
- Mobile-first or desktop-first? (default: responsive, works everywhere)

Skip questions where the answer is obvious from context. If the user already provided detailed content (like the LSAIR example), go straight to design questions.

### 2. Design System

Before coding, define these and present them to the user for approval:

```
Fonts:      [heading font] + [body font]
Palette:    --bg, --bg-alt, --text, --text-muted, --accent, --accent-hover
Mood:       [one-line description]
Sections:   [ordered list of sections]
```

### 3. Build

Generate a single `index.html` following the architecture below.

## Update Mode

When the user has an existing site to modify:

1. **Read the entire `index.html`** first
2. **Identify the design system**: extract CSS custom properties, font choices, color palette, spacing scale
3. **Understand the structure**: map out all sections and their patterns
4. **Make surgical edits**: match the existing style exactly — same naming conventions, same spacing patterns, same animation approach
5. **Never rewrite the whole file** unless explicitly asked — use Edit tool for targeted changes

## Architecture

### File Structure

```
site-name/
  index.html          # Everything lives here
  fonts/              # Optional: self-hosted woff2 files
  img/                # Optional: optimized images
```

### HTML Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Site Title]</title>
  <meta name="description" content="[SEO description]">
  <!-- Font faces first, then all styles -->
  <style>/* @font-face declarations */</style>
  <style>/* All CSS */</style>
</head>
<body>
  <!-- nav → hero → content sections → footer -->
  <script>/* All JS at end of body */</script>
</body>
</html>
```

### CSS Patterns

**Always use CSS custom properties** for theming:

```css
:root {
  /* Colors */
  --bg: #FAF8F5;
  --bg-alt: #F5F0EB;
  --text: #1C1917;
  --text-muted: #78716C;
  --accent: #B45309;
  --accent-hover: #D97706;
  --border: #E7E5E4;

  /* Typography */
  --font-body: 'DM Sans', system-ui, sans-serif;
  --font-heading: 'Cormorant Garamond', Georgia, serif;

  /* Spacing scale */
  --space-xs: 8px; --space-sm: 16px; --space-md: 24px;
  --space-lg: 40px; --space-xl: 64px; --space-2xl: 96px;

  /* Layout */
  --max-w: 1120px;
  --radius: 8px;
}
```

**Required CSS patterns:**
- `*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box }` — reset
- `html { scroll-behavior: smooth }` — smooth anchor scrolling
- `body { -webkit-font-smoothing: antialiased }` — crisp text
- `::selection { background: var(--accent); color: #fff }` — branded text selection
- Headings use `--font-heading`, body uses `--font-body`
- All colors reference custom properties, never hardcoded values in component styles
- Responsive breakpoints via `@media(max-width: 768px)` and `@media(max-width: 640px)`

**Typography hierarchy:**
- Hero title: `clamp(2.8rem, 6.5vw, 5rem)` — fluid scaling
- Section titles: `clamp(2rem, 4.5vw, 3.25rem)`
- Body: `1rem` with `line-height: 1.7`
- Labels: `0.7rem`, uppercase, `letter-spacing: 4px`

**Layout:**
- `.container` with `max-width` and horizontal padding
- CSS Grid for multi-column layouts (not flexbox grids)
- Sections get generous vertical padding (`96px+`)

### Navigation

Fixed nav that transitions on scroll:
- Transparent over hero, becomes frosted glass (`backdrop-filter: blur(20px)`) after scrolling
- Mobile: hamburger menu with slide-in panel
- Smooth scroll to anchor sections

### Scroll Reveal

Lightweight IntersectionObserver for fade-in animations:

```css
.reveal { opacity: 0; transform: translateY(24px); transition: opacity .8s cubic-bezier(.16,1,.3,1), transform .8s cubic-bezier(.16,1,.3,1) }
.reveal.visible { opacity: 1; transform: translateY(0) }
```

```js
const observer = new IntersectionObserver((entries) => {
  entries.forEach(e => {
    if (e.isIntersecting) { e.target.classList.add('visible'); observer.unobserve(e.target) }
  });
}, { threshold: 0.08, rootMargin: '0px 0px -60px 0px' });
document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
```

### Interactive Patterns

Use these sparingly — one or two per site:
- **Expandable items**: click-to-expand with `max-height` transitions (topics, FAQs, speaker bios)
- **Hover reveals**: subtle background shifts, border color changes, arrow animations
- **Counters/stats**: bordered sidebar items with large numbers

### Texture & Depth

Subtle details that elevate the design:
- SVG noise overlay on `body::before` at very low opacity (`0.03`)
- Gradient overlays on dark hero sections
- Accent lines (thin colored bars) for visual anchoring
- `1px solid var(--border)` between sections — not heavy dividers

### Dark Sections

For contrast, alternate between light and dark sections:
- Dark sections: charcoal background, cream text, adjusted link colors
- Use `rgba(255,255,255,0.x)` for muted text on dark backgrounds
- Decorative radial gradients for subtle visual interest

## Font Recommendations

Pair a distinctive heading font with a clean body font. Vary choices per project:

| Mood | Heading | Body |
|------|---------|------|
| Academic/refined | Cormorant Garamond | DM Sans |
| Modern/clean | Sora | Inter |
| Editorial | Playfair Display | Source Sans 3 |
| Warm/organic | Libre Baskerville | Nunito |
| Bold/contemporary | Clash Display | Satoshi |
| Minimal/stark | Space Grotesk | Space Grotesk |
| Elegant | Fraunces | Outfit |

Self-hosted woff2 is preferred for performance. Google Fonts via `<link>` is acceptable as fallback.

## Quality Checklist

- [ ] Single `index.html` file — no build step, no external JS dependencies
- [ ] All CSS in `<style>` tags, all JS in `<script>` at end of body
- [ ] CSS custom properties for every color, font, and spacing value
- [ ] Responsive: works on mobile (375px) through desktop (1440px+)
- [ ] Fixed nav with scroll-triggered style change
- [ ] Mobile hamburger menu
- [ ] Smooth scroll to sections
- [ ] Scroll-reveal animations on content sections
- [ ] Semantic HTML: `<nav>`, `<section>`, `<footer>`, `<h1>`-`<h4>` hierarchy
- [ ] `<meta>` description for SEO
- [ ] `lang` attribute on `<html>`
- [ ] All interactive elements have hover states
- [ ] No horizontal scrolling at any viewport width
- [ ] Color contrast meets WCAG AA (especially text on dark backgrounds)
- [ ] No JavaScript frameworks or libraries — vanilla JS only
- [ ] Page loads fast without any external requests (except fonts if using Google Fonts)
