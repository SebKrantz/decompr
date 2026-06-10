# Load the Input-Output and Final Demand Tables

This function loads the demand tables and creates all matrices and
variables required for the GVC decompositions.

## Usage

``` r
load_tables_vectors(
  iot,
  x,
  y,
  k,
  i,
  o = NULL,
  v = NULL,
  null_inventory = FALSE
)
```

## Arguments

- iot:

  a Input Output Table object - a list with elements 'inter' (= x),
  'final' (= y), 'output' (= o), 'countries' (= k) and 'industries'
  (= i) of class 'iot'. Alternatively these objects can be passed
  directly to the function, at least x, y, k and i need to be supplied.

- x:

  intermediate demand table supplied as a numeric matrix of dimensions
  GN x GN (G = no. of country, N = no. of industries). Both rows and
  columns should be arranged first by country, then by industry (e.g.
  C1I1, C1I2, ..., C2I1, C2I2, ...) and should match (symmetry), such
  that rows and columns refer to the same country-industries.

- y:

  final demand table supplied as a numeric matrix of dimensions GN x MN
  (M = no. of final demand categories recorded for each country). The
  rows of y need to match the rows of x, and the columns should also be
  arranged first by country, then by final demand category (e.g. C1FD1,
  C1FD2, ..., C2FD1, C2FD2, ...) with the order of the countries the
  same as in x.

- k:

  character. A vector of country or region names of length G, arranged
  in the same order as they occur in the rows and columns of x, y.

- i:

  character. A vector of industry names of length N, arranged in the
  same order as they occur in the rows and columns of x and rows of y.

- o:

  numeric. A vector of final outputs for each country-industry matching
  the rows of x and y. If not provided it will be computed as
  `rowSums(x) + rowSums(y)`.

- v:

  numeric. A vector of value added for each country-industry matching
  the columns of x. If not provided it will be computed as
  `o - colSums(x)`.

- null_inventory:

  logical. `TRUE` sets the inventory (last final demand category for
  each country) to zero.

## Value

A 'decompr' class object - a list with the following elements:

|  |  |  |  |
|----|----|----|----|
| Am |  |  | Imported / Exported goods IO shares matrix (`x` column-normalized by output `o`, with domestic entries set to 0). |
| B |  |  | Leontief Inverse matrix \\(I - A)^{-1}\\ where \\A\\ is `x` column-normalized by output `o`. |
| Bd |  |  | Domestic part of Leontief Inverse matrix (inter-country elements of \\B\\ set to 0, needed for WWZ decomposition). |
| Bm |  |  | Imported / Exported part of Leontief Inverse matrix (domestic elements of \\B\\ set to 0, needed for WWZ decomposition). |
| L |  |  | Domestic economy Leontief Inverse matrix \\(I - Ad)^{-1}\\ where \\Ad\\ is \\A\\ with all inter-country elements set to 0. |
| E |  |  | Total Exports (output of each country-industry servicing foreign production or foreign final demand). |
| ESR |  |  | Total Exports by destination country. |
| Eint |  |  | Exports for intermediate production by destination country. |
| Efd |  |  | Exports for final demand by destination country. |
| Vc |  |  | Value added content of output (`v / o`). |
| G |  |  | Number of countries. |
| N |  |  | Number of industries. |
| GN |  |  | Number of country-industries. |
| k |  |  | Vector of country names. |
| i |  |  | Vector of industry names. |
| rownam |  |  | Unique country-industry names identifying the rows / columns of x and rows of y. |
| X |  |  | Total Output (` = o`). |
| Y |  |  | Total Final Demand by destination country. |
| Yd |  |  | Domestic Final Demand. |
| Ym |  |  | Foreign Final Demand. |

## Details

Adapted from code by Fei Wang.

## See also

[`leontief`](https://bquast.github.io/decompr/reference/leontief.md),
[`kww`](https://bquast.github.io/decompr/reference/kww.md),
[`wwz`](https://bquast.github.io/decompr/reference/wwz.md),
[`decompr-package`](https://bquast.github.io/decompr/reference/decompr-package.md)

## Author

Bastiaan Quast

## Examples

``` r
# Load example data
data(leather)

# Create intermediate object (class 'decompr')
decompr_object <- load_tables_vectors(leather)

# Examine the object                                    
str(decompr_object)
#> List of 20
#>  $ Am    : num [1:9, 1:9] 0 0 0 0.01416 0.00386 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>  $ B     : num [1:9, 1:9] 1.2764 0.0562 0.0197 0.035 0.0244 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>  $ Bd    : num [1:9, 1:9] 1.2764 0.0562 0.0197 0 0 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>  $ Bm    : num [1:9, 1:9] 0 0 0 0.035 0.0244 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>  $ L     : num [1:9, 1:9] 1.2691 0.0492 0.0192 0 0 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>  $ E     : Named num [1:9] 33.2 28.5 2.6 45.9 59.2 8.5 38.7 31 77.9
#>   ..- attr(*, "names")= chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>  $ ESR   : num [1:9, 1:3] 0 0 0 10.7 12.1 1.6 14.9 10.3 31.6 14 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>   .. ..$ : chr [1:3] "Argentina" "Turkey" "Germany"
#>  $ Eint  : num [1:9, 1:3] 0 0 0 3.2 3.2 0.4 5.7 2.4 6.5 7.9 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>   .. ..$ : chr [1:3] "Argentina" "Turkey" "Germany"
#>  $ Efd   : num [1:9, 1:3] 0 0 0 7.5 8.9 1.2 9.2 7.9 25.1 6.1 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>   .. ..$ : chr [1:3] "Argentina" "Turkey" "Germany"
#>  $ Vc    : Named num [1:9] 0.673 0.569 0.321 0.619 0.509 ...
#>   ..- attr(*, "names")= chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>  $ G     : int 3
#>  $ N     : int 3
#>  $ GN    : int 9
#>  $ k     : chr [1:3] "Argentina" "Turkey" "Germany"
#>  $ i     : chr [1:3] "Agriculture" "Textile_and_Leather" "Transport_Equipment"
#>  $ rownam: chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>  $ X     : Named num [1:9] 77.7 58.3 19 112.7 124.6 ...
#>   ..- attr(*, "names")= chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>  $ Y     : num [1:9, 1:3] 21.5 16.2 11 7.5 8.9 1.2 9.2 7.9 25.1 6.1 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>   .. ..$ : chr [1:3] "Argentina" "Turkey" "Germany"
#>  $ Yd    : num [1:9, 1:3] 21.5 16.2 11 0 0 0 0 0 0 0 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>   .. ..$ : chr [1:3] "Argentina" "Turkey" "Germany"
#>  $ Ym    : num [1:9, 1:3] 0 0 0 7.5 8.9 1.2 9.2 7.9 25.1 6.1 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:9] "Argentina.Agriculture" "Argentina.Textile_and_Leather" "Argentina.Transport_Equipment" "Turkey.Agriculture" ...
#>   .. ..$ : chr [1:3] "Argentina" "Turkey" "Germany"
#>  - attr(*, "class")= chr "decompr"
```
