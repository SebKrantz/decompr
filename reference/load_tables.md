# Load the Input-Output and Final Demand Tables: Depreciated Interface

This function loads the demand tables and defines all variables for the
decomposition. It is kept in the package for backward compatibility. New
users should use
[`load_tables_vectors`](https://sebkrantz.github.io/decompr/reference/load_tables_vectors.md)
instead.

## Usage

``` r
load_tables(x, y)
```

## Arguments

- x:

  the intermediate demand table, it has dimensions GN x GN (G = no. of
  country, N = no. of industries), excluding the first row and the first
  column which contains the country names, and the second row and second
  column which contain the industry names for each country. In addition,
  an extra row at the end should contain final demand.

- y:

  the final demand table it has dimensions GN x MN, excluding the first
  row and the first column which contains the country names, the second
  column which contains the industry names for each country, and second
  row which contains the five decomposed final demands (M).

## Value

A 'decompr' class object.

## Details

Adapted from code by Fei Wang.

## See also

[`load_tables_vectors`](https://sebkrantz.github.io/decompr/reference/load_tables_vectors.md)

## Author

Bastiaan Quast
