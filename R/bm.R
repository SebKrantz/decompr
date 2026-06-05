#' Borin-Mancini Decomposition of Gross Exports
#'
#' Decomposes gross exports into value-added and Global Value Chain (GVC) components following
#' the Borin and Mancini (2019) framework, as implemented in the Stata \code{icio} command
#' (Belotti, Borin and Mancini 2021). It is the R counterpart of the \code{decompose()} function
#' in the Julia package \code{ICIO.jl}, and operates on a \code{decompr} object created by
#' \code{\link{load_tables_vectors}}.
#'
#' @param x an object of class \code{decompr} obtained from \code{\link{load_tables_vectors}}.
#' @param aggregation character. The level of the decomposition:
#'  \code{"country"} (one row per exporting country), \code{"sector"} (one row per exporting
#'  country-industry), or \code{"bilateral"} (one row per exporting country-industry and
#'  importing country, excluding within-country flows). Default \code{"country"}.
#' @param perspective character. The accounting perspective defining the perimeter for double
#'  counting: \code{"exporter"} (exporting-country perspective, additive across sectors and
#'  destinations, 13 terms) or \code{"world"} (world perspective, 9 terms, only available for
#'  \code{aggregation = "country"}). Default \code{"exporter"}.
#' @param approach character. How double-counted items are allocated across shipments:
#'  \code{"source"} (value added recorded the first time it leaves the country of origin) or
#'  \code{"sink"} (the last time). \code{"exporter"} requires \code{"source"}; \code{"world"}
#'  requires \code{"sink"}. Default \code{"source"}.
#'
#' @details
#' For the default exporter / source perspective the decomposition yields 13 terms; the
#' world / sink perspective (country level only, the "corrected KWW" decomposition) yields 9.
#' All terms are in the same units as the input-output table (e.g. millions of USD). The
#' following accounting identities hold: \code{GEXP = DC + FC}, \code{DC = DVA + DDC},
#' \code{FC = FVA + FDC}, \code{DVA = VAX + REF}, and (exporter/source only)
#' \code{GVC = GVCB + GVCF = GEXP - DAVAX} and \code{GVCB = FC + DDC}.
#'
#' \tabular{ll}{
#'  \code{GEXP} \tab Gross exports. \cr
#'  \code{DC} / \code{FC} \tab Domestic / foreign content. \cr
#'  \code{DVA} / \code{FVA} \tab Domestic / foreign value added. \cr
#'  \code{DDC} / \code{FDC} \tab Domestic / foreign double counting. \cr
#'  \code{VAX} \tab Domestic value added absorbed abroad (Johnson and Noguera 2012). \cr
#'  \code{REF} \tab Reflection: domestic value added returning home. \cr
#'  \code{DAVAX} \tab Domestic value added directly absorbed by the importer. \cr
#'  \code{GVC} \tab GVC-related trade (value added crossing more than one border). \cr
#'  \code{GVCB} / \code{GVCF} \tab Backward / forward GVC participation. \cr
#' }
#'
#' The exporter / source decomposition is additive: the \code{"sector"} result is the sum of
#' the \code{"bilateral"} result over importers, and the \code{"country"} result is the sum of
#' the \code{"sector"} result over industries.
#'
#' @return A \code{data.frame} with one row per unit and one column per value-added term,
#'  preceded by factor identifier columns: \code{Exporting_Country} (country);
#'  \code{Exporting_Country, Exporting_Industry} (sector); or \code{Exporting_Country,
#'  Exporting_Industry, Importing_Country} (bilateral). The attribute \code{"decomposition"} is
#'  set to \code{"bm"}.
#'
#' @author Sebastian Krantz
#' @references
#' Borin, A. and Mancini, M. (2019). Measuring What Matters in Global Value Chains and
#' Value-Added Trade. \emph{World Bank Policy Research Working Paper 8804}.
#'
#' Belotti, F., Borin, A. and Mancini, M. (2021). icio: Economic analysis with intercountry
#' input-output tables. \emph{The Stata Journal, 21}(3), 708-755.
#' @export
#' @seealso \code{\link{kww}}, \code{\link{wwz}}, \code{\link{leontief}}, \code{\link{decompr-package}}
#' @examples
#' # Load example data and create a 'decompr' object
#' data(leather)
#' dec <- load_tables_vectors(leather)
#'
#' # Country-level decomposition (exporter perspective, source approach; 13 terms)
#' bm(dec)
#'
#' # Country-level "corrected KWW" (world perspective, sink approach; 9 terms)
#' bm(dec, perspective = "world", approach = "sink")
#'
#' # Sector- and bilateral-sector-level decompositions
#' bm(dec, aggregation = "sector")
#' bm(dec, aggregation = "bilateral")
bm <- function(x,
               aggregation = c("country", "sector", "bilateral"),
               perspective = c("exporter", "world"),
               approach    = c("source", "sink")) {

  if(!inherits(x, "decompr"))
    stop("x must be an object of class 'decompr' created by the load_tables_vectors() function.")
  aggregation <- match.arg(aggregation)
  perspective <- match.arg(perspective)
  approach    <- match.arg(approach)

  worldsink <- perspective == "world"    && approach == "sink"
  expsource <- perspective == "exporter" && approach == "source"
  if(!(worldsink || expsource))
    stop("bm() supports perspective = 'exporter', approach = 'source' (13 terms), or ",
         "perspective = 'world', approach = 'sink' (9 terms).")
  if(worldsink && aggregation != "country")
    stop("perspective = 'world', approach = 'sink' is only available for aggregation = 'country'.")

  # bring decompr-object elements into scope
  Am <- B <- Bd <- Bm <- L <- Vc <- E <- ESR <- Y <- Yd <- Ym <- X <-
    G <- N <- GN <- k <- i <- NULL
  list2env(x, environment())

  Nseq    <- seq_len(N)
  blk     <- function(g) (g - 1L) * N + Nseq          # row/col range for country g
  ctryvec <- rep(seq_len(G), each = N)                # country of each country-sector
  idiag   <- cbind(seq_len(GN), ctryvec)              # [j, country(j)] extraction index

  ## ---- per-cell coefficients (length GN) -------------------------------------------------
  VBdom <- colSums2(Bd * Vc)                          # domestic VA multiplier  (kww Bd_Vhat_sum)
  VBfor <- colSums2(Bm * Vc)                          # foreign  VA multiplier
  VLdom <- colSums2(L  * Vc)                          # local domestic VA       (wwz VsLss_colSums)

  fvacoef <- numeric(GN)                              # exporter/source foreign-VA-once coefficient
  IN <- diag(N)
  for(s in seq_len(G)) {
    bs <- blk(s)
    Ms <- Am[bs, , drop = FALSE] %*% B[, bs, drop = FALSE]   # N x N  (= sum_{j!=s} A_sj B_js)
    fvacoef[bs] <- solve(t(IN + Ms), VBfor[bs])
  }

  ## ---- directly-absorbed exports DAE and "absorbed-abroad" exports VAXE (GN x G) ---------
  Yddiag <- Yd[idiag]                                 # domestic final demand per country-sector
  Wcol   <- as.vector(L %*% Yddiag)                   # L_rr Y_rr, stacked
  BFD    <- B %*% Y                                   # output driven by each country's final demand

  DAE  <- Ym
  VAXE <- Ym
  for(r in seq_len(G)) {
    br <- blk(r)
    DAE[, r]  <- DAE[, r] + Am[, br, drop = FALSE] %*% Wcol[br]
    Mr        <- Am[, br, drop = FALSE] %*% BFD[br, , drop = FALSE]   # GN x G
    VAXE[, r] <- VAXE[, r] + Am[, br, drop = FALSE] %*% X[br] - Mr[idiag]
  }

  ## ---- term matrices (GN x G), exporter / source ----------------------------------------
  GEXP  <- ESR
  DC    <- VBdom   * ESR
  FC    <- VBfor   * ESR
  DVA   <- VLdom   * ESR
  DDC   <- DC - DVA
  FVA   <- fvacoef * ESR
  FDC   <- FC - FVA
  DAVAX <- VLdom * DAE
  VAX   <- VLdom * VAXE
  REF   <- DVA - VAX
  GVC   <- ESR - DAVAX
  GVCB  <- FC + DDC
  GVCF  <- GVC - GVCB

  ## ---- assemble output -------------------------------------------------------------------
  if(aggregation == "bilateral") {
    terms <- list(GEXP = GEXP, DC = DC, DVA = DVA, VAX = VAX, DAVAX = DAVAX, REF = REF,
                  DDC = DDC, FC = FC, FVA = FVA, FDC = FDC, GVC = GVC, GVCB = GVCB, GVCF = GVCF)
    expsec <- rep.int(seq_len(GN), G)
    imp    <- rep(seq_len(G), each = GN)
    keep   <- ctryvec[expsec] != imp                  # drop within-country flows
    out <- c(list(Exporting_Country  = structure(ctryvec[expsec][keep], levels = k, class = "factor"),
                  Exporting_Industry = structure(rep.int(seq_len(N), G)[expsec][keep], levels = i, class = "factor"),
                  Importing_Country  = structure(imp[keep], levels = k, class = "factor")),
             lapply(terms, function(m) as.vector(m)[keep]))
    nr <- sum(keep)

  } else {
    # sector level: sum each term over importers (within-country columns are 0)
    sec <- list(GEXP = E, DC = VBdom * E, DVA = VLdom * E, VAX = VLdom * rowSums2(VAXE),
                DAVAX = VLdom * rowSums2(DAE))
    sec$REF  <- sec$DVA - sec$VAX
    sec$DDC  <- sec$DC - sec$DVA
    sec$FC   <- VBfor * E
    sec$FVA  <- fvacoef * E
    sec$FDC  <- sec$FC - sec$FVA
    sec$GVC  <- E - sec$DAVAX
    sec$GVCB <- sec$FC + sec$DDC
    sec$GVCF <- sec$GVC - sec$GVCB
    ord <- c("GEXP","DC","DVA","VAX","DAVAX","REF","DDC","FC","FVA","FDC","GVC","GVCB","GVCF")

    if(aggregation == "sector") {
      out <- c(list(Exporting_Country  = structure(ctryvec, levels = k, class = "factor"),
                    Exporting_Industry = structure(rep.int(seq_len(N), G), levels = i, class = "factor")),
               sec[ord])
      nr <- GN

    } else { # country
      cty <- lapply(sec[ord], function(v) rowsum(v, ctryvec, reorder = FALSE)[, 1L])
      if(worldsink) {
        # world/sink foreign VA (Borin & Mancini 2019, eq. 54); domestic side is unchanged
        Yms     <- rowSums2(Ym)
        Wrex    <- as.vector(L %*% (Yms + as.vector(Am %*% Wcol)))
        AsrWrex <- matrix(0, GN, G)
        VBR     <- matrix(0, GN, G)
        for(r in seq_len(G)) {
          br <- blk(r)
          AsrWrex[, r] <- Am[, br, drop = FALSE] %*% Wrex[br]
          VBR[, r]     <- colSums2(B[br, , drop = FALSE] * Vc[br])   # sum_{m in r} V_m B[m, ]
        }
        TC     <- VBR * AsrWrex
        fva_cs <- VBfor * (rowSums2(DAE) - DAE[idiag]) + (rowSums2(TC) - TC[idiag])
        fva_ws <- rowsum(fva_cs, ctryvec, reorder = FALSE)[, 1L]
        cty$FVA <- fva_ws
        cty$FDC <- cty$FC - fva_ws
        ord <- c("GEXP","DC","DVA","VAX","REF","DDC","FC","FVA","FDC")   # 9 terms
      }
      out <- c(list(Exporting_Country = structure(seq_len(G), levels = k, class = "factor")),
               cty[ord])
      nr <- G
    }
  }

  out <- lapply(out, unname)                # drop stray element names from term columns
  attr(out, "row.names") <- .set_row_names(nr)
  class(out) <- "data.frame"
  attr(out, "decomposition") <- "bm"
  out
}
