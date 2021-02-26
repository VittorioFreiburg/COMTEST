//
// File: quaternionMultiply.h
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//
#ifndef QUATERNIONMULTIPLY_H
#define QUATERNIONMULTIPLY_H

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
extern void b_quaternionMultiply(const emxArray_real_T *q1, const double q2[4],
  emxArray_real_T *q3);
extern void quaternionMultiply(const emxArray_real_T *q1, const double q2[4],
  emxArray_real_T *q3);

#endif

//
// File trailer for quaternionMultiply.h
//
// [EOF]
//
