#' Rank biome schemes for a given occurrence dataset
#'
#' Compares the biome schemes for a user-supplied set of occurrence
#' records and proposes a single "best" scheme for that dataset. Each
#' scheme is scored on several data-driven criteria that are combined
#' into one `composite_score`, which drives the ranking.
#'
#' Three equally weighted criteria are used:
#' \enumerate{
#'   \item \strong{coverage}: fraction of records that the scheme places
#'     in a biome at all (the rest fall on unclassified, NA cells).
#'   \item \strong{effective_biomes}: \eqn{\exp(H')} (Hill number of
#'     order 1), i.e. the effective number of biomes the records spread
#'     across, weighted by evenness.
#'   \item \strong{granularity}: biomes actually used, divided by the
#'     biomes available in the scheme.
#' }
#'
#' @section Scaling and the composite score:
#' Every criterion is min-max rescaled to \eqn{[0, 1]} across the compared
#' schemes: the scheme with the lowest value gets 0, the one with the
#' highest gets 1. The `composite_score` is the equal-weight mean of the
#' rescaled criteria. Because the rescaling is relative to the compared
#' set, composite scores are comparable only among schemes that were
#' ranked together, and a rescaled 0 means "lowest among the compared
#' schemes", not zero. Two edge cases: a criterion that does not vary
#' among the compared schemes carries no information and is left out of
#' the composite (its `*_scaled` column is `NA`; see the attribute
#' `criteria_used`), and a single compared scheme gets no composite score
#' (`NA`) but is still returned as `best_scheme`.
#'
#' Schemes are ordered by `composite_score` and ties resolved according to
#' `tiebreaker`.
#'
#' @note
#' `biomes_rank()` gives a data-driven ranking, not an authoritative
#' "best" classification. The criteria favour schemes that cover your
#' records and split them into many, evenly-used biomes, but the
#' top-ranked scheme is not necessarily the most suitable one for your
#' question. For best results, narrow the comparison to one biome
#' definition via `definition`, and treat the ranking as a shortlist
#' rather than a verdict: inspect the per-criterion columns in the
#' result and use [biomes_info()] to choose the scheme whose concept and
#' resolution actually match your data.
#'
#' @param x A data frame with longitude / latitude columns, an `sf`
#'   spatial object, or a `terra::SpatVector` of point geometries.
#' @param scheme Optional integer vector in `1:31` (biome scheme numbers)
#'   to restrict the ranking to a subset of the packaged schemes (e.g.
#'   `scheme = c(1, 5, 25)`). `NULL` (default) ranks all 31 schemes.
#'   Ignored when `biome` is supplied.
#' @param biome Optional `terra::SpatRaster` stack of biome schemes. Use
#'   this for custom rasters; for the packaged stack prefer
#'   `scheme = <int>` instead.
#' @param lon Column name of longitude in `x` (only used if `x` is a
#'   non-spatial data frame). Default `"decimalLongitude"`.
#' @param lat Column name of latitude in `x` (only used if `x` is a
#'   non-spatial data frame). Default `"decimalLatitude"`.
#' @param definition Character. Restrict the ranking to the schemes that
#'   share one biome definition: one of `"all"` (default; rank all 31
#'   schemes), `"climate"`, `"vegetation"`, `"land_cover"`,
#'   `"ecoregion"`, `"integrative"`, or `"anthropogenic"`. The grouping
#'   is taken from the `biome_definition` column of [biomes_information].
#'   When a specific definition is chosen, only the schemes of that
#'   definition are classified, scored and returned, so the scaled scores
#'   and the best scheme are determined within that group. Ignored when
#'   `biome` is supplied.
#' @param criteria Character vector with one or more of `"coverage"`,
#'   `"effective_biomes"`, `"granularity"`. Default: all three.
#' @param tiebreaker How tied `composite_score`s are resolved: `"year"`
#'   (default, more recent publication ranks higher), `"biomes"` (more
#'   biomes ranks higher), or `"none"` (do not break ties; tied schemes
#'   share a rank, dense ranking). With `"year"` and `"biomes"` the
#'   other key serves as a further fallback, alphabetical `scheme_name`
#'   resolves any remaining ties, and ranks are strict 1..N. With
#'   `"none"` multiple schemes may carry `is_best = TRUE`.
#' @param verbose Logical. Print progress messages? Default `TRUE`.
#'
#' @return A data frame of classes `biomes_rank` and `data.frame`, with
#'   one row per compared biome scheme. Columns: `scheme` (the biome
#'   scheme number, 1-31), `scheme_name`, `year` (publication year of
#'   the scheme), `n_total`, `n_hit` and `n_na` (number of records in
#'   total, classified, and unclassified), `pct_na` (percentage of
#'   unclassified records), then one `*_raw` and one `*_scaled` column
#'   per requested criterion (the raw score and its rescaled version),
#'   `composite_score` (mean
#'   of the scaled criteria, drives the ranking), `rank` (1 = best), and
#'   `is_best` (`TRUE` for the top-ranked scheme). The result carries the
#'   attributes `criteria` (requested), `criteria_used` (those that entered
#'   the composite), `tiebreaker`, `definition`, and
#'   `best_scheme` (the biome scheme number of the top-ranked scheme, ready
#'   to be used as the `scheme` argument of [biomes_classify()] or
#'   [biomes_full()]).
#'
#' @examples
#' data("bombacoideae_occurrences")
#'
#' \donttest{
#' # Ranks the schemes of the biome raster (~36 MB), downloaded on first use.
#'
#' # Default call: coverage + effective_biomes + granularity, equally weighted
#' r <- biomes_rank(bombacoideae_occurrences, verbose = FALSE)
#' head(r)
#' attr(r, "best_scheme")
#'
#' # Restrict to a subset of criteria
#' r2 <- biomes_rank(
#'   bombacoideae_occurrences,
#'   criteria = c("coverage", "effective_biomes"),
#'   verbose  = FALSE
#' )
#'
#' }
#'
#' @export
biomes_rank <- function(
    x,
    scheme     = NULL,
    biome      = NULL,
    lon         = "decimalLongitude",
    lat         = "decimalLatitude",
    definition = "all",
    criteria    = c("coverage", "effective_biomes", "granularity"),
    tiebreaker = c("year", "biomes", "none"),
    verbose    = TRUE
) {

  # ---------------------------------------------------------------- input
  checkmate::assert_true(
    any(c("data.frame", "sf", "SpatVector") %in% class(x)),
    .var.name = "x"
  )
  if (inherits(x, "data.frame") && !inherits(x, "sf")) {
    checkmate::assert_subset(c(lon, lat), choices = names(x), .var.name = "x")
    checkmate::assert_numeric(x[[lon]], any.missing = TRUE)
    checkmate::assert_numeric(x[[lat]], any.missing = TRUE)
  }
  if (!is.null(biome)) {
    checkmate::assert_class(biome, "SpatRaster")
  }
  if (!is.null(scheme)) {
    checkmate::assert_integerish(scheme, lower = 1L, upper = 31L,
                                 any.missing = FALSE, min.len = 1L,
                                 .var.name = "scheme")
    if (!is.null(biome)) {
      warning("`scheme` is ignored because `biome` was supplied.",
              call. = FALSE)
    }
  }

  # ---- definition: restrict to one methodological group of schemes -------
  definitions <- c("all", "climate", "vegetation", "land_cover",
                    "ecoregion", "integrative", "anthropogenic")
  checkmate::assert_choice(definition, definitions, .var.name = "definition")
  if (definition != "all") {
    if (!is.null(biome)) {
      warning("`definition` is ignored because `biome` was supplied.",
              call. = FALSE)
    } else {
      if (!"biome_definition" %in% names(biomes::biomes_information)) {
        stop("biomes_information has no `biome_definition` column; reinstall the ",
             "package to use `definition`.", call. = FALSE)
      }
      def_schemes <- which(biomes::biomes_information$biome_definition == definition)
      if (length(def_schemes) == 0L) {
        stop("No schemes found for definition = '", definition, "'.",
             call. = FALSE)
      }
      scheme <- if (is.null(scheme)) def_schemes else intersect(scheme, def_schemes)
      if (length(scheme) == 0L) {
        stop("`scheme` and `definition` together select no schemes.",
             call. = FALSE)
      }
    }
  }

  all_criteria <- c("coverage", "effective_biomes", "granularity")
  checkmate::assert_subset(criteria, choices = all_criteria,
                           empty.ok = FALSE, .var.name = "criteria")
  criteria   <- unique(criteria)
  tiebreaker <- match.arg(tiebreaker)
  checkmate::assert_flag(verbose)

  # rows with NA coords cannot be classified -> drop with a warning
  if (inherits(x, "data.frame") && !inherits(x, "sf")) {
    bad <- !is.finite(x[[lon]]) | !is.finite(x[[lat]])
    if (any(bad)) {
      warning(sprintf(
        "Dropping %d record(s) with non-finite coordinates.", sum(bad)
      ))
      x <- x[!bad, , drop = FALSE]
    }
  }

  n_total <- if (inherits(x, "data.frame")) nrow(x) else length(x)

  # ---------------------------------------------------------------- empty
  if (n_total == 0) {
    warning("Input has zero usable records; returning an empty ranking.")
    return(.empty_rank(criteria, tiebreaker))
  }

  # ---------------------------------------------------------- classify
  if (verbose) message("Classifying ", n_total,
                       " record(s) against the biome schemes ...")
  ids <- suppressMessages(suppressWarnings(
    biomes_classify(x, scheme = scheme, biome = biome,
                    lon = lon, lat = lat,
                    value = "ID", append = FALSE, na = NA)
  ))
  # biomes_classify returns *_value columns
  layer_cols <- names(ids)
  layer_idx  <- suppressWarnings(readr::parse_number(layer_cols))

  use_default_legend <- all(!is.na(layer_idx)) &&
    all(layer_idx >= 1 & layer_idx <= nrow(biomes::biomes_information))

  # scheme-level metadata (year, total biomes, scheme name)
  info <- .layer_info(layer_idx, use_default_legend)

  # ---------------------------------------------------------- per-scheme
  if (verbose) message("Computing per-scheme criteria ...")
  per_layer <- lapply(seq_along(layer_cols), function(i) {
    vals <- ids[[i]]
    n_hit <- sum(!is.na(vals))
    n_na  <- n_total - n_hit
    raw <- list(
      coverage         = n_hit / n_total,
      effective_biomes = NA_real_,
      granularity      = NA_real_
    )
    if (n_hit > 0) {
      used <- table(vals, useNA = "no")
      k_used <- length(used)
      total_biomes <- info$total_biomes[i]
      raw$granularity <- if (!is.na(total_biomes) && total_biomes > 0) {
        min(k_used / total_biomes, 1)
      } else {
        NA_real_
      }
      shannon <- .compute_shannon(used)
      raw$effective_biomes <- exp(shannon)
    }
    list(
      n_total = n_total,
      n_hit   = n_hit,
      n_na    = n_na,
      raw     = raw
    )
  })

  # ---------------------------------------------------------- assemble
  raw_mat <- do.call(rbind, lapply(per_layer, function(z) {
    unlist(z$raw[criteria])
  }))
  colnames(raw_mat) <- criteria

  # min-max rescaling of every criterion across the compared schemes
  scaled_mat <- apply(raw_mat, 2, .minmax)
  if (is.null(dim(scaled_mat))) {
    # apply collapses to a vector when only 1 row -> reshape
    scaled_mat <- matrix(scaled_mat, nrow = nrow(raw_mat),
                         dimnames = list(NULL, criteria))
  }

  # criteria that carry no information for this comparison (no variation
  # among the compared schemes, or all NA) are left out of the composite
  has_raw  <- colSums(!is.na(raw_mat)) > 0
  has_info <- colSums(!is.na(scaled_mat)) > 0
  criteria_used <- criteria[has_info]
  if (nrow(raw_mat) == 1L) {
    if (verbose) message("Only one scheme compared: no composite score.")
  } else if (any(has_raw & !has_info) && verbose) {
    message("Criterion without variation among the compared schemes, left ",
            "out of the composite score: ",
            paste(criteria[has_raw & !has_info], collapse = ", "))
  }

  # composite is the equal-weight mean of the available scaled criteria;
  # schemes with NA on one criterion are not punished twice.
  composite <- vapply(seq_len(nrow(scaled_mat)), function(i) {
    s <- scaled_mat[i, ]
    ok <- !is.na(s)
    if (!any(ok)) return(NA_real_)
    mean(s[ok])
  }, numeric(1))

  out <- data.frame(
    scheme      = layer_idx,
    scheme_name = info$layer_name,
    year        = info$year,
    n_total    = vapply(per_layer, `[[`, integer(1), "n_total"),
    n_hit      = vapply(per_layer, `[[`, integer(1), "n_hit"),
    n_na       = vapply(per_layer, `[[`, integer(1), "n_na"),
    stringsAsFactors = FALSE
  )
  out$pct_na <- round(100 * out$n_na / pmax(out$n_total, 1), 2)
  for (cr in criteria) {
    out[[paste0(cr, "_raw")]]    <- raw_mat[, cr]
    out[[paste0(cr, "_scaled")]] <- scaled_mat[, cr]
  }
  out$composite_score <- composite

  # ranks + tiebreaker on rank 1
  out <- .apply_tiebreaker(out, tiebreaker)
  best_scheme <- out$scheme[out$is_best][1]

  attr(out, "criteria")      <- criteria
  attr(out, "criteria_used") <- criteria_used
  attr(out, "tiebreaker")    <- tiebreaker
  attr(out, "best_scheme") <- best_scheme
  attr(out, "definition") <- definition
  class(out) <- c("biomes_rank", "data.frame")

  if (verbose && !is.na(out$composite_score[out$is_best][1])) {
    message(sprintf(
      "Best scheme: %s, %s (composite = %.3f)",
      best_scheme,
      out$scheme_name[out$is_best][1],
      out$composite_score[out$is_best][1]
    ))
  }
  out
}


