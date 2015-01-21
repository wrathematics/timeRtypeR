# timebetween

Ever wanted to know


However, this is just a toy, and have some important caveats:

1. This will not work in RStudio.  RStudio has its own way of reading
   input, and this package will break it, **requiring you to restart
   your RStudio session if you run it**.  The other R gui's (R.app,
   that disgusting monster Rgui that ships on Windows, etc.) will 
   probably break as well.  You have to use this from a terminal.

2. This breaks basically everything nice about the R terminal:  
   tab-completion, pasting, the ability to backspace, etc.

3. If your (natural) language has non-ascii characters (just about
   anything other than English), this will probably break.



## How It Works

For a toy, it's a pretty darn complicated one.  I wrote a custom REPL
to handle the "hijacking" of the R interpreter.  Each time you press a
key on your keyboard, instead of being handled by the R terminal buffer,
it's managed in a convoluted way that allows me to store the time between
key presses as well as the total number of key presses.

The first step is to be able to read keyboard input one character at
a time.  Unfortunately, this excludes `readline()` and `readLines()`.
So basically you have to write your own.
