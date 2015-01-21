# timeRtypeR

Ever wanted to know how fast you write R?  Now you can!

Simply install via

```r
library(devtools)
install_github("wrathematics/timeRtypeR")
```

Then run it by executing:

```r
library(timeRtypeR)
timertyper()
```

Then just start typing R commands (or jibberish).  See your timings by
entering the command:

```r
showspeed()
```

You can reset the timings by using the `restart()` command.  You can
exit the repl by executing `q()` or `quit()` (this will not close
the current R session).



### Example

Since this can be difficult to use (see section below), I provide here
a full example of its behavior.

```r
library(timeRtypeR)
> timertyper()
> x <- matrix(rnorm(30), 10)
> sum(x)
[1] 3.67418
> showspeed()
Average # keys per second:		5.894
Average time between keypresses:	0.17
Average # words per minute:		46.129
```



## Important Caveats

This package is really just a toy; it is not meant to be used in anything
approaching a production environment.  Also, a lot of pretty standard
behavior will break.  Notably:

1. This will not work in RStudio.  RStudio has its own way of reading
   keyboard input, and this package will break it, **requiring you to 
   restart your RStudio session if you run it**.  The other R gui's 
   (R.app, that disgusting monster Rgui that ships on Windows, etc.) will 
   almost certainly break as well.  You have to use this from a terminal.

2. This breaks basically everything nice about the R terminal:  
   tab-completion, pasting, the ability to backspace, C-d to exit, etc.

3. If your (natural) language has non-ascii characters (just about
   anything other than English), this will probably break.

4. May not work on Windows at all...



## How It Works

For a toy, it's a pretty darn complicated one.  I wrote a custom REPL
to handle the "hijacking" of the R interpreter.  Each time you press a
key on your keyboard, instead of being handled by the R terminal buffer,
it's managed in a convoluted way that allows me to store the time between
key presses as well as the total number of key presses.

The first step is to be able to read keyboard input one character at
a time.  Unfortunately, this excludes `readline()` and `readLines()`.
So basically you have to write your own.
