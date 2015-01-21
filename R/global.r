### Global data
tbenv <- new.env()

tbenv$tb_prompt_active <- FALSE
tbenv$should_exit <- FALSE
tbenv$continuation <- FALSE

tbenv$warnings <- NULL
tbenv$num_warnings <- 0

tbenv$start_time <- Sys.time()
tbenv$tottime <- 0.0
tbenv$chars <- 0L
tbenv$words <- 0L
tbenv$avgchars <- 0.0
tbenv$avgwords <- 0.0



tb_init_gloabls <- function()
{
  tbenv$tb_prompt_active <- FALSE
  tbenv$should_exit <- FALSE
  tbenv$continuation <- FALSE
  
  tbenv$warnings <- NULL
  tbenv$num_warnings <- 0
  
  tbenv$start_time <- Sys.time()
  tbenv$tottime <- 0.0
  tbenv$chars <- 0L
  tbenv$words <- 0L
  tbenv$avgchars <- 0.0
  tbenv$avgwords <- 0.0
  
  invisible()
}

tb_update_globals <- function(char)
{
  time <- Sys.time()
  tbenv$tottime <- tbenv$tottime + unclass(time - tbenv$start_time)[1]
  tbenv$chars <- tbenv$chars + 1L
  tbenv$avgchars <- tbenv$chars / tbenv$tottime
  tbenv$start_time <- time
  
  if (char == " " || char == "\n")
  {
    tbenv$words <- tbenv$words + 1L
    tbenv$avgwords <- tbenv$words / tbenv$tottime * 60
  }
  
  invisible()
}

showspeed <- function()
{
  avgchars <- tbenv$avgchars
  avgwords <- tbenv$avgwords
  
  cat(paste0("Average # keys per second:  ", avgchars, "\n"))
  cat(paste0("Average time between keypresses:  ", 1 / avgchars, "\n"))
  
  cat(paste0("Average # words per minute:  ", avgwords, "\n\n"))
  
  invisible()
}

restart <- function()
{
  tbenv$start_time <- Sys.time()
  tbenv$tottime <- 0.0
  tbenv$chars <- 0L
  tbenv$avgchars <- 0.0
  tbenv$avgwords <- 0.0
  
  invisible()
}
