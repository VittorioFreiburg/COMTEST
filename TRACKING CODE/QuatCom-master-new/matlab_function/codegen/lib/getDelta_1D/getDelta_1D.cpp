//
// File: getDelta_1D.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "getDelta_1D_emxutil.h"
#include "sqrt.h"
#include "power.h"
#include "quaternionRotate.h"
#include "getErrorAndJac_1D.h"
#include "interp1.h"
#include "unwrap.h"
#include "headingFilter_extrap.h"

// Function Declarations
static void delta_est_window(const emxArray_real_T *q1, const emxArray_real_T
  *q2, const double j[3], double startVal, double *delta, double *cost);
static int div_s32_floor(int numerator, int denominator);
static double getWindowWeight(const emxArray_real_T *q1, const emxArray_real_T
  *q2, const double j[3]);

// Function Definitions

//
// Arguments    : const emxArray_real_T *q1
//                const emxArray_real_T *q2
//                const double j[3]
//                double startVal
//                double *delta
//                double *cost
// Return Type  : void
//
static void delta_est_window(const emxArray_real_T *q1, const emxArray_real_T
  *q2, const double j[3], double startVal, double *delta, double *cost)
{
  emxArray_real_T *errors;
  emxArray_real_T *errors_eps;
  emxArray_real_T *a;
  int i;
  int k;
  int loop_ub;
  double y;
  double b_y;
  double scale;
  double absxk;
  double t;

  //  delta_est_window
  *delta = startVal;
  emxInit_real_T1(&errors, 1);
  emxInit_real_T1(&errors_eps, 1);
  emxInit_real_T(&a, 2);
  for (i = 0; i < 2; i++) {
    //  gnStep
    //  getErrorAndJac_euler1D
    cost_euler1D(*delta, q1, q2, j, errors);
    cost_euler1D(*delta + 1.0E-8, q1, q2, j, errors_eps);
    k = errors_eps->size[0];
    emxEnsureCapacity_real_T1(errors_eps, k);
    loop_ub = errors_eps->size[0];
    for (k = 0; k < loop_ub; k++) {
      errors_eps->data[k] = (errors_eps->data[k] - errors->data[k]) / 1.0E-8;
    }

    k = a->size[0] * a->size[1];
    a->size[0] = 1;
    a->size[1] = errors_eps->size[0];
    emxEnsureCapacity_real_T(a, k);
    loop_ub = errors_eps->size[0];
    for (k = 0; k < loop_ub; k++) {
      a->data[a->size[0] * k] = errors_eps->data[k];
    }

    if ((a->size[1] == 1) || (errors_eps->size[0] == 1)) {
      y = 0.0;
      for (k = 0; k < a->size[1]; k++) {
        y += a->data[a->size[0] * k] * errors_eps->data[k];
      }
    } else {
      y = 0.0;
      for (k = 0; k < a->size[1]; k++) {
        y += a->data[a->size[0] * k] * errors_eps->data[k];
      }
    }

    k = a->size[0] * a->size[1];
    a->size[0] = 1;
    a->size[1] = errors_eps->size[0];
    emxEnsureCapacity_real_T(a, k);
    loop_ub = errors_eps->size[0];
    for (k = 0; k < loop_ub; k++) {
      a->data[a->size[0] * k] = errors_eps->data[k];
    }

    if ((a->size[1] == 1) || (errors->size[0] == 1)) {
      b_y = 0.0;
      for (k = 0; k < a->size[1]; k++) {
        b_y += a->data[a->size[0] * k] * errors->data[k];
      }
    } else {
      b_y = 0.0;
      for (k = 0; k < a->size[1]; k++) {
        b_y += a->data[a->size[0] * k] * errors->data[k];
      }
    }

    if (errors->size[0] == 0) {
      *cost = 0.0;
    } else {
      *cost = 0.0;
      if (errors->size[0] == 1) {
        *cost = fabs(errors->data[0]);
      } else {
        scale = 3.3121686421112381E-170;
        for (k = 1; k <= errors->size[0]; k++) {
          absxk = fabs(errors->data[k - 1]);
          if (absxk > scale) {
            t = scale / absxk;
            *cost = 1.0 + *cost * t * t;
            scale = absxk;
          } else {
            t = absxk / scale;
            *cost += t * t;
          }
        }

        *cost = scale * sqrt(*cost);
      }
    }

    *delta += -(b_y / y);
  }

  emxFree_real_T(&a);
  emxFree_real_T(&errors_eps);
  emxFree_real_T(&errors);
  while (*delta < -3.1415926535897931) {
    *delta += 6.2831853071795862;
  }

  while (*delta > 3.1415926535897931) {
    *delta -= 6.2831853071795862;
  }
}

