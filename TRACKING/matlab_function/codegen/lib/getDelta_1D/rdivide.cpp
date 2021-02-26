//
// File: rdivide.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "rdivide.h"
#include "getDelta_1D_emxutil.h"

// Function Definitions

//
// Arguments    : const emxArray_real_T *y
//                emxArray_real_T *z
// Return Type  : void
//
void rdivide(const emxArray_real_T *y, emxArray_real_T *z)
{
  int i13;
  int loop_ub;
  i13 = z->size[0] * z->size[1];
  z->size[0] = 1;
  z->size[1] = y->size[1];
  emxEnsureCapacity_real_T(z, i13);
  loop_ub = y->size[0] * y->size[1];
  for (i13 = 0; i13 < loop_ub; i13++) {
    z->data[i13] = -0.69314718055994529 / y->data[i13];
  }
}

//
// File trailer for rdivide.cpp
//
// [EOF]
//