# =====================================================================
# Internal helpers
# =====================================================================

#' Min-max scale a numeric vector to `[0, 1]`.
#'
#' NA values are preserved. If all non-NA values are equal, the criterion
#' does not discriminate between the compared schemes and all entries
#' become NA, so that the criterion is left out of the composite score.
#'
#' @keywords internal
#' @noRd
.minmax <- function(x) {
  if (all(is.na(x))) return(x)
  mn <- min(x, na.rm = TRUE)
  mx <- max(x, na.rm = TRUE)
  if (isTRUE(all.equal(mn, mx))) {
    return(rep(NA_real_, length(x)))
  }
  (x - mn) / (mx - mn)
}

#' Shannon entropy of a frequency table (natural log).
#'
#' @keywords internal
#' @noRd
.compute_shannon <- function(counts) {
  counts <- counts[counts > 0]
  if (length(counts) == 0) return(0)
  p <- counts / sum(counts)
  -sum(p * log(p))
}

#' Scheme-level metadata: scheme name, publication year, biome count.
#'
#' @keywords internal
#' @noRd
.layer_info <- function(layer_idx, use_default_legend) {
  layer_name <- rep(NA_character_, length(layer_idx))
  year       <- rep(NA_integer_,   length(layer_idx))
  total_cls  <- rep(NA_integer_,   length(layer_idx))
  if (!use_default_legend) return(list(layer_name = layer_name,
                                       year = year,
                                       total_biomes = total_cls))

  info <- biomes::biomes_information
  leg  <- biomes::biomes_legend
  for (i in seq_along(layer_idx)) {
    k <- layer_idx[i]
    if (is.na(k) || k < 1 || k > nrow(info)) next
    layer_name[i] <- info[[k, "name_of_classification"]]
    pub <- info[[k, "publication"]]
    yr  <- suppressWarnings(as.integer(regmatches(
      pub, regexpr("(18|19|20)[0-9]{2}", pub)
    )))
    if (length(yr) == 1 && !is.na(yr)) year[i] <- yr
    leg_row <- leg[k, -c(1, 2), drop = FALSE]
    total_cls[i] <- sum(!is.na(unlist(leg_row)))
  }
  list(layer_name = layer_name, year = year, total_biomes = total_cls)
}

