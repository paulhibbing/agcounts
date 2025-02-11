.get_timestamps <- function(raw, epoch, frequency, tz) {

  start <-
    attr(raw, "start_time") %>%
    lubridate::force_tz(tz)

  end <- .last_complete_epoch(raw, epoch, frequency, tz)

  list(
    start = start,
    end = end,
    timestamps = seq(start, end, epoch)
  )

}


.last_complete_epoch <- function(raw, epoch, frequency, tz) {

  samples_per_epoch <- frequency * epoch

  utils::tail(raw$time, samples_per_epoch * 3) %>%
  lubridate::floor_date(paste(epoch, "sec")) %>%
  as.character(.) %>%
  rle(.) %>%
  {.$values[max(which(.$lengths == samples_per_epoch))]} %>%
  as.POSIXct(tz) %>%
  {. + epoch - 0.001} %>%
  lubridate::force_tz(tz)

}
