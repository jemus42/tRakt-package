#' Common API parameters
#'
#' These parameters are used extensively throughout this package as they are required
#' for many API methods. Here there are all documented in one place, which is
#' intended to make the individual function documentation more consistent.
#'
#' @name trakt_api_common_parameters
#' @keywords internal
#' @param id `character(1)`: The ID of the item requested. Preferably the
#'   `trakt` ID (e.g. `1429`). Other options are the trakt.tv `slug` (e.g. `"the-wire"`)
#'   or `imdb` ID (e.g. `"tt0306414"`).
#'   Can also be of length greater than 1, in which case the function is called on all
#'   `id` values separately and the result is combined. See
#'   `vignette("finding-things")` for more details.
#' @param extended `character(1)`: Either `"min"` (API default) or `"full"`. The latter
#'   returns more variables and should generally only be used if required.
#'   See `vignette("finding-things")` for more details.
#' @param type `character(1)`: Either `"shows"` or `"movies"`. For season/episode-specific
#'   functions, values `seasons` or `episodes` are also allowed.
#' @param user `character(1)`: Target username (or `slug`). Defaults to
#'   `getOption("trakt_username")`.
#'   Can also be of length greater than 1, in which case the function is called on all
#'   `user` values separately and the result is combined.
#' @param period `character(1) ["weekly"]`: Which period to filter by. Possible values
#'   are `"weekly"`, `"monthly"`, `"yearly"`, `"all"`.
#' @param limit `integer(1) [10L]`: Number of items to return. Must be greater
#'   than `0` and will be coerced via `as.integer()`.
#' @param season,episode `integer(1) [1L]`: The season and eisode number. If longer,
#'   e.g. `1:5`, the function is vectorized and the output will be
#'   combined. This may result in *a lot* of API calls. Use wisely.
#' @param start_date `character(1)`: A date in the past from which
#'   on to count updates. If no date is supplied, the default is to
#'   use yesterday relative to the current date. Value must either
#'   be standard `YYYY-MM-DD` format or an object of class [Date][base::Dates],
#'   which will then be coerced via [as.character()][base::as.character].
#' @param sort `character(1) ["newest"]`: Comment sort order, one of
#'   "newest", "oldest", "likes" or "replies".
#
#' @param query `character(1)`: Search string for titles and descriptions.
#'   For `search_query()` other fields are searched depending on the `type` of media.
#'   See [the API docs](https://trakt.docs.apiary.io/#reference/search/text-query) for a
#'   full reference.
#' @param years `character | integer`: 4-digit year (`2010`) **or** range,
#'   e.g. `"2010-2020"`. Can also be an integer vector of length two which will be
#'   coerced appropriately, e.g. `c(2010, 2020)`.
#' @param genres `character(n)`: Genre  slug(s).
#'   See [`trakt_genres`] for a table of genres.
#'   Multiple values are allowed and will be concatenated.
#' @param languages `character(n)`: Two-letter language code(s).
#'   Also see [`trakt_languages`] for available languages (code and name).
#' @param countries `character(n)`: Two-letter country code(s).
#'   See [`trakt_countries`].
#' @param runtimes `character | integer`: Integer range in minutes, e.g. `30-90`.
#'   Can also be an integer vector of length two which will be coerced appropriately.
#' @param ratings `character | integer`:  Integer range between `0` and `100`.
#'   Can also be an integer vector of length two which will be coerced appropriately.
#'   Note that user-supplied ratings are in the range of 1 to 10, yet the ratings
#'   on the site itself are scaled to the range of 1 to 100.
#' @param certifications `character(n)`: Certification(s) like `pg-13`.
#'   Multiple values are allowed. Use [`trakt_certifications`] for reference.
#'   Note that there are different certifications for shows and movies.
#' @param networks `character(n)`: (Shows only) Network name like `HBO`.
#'   See [`trakt_networks`] for a list of known networks.
#' @param status `character(n)`: (Shows only) The status of the shows.
#'   One of `"returning series"`, `"in production"`, `"planned"`,
#'   `"canceled"`, or `"ended"`.
#'
#' @return A [tibble()][tibble::tibble-package]. If the function has a `limit` parameter
#'   (defaulting to `10`), this will be the (maximum) number of rows of the `tibble`.
#'   If there are no results (or the API is unreachable), an empty `tibble()` is returned.
NULL
