# load the package
library(decompr)

# load test data
data(leather)
list2env(leather, environment())

dec <- load_tables_vectors(leather)

context("bm output format")

cty <- bm(dec)                                          # country, exporter/source (13 terms)
sec <- bm(dec, aggregation = "sector")
bil <- bm(dec, aggregation = "bilateral")
ws  <- bm(dec, perspective = "world", approach = "sink")  # country, world/sink (9 terms)

test_that("output sizes match", {
  expect_equal(dim(cty), c(3L, 14L))   # 1 id + 13 terms
  expect_equal(dim(sec), c(9L, 15L))   # 2 id + 13 terms
  expect_equal(dim(bil), c(18L, 16L))  # 3 id + 13 terms, within-country excluded (3*3*2)
  expect_equal(dim(ws),  c(3L, 10L))   # 1 id + 9 terms
})

test_that("identifier columns are factors and terms are double", {
  expect_s3_class(bil$Exporting_Country, "factor")
  expect_s3_class(bil$Importing_Country, "factor")
  expect_match(typeof(sec$GVC), "double")
  expect_true(all(bil$Exporting_Country != bil$Importing_Country))  # self-pairs excluded
  expect_identical(attr(cty, "decomposition"), "bm")
})

test_that("decomp() interface dispatches to bm", {
  d <- decomp(x = inter, y = final, k = countries, i = industries, o = out,
              method = "bm", aggregation = "sector")
  expect_equal(d$GVC, sec$GVC)
})

context("bm accounting identities")

test_that("identities hold (sector level)", {
  expect_equal(sec$GEXP, sec$DC + sec$FC)
  expect_equal(sec$DC,   sec$DVA + sec$DDC)
  expect_equal(sec$FC,   sec$FVA + sec$FDC)
  expect_equal(sec$DVA,  sec$VAX + sec$REF)
  expect_equal(sec$GVC,  sec$GVCB + sec$GVCF)
  expect_equal(sec$GVC,  sec$GEXP - sec$DAVAX)
  expect_equal(sec$GVCB, sec$FC + sec$DDC)
})

test_that("no negative GVC or gross exports", {
  expect_true(all(sec$GVC  >= -1e-9))
  expect_true(all(sec$GEXP >= -1e-9))
})

context("bm additivity")

test_that("bilateral sums to sector", {
  agg <- aggregate(bil[c("GEXP", "DVA", "FVA", "DAVAX", "GVC")],
                   list(Exporting_Country = bil$Exporting_Country,
                        Exporting_Industry = bil$Exporting_Industry), sum)
  agg <- agg[order(agg$Exporting_Country, agg$Exporting_Industry), ]
  so  <- sec[order(sec$Exporting_Country, sec$Exporting_Industry), ]
  for (cl in c("GEXP", "DVA", "FVA", "DAVAX", "GVC"))
    expect_equal(so[[cl]], agg[[cl]], tolerance = 1e-8)
})

test_that("sector sums to country", {
  agg <- aggregate(sec[c("GEXP", "DVA", "FVA", "GVC")],
                   list(Exporting_Country = sec$Exporting_Country), sum)
  for (cl in c("GEXP", "DVA", "FVA", "GVC"))
    expect_equal(cty[[cl]], agg[[cl]], tolerance = 1e-8)
})

context("bm cross-checks vs kww")

test_that("world/sink domestic terms and FC match kww aggregates", {
  K <- kww(dec)
  expect_equal(ws$GEXP, rowSums(K[, -1]), tolerance = 1e-8)            # gross exports
  expect_equal(ws$DVA,  K$DVA_FIN + K$DVA_INT + K$DVA_INTrex +
                        K$RDV_FIN + K$RDV_INT, tolerance = 1e-8)        # total DVA
  expect_equal(ws$DDC,  K$DDC, tolerance = 1e-8)                        # domestic double counting
  expect_equal(ws$FC,   K$FVA_FIN + K$FVA_INT + K$FDC, tolerance = 1e-8)# foreign content
})

test_that("world/sink and exporter/source share domestic side and FC", {
  for (cl in c("GEXP", "DC", "DVA", "VAX", "REF", "DDC", "FC"))
    expect_equal(ws[[cl]], cty[[cl]], tolerance = 1e-8)
})

context("bm value-added zeroing")

test_that("only the origin country has positive domestic value added", {
  va <- out - colSums(inter)
  va[4:9] <- 0  # keep only Argentina's value added (country-sectors 1:3)
  s.arg <- decomp(x = inter, y = final, k = countries, i = industries, o = out, v = va,
                  method = "bm", aggregation = "sector")
  expect_true(all(s.arg$DVA[1:3] > 0))   # Argentina
  expect_true(all(s.arg$DVA[4:9] == 0))  # Turkey and Germany
})
