//
// File: getDelta_1D.h
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//
#ifndef GETDELTA_1D_H
#define GETDELTA_1D_H

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
extern void getDelta_1D(const struct0_T *meta, const struct1_T *data1, const
  struct1_T *data2, const double joint[3], emxArray_real_T *delta,
  emxArray_real_T *delta_filt, emxArray_real_T *r_w, emxArray_real_T *stillness);

#endif

//
// File trailer for getDelta_1D.h
//
// [EOF]
//
