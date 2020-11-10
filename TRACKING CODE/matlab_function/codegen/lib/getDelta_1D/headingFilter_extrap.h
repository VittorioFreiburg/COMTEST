//
// File: headingFilter_extrap.h
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//
#ifndef HEADINGFILTER_EXTRAP_H
#define HEADINGFILTER_EXTRAP_H

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
extern void headingFilter_extrap(emxArray_real_T *delta, emxArray_real_T *rating,
  const emxArray_real_T *tau_bias, const emxArray_real_T *tau_delta,
  emxArray_real_T *delta_out);

#endif

//
// File trailer for headingFilter_extrap.h
//
// [EOF]
//
