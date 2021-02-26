//
// File: getDelta_1D_types.h
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//
#ifndef GETDELTA_1D_TYPES_H
#define GETDELTA_1D_TYPES_H

// Include Files
#include "rtwtypes.h"

// Type Definitions
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  double *data;
  int *size;
  int allocatedSize;
  int numDimensions;
  boolean_T canFreeData;
};

#endif                                 //struct_emxArray_real_T

typedef struct {
  double rate;
} struct0_T;

typedef struct {
  emxArray_real_T *time;
  emxArray_real_T *quat;
} struct1_T;

#endif

//
// File trailer for getDelta_1D_types.h
//
// [EOF]
//
