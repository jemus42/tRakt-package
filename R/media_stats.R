#' Get a show or movie's (or season's or episode's) stats
#'
#' The data contains watchers, playes, collectors, comments, lists, and votes.
#'
#' @inheritParams trakt_api_common_parameters
#' @inherit trakt_api_common_parameters return
#' @name media_stats
#' @examples
#' # Stats for a movie
#' movies_stats("inception-2010")
#' \dontrun{
#' # Stats for multiple shows at once
#' shows_stats(c("breaking-bad", "game-of-thrones"))
#'
#' # Stats for multiple episodes
#' episodes_stats("futurama", season = 1, episode = 1:7)
#' }
NULL

#' @keywords internal
#' @noRd
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
media_stats <- function(type = c("shows", "movies"), id) {
  type <- match.arg(type)

  if (length(id) > 1) {
    return(map_df(id, ~ media_stats(type, .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url(type, id, "stats")
  response <- trakt_get(url = url)
  response$type <- type
  response$id <- id

  as_tibble(response)
}

# Derived ----

#' @rdname media_stats
#' @eval apiurl("shows", "stats")
#' @family show data
#' @export
shows_stats <- function(id) {
  media_stats(type = "shows", id)
}

#' @rdname media_stats
#' @eval apiurl("movies", "stats")
#' @family movie data
#' @export
movies_stats <- function(id) {
  media_stats(type = "movies", id)
}

#' @rdname media_stats
#' @eval apiurl("seasons", "stats")
#' @family season data
#' @export
#' @importFrom purrr map_df
seasons_stats <- function(id, season = 1L) {
  if (length(id) > 1) {
    return(map_df(id, ~ seasons_stats(.x, season)))
  }

  if (length(season) > 1) {
    return(map_df(season, ~ seasons_stats(id, .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", id, "seasons", season, "stats")
  response <- trakt_get(url = url)
  response$season <- season
  response$id <- id

  as_tibble(response)
}

#' @rdname media_stats
#' @eval apiurl("episodes", "stats")
#' @family episode data
#' @export
#' @importFrom purrr map_df
episodes_stats <- function(id, season = 1L, episode = 1L) {
  if (length(id) > 1) {
    return(map_df(id, ~ episodes_stats(.x, season, episode)))
  }

  if (length(season) > 1) {
    return(map_df(season, ~ episodes_stats(id, .x, episode)))
  }

  if (length(episode) > 1) {
    return(map_df(episode, ~ episodes_stats(id, season, .x)))
  }

  # Construct URL, make API call
  url <- build_trakt_url("shows", id, "seasons", season, "episodes", episode, "stats")
  response <- trakt_get(url = url)
  response$season <- season
  response$episode <- episode
  response$id <- id

  as_tibble(response)
}
