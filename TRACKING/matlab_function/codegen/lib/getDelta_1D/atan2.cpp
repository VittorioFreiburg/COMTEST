//
// File: atan2.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "atan2.h"
#include "getDelta_1D_emxutil.h"

// Function Declarations
static double rt_atan2d_snf(double u0, double u1);

// Function Definitions

//
// Arguments    : double u0
//                double u1
// Return Type  : double
//
static double rt_atan2d_snf(double u0, double u1)
{
  double y;
  int b_u0;
  int b_u1;
  if (rtIsNaN(u0) || rtIsNaN(u1)) {
    y = rtNaN;
  } else if (rtIsInf(u0) && rtIsInf(u1)) {
    if (u0 > 0.0) {
      b_u0 = 1;
    } else {
      b_u0 = -1;
    }

    if (u1 > 0.0) {
      b_u1 = 1;
    } else {
      b_u1 = -1;
    }

    y = atan2((double)b_u0, (double)b_u1);
  } else if (u1 == 0.0) {
    if (u0 > 0.0) {
      y = RT_PI / 2.0;
    } else if (u0 < 0.0) {
      y = -(RT_PI / 2.0);
    } else {
      y = 0.0;
    }
  } else {
    y = atan2(u0, u1);
  }

  return y;
}

//
// Arguments    : const emxArray_real_T *y
//                const emxArray_real_T *x
//                emxArray_real_T *r
// Return Type  : void
//
void b_atan2(const emxArray_real_T *y, const emxArray_real_T *x, emxArray_real_T
             *r)
{
  int c;
  int k;
  if (y->size[0] <= x->size[0]) {
    c = y->size[0];
  } else {
    c = x->size[0];
  }

  k = r->size[0];
  r->size[0] = c;
  emxEnsureCapacity_real_T1(r, k);
  for (k = 0; k + 1 <= c; k++) {
    r->data[k] = rt_atan2d_snf(y->data[k], x->data[k]);
  }
}

//
// File trailer for atan2.cpp
//
// [EOF]
//
