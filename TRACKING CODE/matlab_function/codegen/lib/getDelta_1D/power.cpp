//
// File: power.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "power.h"
#include "getDelta_1D_emxutil.h"

// Function Definitions

//
// Arguments    : const emxArray_real_T *a
//                emxArray_real_T *y
// Return Type  : void
//
void power(const emxArray_real_T *a, emxArray_real_T *y)
{
  unsigned int a_idx_0;
  unsigned int b_a_idx_0;
  int k;
  a_idx_0 = (unsigned int)a->size[0];
  b_a_idx_0 = (unsigned int)a->size[0];
  k = y->size[0];
  y->size[0] = (int)b_a_idx_0;
  emxEnsureCapacity_real_T1(y, k);
  for (k = 0; k + 1 <= (int)a_idx_0; k++) {
    y->data[k] = a->data[k] * a->data[k];
  }
}

//
// File trailer for power.cpp
//
// [EOF]
//
