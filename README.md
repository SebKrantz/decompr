# decompr

[![License](http://img.shields.io/badge/license-GPLv3-brightgreen.svg?style=flat)](https://www.gnu.org/licenses/gpl-3.0.html)
[![CRAN Version](http://www.r-pkg.org/badges/version/decompr)](https://cran.r-project.org/package=decompr)
[![R build status](https://github.com/SebKrantz/decompr/workflows/R-CMD-check/badge.svg)](https://github.com/SebKrantz/decompr/actions?workflow=R-CMD-check)
[![Total Downloads](http://cranlogs.r-pkg.org/badges/grand-total/decompr?color=brightgreen)](https://cran.r-project.org/package=decompr)
[![Monthly Downloads](http://cranlogs.r-pkg.org/badges/decompr?color=brightgreen)](https://cran.r-project.org/package=decompr)

**decompr** implements four global value chain (GVC) decompositions of gross exports into value-added and double-counting components:

| Function | Method | Level | Terms |
|----------|--------|-------|-------|
| `leontief()` | Hummels, Ishii & Yi (2001) | country × industry | continuous VA origin |
| `kww()` | Koopman, Wang & Wei (2014) | country | 9 |
| `wwz()` | Wang, Wei & Zhu (2013) | bilateral country × sector | 16 |
| `bm()` | Borin & Mancini (2019) | country / sector / bilateral | up to 13 |

`bm()` is the recommended state-of-the-art decomposition. It also provides a corrected version of the KWW decomposition (use `perspective = "world", approach = "sink"`), which fixes a known systematic bias in `kww()`.

GVC indicators based on these decompositions are available in the companion [gvc](https://cran.r-project.org/package=gvc) package.

## Installation

Install the stable version from CRAN:

```r
install.packages("decompr")
```

Install the development version from GitHub:

```r
# install.packages("remotes")
remotes::install_github("SebKrantz/decompr")
```

## Usage

```r
library(decompr)

# Load the built-in 3×3 leather-sector ICIO table
data(leather)

# Build a decompr object from raw ICIO matrices
x <- load_tables_vectors(
  inter  = leather$inter,
  final  = leather$final,
  output = leather$output,
  countries = leather$countries,
  industries = leather$industries
)

# Leontief decomposition
leontief(x)

# Wang-Wei-Zhu (2013): 16 bilateral terms
wwz(x)

# Borin-Mancini (2019): up to 13 terms, exporter perspective
bm(x)

# Borin-Mancini corrected KWW (world / sink perspective)
bm(x, perspective = "world", approach = "sink")

# Or use the unified interface
decomp(x, method = "bm")
```

See `vignette("decompr")` for a detailed walk-through.

## References

- Borin, A., & Mancini, M. (2019). *Measuring What Matters in Global Value Chains and Value-Added Trade*. World Bank Policy Research Working Paper 8804.
- Koopman, R., Wang, Z., & Wei, S.-J. (2014). Tracing value-added and double counting in gross exports. *American Economic Review*, 104(2), 459–494.
- Wang, Z., Wei, S.-J., & Zhu, K. (2013). *Quantifying International Production Sharing at the Bilateral and Sector Levels*. NBER Working Paper 19677.
- Hummels, D., Ishii, J., & Yi, K.-M. (2001). The nature and growth of vertical specialization in world trade. *Journal of International Economics*, 54(1), 75–96.
