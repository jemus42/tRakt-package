# Worker function ----
#' @keywords internal
#' @importFrom rlang has_name
#' @importFrom dplyr select bind_rows
#' @noRd
trakt_auto_lists <- function(list_type = c(
                               "popular", "trending", "anticipated",
                               "played", "watched", "collected", "updates"
                             ),
                             type = c("shows", "movies"),
                             limit = 10L,
                             extended = c("min", "full"),
                             period = NULL, start_date = NULL,
                             query = NULL, years = NULL,
                             genres = NULL, languages = NULL,
                             countries = NULL, runtimes = NULL,
                             ratings = NULL, certifications = NULL,
                             networks = NULL, status = NULL) {
  # Check arguments
  list_type <- match.arg(list_type)

  extended <- match.arg(extended)
  limit <- as.integer(limit)

  # Check filters
  query <- check_filter_arg(query, "query")
  years <- check_filter_arg(years, "years")
  genres <- check_filter_arg(genres, "genres")
  languages <- check_filter_arg(languages, "languages")
  countries <- check_filter_arg(countries, "countries")
  runtimes <- check_filter_arg(runtimes, "runtimes")
  ratings <- check_filter_arg(ratings, "ratings")
  certifications <- check_filter_arg(certifications, "certifications")
  networks <- check_filter_arg(networks, "networks")
  status <- check_filter_arg(status, "status")

  # Check limit
  if (limit < 1) {
    stop("'limit' must be greater than zero, supplied <", limit, ">")
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, list_type, start_date, period,
    limit = limit, extended = extended,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
  response <- trakt_get(url)
  response <- as_tibble(response)

  # For this case we *only* get show objects, so we handle that first
  if (type == "shows" & list_type == "popular") {
    response <- unpack_show(response)
  }

  # Unnest show or movie object present only in some methods
  if (has_name(response, "show")) {
    response <- bind_cols(
      response %>% select(-show),
      unpack_show(response$show)
    )
  }

  if (has_name(response, "movie")) {
    response <- bind_cols(
      response %>% select(-movie),
      response$movie %>% select(-ids),
      response$movie$ids
    )
  }

  # Unpack ids – required for extended = "min"
  # This is done last because at this point we can be
  # reasonably certain there's no other problematic list/df columns
  if (has_name(response, "ids")) {
    response <- bind_cols(
      response %>% select(-ids),
      response$ids
    )
  }

  fix_tibble_response(response)
}

# Popular ----

#' Popular media
#'
#' These functions return the popular movies/shows on trakt.tv.
#' @name popular_media
#' @inheritParams trakt_api_common_parameters
#' @inheritParams search_filters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @export
#' @family dynamic lists
#' @examples
#' \dontrun{
#' # Get the most popular German-language movies between 2000 and 2010
#' movies_popular(languages = "de", years = c(2000, 2010))
#' }
movies_popular <- function(limit = 10,
                           extended = c("min", "full"),
                           query = NULL, years = NULL,
                           genres = NULL, languages = NULL,
                           countries = NULL, runtimes = NULL,
                           ratings = NULL, certifications = NULL,
                           networks = NULL, status = NULL) {
  extended <- match.arg(extended)

  trakt_auto_lists(
    list_type = "popular", type = "movies",
    limit = limit, extended = extended,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
}

#' @rdname popular_media
#' @export
shows_popular <- function(limit = 10,
                          extended = c("min", "full"),
                          query = NULL, years = NULL,
                          genres = NULL, languages = NULL,
                          countries = NULL, runtimes = NULL,
                          ratings = NULL, certifications = NULL,
                          networks = NULL, status = NULL) {
  extended <- match.arg(extended)

  trakt_auto_lists(
    list_type = "popular", type = "shows",
    limit = limit, extended = extended,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
}

# Trending ----

#' Trending media
#'
#' These functions return the trending movies/shows on trakt.tv.
#' @name trending_media
#' @inheritParams trakt_api_common_parameters
#' @inheritParams search_filters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @export
#' @family dynamic lists
movies_trending <- function(limit = 10,
                            extended = c("min", "full"),
                            query = NULL, years = NULL,
                            genres = NULL, languages = NULL,
                            countries = NULL, runtimes = NULL,
                            ratings = NULL, certifications = NULL,
                            networks = NULL, status = NULL) {
  extended <- match.arg(extended)

  trakt_auto_lists(
    list_type = "trending", type = "movies",
    limit = limit, extended = extended,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
}

#' @rdname trending_media
#' @export
shows_trending <- function(limit = 10,
                           extended = c("min", "full"),
                           query = NULL, years = NULL,
                           genres = NULL, languages = NULL,
                           countries = NULL, runtimes = NULL,
                           ratings = NULL, certifications = NULL,
                           networks = NULL, status = NULL) {
  extended <- match.arg(extended)

  trakt_auto_lists(
    list_type = "trending", type = "shows",
    limit = limit, extended = extended,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
}

# Anticipated ----

#' Anticipated media
#'
#' These functions return the most anticipated movies/shows on trakt.tv.
#' @name anticipated_media
#' @inheritParams trakt_api_common_parameters
#' @inheritParams search_filters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @export
#' @family dynamic lists
movies_anticipated <- function(limit = 10,
                               extended = c("min", "full"),
                               query = NULL, years = NULL,
                               genres = NULL, languages = NULL,
                               countries = NULL, runtimes = NULL,
                               ratings = NULL, certifications = NULL,
                               networks = NULL, status = NULL) {
  extended <- match.arg(extended)

  trakt_auto_lists(
    list_type = "anticipated", type = "movies",
    limit = limit, extended = extended,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
}

#' @rdname anticipated_media
#' @export
#' @examples
#' \dontrun{
#' # Get 15 the most anticipated upcoming shows on Netflix that air this year
#' current_year <- format(Sys.Date(), "%Y")
#' shows_anticipated(limit = 15, networks = "Netflix", years = current_year)
#' }
shows_anticipated <- function(limit = 10,
                              extended = c("min", "full"),
                              query = NULL, years = NULL,
                              genres = NULL, languages = NULL,
                              countries = NULL, runtimes = NULL,
                              ratings = NULL, certifications = NULL,
                              networks = NULL, status = NULL) {
  extended <- match.arg(extended)

  trakt_auto_lists(
    list_type = "anticipated", type = "shows",
    limit = limit, extended = extended,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
}

# Played ----

#' Most played media
#'
#' These functions return the most played movies/shows on trakt.tv.
#' @name played_media
#' @inheritParams trakt_api_common_parameters
#' @inheritParams search_filters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @export
#' @family dynamic lists
movies_played <- function(limit = 10, extended = c("min", "full"),
                          period = c("weekly", "monthly", "yearly", "all"),
                          query = NULL, years = NULL,
                          genres = NULL, languages = NULL,
                          countries = NULL, runtimes = NULL,
                          ratings = NULL, certifications = NULL,
                          networks = NULL, status = NULL) {
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(
    list_type = "played", type = "movies",
    limit = limit,
    extended = extended, period = period,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
}

#' @rdname played_media
#' @export
shows_played <- function(limit = 10, extended = c("min", "full"),
                         period = c("weekly", "monthly", "yearly", "all"),
                         query = NULL, years = NULL,
                         genres = NULL, languages = NULL,
                         countries = NULL, runtimes = NULL,
                         ratings = NULL, certifications = NULL,
                         networks = NULL, status = NULL) {
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(
    list_type = "played", type = "shows",
    limit = limit,
    extended = extended, period = period,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
}

# Watched ----

#' Most watched media
#'
#' These functions return the most watched movies/shows on trakt.tv.
#' @name watched_media
#' @inheritParams trakt_api_common_parameters
#' @inheritParams search_filters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @export
#' @family dynamic lists
movies_watched <- function(limit = 10, extended = c("min", "full"),
                           period = c("weekly", "monthly", "yearly", "all"),
                           query = NULL, years = NULL,
                           genres = NULL, languages = NULL,
                           countries = NULL, runtimes = NULL,
                           ratings = NULL, certifications = NULL,
                           networks = NULL, status = NULL) {
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(
    list_type = "watched", type = "movies",
    limit = limit,
    extended = extended, period = period,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
}

#' @rdname watched_media
#' @export
shows_watched <- function(limit = 10, extended = c("min", "full"),
                          period = c("weekly", "monthly", "yearly", "all"),
                          query = NULL, years = NULL,
                          genres = NULL, languages = NULL,
                          countries = NULL, runtimes = NULL,
                          ratings = NULL, certifications = NULL,
                          networks = NULL, status = NULL) {
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(
    list_type = "watched", type = "shows",
    limit = limit,
    extended = extended, period = period,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
}

# Collected ----

#' Most collected media
#'
#' These functions return the most collected movies/shows on trakt.tv.
#' @name collected_media
#' @inheritParams trakt_api_common_parameters
#' @inheritParams search_filters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @export
#' @family dynamic lists
movies_collected <- function(limit = 10, extended = c("min", "full"),
                             period = c("weekly", "monthly", "yearly", "all"),
                             query = NULL, years = NULL,
                             genres = NULL, languages = NULL,
                             countries = NULL, runtimes = NULL,
                             ratings = NULL, certifications = NULL,
                             networks = NULL, status = NULL) {
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(
    list_type = "collected", type = "movies",
    limit = limit,
    extended = extended, period = period,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
}

#' @rdname collected_media
#' @export
shows_collected <- function(limit = 10, extended = c("min", "full"),
                            period = c("weekly", "monthly", "yearly", "all"),
                            query = NULL, years = NULL,
                            genres = NULL, languages = NULL,
                            countries = NULL, runtimes = NULL,
                            ratings = NULL, certifications = NULL,
                            networks = NULL, status = NULL) {
  extended <- match.arg(extended)
  period <- match.arg(period)

  trakt_auto_lists(
    list_type = "collected", type = "shows",
    limit = limit,
    extended = extended, period = period,
    query = query, years = years, genres = genres,
    languages = languages, countries = countries, runtimes = runtimes,
    ratings = ratings, certifications = certifications, networks = networks,
    status = status
  )
}

# Updates ----

#' Recently updated media
#'
#' These functions return recently updated movies/shows on trakt.tv.
#' @name updated_media
#' @inheritParams trakt_api_common_parameters
#' @inheritParams search_filters
#' @inheritSection dynamic_lists The Dynamic Lists on trakt.tv
#' @export
#' @family dynamic lists
#' @note `shows_updates` and `movies_updates` do not support filters.
movies_updates <- function(limit = 10, extended = c("min", "full"),
                           start_date = Sys.Date() - 1) {
  extended <- match.arg(extended)
  start_date <- as.character(as.Date(start_date))

  if (is.null(start_date)) {
    start_date <- Sys.Date() - 1
  }

  trakt_auto_lists(
    list_type = "updates", type = "movies",
    limit = limit,
    extended = extended, start_date = start_date
  )
}

#' @rdname updated_media
#' @export
shows_updates <- function(limit = 10, extended = c("min", "full"),
                          start_date = Sys.Date() - 1) {
  extended <- match.arg(extended)
  start_date <- as.character(as.Date(start_date))

  if (is.null(start_date)) {
    start_date <- Sys.Date() - 1
  }

  trakt_auto_lists(
    list_type = "updates", type = "shows",
    limit = limit,
    extended = extended, start_date = start_date
  )
}