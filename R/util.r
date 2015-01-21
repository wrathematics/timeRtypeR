is.error <- function(obj)
{
  if (inherits(obj, "try-error") || inherits(obj, "error"))
    return(TRUE)
  else
    return(FALSE)
}



clear <- function()
{
  platform <- .Platform$OS.type
  gui <- .Platform$GUI
  
  if (gui == "RStudio" || platform == "Windows")
    cat("\014")
  else if (platform == "unix")
    system("clear")
  else # what the hell platform are you using?
    cat(rep("\n", 100))
  
  invisible()
}
