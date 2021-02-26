//
// File: quaternionInvert.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "quaternionInvert.h"
#include "getDelta_1D_emxutil.h"

// Function Definitions

//
// Arguments    : const emxArray_real_T *q
//                emxArray_real_T *qInvert
// Return Type  : void
//
void quaternionInvert(const emxArray_real_T *q, emxArray_real_T *qInvert)
{
  emxArray_real_T *varargin_2;
  int loop_ub;
  int i7;
  int i8;
  int result;
  boolean_T empty_non_axis_sizes;
  int b_result;
  int c_result;
  emxArray_real_T *b_q;
  emxInit_real_T(&varargin_2, 2);
  loop_ub = q->size[0];
  i7 = varargin_2->size[0] * varargin_2->size[1];
  varargin_2->size[0] = loop_ub;
  varargin_2->size[1] = 3;
  emxEnsureCapacity_real_T(varargin_2, i7);
  for (i7 = 0; i7 < 3; i7++) {
    for (i8 = 0; i8 < loop_ub; i8++) {
      varargin_2->data[i8 + varargin_2->size[0] * i7] = -q->data[i8 + q->size[0]
        * (1 + i7)];
    }
  }

  i7 = q->size[0];
  if (!(i7 == 0)) {
    result = q->size[0];
  } else if (!(varargin_2->size[0] == 0)) {
    result = varargin_2->size[0];
  } else {
    i7 = q->size[0];
    if (i7 > 0) {
      result = q->size[0];
    } else {
      result = 0;
    }
  }

  empty_non_axis_sizes = (result == 0);
  if (empty_non_axis_sizes) {
    b_result = 1;
  } else {
    i7 = q->size[0];
    if (!(i7 == 0)) {
      b_result = 1;
    } else {
      b_result = 0;
    }
  }

  if (empty_non_axis_sizes || (!(varargin_2->size[0] == 0))) {
    c_result = 3;
  } else {
    c_result = 0;
  }

  emxInit_real_T1(&b_q, 1);
  loop_ub = q->size[0];
  i7 = b_q->size[0];
  b_q->size[0] = loop_ub;
  emxEnsureCapacity_real_T1(b_q, i7);
  for (i7 = 0; i7 < loop_ub; i7++) {
    b_q->data[i7] = q->data[i7];
  }

  i7 = qInvert->size[0] * qInvert->size[1];
  qInvert->size[0] = result;
  qInvert->size[1] = b_result + c_result;
  emxEnsureCapacity_real_T(qInvert, i7);
  for (i7 = 0; i7 < b_result; i7++) {
    for (i8 = 0; i8 < result; i8++) {
      qInvert->data[i8 + qInvert->size[0] * i7] = b_q->data[i8 + result * i7];
    }
  }

  emxFree_real_T(&b_q);
  for (i7 = 0; i7 < c_result; i7++) {
    for (i8 = 0; i8 < result; i8++) {
      qInvert->data[i8 + qInvert->size[0] * (i7 + b_result)] = varargin_2->
        data[i8 + result * i7];
    }
  }

  emxFree_real_T(&varargin_2);
}

//
// File trailer for quaternionInvert.cpp
//
// [EOF]
//
