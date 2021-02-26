//
// File: quaternionRotate.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "quaternionRotate.h"
#include "getDelta_1D_emxutil.h"
#include "quaternionMultiply.h"
#include "quaternionInvert.h"

// Function Definitions

//
// This function will rotate the vectors v (1x3 or Nx3) by the quaternions
//  q (1x4 or Nx4)
//  Result: q * [0,v] * q'
//  The result will always be a vector (Nx3)
// Arguments    : const emxArray_real_T *q
//                const double vec[3]
//                emxArray_real_T *v
// Return Type  : void
//
void quaternionRotate(const emxArray_real_T *q, const double vec[3],
                      emxArray_real_T *v)
{
  emxArray_real_T *qInv;
  double dv1[4];
  int i10;
  emxArray_real_T *q1;
  int shape;
  emxArray_real_T *qv;
  int i11;
  emxInit_real_T(&qInv, 2);
  quaternionInvert(q, qInv);
  dv1[0] = 0.0;
  for (i10 = 0; i10 < 3; i10++) {
    dv1[i10 + 1] = vec[i10];
  }

  emxInit_real_T(&q1, 2);
  quaternionMultiply(q, dv1, q1);
  if (q1->size[0] == qInv->size[0]) {
    shape = q1->size[0];
  } else if (q1->size[0] == 1) {
    shape = qInv->size[0];
  } else {
    if (qInv->size[0] == 1) {
      shape = q1->size[0];
    }
  }

  emxInit_real_T(&qv, 2);
  i10 = qv->size[0] * qv->size[1];
  qv->size[0] = shape;
  qv->size[1] = 4;
  emxEnsureCapacity_real_T(qv, i10);
  shape <<= 2;
  for (i10 = 0; i10 < shape; i10++) {
    qv->data[i10] = 0.0;
  }

  shape = q1->size[0] - 1;
  for (i10 = 0; i10 <= shape; i10++) {
    qv->data[i10] = ((q1->data[i10] * qInv->data[i10] - q1->data[i10 + q1->size
                      [0]] * qInv->data[i10 + qInv->size[0]]) - q1->data[i10 +
                     (q1->size[0] << 1)] * qInv->data[i10 + (qInv->size[0] << 1)])
      - q1->data[i10 + q1->size[0] * 3] * qInv->data[i10 + qInv->size[0] * 3];
  }

  shape = q1->size[0] - 1;
  for (i10 = 0; i10 <= shape; i10++) {
    qv->data[i10 + qv->size[0]] = ((q1->data[i10] * qInv->data[i10 + qInv->size
      [0]] + q1->data[i10 + q1->size[0]] * qInv->data[i10]) + q1->data[i10 +
      (q1->size[0] << 1)] * qInv->data[i10 + qInv->size[0] * 3]) - q1->data[i10
      + q1->size[0] * 3] * qInv->data[i10 + (qInv->size[0] << 1)];
  }

  shape = q1->size[0] - 1;
  for (i10 = 0; i10 <= shape; i10++) {
    qv->data[i10 + (qv->size[0] << 1)] = ((q1->data[i10] * qInv->data[i10 +
      (qInv->size[0] << 1)] - q1->data[i10 + q1->size[0]] * qInv->data[i10 +
      qInv->size[0] * 3]) + q1->data[i10 + (q1->size[0] << 1)] * qInv->data[i10])
      + q1->data[i10 + q1->size[0] * 3] * qInv->data[i10 + qInv->size[0]];
  }

  shape = q1->size[0] - 1;
  for (i10 = 0; i10 <= shape; i10++) {
    qv->data[i10 + qv->size[0] * 3] = ((q1->data[i10] * qInv->data[i10 +
      qInv->size[0] * 3] + q1->data[i10 + q1->size[0]] * qInv->data[i10 +
      (qInv->size[0] << 1)]) - q1->data[i10 + (q1->size[0] << 1)] * qInv->
      data[i10 + qInv->size[0]]) + q1->data[i10 + q1->size[0] * 3] * qInv->
      data[i10];
  }

  emxFree_real_T(&q1);
  emxFree_real_T(&qInv);
  shape = qv->size[0];
  i10 = v->size[0] * v->size[1];
  v->size[0] = shape;
  v->size[1] = 3;
  emxEnsureCapacity_real_T(v, i10);
  for (i10 = 0; i10 < 3; i10++) {
    for (i11 = 0; i11 < shape; i11++) {
      v->data[i11 + v->size[0] * i10] = qv->data[i11 + qv->size[0] * (1 + i10)];
    }
  }

  emxFree_real_T(&qv);
}

//
// File trailer for quaternionRotate.cpp
//
// [EOF]
//