#' Assign ranks per the chosen tiebreaker.
#'
#' - `"year"`  : strict 1..N, order chain composite -> year -> biomes -> name
#' - `"biomes"`: strict 1..N, order chain composite -> biomes -> year -> name
#' - `"none"`  : dense ranks, ties on `composite_score` share a rank;
#'                multiple schemes may carry `is_best = TRUE`.
#' Schemes with NA `composite_score` get NA rank.
#'
#' @keywords internal
#' @noRd
.apply_tiebreaker <- function(df, tiebreaker) {
  # a single compared scheme is trivially the best, even without composite
  if (nrow(df) == 1L) {
    df$rank    <- 1L
    df$is_best <- TRUE
    return(df)
  }
  cls    <- .total_biomes_from_df(df)
  non_na <- !is.na(df$composite_score)

  if (tiebreaker == "none") {
    rank_vec <- rep(NA_integer_, nrow(df))
    ord <- order(-df$composite_score[non_na])
    positions <- which(non_na)[ord]
    scores <- df$composite_score[positions]
    dense_rank <- integer(length(scores))
    current <- 0L
    prev <- NA_real_
    for (k in seq_along(scores)) {
      if (k == 1L || !isTRUE(abs(scores[k] - prev) < 1e-9)) {
        current <- current + 1L
      }
      dense_rank[k] <- current
      prev <- scores[k]
    }
    rank_vec[positions] <- dense_rank
    df$rank    <- rank_vec
    df$is_best <- !is.na(rank_vec) & rank_vec == 1L
    return(df)
  }

  if (tiebreaker == "year") {
    sort_idx <- order(
      -df$composite_score[non_na],
      -df$year[non_na],
      -cls[non_na],
      df$scheme_name[non_na],
      na.last = TRUE
    )
  } else {  # "biomes"
    sort_idx <- order(
      -df$composite_score[non_na],
      -cls[non_na],
      -df$year[non_na],
      df$scheme_name[non_na],
      na.last = TRUE
    )
  }

  rank_vec  <- rep(NA_integer_, nrow(df))
  positions <- which(non_na)[sort_idx]
  rank_vec[positions] <- seq_along(positions)

  df$rank    <- rank_vec
  df$is_best <- !is.na(rank_vec) & rank_vec == 1L
  df
}

