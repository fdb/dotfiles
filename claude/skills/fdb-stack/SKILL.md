---
name: fdb-stack
description: Reference guide for Frederik's preferred web development stack. Use when starting new projects, scaffolding apps, or when asked about preferred conventions for Cloudflare, Hono, React, or full-stack TypeScript projects.
argument-hint: "[new-project-name]"
---

# Developer Style Guide — FDB Stack

Use these conventions when starting new projects or scaffolding code.

## Stack Overview

```
Platform:     Cloudflare Pages + Workers
Backend:      Hono (SSR with JSX)
Database:     Cloudflare D1 (SQLite)
Admin UI:     React 18 + Vite (builds to static/admin)
State:        Zustand (local UI) + TanStack Query (server)
Styling:      Vanilla CSS with variables, light/dark mode
Testing:      Playwright (E2E), Vitest (unit)
Scripts:      Node.js ESM (.mjs) in ./scripts/
```

## Project Structure

```
src/                    # Hono worker code (SSR pages, API routes)
  ├── index.tsx         # Main entry, route registration
  ├── routes/           # Route handlers (auth.tsx, admin-api.ts)
  ├── components/       # Hono JSX components (Layout, Cards)
  ├── lib/              # Shared utilities
  ├── middleware/       # Hono middleware (auth)
  └── types.ts          # Shared TypeScript types

admin/                  # React SPA (Vite)
  └── src/
      ├── main.tsx      # React entry
      ├── App.tsx       # Root component
      ├── pages/        # Page components
      ├── components/   # React components
      ├── api/          # TanStack Query hooks (queries.ts, mutations.ts)
      ├── store/        # Zustand stores
      └── lib/          # Utilities

static/                 # Static assets served by worker
  ├── styles.css        # Public site styles
  ├── admin.css         # Admin styles
  └── admin/            # Vite build output (gitignored)

scripts/                # Node.js utility scripts (.mjs)
e2e/                    # Playwright tests
schema.sql              # D1 schema
wrangler.toml           # Cloudflare config
```

## TypeScript Configuration

### Worker (tsconfig.json)

```json
{
  "compilerOptions": {
    "target": "ES2021",
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "strict": true,
    "jsx": "react-jsx",
    "jsxImportSource": "hono/jsx",
    "types": ["@cloudflare/workers-types"]
  }
}
```

### Admin React (admin/tsconfig.json)

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "strict": true,
    "jsx": "react-jsx",
    "lib": ["ES2020", "DOM", "DOM.Iterable"]
  }
}
```

## Vite Configuration

Admin builds to `static/admin/` with watch mode for development:

```ts
// admin/vite.config.ts
export default defineConfig({
  root: __dirname,
  plugins: [react()],
  base: "/admin/",
  build: {
    outDir: resolve(__dirname, "../static/admin"),
    emptyOutDir: true,
  },
});
```

## Development Workflow

```bash
npm run dev           # Runs wrangler + vite --watch concurrently
npm run typecheck     # Check both worker and admin
npm run format        # Prettier
npm run test:e2e      # Playwright tests
```

## CSS Design System

### OKLCH Colors

Use OKLCH color space for all colors. OKLCH provides perceptual uniformity, making it easy to create lighter/darker shades by adjusting the L (lightness) value while keeping hue and chroma consistent.

```css
:root {
  /* Define hue and chroma as variables, then derive tints/shades by varying lightness */
  /* Example: each project chooses its own primary-h and primary-c values */
  --primary-h: 250;           /* Hue (0-360) */
  --primary-c: 0.15;          /* Chroma (0-0.4 typical range) */
  --primary: oklch(55% var(--primary-c) var(--primary-h));
  --primary-light: oklch(70% var(--primary-c) var(--primary-h));
  --primary-dark: oklch(40% var(--primary-c) var(--primary-h));

  /* Grayscale uses chroma 0 */
  --black: oklch(10% 0 0);
  --white: oklch(100% 0 0);
  --gray: oklch(50% 0 0);
  --light-gray: oklch(90% 0 0);
}

