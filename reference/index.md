# Package index

## Data Input

Parse raw ICIO table matrices into a `decompr` class object containing
all derived matrices (Leontief inverse, domestic/import IO coefficients,
value-added shares, export vectors) required by the decomposition
functions.

- [`load_tables_vectors()`](https://sebkrantz.github.io/decompr/reference/load_tables_vectors.md)
  : Load the Input-Output and Final Demand Tables
- [`load_tables()`](https://sebkrantz.github.io/decompr/reference/load_tables.md)
  : Load the Input-Output and Final Demand Tables: Depreciated Interface

## Leontief Decomposition

Derive the value-added origin of exports by country and industry
(Hummels, Ishii & Yi 2001). Returns a matrix whose rows correspond to
source country-sectors and whose columns correspond to destination
country-sectors, optionally post-multiplied by output, final demand, or
left as is.

- [`leontief()`](https://sebkrantz.github.io/decompr/reference/leontief.md)
  : Leontief Decomposition

## Koopman-Wang-Wei (KWW) Decomposition

Split country-level exports into 9 value-added and double-counting
components (Koopman, Wang & Wei 2014). Note: KWW contains a known
systematic bias — see
[`bm()`](https://sebkrantz.github.io/decompr/reference/bm.md) for the
Borin-Mancini correction.
[`wwz2kww()`](https://sebkrantz.github.io/decompr/reference/wwz2kww.md)
maps the 16-term WWZ result to the 9-term KWW format when both
decompositions are needed.

- [`kww()`](https://sebkrantz.github.io/decompr/reference/kww.md) :
  Koopman-Wang-Wei Decomposition of Gross Exports
- [`wwz2kww()`](https://sebkrantz.github.io/decompr/reference/wwz2kww.md)
  : Koopman-Wang-Wei from Wang-Wei-Zhu Decomposition

## Wang-Wei-Zhu (WWZ) Decomposition

Split bilateral country-sector exports into 16 value-added and
double-counting components by importing country (Wang, Wei & Zhu 2013).
Returns a long-format array with an additional diagnostic block (texp,
texpint, texpfd, texpdiff) for accounting checks.

- [`wwz()`](https://sebkrantz.github.io/decompr/reference/wwz.md) :
  Wang-Wei-Zhu Decomposition of Gross Exports

## Borin-Mancini (BM) Decomposition

Split gross exports into up to 13 value-added and GVC participation
components (Borin & Mancini 2019). Supports three aggregation levels
(country, sector, bilateral) and two accounting perspectives
(exporter/source or world/sink). The world/sink perspective implements
the corrected KWW and is the recommended replacement for
[`kww()`](https://sebkrantz.github.io/decompr/reference/kww.md).

- [`bm()`](https://sebkrantz.github.io/decompr/reference/bm.md) :
  Borin-Mancini Decomposition of Gross Exports

## Convenience Interface

High-level wrapper for running any decomposition with a single call. See
also the package-level help page for an overview of all methods.

- [`decomp()`](https://sebkrantz.github.io/decompr/reference/decomp.md)
  : Interface Function for Decompositions
- [`decompr`](https://sebkrantz.github.io/decompr/reference/decompr-package.md)
  [`decompr-package`](https://sebkrantz.github.io/decompr/reference/decompr-package.md)
  : Global Value Chain Decomposition

## Example Data

Built-in 3×3 ICIO table (leather sector) for testing and learning.

- [`leather`](https://sebkrantz.github.io/decompr/reference/leather.md)
  : Leather Example ICIO Data
