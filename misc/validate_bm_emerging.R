# Validate decompr::bm() on the EMERGING ICIO data against the ICIO.jl (Julia) output,
# which is itself validated to ~1e-7 against the Stata `icio` command.
#
# Local/dev script (the misc/ folder is git-ignored). Requires the EMERGING .qs2 table and the
# Julia-generated reference CSVs under ICIO_CSV/EMERGING_Broad_Sectors/.
#
#   Rscript misc/validate_bm_emerging.R

suppressMessages({
  devtools::load_all("/Users/sebastiankrantz/Documents/R/decompr", quiet = TRUE)
  library(qs2); library(data.table)
})

base   <- "/Users/sebastiankrantz/Documents/Data/EMERGING/ICIO_CSV/EMERGING_Broad_Sectors"
qs2f   <- "/Users/sebastiankrantz/Documents/Data/EMERGING/EMERGING_Broad_Sectors.qs2"
yr     <- 2015L
bil_sample_exporters <- c("CHN", "DEU", "USA", "ZAF")   # bilateral spot-check subset

EM  <- qs_read(qs2f)
d   <- EM$DATA[[as.character(yr)]]
# residual VA (no o/v) -> matches icio / ICIO.jl read_icio_csv
dec <- load_tables_vectors(x = d$T, y = d$FD, k = EM$Regions$ISO3, i = EM$Sectors$Broad_Sector_Code)

maxrel <- function(a, b, thr = 1) { a <- as.numeric(a); b <- as.numeric(b)
  big <- abs(b) > thr; if (!any(big)) 0 else max(abs(a[big] - b[big]) / abs(b[big])) }
report <- function(tag, R, J, cols) { cat(tag, "(", nrow(R), "rows )\n")
  for (c in cols) { Rc <- R[[toupper(c)]]; Jc <- J[[c]]
    cat("  ", formatC(c, width = 6, flag = "-"),
        " maxrel=", formatC(maxrel(Rc, Jc), format = "e", digits = 2),
        " maxabs=", formatC(max(abs(as.numeric(Rc) - as.numeric(Jc))), format = "g", digits = 4), "\n") } }

T9  <- c("gexp","dc","dva","vax","ref","ddc","fc","fva","fdc")
T13 <- c("gexp","dc","dva","vax","davax","ref","ddc","fc","fva","fdc","gvc","gvcb","gvcf")

## 1. country, world / sink (9 terms)
RC <- bm(dec, perspective = "world", approach = "sink")
RC$country <- as.character(RC$Exporting_Country)
JC <- fread(file.path(base, "EM_GVC_KWW_BM19.csv"))[year == yr]
RC <- RC[order(RC$country), ]; JC <- JC[order(JC$country)]
stopifnot(RC$country == JC$country)
report("== COUNTRY world/sink vs ICIO.jl ==", RC, JC, T9)

## 2. sector, exporter / source (13 terms)
RS <- bm(dec, aggregation = "sector")
RS$from_region <- as.character(RS$Exporting_Country)
RS$from_sector <- as.character(RS$Exporting_Industry)
JS <- fread(file.path(base, "EM_GVC_SEC_BM19.csv"))[year == yr]
setorder(JS, from_region, from_sector); RS <- RS[order(RS$from_region, RS$from_sector), ]
stopifnot(RS$from_region == JS$from_region, RS$from_sector == JS$from_sector)
report("== SECTOR exporter/source vs ICIO.jl ==", RS, JS, T13)

## 3. bilateral, exporter / source (13 terms) -- spot-check on a few exporters
RB <- bm(dec, aggregation = "bilateral")
RB$from_region <- as.character(RB$Exporting_Country)
RB$from_sector <- as.character(RB$Exporting_Industry)
RB$to_region   <- as.character(RB$Importing_Country)
RB <- RB[RB$from_region %in% bil_sample_exporters, ]
JB <- fread(file.path(base, "EM_GVC_BIL_SEC_BM19.csv"))[year == yr &
        from_region %in% bil_sample_exporters]
setorder(JB, from_region, from_sector, to_region)
RB <- RB[order(RB$from_region, RB$from_sector, RB$to_region), ]
stopifnot(nrow(RB) == nrow(JB), RB$from_region == JB$from_region,
          RB$from_sector == JB$from_sector, RB$to_region == JB$to_region)
report(sprintf("== BILATERAL exporter/source (%s) vs ICIO.jl ==",
               paste(bil_sample_exporters, collapse = ",")), RB, JB, T13)
