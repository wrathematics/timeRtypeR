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
tbenv$avg <- Inf



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
  tbenv$avg <- Inf
  
  invisible()
}

tb_update_globals <- function()
{
  time <- Sys.time()
  tbenv$tottime <- tbenv$tottime + unclass(time - tbenv$start_time)[1]
  tbenv$chars <- tbenv$chars + 1L
  tbenv$avg <- tbenv$chars / tbenv$tottime
  tbenv$start_time <- time
  
  invisible()
}

showspeed <- function()
{
  tbenv$avg
}

restart <- function()
{
  tbenv$start_time <- Sys.time()
  tbenv$tottime <- 0.0
  tbenv$chars <- 0L
  tbenv$avg <- Inf
  
  invisible()
}
