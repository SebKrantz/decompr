# Package index

- [`decompr`](https://bquast.github.io/decompr/reference/decompr-package.md)
  [`decompr-package`](https://bquast.github.io/decompr/reference/decompr-package.md)
  : Global Value Chain Decomposition

## Data Input

Parse raw ICIO table matrices into a `decompr` class object.

- [`load_tables_vectors()`](https://bquast.github.io/decompr/reference/load_tables_vectors.md)
  : Load the Input-Output and Final Demand Tables
- [`load_tables()`](https://bquast.github.io/decompr/reference/load_tables.md)
  : Load the Input-Output and Final Demand Tables: Depreciated Interface

## Leontief Decomposition

Derive the value-added origin of exports by country and industry
(Hummels, Ishii & Yi 2001).

- [`leontief()`](https://bquast.github.io/decompr/reference/leontief.md)
  : Leontief Decomposition

## Koopman-Wang-Wei (KWW) Decomposition

Split country-level exports into 9 value-added components (Koopman, Wang
& Wei 2014).

- [`kww()`](https://bquast.github.io/decompr/reference/kww.md) :
  Koopman-Wang-Wei Decomposition of Gross Exports
- [`wwz2kww()`](https://bquast.github.io/decompr/reference/wwz2kww.md) :
  Koopman-Wang-Wei from Wang-Wei-Zhu Decomposition

## Wang-Wei-Zhu (WWZ) Decomposition

Split bilateral exports into 16 value-added components by importing
country (Wang, Wei & Zhu 2013).

- [`wwz()`](https://bquast.github.io/decompr/reference/wwz.md) :
  Wang-Wei-Zhu Decomposition of Gross Exports

## Borin-Mancini (BM) Decomposition

Split gross exports into up to 13 value-added and GVC participation
components (Borin & Mancini 2019).

- [`bm()`](https://bquast.github.io/decompr/reference/bm.md) :
  Borin-Mancini Decomposition of Gross Exports

## Convenience Interface

High-level wrapper for running any decomposition with a single call.

- [`decomp()`](https://bquast.github.io/decompr/reference/decomp.md) :
  Interface Function for Decompositions

## Example Data

Built-in 3×3 ICIO table (leather sector) for testing and learning.

- [`leather`](https://bquast.github.io/decompr/reference/leather.md) :
  Leather Example ICIO Data
