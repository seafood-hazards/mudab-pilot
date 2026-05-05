# MUDAB Pilot Database

[![DOI](https://zenodo.org/badge/1227957054.svg)](https://doi.org/10.5281/zenodo.20036772)

This repository contains the source Quarto Markdown documents for the [Marine Environmental Database (MUDAB)](https://www.mudab.de/en) website.

## License
This project is licensed under the [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) license.

## Data source
The original data used in this project is available on the [MUDAB](https://www.mudab.de/en) website.

## Reproducibility

This project is designed to be fully reproducible. All required R package versions are recorded using [renv](https://rstudio.github.io/renv/), ensuring a consistent computational environment.

To reproduce the analysis and website locally:

 1. Clone the repository
 2. Open the project in R
 3. Restore the package environment:

```R
renv::restore()
```

 4. Render the website:

Use the ``Render Website`` option in RStudio. 

> [!Note]
> The website deployed on GitHub Pages is automatically built using the same workflow and environment configuration.
