# CLAUDE.md

MUDAB Pilot Database: a Quarto static site presenting a pilot relational DB
design built from the public MUDAB (German marine environmental) sediment
monitoring dataset. Deployed to GitHub Pages.

## Stack
- Quarto (`.qmd` pages, OJS for client-side interactivity, R for prepping tables)
- SQLite DB (`pilot_mudab.sqlite`) queried in-browser via sql.js/WASM
  (`stratum-sqlite`, loaded through `header.html` + `_db-setup.qmd`)
- R deps pinned via `renv` (`renv.lock`)

## Layout
- `_quarto.yml` — site/navbar config
- `index.qmd`, `db-schema.qmd`, `data-preparation.qmd` — DB design docs
- `distance-to-coast.qmd`, `distance-interactive-map.qmd`, `location-names.qmd` — geospatial analysis
- `data-export.qmd` — flat `.tsv.gz` export docs
- `pilot-db-viewer.qmd`, `code-lookup-browser.qmd`, `sediment-map.qmd` — interactive DB tools
- `_db-setup.qmd` — shared OJS include that opens the SQLite DB
- `download_resources.R` — pre-render script fetching the DB + sql.js/stratum-sqlite libs
- `.github/workflows/publish.yml` — on push to `main`: `quarto render` → deploy to GitHub Pages

## Conventions
- Render locally with RStudio "Render Website" or `quarto render`; `renv::restore()` first.
- `pilot_*.sqlite` and files under `libs/`, `_site/`, `.quarto/`, `renv/library` are
  build artifacts/data, not source — don't read or edit them for context.
- German→English translations (columns, codes, free-text values) are documented
  in `data-preparation.qmd` — check there before assuming a raw MUDAB field name.

## Git workflow (Gitflow)
- Branches: `main` (releases), `develop` (integration), `feature/*`, `release/*`.
- No PRs — merge branches directly (`git merge --no-ff`) and delete the branch
  when done. Feature branches merge into `develop`; release branches merge into
  both `main` and `develop`.
- Update `CHANGELOG.md` on release branches before merging.
