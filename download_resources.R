options(timeout = 600)

# ── SQLite database ────────────────────────────────────────────────────────
# The only data this site needs. It comes from the LATEST release, so no version
# is edited here: every release must carry the database as an asset, or this
# download 404s. See docs/site.md.
db_url <- "https://github.com/seafood-hazards/mudab-pilot/releases/latest/download/mudab_pilot.sqlite"
local_db_file_name <- "mudab_pilot.sqlite"
if (!file.exists(local_db_file_name)) {
  download.file(db_url, local_db_file_name, mode = "wb")
  message("Database downloaded.")
} else {
  message("Using existing database.")
}

# ── sql.js + stratum-sqlite ────────────────────────────────────────────────
# All four files are downloaded once and served from the site.
# sql-wasm.js and sql-wasm.wasm are the sql.js engine that stratum-sqlite uses.
# stratum-sqlite.umd.js and stratum-sqlite.esm.js are the libraries that wrap sql.js with a clean API.
sqljs_dir <- "libs/sqljs"
dir.create(sqljs_dir, recursive = TRUE, showWarnings = FALSE)

# sql.js engine files
sqljs_base <- "https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.10.3/"
for (f in c("sql-wasm.js", "sql-wasm.wasm")) {
  dest <- file.path(sqljs_dir, f)
  if (!file.exists(dest)) {
    download.file(paste0(sqljs_base, f), dest, mode = "wb")
    message(f, " downloaded.")
  }
}

# stratum-sqlite library (ESM build — loaded via dynamic import() in header.html)
for (f in c("stratum-sqlite.umd.js", "stratum-sqlite.esm.js")) {
  dest <- file.path(sqljs_dir, f)
  if (!file.exists(dest)) {
    download.file(
      paste0("https://github.com/stratum-toolkit/stratum-sqlite/releases/latest/download/", f),
      dest, mode = "wb"
    )
    message(f, " downloaded.")
  }
}