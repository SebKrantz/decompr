decompr 7.0.0
=======================
* Added the Borin-Mancini (2019) decomposition via the new `bm()` function (also available
  through `decomp(method = "bm")`). It decomposes gross exports into up to 13 value-added and
  GVC terms at the country, sector, or bilateral-sector level, and covers the full set of Stata
  `icio` perspectives and approaches:
  - `perspective = "exporter"` with `approach = "source"` (13 terms) or `approach = "sink"`
    (9 terms; the bilateral level adds `VAXIM`, the domestic VA absorbed by the direct importer);
  - `perspective = "world"` (country level) with `approach = "sink"` (corrected KWW) or
    `approach = "source"` (9 terms);
  - `perspective = "self"` (sector or bilateral level), the export flow's own perimeter giving
    the broader Johnson (2018) / Los et al. (2016) domestic value added (9 terms); and
  - `flow = "imports"`, an importer-perspective decomposition of gross imports into value added
    and double counting (`GIMP = VA + DC`), at the country level or by value-added origin.

  It is the R counterpart of `decompose()` in the Julia package `GlobalValueChains.jl` (formerly
  `ICIO.jl`), reproduces the Stata `icio` command's output, and agrees with the Julia
  implementation to machine precision on real ICIO tables.
* The `kww()` documentation now notes that the KWW decomposition is biased (it systematically
  underestimates foreign value added) and points to `bm(perspective = "world", approach = "sink")`
  for the Borin-Mancini correction. Cross-references to `bm()` were added throughout.
* New pkgdown website at https://bquast.github.io/decompr/, and updated [package vignette](https://bquast.github.io/decompr/articles/decompr.html).
* These edits were made by [Sebastian Krantz](https://github.com/SebKrantz), who is now also a package author.

decompr 6.4.0
=======================
* redo documentation
* small general fixes
* add ORCID


decompr 6.2.0
=======================
* documentation updates


decompr 6.0.0
=======================
* Added Koopman-Wang-Wei (KWW) decompositon and function to aggregate WWZ to KWW decomposition
* 2x performance improvement through C-code and matrixStats dependency
* Improved code security through additional checks
* Enhanced documentation providing more details about methods and resulting objects

decompr 5.2.0
=======================
* documentation redone


decompr 4.5.0
=======================
* code refactoring
* added v

decompr 4.1.0
=======================
* fix post multiplication "final_demand" of leontief()

decompr 4.0.0
=======================
* add post-multiplication argument to leontief method
* remove leontief_output(), functionality moved to leontief()
* use ellipsis for decomp function

decompr 3.0.0
=======================
* remove vertical_specialisation and vertical_specialization, will be included in gvc package
* add some attributes to output t.b. used by gvc package
* change the output format of leontief and leontief-output to long form (tidy data)
* add columns country and sectors names
* add DViX_Fsr to wwz
* add Vignette (decompr)
* add tests
* add Travis-CI support
* add coveralls.io support

decompr 2.1.0
=======================
* add a leontief_output decomposition method
* update the README.md file
* add warning when no method is specified in decomp (default is Leontief as of v.2)

decompr 2.0.0
=======================
* make load_tables_vectors default
* change notice to reflect new default
* update examples and data to reflect lt
* replace use of 2 dimensional arrays with matrices
* more efficient construction of rownam and z1
* replace use of length(k) with G
* replace use of various inefficient uses of diag() (e.g. with Vhat)
* improved spacing of code for legibility
* make leontief default method

decompr 1.3.2
=======================
* add notice

decompr 1.3.1
=======================
* fix citations etc.

decompr 1.3.0
=======================
* add load_tables_vectors to input in simple form

decompr 1.2.1
=======================
* update authors

decompr 1.2.0
=======================
* update citation code
* use " in stead of ' in examples and function arguments
* use match.arg for method in decomp function

decompr 1.1.0
=======================
* update references
* include more descriptive description

decompr 1.0.2
=======================
* update example data to regional tables for faster computations
* put back examples for non-decomp functions

decompr 1.0.1
=======================
* remove examples other than for **decomp** function, to pass CRAN test in time
* add cran-comments.md

decompr 1.0.0
=======================
* functions names use underscores in stead of periods
* method names use underscores in stead of periods
* examples reflect the above changes
* WIOD data set is now compressed using bzip2
* included this news file

decompr 0.7.0
=======================
* citation information is included

decompr 0.6.0
=======================
* example data set in included

decompr 0.5.0
=======================
* examples are included
