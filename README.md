<br/>
<p align="center">
  <img src="https://assets.tago.io/tagoio/analysis.png" width="200px" alt="TagoIO"></img>
</p>

# TagoIO Snippets

Code samples for TagoIO Analysis, Payload Parser, and TagoSQL, published as a static site and JSON APIs.

---

## Public URLs

- Analysis JSON: https://snippets.tago.io/analysis/{runtime}.json (for example `deno-rt2025.json`)
- Analysis files: https://snippets.tago.io/analysis/{runtime}/{filename}
- Payload Parser JSON: https://snippets.tago.io/payload-parser/{runtime}.json (`javascript`)
- Payload Parser files: https://snippets.tago.io/payload-parser/{runtime}/{filename}
- TagoSQL JSON: https://snippets.tago.io/tagosql/sql.json
- TagoSQL files: https://snippets.tago.io/tagosql/sql/{filename}

JSON responses hold metadata only. Source files are served from the matching runtime directories.

## Structure

```
snippets/
├── analysis/
│   ├── node-legacy/
│   ├── node-rt2025/
│   ├── deno-rt2025/
│   ├── python-legacy/
│   └── python-rt2025/
├── payload-parser/
│   └── javascript/
└── tagosql/
    └── sql/
scripts/
└── prepare-data.ts    # Collects metadata into src/data/snippets.json
src/                   # Astro site, pages, and lib
public/                # Static assets (CNAME, robots, logos)
dist/                  # Build output (site + prerendered JSON and file routes)
```

Each snippet file carries title, description, and tags in header comments.

## JSON schema

Per-runtime JSON looks like this:

```json
{
  "runtime": "deno-rt2025",
  "schema_version": 1,
  "generated_at": "2025-08-08T00:00:00.000Z",
  "snippets": [
    {
      "id": "hello-world",
      "title": "Hello World",
      "description": "Basic hello world example",
      "language": "typescript",
      "tags": ["basic", "deno"],
      "filename": "hello-world.ts",
      "file_path": "deno-rt2025/hello-world.ts"
    }
  ]
}
```

## Local development

- Node.js 24 (see `.node-version`)
- pnpm (see `packageManager` in `package.json`)

```bash
pnpm install
pnpm dev       # Astro dev server
pnpm build     # prepare-data + Astro build into dist/
pnpm check     # oxlint, oxfmt --check, ruff
pnpm fmt       # oxfmt + ruff format
pnpm lint      # oxlint + ruff check
```

`pnpm build` runs `scripts/prepare-data.ts` before Astro, so snippet JSON is regenerated as part of the build.

## Deployment

GitHub Actions builds with pnpm and deploys `dist/` to the `gh-pages` branch on push to `main`.

## License

This project is licensed under the [Apache License 2.0](LICENSE.md). TagoIO logos and branding are not covered by Apache-2.0; see [Copyright Notice](LICENSE.md#copyright-notice) in `LICENSE.md`.

---

Built by the TagoIO team. Software licensed under [Apache-2.0](LICENSE.md). TagoIO logos and branding are not covered by Apache-2.0; see [Copyright Notice](LICENSE.md#copyright-notice) in LICENSE.md.
