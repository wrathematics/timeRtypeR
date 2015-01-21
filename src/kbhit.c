/* This Source Code Form is subject to the terms of the BSD 2-Clause
 * License. If a copy of the this license was not distributed with this
 * file, you can obtain one from http://opensource.org/licenses/BSD-2-Clause. */

// Copyright 2014, Schmidt

#if OS_WINDOWS

#include <conio.h>

#else

#include <termios.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/time.h>
#include <stdio.h>


void changemode(int dir)
{
  static struct termios oldt, newt;

  if (dir == 1)
  {
    tcgetattr(STDIN_FILENO, &oldt);
    
    newt = oldt;
    
    newt.c_lflag &= ~(ICANON | ECHO);
    
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
  }
  else
    tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
  
}

int getch() 
{
  int ch;
  
  changemode(1);
  
  ch = getchar();
  
  changemode(0);
  
  return ch;
}


int kbhit()
{
  struct timeval tv;
  fd_set rdfs;
  
  tv.tv_sec = 0;
  tv.tv_usec = 0;
  
  FD_ZERO(&rdfs);
  FD_SET (STDIN_FILENO, &rdfs);
  
  select(STDIN_FILENO+1, &rdfs, NULL, NULL, &tv);
  
  return FD_ISSET(STDIN_FILENO, &rdfs);
}


#endif