:root[data-theme="dark"] {
  --black: oklch(100% 0 0);
  --white: oklch(15% 0 0);
  --gray: oklch(60% 0 0);
}
```

Benefits of OKLCH:
- Perceptual uniformity: 10% lightness change looks consistent across all hues
- Easy gradients: vary L value for smooth tint/shade scales from a single base color
- Predictable color manipulation in CSS

### Conventions

- No rounded corners (border-radius: 0)
- Black/white palette with gray shades
- OKLCH for all colors (enables perceptual gradients)
- Variables for all colors
- Light/dark mode via `data-theme` attribute
- Mobile-first responsive breakpoints (768px, 480px)
- Transitions: 0.15s ease for hover states

## State Management

### TanStack Query (Server State)

```ts
// admin/src/api/queries.ts
export function useProject(projectId: string | null) {
  return useQuery({
    queryKey: queryKeys.project(projectId || ""),
    queryFn: () => fetchProject(projectId!),
    enabled: !!projectId,
    staleTime: 30_000,
  });
}
```

### Zustand (Local UI State)

```ts
// admin/src/store/adminStore.ts
export const useAdminStore = create<AdminState>()(
  persist(
    (set, get) => ({
      darkMode: false,
      selectedProjectId: null,
      editModalOpen: false,
      // ...actions
    }),
    { name: "admin-ui", partialize: (state) => ({ darkMode: state.darkMode }) }
  )
);
```

### Pattern

- TanStack Query for all API data
- Zustand for UI state (selection, modals, filters, form drafts)
- Mutations invalidate relevant queries via `queryClient.invalidateQueries()`

## Hono Patterns

### Route Registration

```ts
// src/index.tsx
const app = new Hono<{ Bindings: Bindings }>();
app.route("/api/auth", authApiRoutes);
app.route("/admin", adminPageRoutes);
```

### JSX Components

```tsx
// src/components/Layout.tsx
export const Layout = ({ title, children }: Props) => (
  <html>
    <head>
      <title>{title}</title>
    </head>
    <body>{children}</body>
  </html>
);
```

### D1 Queries

```ts
const { results } = await c.env.DB.prepare(
  "SELECT * FROM projects WHERE status = 'published'"
).all<Project>();
```

## Scripts Pattern

Scripts use ESM (.mjs) with Node.js:

```js
#!/usr/bin/env node

/**
 * Brief description
 * Usage:
 *   node scripts/example.mjs --local
 *   node scripts/example.mjs --remote
 */

import { spawn } from "child_process";

const args = process.argv.slice(2);
const isRemote = args.includes("--remote");
```

Common pattern: `--local` vs `--remote` flags for D1 operations.

## Testing

### Playwright E2E

```ts
// playwright.config.ts
export default defineConfig({
  testDir: "./e2e",
  webServer: {
    command: "npm run dev:e2e",
    url: "http://localhost:5174",
  },
});
```

### Test Database

E2E tests use isolated D1 state via `--persist-to .wrangler/e2e-state`.

## API Design

RESTful JSON APIs under `/api/`:

```
GET  /api/admin/table/:name     # List records
GET  /api/admin/projects/:id    # Get detail
PUT  /api/admin/projects/:id    # Update
POST /api/admin/projects/:id/images/upload  # File upload (FormData)
```

## Component Conventions

### React Components

- Functional components with hooks
- Props interfaces inline or nearby
- Lucide React for icons
- No class components

### Hono JSX

- Server-rendered, no client interactivity
- Use `class` not `className`
- Inline styles for view transitions

## File Naming

- React components: PascalCase.tsx
- Utilities/hooks: camelCase.ts
- Routes: kebab-case.ts or feature.tsx
- Scripts: kebab-case.mjs

## Formatting

Prettier with defaults. Run `npm run format` before committing.

## Key Dependencies

```json
{
  "dependencies": {
    "@tanstack/react-query": "^5.x",
    "hono": "^4.x",
    "react": "^18.x",
    "react-dom": "^18.x",
    "zustand": "^4.x",
    "lucide-react": "^0.5x"
  },
  "devDependencies": {
    "@cloudflare/workers-types": "^4.x",
    "@playwright/test": "^1.x",
    "@vitejs/plugin-react": "^4.x",
    "typescript": "^5.x",
    "vite": "^6.x",
    "vitest": "^4.x",
    "wrangler": "^4.x",
    "prettier": "^3.x"
  }
}
```

## Scaffolding a New Project

If $ARGUMENTS is provided, scaffold a new project with that name:

1. Create project directory and initialize package.json
2. Set up the folder structure above
3. Create tsconfig.json files for worker and admin
4. Create wrangler.toml with D1 binding
5. Create basic schema.sql
6. Set up Vite config for admin
7. Create placeholder files with correct imports
8. Add npm scripts for dev, build, typecheck, format, test:e2e
