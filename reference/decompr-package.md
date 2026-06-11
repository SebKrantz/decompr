# Global Value Chain Decomposition

Four global value chain (GVC) decompositions are implemented. The
Leontief decomposition derives the value added origin of exports by
country and industry as in Hummels, Ishii and Yi (2001). The Koopman,
Wang and Wei (2014) decomposition splits country-level exports into 9
value added components, and the Wang, Wei and Zhu (2013) decomposition
splits bilateral exports into 16 value added components. The Borin and
Mancini (2019) decomposition splits country-, sector- or bilateral-level
exports into up to 13 value added and GVC components, and also provides
a corrected version of the (biased) KWW decomposition. Various GVC
indicators based on these decompositions are computed in the
complimentary 'gvc' package.

## Contents

Interface function for quick analysis

[`decomp()`](https://bquast.github.io/decompr/reference/decomp.md)

Function to load ICIO table and create a 'decompr' object

[`load_tables_vectors()`](https://bquast.github.io/decompr/reference/load_tables_vectors.md)

Functions to perform GVC decompositions on a 'decompr' object

[`leontief()`](https://bquast.github.io/decompr/reference/leontief.md)  
[`kww()`](https://bquast.github.io/decompr/reference/kww.md)  
[`wwz()`](https://bquast.github.io/decompr/reference/wwz.md)  
[`bm()`](https://bquast.github.io/decompr/reference/bm.md)

Function to obtain KWW decomposition from WWZ decomposition

[`wwz2kww()`](https://bquast.github.io/decompr/reference/wwz2kww.md)

Example ICIO data

[`data("leather")`](https://bquast.github.io/decompr/reference/leather.md)

## References

Hummels, D., Ishii, J., & Yi, K. M. (2001). The nature and growth of
vertical specialization in world trade. *Journal of international
Economics, 54*(1), 75-96.

Koopman, R., Wang, Z., & Wei, S. J. (2014). Tracing value-added and
double counting in gross exports. *American Economic Review, 104*(2),
459-94.

Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu (2013). Quantifying
international production sharing at the bilateral and sector levels (No.
w19677). *National Bureau of Economic Research*.

Borin, A., & Mancini, M. (2019). Measuring What Matters in Global Value
Chains and Value-Added Trade. *World Bank Policy Research Working Paper
8804*.

## See also

https://bquast.github.io/decompr/

## Author

Bastiaan Quast <bquast@gmail.com>  
Sebastian Krantz  
Fei Wang  
Victor Stolzenburg