#' Compute "total biomes" for a ranked data frame, even if the user
#' passed a custom raster (legend unknown); fall back to NA there.
#'
#' @keywords internal
#' @noRd
.total_biomes_from_df <- function(df) {
  k <- df$scheme
  leg <- biomes::biomes_legend
  out <- rep(NA_integer_, length(k))
  ok <- !is.na(k) & k >= 1 & k <= nrow(leg)
  if (any(ok)) {
    out[ok] <- vapply(k[ok], function(i) {
      sum(!is.na(unlist(leg[i, -c(1, 2), drop = FALSE])))
    }, integer(1))
  }
  out
}

#' Return an empty `biomes_rank` data frame with the right shape.
#'
#' @keywords internal
#' @noRd
.empty_rank <- function(criteria, tiebreaker) {
  base <- data.frame(
    scheme = integer(), scheme_name = character(), year = integer(),
    n_total = integer(), n_hit = integer(), n_na = integer(),
    pct_na = numeric(),
    stringsAsFactors = FALSE
  )
  for (cr in criteria) {
    base[[paste0(cr, "_raw")]]    <- numeric()
    base[[paste0(cr, "_scaled")]] <- numeric()
  }
  base$composite_score <- numeric()
  base$rank            <- integer()
  base$is_best         <- logical()
  attr(base, "criteria")      <- criteria
  attr(base, "criteria_used") <- character()
  attr(base, "tiebreaker")    <- tiebreaker
  attr(base, "best_scheme") <- NA_integer_
  class(base) <- c("biomes_rank", "data.frame")
  base
}
