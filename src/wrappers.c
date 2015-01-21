/* This Source Code Form is subject to the terms of the BSD 2-Clause
 * License. If a copy of the this license was not distributed with this
 * file, you can obtain one from http://opensource.org/licenses/BSD-2-Clause. */

// Copyright 2014-2015, Schmidt

#include <stdlib.h>
#include <string.h>

#include <R.h>
#include <Rinternals.h>

#include "kbhit.h"

#define STR(x,i) ((char*)CHAR(STRING_ELT(x,i)))



SEXP R_getchar()
{
  SEXP ret;
  PROTECT(ret = allocVector(STRSXP, 1));
  
  char val[2];
  val[1] = '\0';
  
  changemode(1);
  
  val[0] = (char) getchar();
  SET_STRING_ELT(ret, 0, mkChar(val));
  
  changemode(0);
  
  UNPROTECT(1);
  return ret;
}

