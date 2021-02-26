//
// File: getErrorAndJac_1D.h
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//
#ifndef GETERRORANDJAC_1D_H
#define GETERRORANDJAC_1D_H

// Include Files
#include <float.h>
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rt_defines.h"
#include "rt_nonfinite.h"
#include "rtwtypes.h"
#include "getDelta_1D_types.h"

// Function Declarations
extern void cost_euler1D(double delta, const emxArray_real_T *q1, const
  emxArray_real_T *q2, const double j[3], emxArray_real_T *error);

#endif

//
// File trailer for getErrorAndJac_1D.h
//
// [EOF]
//
