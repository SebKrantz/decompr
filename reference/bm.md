# Borin-Mancini Decomposition of Gross Exports

Decomposes gross exports into value-added and Global Value Chain (GVC)
components following the Borin and Mancini (2019) framework, as
implemented in the Stata `icio` command (Belotti, Borin and Mancini
2021). It is the R counterpart of the
[`decompose()`](https://rdrr.io/r/stats/decompose.html) function in the
Julia package `ICIO.jl`, and operates on a `decompr` object created by
[`load_tables_vectors`](https://sebkrantz.github.io/decompr/reference/load_tables_vectors.md).

## Usage

``` r
bm(
  x,
  aggregation = c("country", "sector", "bilateral"),
  perspective = c("exporter", "world"),
  approach = c("source", "sink")
)
```

## Arguments

- x:

  an object of class `decompr` obtained from
  [`load_tables_vectors`](https://sebkrantz.github.io/decompr/reference/load_tables_vectors.md).

- aggregation:

  character. The level of the decomposition: `"country"` (one row per
  exporting country), `"sector"` (one row per exporting
  country-industry), or `"bilateral"` (one row per exporting
  country-industry and importing country, excluding within-country
  flows). Default `"country"`.

- perspective:

  character. The accounting perspective defining the perimeter for
  double counting: `"exporter"` (exporting-country perspective, additive
  across sectors and destinations, 13 terms) or `"world"` (world
  perspective, 9 terms, only available for `aggregation = "country"`).
  Default `"exporter"`.

- approach:

  character. How double-counted items are allocated across shipments:
  `"source"` (value added recorded the first time it leaves the country
  of origin) or `"sink"` (the last time). `"exporter"` requires
  `"source"`; `"world"` requires `"sink"`. Default `"source"`.

## Value

A `data.frame` with one row per unit and one column per value-added
term, preceded by factor identifier columns: `Exporting_Country`
(country); `Exporting_Country, Exporting_Industry` (sector); or
`Exporting_Country, Exporting_Industry, Importing_Country` (bilateral).
The attribute `"decomposition"` is set to `"bm"`.

## Details

For the default exporter / source perspective the decomposition yields
13 terms; the world / sink perspective (country level only, the
"corrected KWW" decomposition) yields 9. All terms are in the same units
as the input-output table (e.g. millions of USD). The following
accounting identities hold: `GEXP = DC + FC`, `DC = DVA + DDC`,
`FC = FVA + FDC`, `DVA = VAX + REF`, and (exporter/source only)
`GVC = GVCB + GVCF = GEXP - DAVAX` and `GVCB = FC + DDC`.

|  |  |
|----|----|
| `GEXP` | Gross exports. |
| `DC` / `FC` | Domestic / foreign content. |
| `DVA` / `FVA` | Domestic / foreign value added. |
| `DDC` / `FDC` | Domestic / foreign double counting. |
| `VAX` | Domestic value added absorbed abroad (Johnson and Noguera 2012). |
| `REF` | Reflection: domestic value added returning home. |
| `DAVAX` | Domestic value added directly absorbed by the importer. |
| `GVC` | GVC-related trade (value added crossing more than one border). |
| `GVCB` / `GVCF` | Backward / forward GVC participation. |

The exporter / source decomposition is additive: the `"sector"` result
is the sum of the `"bilateral"` result over importers, and the
`"country"` result is the sum of the `"sector"` result over industries.

## References

Borin, A. and Mancini, M. (2019). Measuring What Matters in Global Value
Chains and Value-Added Trade. *World Bank Policy Research Working Paper
8804*.

Belotti, F., Borin, A. and Mancini, M. (2021). icio: Economic analysis
with intercountry input-output tables. *The Stata Journal, 21*(3),
708-755.

## See also

[`kww`](https://sebkrantz.github.io/decompr/reference/kww.md),
[`wwz`](https://sebkrantz.github.io/decompr/reference/wwz.md),
[`leontief`](https://sebkrantz.github.io/decompr/reference/leontief.md),
[`decompr-package`](https://sebkrantz.github.io/decompr/reference/decompr-package.md)

## Author

Sebastian Krantz

## Examples

``` r
# Load example data and create a 'decompr' object
data(leather)
dec <- load_tables_vectors(leather)

# Country-level decomposition (exporter perspective, source approach; 13 terms)
bm(dec)
#>   Exporting_Country  GEXP        DC       DVA      VAX    DAVAX       REF
#> 1         Argentina  64.3  53.68996  52.81756 46.73209 34.79877  6.085473
#> 2            Turkey 113.6  92.46175  89.82482 77.34144 65.50360 12.483373
#> 3           Germany 147.6 111.29058 106.84240 96.71914 89.31689 10.123261
#>         DDC       FC      FVA       FDC      GVC     GVCB     GVCF
#> 1 0.8723949 10.61004 10.43484 0.1752063 29.50123 11.48244 18.01879
#> 2 2.6369363 21.13825 20.55564 0.5826050 48.09640 23.77518 24.32122
#> 3 4.4481800 36.30942 35.06489 1.2445289 58.28311 40.75760 17.52551

# Country-level "corrected KWW" (world perspective, sink approach; 9 terms)
bm(dec, perspective = "world", approach = "sink")
#>   Exporting_Country  GEXP        DC       DVA      VAX       REF       DDC
#> 1         Argentina  64.3  53.68996  52.81756 46.73209  6.085473 0.8723949
#> 2            Turkey 113.6  92.46175  89.82482 77.34144 12.483373 2.6369363
#> 3           Germany 147.6 111.29058 106.84240 96.71914 10.123261 4.4481800
#>         FC       FVA      FDC
#> 1 10.61004  8.471827 2.138217
#> 2 21.13825 18.265189 2.873058
#> 3 36.30942 33.128506 3.180911

# Sector- and bilateral-sector-level decompositions
bm(dec, aggregation = "sector")
#>   Exporting_Country  Exporting_Industry GEXP        DC       DVA       VAX
#> 1         Argentina         Agriculture 33.2 29.795288 29.493900 26.540382
#> 2         Argentina Textile_and_Leather 28.5 22.056767 21.569374 18.582499
#> 3         Argentina Transport_Equipment  2.6  1.837902  1.754288  1.609208
#> 4            Turkey         Agriculture 45.9 38.432068 37.469257 32.468054
#> 5            Turkey Textile_and_Leather 59.2 48.074157 46.789941 39.702280
#> 6            Turkey Transport_Equipment  8.5  5.955528  5.565619  5.171110
#> 7           Germany         Agriculture 38.7 33.067867 32.402844 29.139637
#> 8           Germany Textile_and_Leather 31.0 25.719889 25.082406 21.487520
#> 9           Germany Transport_Equipment 77.9 52.502827 49.357153 46.091985
#>       DAVAX       REF        DDC        FC        FVA        FDC       GVC
#> 1 20.385155 2.9535185 0.30138767  3.404712  3.3423229 0.06238937 12.814845
#> 2 13.084653 2.9868748 0.48739312  6.443233  6.3486717 0.09456147 15.415347
#> 3  1.328962 0.1450801 0.08361414  0.762098  0.7438425 0.01825550  1.271038
#> 4 27.673077 5.0012037 0.96281049  7.467932  7.2556717 0.21226046 18.226923
#> 5 33.025635 7.0876610 1.28421633 11.125843 10.8426216 0.28322154 26.174365
#> 6  4.804889 0.3945085 0.38990949  2.544472  2.4573486 0.08712297  3.695111
#> 7 26.657741 3.2632066 0.66502295  5.632133  5.4445468 0.18758643 12.042259
#> 8 18.915931 3.5948858 0.63748284  5.280111  5.1021480 0.17796309 12.084069
#> 9 43.743217 3.2651685 3.14567421 25.397173 24.5181932 0.87897942 34.156783
#>         GVCB      GVCF
#> 1  3.7060999  9.108745
#> 2  6.9306263  8.484721
#> 3  0.8457122  0.425326
#> 4  8.4307426  9.796180
#> 5 12.4100595 13.764306
#> 6  2.9343811  0.760730
#> 7  6.2971562  5.745103
#> 8  5.9175939  6.166475
#> 9 28.5428469  5.613936
bm(dec, aggregation = "bilateral")
#>    Exporting_Country  Exporting_Industry Importing_Country GEXP         DC
#> 1             Turkey         Agriculture         Argentina 10.7  8.9591095
#> 2             Turkey Textile_and_Leather         Argentina 12.1  9.8259679
#> 3             Turkey Transport_Equipment         Argentina  1.6  1.1210406
#> 4            Germany         Agriculture         Argentina 14.9 12.7315559
#> 5            Germany Textile_and_Leather         Argentina 10.3  8.5456405
#> 6            Germany Transport_Equipment         Argentina 31.6 21.2976809
#> 7          Argentina         Agriculture            Turkey 14.0 12.5642780
#> 8          Argentina Textile_and_Leather            Turkey  6.8  5.2626672
#> 9          Argentina Transport_Equipment            Turkey  0.9  0.6361968
#> 10           Germany         Agriculture            Turkey 23.8 20.3363108
#> 11           Germany Textile_and_Leather            Turkey 20.7 17.1742484
#> 12           Germany Transport_Equipment            Turkey 46.3 31.2051464
#> 13         Argentina         Agriculture           Germany 19.2 17.2310098
#> 14         Argentina Textile_and_Leather           Germany 21.7 16.7940996
#> 15         Argentina Transport_Equipment           Germany  1.7  1.2017051
#> 16            Turkey         Agriculture           Germany 35.2 29.4729584
#> 17            Turkey Textile_and_Leather           Germany 47.1 38.2481890
#> 18            Turkey Transport_Equipment           Germany  6.9  4.8344878
#>           DVA       VAX      DAVAX        REF        DDC         FC        FVA
#> 1   8.7346635  8.224093  7.2163401 0.51057032 0.22444602  1.7408905  1.6914093
#> 2   9.5634845  9.079825  8.0548444 0.48365898 0.26248341  2.2740321  2.2161439
#> 3   1.0476459  1.018431  0.9626616 0.02921527 0.07339473  0.4789594  0.4625597
#> 4  12.4755135 10.951482  9.6750702 1.52403152 0.25604243  2.1684441  2.0962209
#> 5   8.3338317  7.706572  7.1641956 0.62725969 0.21180881  1.7543595  1.6952298
#> 6  20.0216436 19.072854 18.2515939 0.94879005 1.27603729 10.3023191  9.9457626
#> 7  12.4371868 11.215869  8.0001479 1.22131820 0.12709119  1.4357220  1.4094133
#> 8   5.1463769  4.569764  2.9980790 0.57661309 0.11629029  1.5373328  1.5147708
#> 9   0.6072535  0.575969  0.4840523 0.03128448 0.02894336  0.2638032  0.2574840
#> 10 19.9273303 18.188155 16.9826710 1.73917503 0.40898052  3.4636892  3.3483259
#> 11 16.7485744 13.780948 11.7517352 2.96762614 0.42567402  3.5257516  3.4069182
#> 12 29.3355095 27.019131 25.4916229 2.31637845 1.86963692 15.0948536 14.5724306
#> 13 17.0567133 15.324513 12.3850073 1.73220028 0.17429648  1.9689902  1.9329096
#> 14 16.4229968 14.012735 10.0865741 2.41026176 0.37110283  4.9059004  4.8339009
#> 15  1.1470343  1.033239  0.8449095 0.11379565 0.05467078  0.4982949  0.4863586
#> 16 28.7345939 24.243961 20.4567369 4.49063336 0.73836447  5.7270416  5.5642624
#> 17 37.2264561 30.622454 24.9707904 6.60400204 1.02173293  8.8518110  8.6264777
#> 18  4.5179730  4.152680  3.8422274 0.36529320 0.31651476  2.0655122  1.9947889
#>            FDC        GVC       GVCB       GVCF
#> 1  0.049481197  3.4836599  1.9653365  1.5183234
#> 2  0.057888186  4.0451556  2.5365155  1.5086400
#> 3  0.016399618  0.6373384  0.5523541  0.0849843
#> 4  0.072223200  5.2249298  2.4244865  2.8004433
#> 5  0.059129673  3.1358044  1.9661683  1.1696361
#> 6  0.356556480 13.3484061 11.5783564  1.7700497
#> 7  0.026308772  5.9998521  1.5628132  4.4370389
#> 8  0.022562035  3.8019210  1.6536231  2.1482979
#> 9  0.006319211  0.4159477  0.2927465  0.1232012
#> 10 0.115363232  6.8173290  3.8726697  2.9446593
#> 11 0.118833420  8.9482648  3.9514256  4.9968392
#> 12 0.522422944 20.8083771 16.9644905  3.8438866
#> 13 0.036080601  6.8149927  2.1432867  4.6717060
#> 14 0.071999434 11.6134259  5.2770032  6.3364227
#> 15 0.011936287  0.8550905  0.5529657  0.3021248
#> 16 0.162779264 14.7432631  6.4654061  8.2778570
#> 17 0.225333351 22.1292096  9.8735439 12.2556656
#> 18 0.070723354  3.0577726  2.3820270  0.6757457
```