//
// Arguments    : int numerator
//                int denominator
// Return Type  : int
//
static int div_s32_floor(int numerator, int denominator)
{
  int quotient;
  unsigned int absNumerator;
  unsigned int absDenominator;
  boolean_T quotientNeedsNegation;
  unsigned int tempAbsQuotient;
  if (denominator == 0) {
    if (numerator >= 0) {
      quotient = MAX_int32_T;
    } else {
      quotient = MIN_int32_T;
    }
  } else {
    if (numerator < 0) {
      absNumerator = ~(unsigned int)numerator + 1U;
    } else {
      absNumerator = (unsigned int)numerator;
    }

    if (denominator < 0) {
      absDenominator = ~(unsigned int)denominator + 1U;
    } else {
      absDenominator = (unsigned int)denominator;
    }

    quotientNeedsNegation = ((numerator < 0) != (denominator < 0));
    tempAbsQuotient = absNumerator / absDenominator;
    if (quotientNeedsNegation) {
      absNumerator %= absDenominator;
      if (absNumerator > 0U) {
        tempAbsQuotient++;
      }

      quotient = -(int)tempAbsQuotient;
    } else {
      quotient = (int)tempAbsQuotient;
    }
  }

  return quotient;
}

//
// Arguments    : const emxArray_real_T *q1
//                const emxArray_real_T *q2
//                const double j[3]
// Return Type  : double
//
static double getWindowWeight(const emxArray_real_T *q1, const emxArray_real_T
  *q2, const double j[3])
{
  double out;
  emxArray_real_T *v1;
  emxArray_real_T *v2;
  emxArray_real_T *b_v1;
  int loop_ub;
  int i12;
  emxArray_real_T *weight;
  emxArray_real_T *r5;
  emxArray_real_T *r6;
  emxArray_real_T *r7;
  double y;
  emxInit_real_T(&v1, 2);
  emxInit_real_T(&v2, 2);
  emxInit_real_T1(&b_v1, 1);

  //  getWindowWeight
  quaternionRotate(q1, j, v1);
  quaternionRotate(q2, j, v2);
  loop_ub = v1->size[0];
  i12 = b_v1->size[0];
  b_v1->size[0] = loop_ub;
  emxEnsureCapacity_real_T1(b_v1, i12);
  for (i12 = 0; i12 < loop_ub; i12++) {
    b_v1->data[i12] = v1->data[i12];
  }

  emxInit_real_T1(&weight, 1);
  power(b_v1, weight);
  loop_ub = v1->size[0];
  i12 = b_v1->size[0];
  b_v1->size[0] = loop_ub;
  emxEnsureCapacity_real_T1(b_v1, i12);
  for (i12 = 0; i12 < loop_ub; i12++) {
    b_v1->data[i12] = v1->data[i12 + v1->size[0]];
  }

  emxFree_real_T(&v1);
  emxInit_real_T1(&r5, 1);
  power(b_v1, r5);
  loop_ub = v2->size[0];
  i12 = b_v1->size[0];
  b_v1->size[0] = loop_ub;
  emxEnsureCapacity_real_T1(b_v1, i12);
  for (i12 = 0; i12 < loop_ub; i12++) {
    b_v1->data[i12] = v2->data[i12];
  }

  emxInit_real_T1(&r6, 1);
  power(b_v1, r6);
  loop_ub = v2->size[0];
  i12 = b_v1->size[0];
  b_v1->size[0] = loop_ub;
  emxEnsureCapacity_real_T1(b_v1, i12);
  for (i12 = 0; i12 < loop_ub; i12++) {
    b_v1->data[i12] = v2->data[i12 + v2->size[0]];
  }

  emxFree_real_T(&v2);
  emxInit_real_T1(&r7, 1);
  power(b_v1, r7);
  i12 = weight->size[0];
  emxEnsureCapacity_real_T1(weight, i12);
  loop_ub = weight->size[0];
  emxFree_real_T(&b_v1);
  for (i12 = 0; i12 < loop_ub; i12++) {
    weight->data[i12] += r5->data[i12];
  }

  emxFree_real_T(&r5);
  b_sqrt(weight);
  i12 = r6->size[0];
  emxEnsureCapacity_real_T1(r6, i12);
  loop_ub = r6->size[0];
  for (i12 = 0; i12 < loop_ub; i12++) {
    r6->data[i12] += r7->data[i12];
  }

  emxFree_real_T(&r7);
  b_sqrt(r6);
  i12 = weight->size[0];
  emxEnsureCapacity_real_T1(weight, i12);
  loop_ub = weight->size[0];
  for (i12 = 0; i12 < loop_ub; i12++) {
    weight->data[i12] *= r6->data[i12];
  }

  emxFree_real_T(&r6);
  i12 = weight->size[0];
  emxEnsureCapacity_real_T1(weight, i12);
  loop_ub = weight->size[0];
  for (i12 = 0; i12 < loop_ub; i12++) {
    weight->data[i12] *= weight->data[i12];
  }

  if (weight->size[0] == 0) {
    y = 0.0;
  } else {
    y = weight->data[0];
    for (loop_ub = 2; loop_ub <= weight->size[0]; loop_ub++) {
      y += weight->data[loop_ub - 1];
    }
  }

  y /= (double)weight->size[0];
  out = sqrt(y);
  emxFree_real_T(&weight);
  return out;
}

