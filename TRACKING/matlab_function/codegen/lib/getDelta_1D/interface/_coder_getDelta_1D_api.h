/*
 * File: _coder_getDelta_1D_api.h
 *
 * MATLAB Coder version            : 3.4
 * C/C++ source code generated on  : 23-Jan-2020 01:46:52
 */

#ifndef _CODER_GETDELTA_1D_API_H
#define _CODER_GETDELTA_1D_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_getDelta_1D_api.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_real_T*/

#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T

typedef struct emxArray_real_T emxArray_real_T;

#endif                                 /*typedef_emxArray_real_T*/

#ifndef typedef_struct0_T
#define typedef_struct0_T

typedef struct {
  real_T rate;
} struct0_T;

#endif                                 /*typedef_struct0_T*/

#ifndef typedef_struct1_T
#define typedef_struct1_T

typedef struct {
  emxArray_real_T *time;
  emxArray_real_T *quat;
} struct1_T;

#endif                                 /*typedef_struct1_T*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void getDelta_1D(struct0_T *meta, struct1_T *data1, struct1_T *data2,
  real_T joint[3], emxArray_real_T *delta, emxArray_real_T *delta_filt,
  emxArray_real_T *r_w, emxArray_real_T *stillness);
extern void getDelta_1D_api(const mxArray * const prhs[4], const mxArray *plhs[4]);
extern void getDelta_1D_atexit(void);
extern void getDelta_1D_initialize(void);
extern void getDelta_1D_terminate(void);
extern void getDelta_1D_xil_terminate(void);

#endif

/*
 * File trailer for _coder_getDelta_1D_api.h
 *
 * [EOF]
 */
