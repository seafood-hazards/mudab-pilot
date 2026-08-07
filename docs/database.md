# Database

`mudab_pilot.sqlite` is the **only** file this site depends on. It is built by
the `multised-engine` package (`create_db("pilot", "mudab")`), not in this
repository, and is published as an asset on this repository's latest GitHub
release.

The name changed from `pilot_mudab.sqlite` at site v0.1.11, matching the
engine's `<source>_pilot.sqlite` convention. The same release also refreshed the
data: the site had been serving the v0.1.4 build, which held about two thirds of
the rows.

## Schema

Ten tables. All access is client-side, through stratum-sqlite.

| Table | PK | Rows | Notes |
|---|---|--:|---|
| `sediment` | nine-column composite | 167,124 | the fact table: measured_value, unit, data_qualifier, recovery_rate, measurement_start/end, internal_qa_count |
| `sample` | `sample_no` | 14,089 | layer boundaries, sampling_method, matrix, sediment_composition, sediment_content, sampled_area |
| `measurement_time` | `measurement_time_id` | 5,514 | year, measurement_date, measurement_time |
| `survey` | `survey_id` | 3,981 | the geo-enriched table: dist_to_coast, est_country, country_code, municipality, sea_name, plus vessel and project fields |
| `station` | `station_no` | 823 | station_name, latitude, longitude, region, institute, water_body_category |
| `reference_material` | `reference_material_id` | 542 | code, basis, type, mean, sd |
| `lod` | `lod_id` | 482 | detection and quantification limits, expanded uncertainty |
| `analysis_method` | `analysis_method_id` | 342 | measurement and treatment codes, laboratory, accreditation |
| `code_lookup` | `category_code, code` | 279 | the MUDAB and ICES vocabularies |
| `parameter` | `parameter` | 61 | parameter_name, parameter_group, cas_number, lawa_code |

**The geo columns live on `survey`, not `station`.** This is the only pilot
source where that is true, and it is why `distance-to-coast.qmd` and
`location-names.qmd` join through `survey`. Coordinates appear on both tables:
`station.latitude`/`longitude` and `survey.station_latitude`/`station_longitude`.

## The geo columns

`survey.dist_to_coast`, `est_country`, `country_code`, `municipality` and
`sea_name` are computed by the external
[seastamp](https://github.com/AIQC-Hub/seastamp) CLI (GSHHG full resolution,
Natural Earth 1:10m, GISCO LAU 2021, IHO Sea Areas v3), run over the distinct
survey positions in an LAEA projection derived from the points themselves. They
are **not** in the raw MUDAB export.

They were recomputed at site v0.1.12: before that they came from an `sf` /
`rnaturalearth` / `giscoR` implementation, which resolved `sea_name` only to
ocean basin level and emitted alpha-2 country codes. `distance-to-coast.qmd` and
`location-names.qmd` document the method and the measured change.

`sediment` has a nine-column primary key because MUDAB carries the analysis
method, reference material, detection limit and measurement time as separate
dimensions per measurement rather than as attributes of the sample.

`db-schema.qmd` renders the ER diagram and the full column definitions.
`data-preparation.qmd` is the largest page on the site: it documents the German
to English translation of column names, codes and free-text values, so check
there before assuming a raw MUDAB field name.

## Querying it from a page

Every page that reads the database includes `_db-setup.qmd`:

```qmd
{{< include _db-setup.qmd >}}
```

`header.html` sets `window._stratumSQLite`, `window._dbPath` and
`window._sqljsBase` at page load; `_db-setup.qmd` opens the file and exposes it
as `db`, which is then available to every OJS block on that page.

**One database per page.** Opening a second one on the same page fails.

## The cache key

stratum-sqlite caches the database in the browser, keyed by the `cacheKey` in
`_db-setup.qmd` (`mudab-pilot@vX.Y.Z`). Whenever the database **content**
changes, bump that key, or returning browsers keep serving the stale cached copy
and queries fail with "no such column".

This is the one version string that still has to be edited by hand; the download
URLs resolve to the latest release on their own.

## Scope

This site documents the **pilot** generation only. The slim, clean, merged and
refined generations have their own sites, and nothing here should link to their
schemas or ship their database files.
