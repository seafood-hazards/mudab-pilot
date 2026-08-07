# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
As this project is still in active development, it does not yet strictly adhere to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.12] - 2026-08-07
### Changed
- **Geospatial columns recomputed with [seastamp](https://github.com/AIQC-Hub/seastamp)**, the tool the whole pipeline now uses, replacing the earlier `sf` / `rnaturalearth` / `giscoR` implementation. Across the 2,045 distinct survey positions: `dist_to_coast` moves by a median of 0.05 km (0.2%, largest 62.4 km), `municipality` is reassigned for 1,005, `sea_name` for 1,505, and `est_country` for 87
- `sea_name` now resolves to 14 IHO sea areas instead of 3 ocean basins, so North Sea and Baltic surveys are distinguishable
- `country_code` is now ISO 3166-1 alpha-3 (`DEU`) rather than alpha-2 (`DE`)
- Distance Calculation and Estimation of Location Names pages rewritten for the seastamp method and data sources
- Survey table schema describes the source and units of each geospatial column

## [0.1.11] - 2026-08-07
### Added
- Pipeline Generations section on the home page (`_generations.qmd`), with links to the other four pilot sites and to the slim, clean, merged and refined generation sites

### Changed
- **Database refreshed to the engine's current build**: sediment 114,490 to 167,124 rows, sample 7,976 to 14,089, station 482 to 823. The site had been serving the v0.1.4 build. The schema is unchanged
- Database file renamed from `pilot_mudab.sqlite` to `mudab_pilot.sqlite`, matching the engine's `<source>_pilot.sqlite` convention
- Database is downloaded from the latest GitHub release instead of a pinned release tag, so no version string has to be edited when a new database is published
- Database Downloads page lists the single pilot database and links to the latest release
- Data Export menu renamed to EFSA Submission
- CLAUDE.md reduced to the site's invariants, with the detail moved to `docs/database.md` and `docs/site.md`

### Fixed
- Data Preparation link on the home page said the page covers the ICES-DOME dataset

### Removed
- Export to Tabular File page: the pilot generation no longer exports a dataset file
- DB Schema (Slim) page and the slim database download, which belong to the slim generation's own site

## [0.1.10] - 2026-07-24
### Added
- Database Downloads page with links to the full and slim SQLite database files

## [0.1.9] - 2026-07-21
### Changed
- Moved the `matrix` column from the subsample table to the measurement table
  in the slim DB schema, and updated the schema diagram accordingly

## [0.1.8] - 2026-07-17
### Fixed
- Missing closing parenthesis in db-schema page's code_lookup table description

## [0.1.7] - 2026-07-16
### Added
- Schema diagram image for the slim DB schema page

## [0.1.6] - 2026-07-16
### Added
- Slim DB schema page (`db-schema-slim.qmd`) documenting a common
  cross-project schema (dataset, site, event, subsample, measurement,
  method, element tables), converted from the full MUDAB schema

## [0.1.5] - 2026-07-16
### Changed
- Updated DB and datafile version references to v0.1.4
### Fixed
- Survey table section heading in db-schema page

## [0.1.4] - 2026-07-13
### Added
- EFSA Format v1/v2 and EFSA Submission v1/v2 pages under Data Export, mapping
  pilot database fields to the EFSA submission formats
### Fixed
- Typos in EFSA pages ("EFDA" -> "EFSA", duplicated "the")

## [0.1.2] - 2026-05-07
### Fixed
- average calculation for the interactive map

## [0.1.1] - 2026-05-05
### Changed
- All Quarto pages for the pilot DB

## [0.1.0] - 2026-05-03
### Added
- Initial Quarto pages
