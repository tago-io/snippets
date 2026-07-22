# TagoIO Snippets

Static Astro site and JSON/file APIs for TagoIO Analysis, Payload Parser, and TagoSQL code samples. Deployed to GitHub Pages at snippets.tago.io.

## Commands

```bash
pnpm install
pnpm dev
pnpm build
pnpm check
pnpm fmt
pnpm lint
```

`pnpm build` runs `scripts/prepare-data.ts` then `astro build`.

## Tooling

- Node 24 (`.node-version`); pnpm only (`packageManager` in `package.json`)
- OXC: oxlint + oxfmt for JS/TS
- Ruff for Python samples under `snippets/analysis/`

## Rules

- Do not rewrite sample snippets under `snippets/` unless explicitly asked.
- Prefer category endpoints (`/analysis`, `/payload-parser`, `/tagosql`) over legacy Analysis root paths.

## README and repo files

Follow `tagoio:repo-standards` for README headers, section packs, LICENSE.md, CODE_OF_CONDUCT.md, SECURITY.md, and footer.
