# Koopman-Wang-Wei Decomposition of Gross Exports

This function performs the Koopman-Wang-Wei (2014) decomposition of a
countries gross exports into 9 separate value added components.

## Usage

``` r
kww(x)
```

## Arguments

- x:

  an object of the class 'decompr' obtained from
  [`load_tables_vectors`](https://bquast.github.io/decompr/reference/load_tables_vectors.md).

## Value

A data frame where a country's gross exports is decomposed into 9
components (columns), as detailed in Figure 1 of the AER paper:

|  |  |
|----|----|
| *Term* | *Description* |
| `DVA_FIN` | Domestic VA in final goods exports. |
| `DVA_INT` | Domestic VA in intermediate exports absorbed by direct importers (used to produce a locally consumed final good). |
| `DVA_INTrex` | Domestic VA in intermediate exports reexported to third countries and absorbed there. |
| `RDV_FIN` | Domestic VA in intermediate exports that returns home via final imports. |
| `RDV_INT` | Domestic VA in intermediate exports that returns home via intermediate imports (used to produce a domestically consumed final good). |
| `DDC` | Double counted DVA in intermediate exports (arising from 2-way trade in intermediate goods). |
| `FVA_FIN` | Foreign VA in final goods exports. |
| `FVA_INT` | Foreign VA in intermediate exports. |
| `FDC` | Double counted FVA in intermediate exports (arising from 2-way trade in intermediate goods). |

## Note

The KWW decomposition is known to be biased. As shown by Borin and
Mancini (2019), it systematically underestimates the foreign value added
in exports – and correspondingly overstates foreign double counting –
because the entire foreign content that the direct importer re-exports
to third countries is classified as 'foreign double counted', including
the part (value added generated in the importing country and re-exported
onwards) that is never recorded as foreign value added in any other
flow. KWW also overlooks the bilateral dimension of trade, so it cannot
correctly split domestic value added between absorption by the direct
importer and by third markets (hence indicators such as DAVAX cannot be
derived from it). Borin and Mancini (2019) correct these issues using a
sink-based, world-level perspective for the foreign content of exports;
this corrected KWW decomposition is available as
[`bm`](https://bquast.github.io/decompr/reference/bm.md)`(x, perspective = "world", approach = "sink")`.

## References

Koopman, R., Wang, Z., & Wei, S. J. (2014). Tracing value-added and
double counting in gross exports. *American Economic Review, 104*(2),
459-94.

Borin, A., & Mancini, M. (2019). Measuring What Matters in Global Value
Chains and Value-Added Trade. *World Bank Policy Research Working Paper
8804*.

## See also

[`bm`](https://bquast.github.io/decompr/reference/bm.md),
[`wwz`](https://bquast.github.io/decompr/reference/wwz.md),
[`wwz2kww`](https://bquast.github.io/decompr/reference/wwz2kww.md),
[`decompr-package`](https://bquast.github.io/decompr/reference/decompr-package.md)

## Author

Sebastian Krantz

## Examples

``` r
# Load example data
data(leather)

# Create intermediate object (class 'decompr')
decompr_object <- load_tables_vectors(leather)
 
# Perform the KWW decomposition
kww(decompr_object)
#>     Country  DVA_FIN  DVA_INT DVA_INTrex   RDV_FIN   RDV_INT       DDC
#> 1 Argentina 19.34940 18.97119   8.411491  5.259501 0.8259724 0.8723949
#> 2    Turkey 43.39461 26.20678   7.740053 10.475795 2.0075781 2.6369363
#> 3   Germany 78.73101 15.23967   2.748464  5.689669 4.4335916 4.4481800
#>     FVA_FIN  FVA_INT      FDC
#> 1  3.450595 3.388617 3.770832
#> 2 10.205386 5.359698 5.573163
#> 3 26.668992 4.455024 5.185401
```
