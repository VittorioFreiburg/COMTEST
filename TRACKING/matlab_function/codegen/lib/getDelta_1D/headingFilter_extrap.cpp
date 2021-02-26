//
// File: headingFilter_extrap.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "headingFilter_extrap.h"
#include "getDelta_1D_emxutil.h"
#include "repmat.h"
#include "exp.h"
#include "rdivide.h"
#include "unwrap.h"

// Function Definitions

//
// tau_bias = 8; % tuning parameter: time constant for bias filter %15
//  tau_delta = 15; % tuning parameter: time constant for heading filter %30
// minRating = 0.4; % tuning parameter: extrapolating if rating < minRating
// Arguments    : emxArray_real_T *delta
//                emxArray_real_T *rating
//                const emxArray_real_T *tau_bias
//                const emxArray_real_T *tau_delta
//                emxArray_real_T *delta_out
// Return Type  : void
//
void headingFilter_extrap(emxArray_real_T *delta, emxArray_real_T *rating, const
  emxArray_real_T *tau_bias, const emxArray_real_T *tau_delta, emxArray_real_T
  *delta_out)
{
  emxArray_real_T *out;
  int k_bias;
  int loop_ub;
  emxArray_real_T *bias;
  emxArray_real_T *b_k_bias;
  emxArray_real_T *k_delta;
  emxArray_real_T *k_delta_new;
  emxArray_real_T *k_bias_new;
  double y;
  double angle;
  emxInit_real_T1(&out, 1);
  unwrap(delta);
  k_bias = out->size[0];
  out->size[0] = delta->size[1];
  emxEnsureCapacity_real_T1(out, k_bias);
  loop_ub = delta->size[1];
  for (k_bias = 0; k_bias < loop_ub; k_bias++) {
    out->data[k_bias] = 0.0;
  }

  k_bias = delta_out->size[0];
  delta_out->size[0] = delta->size[1];
  emxEnsureCapacity_real_T1(delta_out, k_bias);
  loop_ub = delta->size[1];
  for (k_bias = 0; k_bias < loop_ub; k_bias++) {
    delta_out->data[k_bias] = 0.0;
  }

  emxInit_real_T1(&bias, 1);
  k_bias = bias->size[0];
  bias->size[0] = delta->size[1];
  emxEnsureCapacity_real_T1(bias, k_bias);
  loop_ub = delta->size[1];
  for (k_bias = 0; k_bias < loop_ub; k_bias++) {
    bias->data[k_bias] = 0.0;
  }

  emxInit_real_T(&b_k_bias, 2);
  rdivide(tau_bias, b_k_bias);
  b_exp(b_k_bias);
  k_bias = b_k_bias->size[0] * b_k_bias->size[1];
  b_k_bias->size[0] = 1;
  emxEnsureCapacity_real_T(b_k_bias, k_bias);
  k_bias = b_k_bias->size[0];
  loop_ub = b_k_bias->size[1];
  loop_ub *= k_bias;
  for (k_bias = 0; k_bias < loop_ub; k_bias++) {
    b_k_bias->data[k_bias] = 1.0 - b_k_bias->data[k_bias];
  }

  emxInit_real_T(&k_delta, 2);
  rdivide(tau_delta, k_delta);
  b_exp(k_delta);
  k_bias = k_delta->size[0] * k_delta->size[1];
  k_delta->size[0] = 1;
  emxEnsureCapacity_real_T(k_delta, k_bias);
  loop_ub = k_delta->size[0];
  k_bias = k_delta->size[1];
  loop_ub *= k_bias;
  for (k_bias = 0; k_bias < loop_ub; k_bias++) {
    k_delta->data[k_bias] = 1.0 - k_delta->data[k_bias];
  }

  emxInit_real_T(&k_delta_new, 2);
  emxInit_real_T(&k_bias_new, 2);

  //  if(length(tau_delta)==1)
  //      k_delta_new = repmat(k_delta,length(rating),1);
  //  end
  //  if(length(tau_bias)==1)
  //      k_bias_new = repmat(k_bias,length(rating),1);
  //  end
  repmat(k_delta, (double)rating->size[1], k_delta_new);
  repmat(b_k_bias, (double)rating->size[1], k_bias_new);
  loop_ub = rating->size[1];
  for (k_bias = 0; k_bias < loop_ub; k_bias++) {
    if (rating->data[k_bias] < 0.45) {
      rating->data[k_bias] = 0.0;
    }
  }

  out->data[0] = delta->data[0];
  for (k_bias = 1; k_bias - 1 < (int)((double)delta->size[1] + -1.0); k_bias++)
  {
    //      bias(i) = bias(i-1) + rating(i) * max(k_bias(i), 1/i) * (wrapToPi(delta(i) - delta(i-1)) - bias(i-1)); 
    if (tau_bias->size[1] == 1) {
      y = 1.0 / (2.0 + (double)(k_bias - 1));
      if ((k_delta_new->data[k_bias] > y) || rtIsNaN(y)) {
        y = k_delta_new->data[k_bias];
      }

      angle = delta->data[k_bias] - delta->data[(int)((2.0 + (double)(k_bias - 1))
        - 1.0) - 1];
      bias->data[k_bias] = bias->data[(int)((2.0 + (double)(k_bias - 1)) - 1.0)
        - 1] + rating->data[k_bias] * y * ((angle - 6.2831853071795862 * floor
        ((angle + 3.1415926535897931) / 6.2831853071795862)) - bias->data[(int)
        ((2.0 + (double)(k_bias - 1)) - 1.0) - 1]);
    } else {
      y = 1.0 / (2.0 + (double)(k_bias - 1));
      if ((b_k_bias->data[k_bias] > y) || rtIsNaN(y)) {
        y = b_k_bias->data[k_bias];
      }

      angle = delta->data[k_bias] - delta->data[(int)((2.0 + (double)(k_bias - 1))
        - 1.0) - 1];
      bias->data[k_bias] = bias->data[(int)((2.0 + (double)(k_bias - 1)) - 1.0)
        - 1] + rating->data[k_bias] * y * ((angle - 6.2831853071795862 * floor
        ((angle + 3.1415926535897931) / 6.2831853071795862)) - bias->data[(int)
        ((2.0 + (double)(k_bias - 1)) - 1.0) - 1]);
    }

    if (tau_delta->size[1] == 1) {
      y = 1.0 / (2.0 + (double)(k_bias - 1));
      if ((k_bias_new->data[k_bias] > y) || rtIsNaN(y)) {
        y = k_bias_new->data[k_bias];
      }

      angle = delta->data[k_bias] - out->data[(int)((2.0 + (double)(k_bias - 1))
        - 1.0) - 1];
      out->data[k_bias] = (out->data[(int)((2.0 + (double)(k_bias - 1)) - 1.0) -
                           1] + bias->data[k_bias]) + rating->data[k_bias] * y *
        ((angle - 6.2831853071795862 * floor((angle + 3.1415926535897931) /
           6.2831853071795862)) - bias->data[k_bias]);
    } else {
      y = 1.0 / (2.0 + (double)(k_bias - 1));
      if ((k_delta->data[k_bias] > y) || rtIsNaN(y)) {
        y = k_delta->data[k_bias];
      }

      angle = delta->data[k_bias] - out->data[(int)((2.0 + (double)(k_bias - 1))
        - 1.0) - 1];
      out->data[k_bias] = (out->data[(int)((2.0 + (double)(k_bias - 1)) - 1.0) -
                           1] + bias->data[k_bias]) + rating->data[k_bias] * y *
        ((angle - 6.2831853071795862 * floor((angle + 3.1415926535897931) /
           6.2831853071795862)) - bias->data[k_bias]);
    }

    delta_out->data[k_bias] = out->data[k_bias] + 5.0 * bias->data[k_bias];
  }

  emxFree_real_T(&bias);
  emxFree_real_T(&k_bias_new);
  emxFree_real_T(&k_delta_new);
  emxFree_real_T(&k_delta);
  emxFree_real_T(&b_k_bias);
  emxFree_real_T(&out);
}

//
// File trailer for headingFilter_extrap.cpp
//
// [EOF]
//