//
// Params
// Arguments    : const struct0_T *meta
//                const struct1_T *data1
//                const struct1_T *data2
//                const double joint[3]
//                emxArray_real_T *delta
//                emxArray_real_T *delta_filt
//                emxArray_real_T *r_w
//                emxArray_real_T *stillness
// Return Type  : void
//
void getDelta_1D(const struct0_T *meta, const struct1_T *data1, const struct1_T *
                 data2, const double joint[3], emxArray_real_T *delta,
                 emxArray_real_T *delta_filt, emxArray_real_T *r_w,
                 emxArray_real_T *stillness)
{
  double sample_rate;
  double window_steps;
  double data_steps;
  double last_delta_w;
  emxArray_real_T *starts;
  int i0;
  double ndbl;
  double absa;
  double apnd;
  emxArray_real_T *b_stillness;
  double cdiff;
  double regular_estimation_start;
  int absb;
  double b_absb;
  emxArray_real_T *b_r_w;
  int n;
  int k;
  emxArray_real_T *r_w_mod;
  emxArray_real_T *tauDelta_mod;
  emxArray_real_T *tauBias_mod;
  emxArray_real_T *b_delta;
  emxArray_real_T *b_data1;
  emxArray_real_T *b_data2;
  emxArray_real_T *r0;
  boolean_T startup_estimation;
  emxArray_real_T *c_data1;
  int i1;
  int i2;
  int i3;
  int i4;
  int i5;
  emxArray_real_T *b_delta_filt;

  //  s
  //  Hz
  // Hz
  sample_rate = 1.0 / (1.0 / meta->rate);
  window_steps = 10.0 * sample_rate;
  data_steps = 0.2 * sample_rate;

  //  stillness settings
  //  Coordinate System
  //  Preparation
  last_delta_w = 0.0;
  emxInit_real_T(&starts, 2);
  if (rtIsNaN(window_steps + 1.0) || rtIsNaN(sample_rate)) {
    i0 = starts->size[0] * starts->size[1];
    starts->size[0] = 1;
    starts->size[1] = 1;
    emxEnsureCapacity_real_T(starts, i0);
    starts->data[0] = rtNaN;
  } else if ((sample_rate == 0.0) || ((window_steps + 1.0 < (double)data1->
               time->size[0] - 1.0) && (sample_rate < 0.0)) || (((double)
               data1->time->size[0] - 1.0 < window_steps + 1.0) && (sample_rate >
    0.0))) {
    i0 = starts->size[0] * starts->size[1];
    starts->size[0] = 1;
    starts->size[1] = 0;
    emxEnsureCapacity_real_T(starts, i0);
  } else if (rtIsInf(window_steps + 1.0) && (rtIsInf(sample_rate) ||
              (window_steps + 1.0 == (double)data1->time->size[0] - 1.0))) {
    i0 = starts->size[0] * starts->size[1];
    starts->size[0] = 1;
    starts->size[1] = 1;
    emxEnsureCapacity_real_T(starts, i0);
    starts->data[0] = rtNaN;
  } else if (rtIsInf(sample_rate)) {
    i0 = starts->size[0] * starts->size[1];
    starts->size[0] = 1;
    starts->size[1] = 1;
    emxEnsureCapacity_real_T(starts, i0);
    starts->data[0] = window_steps + 1.0;
  } else if ((floor(window_steps + 1.0) == window_steps + 1.0) && (floor
              (sample_rate) == sample_rate)) {
    absa = (double)data1->time->size[0] - 1.0;
    i0 = starts->size[0] * starts->size[1];
    starts->size[0] = 1;
    starts->size[1] = (int)floor((absa - (window_steps + 1.0)) / sample_rate) +
      1;
    emxEnsureCapacity_real_T(starts, i0);
    absb = (int)floor((absa - (window_steps + 1.0)) / sample_rate);
    for (i0 = 0; i0 <= absb; i0++) {
      starts->data[starts->size[0] * i0] = (window_steps + 1.0) + sample_rate *
        (double)i0;
    }
  } else {
    ndbl = floor((((double)data1->time->size[0] - 1.0) - (window_steps + 1.0)) /
                 sample_rate + 0.5);
    apnd = (window_steps + 1.0) + ndbl * sample_rate;
    if (sample_rate > 0.0) {
      cdiff = apnd - ((double)data1->time->size[0] - 1.0);
    } else {
      cdiff = ((double)data1->time->size[0] - 1.0) - apnd;
    }

    absa = fabs(window_steps + 1.0);
    absb = (int)fabs((double)data1->time->size[0] - 1.0);
    b_absb = absb;
    if (absa > b_absb) {
      b_absb = absa;
    }

    if (fabs(cdiff) < 4.4408920985006262E-16 * b_absb) {
      ndbl++;
      apnd = (double)data1->time->size[0] - 1.0;
    } else if (cdiff > 0.0) {
      apnd = (window_steps + 1.0) + (ndbl - 1.0) * sample_rate;
    } else {
      ndbl++;
    }

    if (ndbl >= 0.0) {
      n = (int)ndbl;
    } else {
      n = 0;
    }

    i0 = starts->size[0] * starts->size[1];
    starts->size[0] = 1;
    starts->size[1] = n;
    emxEnsureCapacity_real_T(starts, i0);
    if (n > 0) {
      starts->data[0] = window_steps + 1.0;
      if (n > 1) {
        starts->data[n - 1] = apnd;
        absb = (n - 1) / 2;
        for (k = 1; k < absb; k++) {
          absa = (double)k * sample_rate;
          starts->data[k] = (window_steps + 1.0) + absa;
          starts->data[(n - k) - 1] = apnd - absa;
        }

        if (absb << 1 == n - 1) {
          starts->data[absb] = ((window_steps + 1.0) + apnd) / 2.0;
        } else {
          absa = (double)absb * sample_rate;
          starts->data[absb] = (window_steps + 1.0) + absa;
          starts->data[absb + 1] = apnd - absa;
        }
      }
    }
  }

  emxInit_real_T(&b_stillness, 2);
  regular_estimation_start = starts->data[0];
  absa = starts->data[0] - data_steps;
  if (rtIsNaN(data_steps) || rtIsNaN(absa)) {
    i0 = b_stillness->size[0] * b_stillness->size[1];
    b_stillness->size[0] = 1;
    b_stillness->size[1] = 1;
    emxEnsureCapacity_real_T(b_stillness, i0);
    b_stillness->data[0] = rtNaN;
  } else if ((data_steps == 0.0) || ((1.0 < absa) && (data_steps < 0.0)) ||
             ((absa < 1.0) && (data_steps > 0.0))) {
    i0 = b_stillness->size[0] * b_stillness->size[1];
    b_stillness->size[0] = 1;
    b_stillness->size[1] = 0;
    emxEnsureCapacity_real_T(b_stillness, i0);
  } else if (rtIsInf(absa) && (rtIsInf(data_steps) || (1.0 == absa))) {
    i0 = b_stillness->size[0] * b_stillness->size[1];
    b_stillness->size[0] = 1;
    b_stillness->size[1] = 1;
    emxEnsureCapacity_real_T(b_stillness, i0);
    b_stillness->data[0] = rtNaN;
  } else if (rtIsInf(data_steps)) {
    i0 = b_stillness->size[0] * b_stillness->size[1];
    b_stillness->size[0] = 1;
    b_stillness->size[1] = 1;
    emxEnsureCapacity_real_T(b_stillness, i0);
    b_stillness->data[0] = 1.0;
  } else if (floor(data_steps) == data_steps) {
    i0 = b_stillness->size[0] * b_stillness->size[1];
    b_stillness->size[0] = 1;
    b_stillness->size[1] = (int)floor((absa - 1.0) / data_steps) + 1;
    emxEnsureCapacity_real_T(b_stillness, i0);
    absb = (int)floor((absa - 1.0) / data_steps);
    for (i0 = 0; i0 <= absb; i0++) {
      b_stillness->data[b_stillness->size[0] * i0] = 1.0 + data_steps * (double)
        i0;
    }
  } else {
    ndbl = floor((absa - 1.0) / data_steps + 0.5);
    apnd = 1.0 + ndbl * data_steps;
    if (data_steps > 0.0) {
      cdiff = apnd - absa;
    } else {
      cdiff = absa - apnd;
    }

    b_absb = fabs(absa);
    if ((1.0 > b_absb) || rtIsNaN(b_absb)) {
      b_absb = 1.0;
    }

    if (fabs(cdiff) < 4.4408920985006262E-16 * b_absb) {
      ndbl++;
      apnd = absa;
    } else if (cdiff > 0.0) {
      apnd = 1.0 + (ndbl - 1.0) * data_steps;
    } else {
      ndbl++;
    }

    if (ndbl >= 0.0) {
      n = (int)ndbl;
    } else {
      n = 0;
    }

    i0 = b_stillness->size[0] * b_stillness->size[1];
    b_stillness->size[0] = 1;
    b_stillness->size[1] = n;
    emxEnsureCapacity_real_T(b_stillness, i0);
    if (n > 0) {
      b_stillness->data[0] = 1.0;
      if (n > 1) {
        b_stillness->data[n - 1] = apnd;
        absb = (n - 1) / 2;
        for (k = 1; k < absb; k++) {
          absa = (double)k * data_steps;
          b_stillness->data[k] = 1.0 + absa;
          b_stillness->data[(n - k) - 1] = apnd - absa;
        }

        if (absb << 1 == n - 1) {
          b_stillness->data[absb] = (1.0 + apnd) / 2.0;
        } else {
          absa = (double)absb * data_steps;
          b_stillness->data[absb] = 1.0 + absa;
          b_stillness->data[absb + 1] = apnd - absa;
        }
      }
    }
  }

  emxInit_real_T(&b_r_w, 2);
  i0 = b_r_w->size[0] * b_r_w->size[1];
  b_r_w->size[0] = 1;
  b_r_w->size[1] = b_stillness->size[1] + starts->size[1];
  emxEnsureCapacity_real_T(b_r_w, i0);
  absb = b_stillness->size[1];
  for (i0 = 0; i0 < absb; i0++) {
    b_r_w->data[b_r_w->size[0] * i0] = b_stillness->data[b_stillness->size[0] *
      i0];
  }

  absb = starts->size[1];
  for (i0 = 0; i0 < absb; i0++) {
    b_r_w->data[b_r_w->size[0] * (i0 + b_stillness->size[1])] = starts->
      data[starts->size[0] * i0];
  }

  i0 = starts->size[0] * starts->size[1];
  starts->size[0] = 1;
  starts->size[1] = b_r_w->size[1];
  emxEnsureCapacity_real_T(starts, i0);
  absb = b_r_w->size[1];
  for (i0 = 0; i0 < absb; i0++) {
    starts->data[starts->size[0] * i0] = b_r_w->data[b_r_w->size[0] * i0];
  }

  emxInit_real_T(&r_w_mod, 2);
  emxInit_real_T(&tauDelta_mod, 2);
  emxInit_real_T(&tauBias_mod, 2);
  emxInit_real_T(&b_delta, 2);
  i0 = b_stillness->size[0] * b_stillness->size[1];
  b_stillness->size[0] = 1;
  b_stillness->size[1] = starts->size[1];
  emxEnsureCapacity_real_T(b_stillness, i0);
  i0 = b_r_w->size[0] * b_r_w->size[1];
  b_r_w->size[0] = 1;
  b_r_w->size[1] = starts->size[1];
  emxEnsureCapacity_real_T(b_r_w, i0);
  i0 = r_w_mod->size[0] * r_w_mod->size[1];
  r_w_mod->size[0] = 1;
  r_w_mod->size[1] = starts->size[1];
  emxEnsureCapacity_real_T(r_w_mod, i0);
  i0 = tauBias_mod->size[0] * tauBias_mod->size[1];
  tauBias_mod->size[0] = 1;
  tauBias_mod->size[1] = starts->size[1];
  emxEnsureCapacity_real_T(tauBias_mod, i0);
  i0 = tauDelta_mod->size[0] * tauDelta_mod->size[1];
  tauDelta_mod->size[0] = 1;
  tauDelta_mod->size[1] = starts->size[1];
  emxEnsureCapacity_real_T(tauDelta_mod, i0);
  i0 = b_delta->size[0] * b_delta->size[1];
  b_delta->size[0] = 1;
  b_delta->size[1] = starts->size[1];
  emxEnsureCapacity_real_T(b_delta, i0);
  k = 0;
  emxInit_real_T(&b_data1, 2);
  emxInit_real_T(&b_data2, 2);
  while (k <= starts->size[1] - 1) {
    //     %% Basic estimation
    //  calculate the start and end index of the chosen alignment
    if (starts->data[k] < regular_estimation_start) {
      startup_estimation = true;
      absa = 1.0;
      b_absb = starts->data[k];
    } else {
      startup_estimation = false;
      absa = starts->data[k] - window_steps;
      b_absb = starts->data[k];
    }

    //  check if the sensors are at rest
    b_stillness->data[k] = 0.0;

    //      disp('stillness:');
    //      disp(size(stillness));
    //      disp(class(stillness));
    //
    if ((data_steps == 0.0) || (((data_steps > 0.0) && (absa > b_absb)) || ((0.0
           > data_steps) && (b_absb > absa)))) {
      i0 = 1;
      n = 1;
      i1 = 0;
      i2 = 1;
      i3 = 1;
      i4 = 0;
    } else {
      i0 = (int)absa;
      n = (int)data_steps;
      i1 = (int)b_absb;
      i2 = (int)absa;
      i3 = (int)data_steps;
      i4 = (int)b_absb;
    }

    i5 = b_data1->size[0] * b_data1->size[1];
    b_data1->size[0] = div_s32_floor(i1 - i0, n) + 1;
    b_data1->size[1] = 4;
    emxEnsureCapacity_real_T(b_data1, i5);
    absb = div_s32_floor(i1 - i0, n);
    for (i1 = 0; i1 < 4; i1++) {
      for (i5 = 0; i5 <= absb; i5++) {
        b_data1->data[i5 + b_data1->size[0] * i1] = data1->quat->data[((i0 + n *
          i5) + data1->quat->size[0] * i1) - 1];
      }
    }

    i0 = b_data2->size[0] * b_data2->size[1];
    b_data2->size[0] = div_s32_floor(i4 - i2, i3) + 1;
    b_data2->size[1] = 4;
    emxEnsureCapacity_real_T(b_data2, i0);
    absb = div_s32_floor(i4 - i2, i3);
    for (i0 = 0; i0 < 4; i0++) {
      for (n = 0; n <= absb; n++) {
        b_data2->data[n + b_data2->size[0] * i0] = data2->quat->data[((i2 + i3 *
          n) + data2->quat->size[0] * i0) - 1];
      }
    }

    delta_est_window(b_data1, b_data2, joint, last_delta_w, &sample_rate, &ndbl);
    if (startup_estimation) {
      if ((data_steps == 0.0) || (((data_steps > 0.0) && (absa > b_absb)) ||
           ((0.0 > data_steps) && (b_absb > absa)))) {
        i0 = 1;
        n = 1;
        i1 = 0;
        i2 = 1;
        i3 = 1;
        i4 = 0;
      } else {
        i0 = (int)absa;
        n = (int)data_steps;
        i1 = (int)b_absb;
        i2 = (int)absa;
        i3 = (int)data_steps;
        i4 = (int)b_absb;
      }

      i5 = b_data1->size[0] * b_data1->size[1];
      b_data1->size[0] = div_s32_floor(i1 - i0, n) + 1;
      b_data1->size[1] = 4;
      emxEnsureCapacity_real_T(b_data1, i5);
      absb = div_s32_floor(i1 - i0, n);
      for (i1 = 0; i1 < 4; i1++) {
        for (i5 = 0; i5 <= absb; i5++) {
          b_data1->data[i5 + b_data1->size[0] * i1] = data1->quat->data[((i0 + n
            * i5) + data1->quat->size[0] * i1) - 1];
        }
      }

      i0 = b_data2->size[0] * b_data2->size[1];
      b_data2->size[0] = div_s32_floor(i4 - i2, i3) + 1;
      b_data2->size[1] = 4;
      emxEnsureCapacity_real_T(b_data2, i0);
      absb = div_s32_floor(i4 - i2, i3);
      for (i0 = 0; i0 < 4; i0++) {
        for (n = 0; n <= absb; n++) {
          b_data2->data[n + b_data2->size[0] * i0] = data2->quat->data[((i2 + i3
            * n) + data2->quat->size[0] * i0) - 1];
        }
      }

      delta_est_window(b_data1, b_data2, joint, last_delta_w +
                       3.1415926535897931, &cdiff, &apnd);
      if (apnd < ndbl) {
        sample_rate = cdiff;
      }
    }

    last_delta_w = sample_rate;
    if ((data_steps == 0.0) || (((data_steps > 0.0) && (absa > b_absb)) || ((0.0
           > data_steps) && (b_absb > absa)))) {
      i0 = 1;
      n = 1;
      i1 = 0;
      i2 = 1;
      i3 = 1;
      i4 = 0;
    } else {
      i0 = (int)absa;
      n = (int)data_steps;
      i1 = (int)b_absb;
      i2 = (int)absa;
      i3 = (int)data_steps;
      i4 = (int)b_absb;
    }

    i5 = b_data1->size[0] * b_data1->size[1];
    b_data1->size[0] = div_s32_floor(i1 - i0, n) + 1;
    b_data1->size[1] = 4;
    emxEnsureCapacity_real_T(b_data1, i5);
    absb = div_s32_floor(i1 - i0, n);
    for (i1 = 0; i1 < 4; i1++) {
      for (i5 = 0; i5 <= absb; i5++) {
        b_data1->data[i5 + b_data1->size[0] * i1] = data1->quat->data[((i0 + n *
          i5) + data1->quat->size[0] * i1) - 1];
      }
    }

    i0 = b_data2->size[0] * b_data2->size[1];
    b_data2->size[0] = div_s32_floor(i4 - i2, i3) + 1;
    b_data2->size[1] = 4;
    emxEnsureCapacity_real_T(b_data2, i0);
    absb = div_s32_floor(i4 - i2, i3);
    for (i0 = 0; i0 < 4; i0++) {
      for (n = 0; n <= absb; n++) {
        b_data2->data[n + b_data2->size[0] * i0] = data2->quat->data[((i2 + i3 *
          n) + data2->quat->size[0] * i0) - 1];
      }
    }

    b_r_w->data[k] = getWindowWeight(b_data1, b_data2, joint);

    //      disp('r_w:');
    //      disp(size(r_w));
    //      disp(class(r_w));
    if (startup_estimation) {
      r_w_mod->data[k] = 1.0;
      tauDelta_mod->data[k] = 0.8;
      tauBias_mod->data[k] = 1.0;
    } else {
      r_w_mod->data[k] = b_r_w->data[k];
      tauBias_mod->data[k] = 2.0;
      tauDelta_mod->data[k] = 2.0;
    }

    b_delta->data[k] = sample_rate;

    //      disp('r_w_mod:');
    //      disp(size(r_w_mod));
    //      disp(class(r_w_mod));
    //      disp('tauDelta_mod:');
    //      disp(size(tauDelta_mod));
    //      disp(class(tauDelta_mod));
    //      disp('tauBias_mod:');
    //      disp(size(tauBias_mod));
    //      disp(class(tauBias_mod));
    //      disp('delta:');
    //      disp(size(delta));
    //      disp(class(delta));
    k++;
  }

  emxFree_real_T(&b_data2);
  emxFree_real_T(&b_data1);
  emxInit_real_T(&r0, 2);

  //  Cut the arrays to the right length
  i0 = r0->size[0] * r0->size[1];
  r0->size[0] = 1;
  r0->size[1] = b_delta->size[1];
  emxEnsureCapacity_real_T(r0, i0);
  absb = b_delta->size[0] * b_delta->size[1];
  for (i0 = 0; i0 < absb; i0++) {
    r0->data[i0] = b_delta->data[i0];
  }

  emxInit_real_T1(&c_data1, 1);
  unwrap(r0);
  headingFilter_extrap(r0, r_w_mod, tauDelta_mod, tauBias_mod, delta_filt);
  unwrap(b_delta);
  i0 = c_data1->size[0];
  c_data1->size[0] = starts->size[1];
  emxEnsureCapacity_real_T1(c_data1, i0);
  absb = starts->size[1];
  emxFree_real_T(&r0);
  emxFree_real_T(&tauBias_mod);
  emxFree_real_T(&tauDelta_mod);
  emxFree_real_T(&r_w_mod);
  for (i0 = 0; i0 < absb; i0++) {
    c_data1->data[i0] = data1->time->data[(int)starts->data[starts->size[0] * i0]
      - 1];
  }

  interp1(c_data1, b_delta, data1->time, delta);
  i0 = c_data1->size[0];
  c_data1->size[0] = starts->size[1];
  emxEnsureCapacity_real_T1(c_data1, i0);
  absb = starts->size[1];
  emxFree_real_T(&b_delta);
  for (i0 = 0; i0 < absb; i0++) {
    c_data1->data[i0] = data1->time->data[(int)starts->data[starts->size[0] * i0]
      - 1];
  }

  emxInit_real_T1(&b_delta_filt, 1);
  i0 = b_delta_filt->size[0];
  b_delta_filt->size[0] = delta_filt->size[0];
  emxEnsureCapacity_real_T1(b_delta_filt, i0);
  absb = delta_filt->size[0];
  for (i0 = 0; i0 < absb; i0++) {
    b_delta_filt->data[i0] = delta_filt->data[i0];
  }

  b_interp1(c_data1, b_delta_filt, data1->time, delta_filt);
  i0 = c_data1->size[0];
  c_data1->size[0] = starts->size[1];
  emxEnsureCapacity_real_T1(c_data1, i0);
  absb = starts->size[1];
  emxFree_real_T(&b_delta_filt);
  for (i0 = 0; i0 < absb; i0++) {
    c_data1->data[i0] = data1->time->data[(int)starts->data[starts->size[0] * i0]
      - 1];
  }

  interp1(c_data1, b_r_w, data1->time, r_w);
  i0 = c_data1->size[0];
  c_data1->size[0] = starts->size[1];
  emxEnsureCapacity_real_T1(c_data1, i0);
  absb = starts->size[1];
  emxFree_real_T(&b_r_w);
  for (i0 = 0; i0 < absb; i0++) {
    c_data1->data[i0] = data1->time->data[(int)starts->data[starts->size[0] * i0]
      - 1];
  }

  emxFree_real_T(&starts);
  interp1(c_data1, b_stillness, data1->time, stillness);
  emxFree_real_T(&c_data1);
  emxFree_real_T(&b_stillness);
}

//
// File trailer for getDelta_1D.cpp
//
// [EOF]
//
