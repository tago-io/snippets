# TagoIO Snippets

Static Astro site and JSON/file APIs for Analysis, Payload Parser, and TagoSQL samples. Deployed to GitHub Pages at snippets.tago.io.

## README and repo files

Follow `tagoio:repo-standards` for README headers, section packs, LICENSE.md, CODE_OF_CONDUCT.md, SECURITY.md, and footer.

## Project overview

Three snippet categories:

- Analysis (node-legacy, node-rt2025, deno-rt2025, python-legacy, python-rt2025)
- Payload Parser (javascript)
- TagoSQL (sql; metadata uses `--` comments)

Build writes metadata JSON and code file endpoints under the Astro static site.

## Tooling

- Node 24 (`.node-version`); pnpm only (`packageManager` in `package.json`; npm/yarn blocked by preinstall)
- OXC: oxlint + oxfmt for JS/TS (line width 120, double quotes, semicolons, ES5 trailing commas)
- Ruff for Python under `snippets/analysis/`
- Astro 7 + Tailwind 4 (`@tailwindcss/vite`)

## Commands

```bash
pnpm install
pnpm dev
pnpm build          # prepare-data.ts then astro build
pnpm preview
pnpm check          # oxlint --deny-warnings, oxfmt --check, ruff check
pnpm fmt            # oxfmt + ruff format
pnpm lint           # oxlint + ruff check
pnpm lint:fix
```

Regenerate data only:

```bash
pnpm exec tsx ./scripts/prepare-data.ts
```

## Analysis runtimes

| Runtime       | Language   | Extensions     | Notes                        |
| ------------- | ---------- | -------------- | ---------------------------- |
| node-legacy   | JS ES5/ES6 | .js, .cjs      | Pre-installed libraries only |
| node-rt2025   | modern JS  | .js            | fetch API                    |
| deno-rt2025   | TS/JS      | .ts, .tsx, .js | Native TS, URL modules       |
| python-legacy | Python 3   | .py            | Pre-installed libraries only |
| python-rt2025 | Python 3   | .py            | UV, PyPI                     |

## Payload Parser

- javascript: .js (Node-based parser runtime)

## TagoSQL

- sql: .sql with `-- @title:`, `-- @description:`, `-- @tags:` headers

## Adding snippets

1. Put the file under the matching `snippets/{category}/{runtime}/` directory (kebab-case filename).
2. Add top-of-file metadata:

```javascript
// @title: Title
// @description: What it does
// @tags: tag1, tag2
```

```python
# @title: Title
# @description: What it does
# @tags: tag1, tag2
```

```sql
-- @title: Title
-- @description: What it does
-- @tags: tag1, tag2
```

3. Run `pnpm build`.

Metadata fields: `@title` (falls back to filename), `@description`, `@tags` (comma-separated).

For Deno/TypeScript analyses, import types from the TagoIO SDK when useful:

```typescript
import type { AnalysisConstructorParams, Data } from "npm:@tago-io/sdk";
```

## Layout

```
snippets/
├── analysis/{node-legacy,node-rt2025,deno-rt2025,python-legacy,python-rt2025}/
├── payload-parser/javascript/
└── tagosql/sql/
scripts/prepare-data.ts
src/          # Astro site, layouts, components
public/       # static assets
.github/workflows/
  ci.yml      # lint/format/build on every push and PR
  deploy.yml  # build + gh-pages on main
```

## Public URLs

Preferred:

- `/analysis/{runtime}.json` and `/analysis/{runtime}/{filename}`
- `/payload-parser/{runtime}.json` and `/payload-parser/{runtime}/{filename}`
- `/tagosql/sql.json` and `/tagosql/sql/{filename}`

Legacy Analysis-only paths (`/{runtime}.json`, `/{runtime}/{filename}`) remain for compatibility. Prefer category endpoints in docs and UI.

## Conventions

- Sample code under `snippets/` is product content: do not rewrite samples unless explicitly asked.
- oxlint ignores `snippets/**`; do not loosen site tooling rules to accommodate sample style.
- Prefer category API paths over legacy Analysis root paths in new UI copy.
- Site brand: tagobrand Default light, Inter + Monaspace Neon, shared header logo + footer in `BaseLayout.astro`.
