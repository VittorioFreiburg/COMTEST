//
// File: getErrorAndJac_1D.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "getErrorAndJac_1D.h"
#include "getDelta_1D_emxutil.h"
#include "sqrt.h"
#include "power.h"
#include "quaternionRotate.h"
#include "atan2.h"
#include "quaternionMultiply.h"
#include "getQuat.h"
#include "quaternionInvert.h"

// Function Definitions

//
// Arguments    : double delta
//                const emxArray_real_T *q1
//                const emxArray_real_T *q2
//                const double j[3]
//                emxArray_real_T *error
// Return Type  : void
//
void cost_euler1D(double delta, const emxArray_real_T *q1, const emxArray_real_T
                  *q2, const double j[3], emxArray_real_T *error)
{
  double xtmp;
  int m;
  emxArray_real_T *q_b1_e1;
  static const signed char iv1[3] = { 0, 0, 1 };

  emxArray_real_T *q_b2_e2;
  emxArray_real_T *r1;
  double a[3];
  double q_rot[4];
  double dv0[4];
  static const signed char b_a[3] = { 0, 0, 1 };

  int shape;
  emxArray_real_T *q_b2_b1;
  emxArray_real_T *angles;
  unsigned int unnamed_idx_0;
  emxArray_real_T *b_q_b2_b1;
  emxArray_real_T *out;
  emxArray_real_T *minval;
  emxArray_real_T *r2;
  emxArray_real_T *r3;
  emxArray_real_T *r4;
  unsigned int out_idx_0;
  int angles_idx_0;
  emxArray_real_T *v2;

  //  cost_euler1D
  xtmp = 0.0;
  for (m = 0; m < 3; m++) {
    xtmp += (double)iv1[m] * j[m];
  }

  emxInit_real_T(&q_b1_e1, 2);
  emxInit_real_T(&q_b2_e2, 2);
  emxInit_real_T(&r1, 2);
  a[0] = 0.0 * j[2] - j[1];
  a[1] = j[0] - 0.0 * j[2];
  a[2] = 0.0 * j[1] - 0.0 * j[0];
  getQuat(acos(xtmp), a, q_rot);
  quaternionMultiply(q1, q_rot, q_b1_e1);
  quaternionMultiply(q2, q_rot, q_b2_e2);
  quaternionInvert(q_b1_e1, r1);
  for (m = 0; m < 3; m++) {
    a[m] = b_a[m];
  }

  getQuat(delta, a, dv0);
  b_quaternionMultiply(r1, dv0, q_b1_e1);
  emxFree_real_T(&r1);
  if (q_b1_e1->size[0] == q_b2_e2->size[0]) {
    shape = q_b1_e1->size[0];
  } else if (q_b1_e1->size[0] == 1) {
    shape = q_b2_e2->size[0];
  } else {
    if (q_b2_e2->size[0] == 1) {
      shape = q_b1_e1->size[0];
    }
  }

  emxInit_real_T(&q_b2_b1, 2);
  m = q_b2_b1->size[0] * q_b2_b1->size[1];
  q_b2_b1->size[0] = shape;
  q_b2_b1->size[1] = 4;
  emxEnsureCapacity_real_T(q_b2_b1, m);
  shape <<= 2;
  for (m = 0; m < shape; m++) {
    q_b2_b1->data[m] = 0.0;
  }

  shape = q_b1_e1->size[0] - 1;
  for (m = 0; m <= shape; m++) {
    q_b2_b1->data[m] = ((q_b1_e1->data[m] * q_b2_e2->data[m] - q_b1_e1->data[m +
                         q_b1_e1->size[0]] * q_b2_e2->data[m + q_b2_e2->size[0]])
                        - q_b1_e1->data[m + (q_b1_e1->size[0] << 1)] *
                        q_b2_e2->data[m + (q_b2_e2->size[0] << 1)]) -
      q_b1_e1->data[m + q_b1_e1->size[0] * 3] * q_b2_e2->data[m + q_b2_e2->size
      [0] * 3];
  }

  shape = q_b1_e1->size[0] - 1;
  for (m = 0; m <= shape; m++) {
    q_b2_b1->data[m + q_b2_b1->size[0]] = ((q_b1_e1->data[m] * q_b2_e2->data[m +
      q_b2_e2->size[0]] + q_b1_e1->data[m + q_b1_e1->size[0]] * q_b2_e2->data[m])
      + q_b1_e1->data[m + (q_b1_e1->size[0] << 1)] * q_b2_e2->data[m +
      q_b2_e2->size[0] * 3]) - q_b1_e1->data[m + q_b1_e1->size[0] * 3] *
      q_b2_e2->data[m + (q_b2_e2->size[0] << 1)];
  }

  shape = q_b1_e1->size[0] - 1;
  for (m = 0; m <= shape; m++) {
    q_b2_b1->data[m + (q_b2_b1->size[0] << 1)] = ((q_b1_e1->data[m] *
      q_b2_e2->data[m + (q_b2_e2->size[0] << 1)] - q_b1_e1->data[m +
      q_b1_e1->size[0]] * q_b2_e2->data[m + q_b2_e2->size[0] * 3]) +
      q_b1_e1->data[m + (q_b1_e1->size[0] << 1)] * q_b2_e2->data[m]) +
      q_b1_e1->data[m + q_b1_e1->size[0] * 3] * q_b2_e2->data[m + q_b2_e2->size
      [0]];
  }

  shape = q_b1_e1->size[0] - 1;
  for (m = 0; m <= shape; m++) {
    q_b2_b1->data[m + q_b2_b1->size[0] * 3] = ((q_b1_e1->data[m] * q_b2_e2->
      data[m + q_b2_e2->size[0] * 3] + q_b1_e1->data[m + q_b1_e1->size[0]] *
      q_b2_e2->data[m + (q_b2_e2->size[0] << 1)]) - q_b1_e1->data[m +
      (q_b1_e1->size[0] << 1)] * q_b2_e2->data[m + q_b2_e2->size[0]]) +
      q_b1_e1->data[m + q_b1_e1->size[0] * 3] * q_b2_e2->data[m];
  }

  emxFree_real_T(&q_b2_e2);
  emxFree_real_T(&q_b1_e1);
  emxInit_real_T(&angles, 2);

  // EULERANGLES Calculates Euler angles from quaternions
  //    convention: Euler angle axis sequence as string, e.g. "zyx".
  //    intrinsic: boolean, if true, intrinsic Euler angles (e.g. z-y'-x'') are
  //    calculated, if false, extrinsic angles (e.g. z-y-x) are calculated.
  //
  //    Author: Daniel Laidig <laidig@control.tu-berlin.de>
  //  sign factor depending on the axis order
  //  anti-cyclic order
  unnamed_idx_0 = (unsigned int)q_b2_b1->size[0];
  m = angles->size[0] * angles->size[1];
  angles->size[0] = (int)unnamed_idx_0;
  angles->size[1] = 3;
  emxEnsureCapacity_real_T(angles, m);
  shape = (int)unnamed_idx_0 * 3;
  for (m = 0; m < shape; m++) {
    angles->data[m] = 0.0;
  }

  emxInit_real_T1(&b_q_b2_b1, 1);

  //  Tait-Bryan
  shape = q_b2_b1->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = q_b2_b1->data[m];
  }

  emxInit_real_T1(&out, 1);
  power(b_q_b2_b1, out);
  shape = q_b2_b1->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = q_b2_b1->data[m + (q_b2_b1->size[0] << 1)];
  }

  emxInit_real_T1(&minval, 1);
  power(b_q_b2_b1, minval);
  shape = q_b2_b1->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = q_b2_b1->data[m + q_b2_b1->size[0]];
  }

  emxInit_real_T1(&r2, 1);
  power(b_q_b2_b1, r2);
  shape = q_b2_b1->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = q_b2_b1->data[m + q_b2_b1->size[0] * 3];
  }

  emxInit_real_T1(&r3, 1);
  emxInit_real_T1(&r4, 1);
  power(b_q_b2_b1, r3);
  shape = q_b2_b1->size[0];
  m = r4->size[0];
  r4->size[0] = shape;
  emxEnsureCapacity_real_T1(r4, m);
  for (m = 0; m < shape; m++) {
    r4->data[m] = 2.0 * (q_b2_b1->data[m + (q_b2_b1->size[0] << 1)] *
                         q_b2_b1->data[m] + -q_b2_b1->data[m + q_b2_b1->size[0]]
                         * q_b2_b1->data[m + q_b2_b1->size[0] * 3]);
  }

  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = out->size[0];
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  shape = out->size[0];
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = ((out->data[m] - minval->data[m]) - r2->data[m]) +
      r3->data[m];
  }

  b_atan2(r4, b_q_b2_b1, r2);
  shape = r2->size[0];
  for (m = 0; m < shape; m++) {
    angles->data[m] = r2->data[m];
  }

  shape = q_b2_b1->size[0];
  m = out->size[0];
  out->size[0] = shape;
  emxEnsureCapacity_real_T1(out, m);
  for (m = 0; m < shape; m++) {
    out->data[m] = 2.0 * (q_b2_b1->data[m + q_b2_b1->size[0]] * q_b2_b1->data[m]
                          - -q_b2_b1->data[m + (q_b2_b1->size[0] << 1)] *
                          q_b2_b1->data[m + q_b2_b1->size[0] * 3]);
  }

  unnamed_idx_0 = (unsigned int)out->size[0];
  out_idx_0 = (unsigned int)out->size[0];
  m = minval->size[0];
  minval->size[0] = (int)out_idx_0;
  emxEnsureCapacity_real_T1(minval, m);
  for (m = 0; m + 1 <= (int)unnamed_idx_0; m++) {
    xtmp = out->data[m];
    if (!(xtmp < 1.0)) {
      xtmp = 1.0;
    }

    minval->data[m] = xtmp;
  }

  unnamed_idx_0 = (unsigned int)minval->size[0];
  out_idx_0 = (unsigned int)minval->size[0];
  m = out->size[0];
  out->size[0] = (int)out_idx_0;
  emxEnsureCapacity_real_T1(out, m);
  for (m = 0; m + 1 <= (int)unnamed_idx_0; m++) {
    if ((-1.0 > minval->data[m]) || rtIsNaN(minval->data[m])) {
      xtmp = -1.0;
    } else {
      xtmp = minval->data[m];
    }

    out->data[m] = xtmp;
  }

  shape = out->size[0];
  for (m = 0; m + 1 <= shape; m++) {
    out->data[m] = asin(out->data[m]);
  }

  shape = out->size[0];
  for (m = 0; m < shape; m++) {
    angles->data[m + angles->size[0]] = out->data[m];
  }

  shape = q_b2_b1->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = q_b2_b1->data[m];
  }

  power(b_q_b2_b1, out);
  shape = q_b2_b1->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = q_b2_b1->data[m + (q_b2_b1->size[0] << 1)];
  }

  power(b_q_b2_b1, minval);
  shape = q_b2_b1->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = q_b2_b1->data[m + q_b2_b1->size[0]];
  }

  power(b_q_b2_b1, r2);
  shape = q_b2_b1->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = q_b2_b1->data[m + q_b2_b1->size[0] * 3];
  }

  power(b_q_b2_b1, r3);
  shape = q_b2_b1->size[0];
  m = r4->size[0];
  r4->size[0] = shape;
  emxEnsureCapacity_real_T1(r4, m);
  for (m = 0; m < shape; m++) {
    r4->data[m] = 2.0 * (-q_b2_b1->data[m + (q_b2_b1->size[0] << 1)] *
                         q_b2_b1->data[m + q_b2_b1->size[0]] + q_b2_b1->data[m +
                         q_b2_b1->size[0] * 3] * q_b2_b1->data[m]);
  }

  emxFree_real_T(&q_b2_b1);
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = out->size[0];
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  shape = out->size[0];
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = ((out->data[m] + minval->data[m]) - r2->data[m]) -
      r3->data[m];
  }

  b_atan2(r4, b_q_b2_b1, r2);
  shape = r2->size[0];
  for (m = 0; m < shape; m++) {
    angles->data[m + (angles->size[0] << 1)] = r2->data[m];
  }

  m = angles->size[0];
  for (shape = 0; shape + 1 <= m; shape++) {
    xtmp = angles->data[shape];
    angles_idx_0 = angles->size[0];
    angles->data[shape] = angles->data[shape + (angles_idx_0 << 1)];
    angles_idx_0 = angles->size[0];
    angles->data[shape + (angles_idx_0 << 1)] = xtmp;
  }

  shape = angles->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = angles->data[m + angles->size[0]];
  }

  power(b_q_b2_b1, out);
  shape = angles->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = angles->data[m + (angles->size[0] << 1)];
  }

  emxInit_real_T(&v2, 2);
  power(b_q_b2_b1, minval);

  //  getWeight
  quaternionRotate(q1, j, angles);
  quaternionRotate(q2, j, v2);
  shape = angles->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = angles->data[m];
  }

  power(b_q_b2_b1, error);
  shape = angles->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = angles->data[m + angles->size[0]];
  }

  emxFree_real_T(&angles);
  power(b_q_b2_b1, r2);
  shape = v2->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = v2->data[m];
  }

  power(b_q_b2_b1, r3);
  shape = v2->size[0];
  m = b_q_b2_b1->size[0];
  b_q_b2_b1->size[0] = shape;
  emxEnsureCapacity_real_T1(b_q_b2_b1, m);
  for (m = 0; m < shape; m++) {
    b_q_b2_b1->data[m] = v2->data[m + v2->size[0]];
  }

  emxFree_real_T(&v2);
  power(b_q_b2_b1, r4);
  m = error->size[0];
  emxEnsureCapacity_real_T1(error, m);
  shape = error->size[0];
  emxFree_real_T(&b_q_b2_b1);
  for (m = 0; m < shape; m++) {
    error->data[m] += r2->data[m];
  }

  emxFree_real_T(&r2);
  b_sqrt(error);
  m = r3->size[0];
  emxEnsureCapacity_real_T1(r3, m);
  shape = r3->size[0];
  for (m = 0; m < shape; m++) {
    r3->data[m] += r4->data[m];
  }

  emxFree_real_T(&r4);
  b_sqrt(r3);
  m = out->size[0];
  emxEnsureCapacity_real_T1(out, m);
  shape = out->size[0];
  for (m = 0; m < shape; m++) {
    out->data[m] += minval->data[m];
  }

  emxFree_real_T(&minval);
  b_sqrt(out);
  m = error->size[0];
  emxEnsureCapacity_real_T1(error, m);
  shape = error->size[0];
  for (m = 0; m < shape; m++) {
    error->data[m] = error->data[m] * r3->data[m] * out->data[m];
  }

  emxFree_real_T(&out);
  emxFree_real_T(&r3);
}

//
// File trailer for getErrorAndJac_1D.cpp
//
// [EOF]
//
