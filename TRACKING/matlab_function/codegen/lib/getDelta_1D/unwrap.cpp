//
// File: unwrap.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "unwrap.h"

// Function Declarations
static double rt_remd_snf(double u0, double u1);
static double rt_roundd_snf(double u);

// Function Definitions

//
// Arguments    : double u0
//                double u1
// Return Type  : double
//
static double rt_remd_snf(double u0, double u1)
{
  double y;
  double b_u1;
  double q;
  if (!((!rtIsNaN(u0)) && (!rtIsInf(u0)) && ((!rtIsNaN(u1)) && (!rtIsInf(u1)))))
  {
    y = rtNaN;
  } else {
    if (u1 < 0.0) {
      b_u1 = ceil(u1);
    } else {
      b_u1 = floor(u1);
    }

    if ((u1 != 0.0) && (u1 != b_u1)) {
      q = fabs(u0 / u1);
      if (fabs(q - floor(q + 0.5)) <= DBL_EPSILON * q) {
        y = 0.0 * u0;
      } else {
        y = fmod(u0, u1);
      }
    } else {
      y = fmod(u0, u1);
    }
  }

  return y;
}

//
// Arguments    : double u
// Return Type  : double
//
static double rt_roundd_snf(double u)
{
  double y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = u * 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

//
// Arguments    : emxArray_real_T *p
// Return Type  : void
//
void unwrap(emxArray_real_T *p)
{
  int m;
  double cumsum_dp_corr;
  unsigned int k;
  double pkm1;
  int exitg1;
  double dp_corr;
  m = p->size[1];
  cumsum_dp_corr = 0.0;
  k = 1U;
  while (((int)k < m) && (!((!rtIsInf(p->data[(int)k - 1])) && (!rtIsNaN(p->
             data[(int)k - 1]))))) {
    k = (unsigned int)((int)k + 1);
  }

  if ((int)k < p->size[1]) {
    pkm1 = p->data[(int)k - 1];
    do {
      exitg1 = 0;
      k++;
      while (((double)k <= m) && (!((!rtIsInf(p->data[(int)k - 1])) && (!rtIsNaN
                (p->data[(int)k - 1]))))) {
        k++;
      }

      if ((double)k > m) {
        exitg1 = 1;
      } else {
        pkm1 = p->data[(int)k - 1] - pkm1;
        dp_corr = pkm1 / 6.2831853071795862;
        if (fabs(rt_remd_snf(dp_corr, 1.0)) <= 0.5) {
          if (dp_corr < 0.0) {
            dp_corr = ceil(dp_corr);
          } else {
            dp_corr = floor(dp_corr);
          }
        } else {
          dp_corr = rt_roundd_snf(dp_corr);
        }

        if (fabs(pkm1) >= 3.1415926535897931) {
          cumsum_dp_corr += dp_corr;
        }

        pkm1 = p->data[(int)k - 1];
        p->data[(int)k - 1] -= 6.2831853071795862 * cumsum_dp_corr;
      }
    } while (exitg1 == 0);
  }
}

//
// File trailer for unwrap.cpp
//
// [EOF]
//
