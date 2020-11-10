//
// File: getQuat.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "getQuat.h"

// Function Definitions

//
// Arguments    : double angle
//                double axis[3]
//                double out[4]
// Return Type  : void
//
void getQuat(double angle, double axis[3], double out[4])
{
  double y;
  int k;
  double scale;
  static const signed char iv0[4] = { 1, 0, 0, 0 };

  double absxk;
  double t;
  if (fabs(angle) < 2.2204460492503131E-16) {
    for (k = 0; k < 4; k++) {
      out[k] = iv0[k];
    }
  } else {
    y = 0.0;
    scale = 3.3121686421112381E-170;
    for (k = 0; k < 3; k++) {
      absxk = fabs(axis[k]);
      if (absxk > scale) {
        t = scale / absxk;
        y = 1.0 + y * t * t;
        scale = absxk;
      } else {
        t = absxk / scale;
        y += t * t;
      }
    }

    y = scale * sqrt(y);
    scale = sin(angle / 2.0);
    out[0] = cos(angle / 2.0);
    for (k = 0; k < 3; k++) {
      absxk = axis[k] / y;
      out[k + 1] = scale * absxk;
      axis[k] = absxk;
    }
  }
}

//
// File trailer for getQuat.cpp
//
// [EOF]
//
