---
name: docs-to-kindle
description: Scrape a documentation website and convert it to .epub and .azw3 for Kindle
---

# Docs to Kindle

Convert a documentation website into a nicely formatted .epub and .azw3 ebook for Kindle.

**Target URL:** $ARGUMENTS

## Process

### 1. Discover all pages

Navigate to the docs URL using Playwright (`browser_navigate`) and take a snapshot (`browser_snapshot`) to extract the full sidebar/navigation structure. Get every documentation page URL. If the sidebar has collapsed/expandable sections, use `browser_run_code` to expand them all and extract links:

```js
async (page) => {
  // Expand collapsed nav sections
  const buttons = await page.locator('nav button[aria-expanded="false"], aside button[aria-expanded="false"]').all();
  for (const btn of buttons) {
    try { await btn.click(); await page.waitForTimeout(200); } catch {}
  }
  // Extract all doc links
  const links = await page.evaluate(() => {
    const anchors = document.querySelectorAll('a[href]');
    return [...new Set(Array.from(anchors).map(a => a.getAttribute('href')).filter(Boolean))];
  });
  return JSON.stringify(links);
}
```

Filter the links to only include documentation pages (same domain/path prefix). Organize them into logical sections based on the navigation structure.

### 2. Scrape all pages with Playwright

Most modern doc sites are client-side rendered (Next.js, etc.), so you MUST use Playwright via a Node.js script to render pages. Plain `fetch`/`curl` will only get loading skeletons.

Write a Node.js script (`scrape-docs.mjs`) that:

- **Uses `playwright`** (install via `npm install playwright` — browser binaries are already cached)
- Opens pages in a headless Chromium browser
- Waits for content to render (`waitUntil: "networkidle"` + `waitForSelector("article h1, main h1")`)
- Extracts the **article/main content only** (no nav, sidebar, footer, cookie banners)
- Removes buttons, SVGs, "Was this page helpful?" sections, "Copy code"/"Copy link" artifacts
- Runs with **3 concurrent pages** for speed
- Saves a combined HTML file with proper chapter structure

Template for the extraction function:

```js
const result = await page.evaluate(() => {
  const article = document.querySelector("article") || document.querySelector("main");
  if (!article) return null;
  const clone = article.cloneNode(true);
  clone.querySelectorAll("button, svg, nav, aside, [role='complementary']").forEach(el => el.remove());
  const h1 = clone.querySelector("h1");
  const title = h1 ? h1.textContent.trim() : "";
  let html = clone.innerHTML;
  html = html.replace(/Copy link to clipboard\s*/g, "");
  html = html.replace(/Copy code\s*/g, "");
  return { title, html };
});
```

### 3. Download and convert images

After scraping, find all image references in the generated HTML:
- Download them from the source site
- Convert any SVGs to PNG using `rsvg-convert -w 1200 input.svg -o output.png` (falls back to `magick` or `sips`)
- Update image `src` paths in the HTML from absolute to relative

### 4. Generate the combined HTML

The combined HTML should have:
- A title page with the doc site name, date, and page count
- Section headings (`<h1>`) for each navigation group
- Page content under each section
- Clean CSS optimized for e-readers (serif font, pre-wrap for code blocks, bordered tables)
- All image paths as relative paths

### 5. Convert to EPUB

```bash
pandoc combined.html \
  --metadata title="<Site Name> Documentation" \
  --metadata author="<Author>" \
  --metadata date="$(date +%Y-%m-%d)" \
  --toc --toc-depth=1 --split-level=1 --wrap=none \
  -o output.epub
```

### 6. Convert to AZW3

```bash
ebook-convert output.epub output.azw3
```

If `ebook-convert` is not installed, install Calibre: `brew install --cask calibre`

### 7. Report results

Show the user:
- File paths and sizes for both .epub and .azw3
- Number of pages scraped and images included
- Instructions for transferring to Kindle (USB, Send-to-Kindle email, etc.)

## Prerequisites

These tools must be available (install if missing):
- **pandoc**: `brew install pandoc`
- **calibre** (for azw3): `brew install --cask calibre`
- **rsvg-convert** (for SVG→PNG): `brew install librsvg`
- **Node.js** with npm

## Important notes

- Always use Playwright for scraping — never plain fetch/curl for JS-rendered sites
- Be polite: add 300ms delays between page fetches
- Accept cookie consent banners before scraping
- Handle both `<article>` and `<main>` as content containers
- The output directory should be the current working directory
