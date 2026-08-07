# mudab-pilot

Quarto static website for the MUDAB Pilot Database
(https://seafood-hazards.github.io/mudab-pilot/), deployed to GitHub Pages.
MUDAB is the German marine environmental monitoring database. One of five
per-source sites for the **pilot** generation of the `multised-engine` pipeline
(`../multised-engine`).

## The one dependency

`mudab_pilot.sqlite`, downloaded from this repository's **latest** GitHub release
by the `download_resources.R` pre-render step and queried in the browser. The
site builds nothing from raw data and ships no other data file.

Two rules follow from that, and they are the ones that break the site when
missed:

- **every release must carry the database as an asset**, or the next render 404s
- **bump the `cacheKey` in `_db-setup.qmd` whenever the database content
  changes**, or returning browsers serve a stale cached copy

## Build

```r
renv::restore()   # restore R packages
```

```bash
quarto render     # renders the site to _site/
```

## Docs

| Doc | Covers |
|-----|--------|
| [database.md](docs/database.md) | the ten-table schema, where the geo columns live, how a page queries it |
| [site.md](docs/site.md) | stack, build, page list, gitflow, the release procedure |

Raw MUDAB field names are German. The translations are documented in
`data-preparation.qmd`: check there before assuming a field name.

## Scope

Pilot generation, MUDAB only. The slim, clean, merged and refined generations
have their own sites: do not link to their pages, document their schemas, or
publish their database files here.
