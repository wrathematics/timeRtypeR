#  Copyright (C) 2015 Drew Schmidt. All rights reserved.
#  
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#  
#    * Redistributions of source code must retain the above copyright notice, 
#      this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice,
#      this list of conditions and the following disclaimer in the documentation
#      and/or other materials provided with the distribution.
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
#  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


### As usual, Martin Morgan is quite helpful: https://stackoverflow.com/questions/4948361/how-do-i-save-warnings-and-errors-as-output-from-a-function



tb_readline <- function(input, continuation)
{
  if (continuation)
    prompt <- "+ "
  else
    prompt <- "> "
  
  cat(prompt)
  
  buffer <- character(0)
  char <- ""
  
  while (char != "\n")
  {
    char <- getchar()
    cat(char)
    buffer <- c(buffer, char)
    
    tb_update_globals()
  }
  
#  ret <- c(input, readline(prompt=prompt))
  ret <- paste0(c(input, buffer), collapse="")
  ret <- tb_sanitize(inputs=ret)
  
  return(ret)
}



tb_sanitize <- function(inputs)
{
  for (i in 1:length(inputs))
  {
    input <- inputs[i]
    if (grepl(x=input, pattern="(^q\\(|^quit\\()", perl=TRUE)) 
      inputs[i] <- "timebetween:::tb_exit()"
  }
  
  return(inputs)
}



is.error <- function(obj)
{
  if (inherits(obj, "try-error") || inherits(obj, "error"))
    return(TRUE)
  else
    return(FALSE)
}



tb_repl_printer <- function(ret)
{
  if (!is.null(tbenv$visible))
  {
    if (tbenv$visible$visible)
      print(tbenv$visible$value)
    
    if (tbenv$num_warnings > 0)
    {
      if (tbenv$num_warnings > 10)
        cat(paste("There were", tbenv$num_warnings, "warnings (use warnings() to see them)\n"))
      else
        print(warnings())
    }
  }
  
  return(invisible())
}



tb_interrupt <- function(x)
{
  tbenv$tb_prompt_active <- FALSE
  cat("interrupt\n")
  print(x)
}



tb_warning <- function(warn)
{
  tbenv$num_warnings <- tbenv$num_warnings + 1
  
  append(tbenv$warnings, conditionMessage(warn))
  invokeRestart("muffleWarning")
  print(warn)
}



tb_error <- function(err)
{
  msg <- err$message
  tbenv$continuation <- grepl(msg, pattern="unexpected end of input")
  
  if (!tbenv$continuation)
  {
    msg <- sub(x=msg, pattern=" in eval\\(expr, envir, enclos\\) ", replacement="")
    cat(paste0("Error: ", msg, "\n"))
  }
  
  return(invisible())
}



tb_eval <- function(input, whoami, env)
{
  tbenv$continuation <- FALSE
  
  ret <- withCallingHandlers(
    tryCatch({
        tbenv$visible <- withVisible(eval(parse(text=input), envir=env))
      }, interrupt=tb_interrupt, error=tb_error
    ), warning=tb_warning
  )
  
  return(ret)
}



tb_exit <- function()
{
  tbenv$should_exit <- TRUE
  
  return(invisible())
}



tb_repl <- function(env=sys.parent())
{
  ### error checking
  if (!interactive())
  {
    stop("You should only use this interactively")
  }
  
  tb_init_gloabls()
  
  if (!tbenv$tb_prompt_active)
    tbenv$tb_prompt_active <- TRUE
  else
  {
    cat("The pbd repl is already running!\n")
    return(invisible())
  }
  
  
  ### the repl
  while (TRUE)
  {
    input <- character(0)
    tbenv$continuation <- FALSE
    
    while (TRUE)
    {
      tbenv$visible <- withVisible(invisible())
      input <- tb_readline(input=input, continuation=tbenv$continuation)
      
      ret <- tb_eval(input=input, whoami=tbenv$whoami, env=env)
      
      if (tbenv$continuation) next
      
      ### handle printing
      tb_repl_printer(ret)
      
      ### Should go after all other evals and handlers
      if (tbenv$should_exit)
      {
        tbenv$tb_prompt_active <- tbenv$should_exit <- FALSE
        return(invisible())
      }
      
      break
    }
  }
  
  tbenv$tb_prompt_active <- tbenv$should_exit <- FALSE
  return(invisible())
}



timebetween <- tb_repl
