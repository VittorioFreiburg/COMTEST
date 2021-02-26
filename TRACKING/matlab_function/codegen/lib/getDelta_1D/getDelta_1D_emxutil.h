//
// File: getDelta_1D_emxutil.h
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//
#ifndef GETDELTA_1D_EMXUTIL_H
#define GETDELTA_1D_EMXUTIL_H

// Include Files
#include <float.h>
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rt_defines.h"
#include "rt_nonfinite.h"
#include "rtwtypes.h"
#include "getDelta_1D_types.h"

// Function Declarations
extern void emxEnsureCapacity_real_T(emxArray_real_T *emxArray, int oldNumel);
extern void emxEnsureCapacity_real_T1(emxArray_real_T *emxArray, int oldNumel);
extern void emxFreeStruct_struct1_T(struct1_T *pStruct);
extern void emxFree_real_T(emxArray_real_T **pEmxArray);
extern void emxInitStruct_struct1_T(struct1_T *pStruct);
extern void emxInit_real_T(emxArray_real_T **pEmxArray, int numDimensions);
extern void emxInit_real_T1(emxArray_real_T **pEmxArray, int numDimensions);

#endif

//
// File trailer for getDelta_1D_emxutil.h
//
// [EOF]
//
