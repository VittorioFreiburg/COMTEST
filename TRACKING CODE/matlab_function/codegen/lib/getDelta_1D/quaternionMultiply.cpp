//
// File: quaternionMultiply.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "quaternionMultiply.h"
#include "getDelta_1D_emxutil.h"

// Function Definitions

//
// Arguments    : const emxArray_real_T *q1
//                const double q2[4]
//                emxArray_real_T *q3
// Return Type  : void
//
void b_quaternionMultiply(const emxArray_real_T *q1, const double q2[4],
  emxArray_real_T *q3)
{
  int shape;
  int i9;
  if (q1->size[0] == 1) {
    shape = 1;
  } else if (q1->size[0] == 1) {
    shape = 1;
  } else {
    shape = q1->size[0];
  }

  i9 = q3->size[0] * q3->size[1];
  q3->size[0] = shape;
  q3->size[1] = 4;
  emxEnsureCapacity_real_T(q3, i9);
  shape <<= 2;
  for (i9 = 0; i9 < shape; i9++) {
    q3->data[i9] = 0.0;
  }

  shape = q1->size[0] - 1;
  for (i9 = 0; i9 <= shape; i9++) {
    q3->data[i9] = ((q1->data[i9] * q2[0] - q1->data[i9 + q1->size[0]] * q2[1])
                    - q1->data[i9 + (q1->size[0] << 1)] * q2[2]) - q1->data[i9 +
      q1->size[0] * 3] * q2[3];
  }

  shape = q1->size[0] - 1;
  for (i9 = 0; i9 <= shape; i9++) {
    q3->data[i9 + q3->size[0]] = ((q1->data[i9] * q2[1] + q1->data[i9 + q1->
      size[0]] * q2[0]) + q1->data[i9 + (q1->size[0] << 1)] * q2[3]) - q1->
      data[i9 + q1->size[0] * 3] * q2[2];
  }

  shape = q1->size[0] - 1;
  for (i9 = 0; i9 <= shape; i9++) {
    q3->data[i9 + (q3->size[0] << 1)] = ((q1->data[i9] * q2[2] - q1->data[i9 +
      q1->size[0]] * q2[3]) + q1->data[i9 + (q1->size[0] << 1)] * q2[0]) +
      q1->data[i9 + q1->size[0] * 3] * q2[1];
  }

  shape = q1->size[0] - 1;
  for (i9 = 0; i9 <= shape; i9++) {
    q3->data[i9 + q3->size[0] * 3] = ((q1->data[i9] * q2[3] + q1->data[i9 +
      q1->size[0]] * q2[2]) - q1->data[i9 + (q1->size[0] << 1)] * q2[1]) +
      q1->data[i9 + q1->size[0] * 3] * q2[0];
  }
}

//
// Arguments    : const emxArray_real_T *q1
//                const double q2[4]
//                emxArray_real_T *q3
// Return Type  : void
//
void quaternionMultiply(const emxArray_real_T *q1, const double q2[4],
  emxArray_real_T *q3)
{
  int shape;
  int i6;
  if (q1->size[0] == 1) {
    shape = 1;
  } else if (q1->size[0] == 1) {
    shape = 1;
  } else {
    shape = q1->size[0];
  }

  i6 = q3->size[0] * q3->size[1];
  q3->size[0] = shape;
  q3->size[1] = 4;
  emxEnsureCapacity_real_T(q3, i6);
  shape <<= 2;
  for (i6 = 0; i6 < shape; i6++) {
    q3->data[i6] = 0.0;
  }

  shape = q1->size[0] - 1;
  for (i6 = 0; i6 <= shape; i6++) {
    q3->data[i6] = ((q1->data[i6] * q2[0] - q1->data[i6 + q1->size[0]] * q2[1])
                    - q1->data[i6 + (q1->size[0] << 1)] * q2[2]) - q1->data[i6 +
      q1->size[0] * 3] * q2[3];
  }

  shape = q1->size[0] - 1;
  for (i6 = 0; i6 <= shape; i6++) {
    q3->data[i6 + q3->size[0]] = ((q1->data[i6] * q2[1] + q1->data[i6 + q1->
      size[0]] * q2[0]) + q1->data[i6 + (q1->size[0] << 1)] * q2[3]) - q1->
      data[i6 + q1->size[0] * 3] * q2[2];
  }

  shape = q1->size[0] - 1;
  for (i6 = 0; i6 <= shape; i6++) {
    q3->data[i6 + (q3->size[0] << 1)] = ((q1->data[i6] * q2[2] - q1->data[i6 +
      q1->size[0]] * q2[3]) + q1->data[i6 + (q1->size[0] << 1)] * q2[0]) +
      q1->data[i6 + q1->size[0] * 3] * q2[1];
  }

  shape = q1->size[0] - 1;
  for (i6 = 0; i6 <= shape; i6++) {
    q3->data[i6 + q3->size[0] * 3] = ((q1->data[i6] * q2[3] + q1->data[i6 +
      q1->size[0]] * q2[2]) - q1->data[i6 + (q1->size[0] << 1)] * q2[1]) +
      q1->data[i6 + q1->size[0] * 3] * q2[0];
  }
}

//
// File trailer for quaternionMultiply.cpp
//
// [EOF]
//
