# Site

Quarto static website, deployed to GitHub Pages. Content is `.qmd` files at the
repository root; there is no application code, test suite or linter.

## Stack

- **Quarto** — static site generator; R chunks for tables, OJS blocks for interactivity
- **R** — tibble, dplyr, knitr (table rendering only; no server-side data access)
- **Observable JS** — client-side reactive queries against SQLite in the browser
- **sql.js + stratum-sqlite** — WebAssembly SQLite engine served from `libs/sqljs/`
- **Leaflet.js** — interactive maps; **Observable Plot / D3** — static plots
- **renv** — R package version pinning (`renv.lock`)

## Build

```r
renv::restore()   # restore R packages
```

```bash
quarto render     # renders the site to _site/
```

`download_resources.R` runs as a Quarto pre-render step. It downloads, if
missing:

- `mudab_pilot.sqlite` from the **latest** release
- sql.js and stratum-sqlite into `libs/sqljs/`

Both are gitignored, and both are skipped if the file is already there — so a
local render after a database change needs the old copy deleted first. Files
under `libs/`, `_site/`, `.quarto/` and `renv/library` are build artefacts, not
source.

CI/CD is `.github/workflows/publish.yml`: push to `main` renders the site and
deploys `_site/` to GitHub Pages.

## Pages

New pages must be added both to the filesystem and to the navbar in
`_quarto.yml`.

| File | Description |
|---|---|
| `index.qmd` | Home — generations overview, source data, sample count table |
| `db-schema.qmd` | DB Schema (Full) — ER diagram + table column definitions |
| `data-preparation.qmd` | German to English translation of columns, codes and free-text values |
| `database-downloads.qmd` | Database Downloads — link to the SQLite file on the latest release |
| `distance-to-coast.qmd` | Distance calculation methods + map |
| `location-names.qmd` | Country/municipality/sea name estimation methods |
| `distance-interactive-map.qmd` | Leaflet map of station locations with meta information |
| `efsa-format.qmd` | EFSA Format v1 — submission column schema and catalogue tables |
| `efsa-submission.qmd` | EFSA Submission v1 — DB field → EFSA column mapping |
| `efsa-format-v2.qmd` | EFSA Format v2 — FHF marine sediment data model column schema |
| `efsa-submission-v2.qmd` | EFSA Submission v2 — DB field → FHF format mapping |
| `pilot-db-viewer.qmd` | Paginated read-only SQLite table browser |
| `code-lookup-browser.qmd` | Browser for the MUDAB and ICES vocabulary codes |
| `sediment-map.qmd` | Leaflet map with element selector and year range filter |

Two include files are not pages: `_db-setup.qmd` opens the database (see
[database.md](database.md)), and `_generations.qmd` holds the pipeline
generations table and the links to the other eight sites. `_generations.qmd` is
kept identical across the five pilot repos apart from which row reads
"this site", so a change to it should be copied to the other four.

The EFSA pages are static documentation of the submission formats. They describe
a column mapping, not a file this project produces: the pilot generation no
longer exports a dataset file, and `data-export.qmd` was removed at v0.1.11.

## Git workflow

Gitflow (`main`, `develop`, `feature/*`, `release/*`). No pull requests — merge
branches directly with `--no-ff` and delete them when done. Feature branches
merge into `develop`; release branches into both `main` and `develop`.

## Releasing

**Every release must carry `mudab_pilot.sqlite` as an asset.** The site
downloads it from `releases/latest/download/`, which does not fall back to an
older release: a release published without the asset breaks the next CI render.

1. `git checkout -b release/vX.Y.Z develop`
2. Set the date on the `[X.Y.Z]` entry in `CHANGELOG.md` and commit
3. Merge into `main` with `--no-ff`, tag `vX.Y.Z`
4. Merge back into `develop` with `--no-ff`, delete the release branch
5. **Create the GitHub release and upload the database, before pushing `main`:**

   ```sh
   git push origin vX.Y.Z
   gh release create vX.Y.Z --title vX.Y.Z --notes-from-tag \
     ../multised-engine/data/db/mudab_pilot.sqlite
   ```

6. Push `main` and `develop` — CI deploys to GitHub Pages

Doing step 5 after step 6 leaves the deploy racing the upload; if the render has
already failed, re-run the workflow once the asset is up.

**When the database content changes**, also bump the `cacheKey` in
`_db-setup.qmd`. That is the only version string left to edit by hand.
