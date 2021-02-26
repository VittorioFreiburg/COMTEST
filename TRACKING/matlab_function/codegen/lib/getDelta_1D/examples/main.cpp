//
// File: main.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

//***********************************************************************
// This automatically generated example C main file shows how to call
// entry-point functions that MATLAB Coder generated. You must customize
// this file for your application. Do not modify this file directly.
// Instead, make a copy of this file, modify it, and integrate it into
// your development environment.
//
// This file initializes entry-point function arguments to a default
// size and value before calling the entry-point functions. It does
// not store or use any values returned from the entry-point functions.
// If necessary, it does pre-allocate memory for returned values.
// You can use this file as a starting point for a main function that
// you can deploy in your application.
//
// After you copy the file, and before you deploy it, you must make the
// following changes:
// * For variable-size function arguments, change the example sizes to
// the sizes that your application requires.
// * Change the example values of function arguments to the values that
// your application requires.
// * If the entry-point functions return values, store these values or
// otherwise use them as required by your application.
//
//***********************************************************************
// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "main.h"
#include "getDelta_1D_terminate.h"
#include "getDelta_1D_emxAPI.h"
#include "getDelta_1D_initialize.h"

// Function Declarations
static void argInit_1x3_real_T(double result[3]);
static emxArray_real_T *argInit_Unboundedx1_real_T();
static emxArray_real_T *argInit_Unboundedx4_real_T();
static double argInit_real_T();
static struct0_T argInit_struct0_T();
static struct1_T argInit_struct1_T();
static void main_getDelta_1D();

// Function Definitions

//
// Arguments    : double result[3]
// Return Type  : void
//
static void argInit_1x3_real_T(double result[3])
{
  int idx1;

  // Loop over the array to initialize each element.
  for (idx1 = 0; idx1 < 3; idx1++) {
    // Set the value of the array element.
    // Change this value to the value that the application requires.
    result[idx1] = argInit_real_T();
  }
}

//
// Arguments    : void
// Return Type  : emxArray_real_T *
//
static emxArray_real_T *argInit_Unboundedx1_real_T()
{
  emxArray_real_T *result;
  static int iv2[1] = { 2 };

  int idx0;

  // Set the size of the array.
  // Change this size to the value that the application requires.
  result = emxCreateND_real_T(1, *(int (*)[1])&iv2[0]);

  // Loop over the array to initialize each element.
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    // Set the value of the array element.
    // Change this value to the value that the application requires.
    result->data[idx0] = argInit_real_T();
  }

  return result;
}

//
// Arguments    : void
// Return Type  : emxArray_real_T *
//
static emxArray_real_T *argInit_Unboundedx4_real_T()
{
  emxArray_real_T *result;
  static int iv3[2] = { 2, 4 };

  int idx0;
  int idx1;

  // Set the size of the array.
  // Change this size to the value that the application requires.
  result = emxCreateND_real_T(2, *(int (*)[2])&iv3[0]);

  // Loop over the array to initialize each element.
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    for (idx1 = 0; idx1 < 4; idx1++) {
      // Set the value of the array element.
      // Change this value to the value that the application requires.
      result->data[idx0 + result->size[0] * idx1] = argInit_real_T();
    }
  }

  return result;
}

//
// Arguments    : void
// Return Type  : double
//
static double argInit_real_T()
{
  return 0.0;
}

//
// Arguments    : void
// Return Type  : struct0_T
//
static struct0_T argInit_struct0_T()
{
  struct0_T result;

  // Set the value of each structure field.
  // Change this value to the value that the application requires.
  result.rate = argInit_real_T();
  return result;
}

//
// Arguments    : void
// Return Type  : struct1_T
//
static struct1_T argInit_struct1_T()
{
  struct1_T result;

  // Set the value of each structure field.
  // Change this value to the value that the application requires.
  result.time = argInit_Unboundedx1_real_T();
  result.quat = argInit_Unboundedx4_real_T();
  return result;
}

//
// Arguments    : void
// Return Type  : void
//
static void main_getDelta_1D()
{
  emxArray_real_T *delta;
  emxArray_real_T *delta_filt;
  emxArray_real_T *r_w;
  emxArray_real_T *stillness;
  struct0_T meta;
  struct1_T data1;
  struct1_T data2;
  double dv2[3];
  emxInitArray_real_T(&delta, 1);
  emxInitArray_real_T(&delta_filt, 1);
  emxInitArray_real_T(&r_w, 1);
  emxInitArray_real_T(&stillness, 1);

  // Initialize function 'getDelta_1D' input arguments.
  // Initialize function input argument 'meta'.
  meta = argInit_struct0_T();

  // Initialize function input argument 'data1'.
  data1 = argInit_struct1_T();

  // Initialize function input argument 'data2'.
  data2 = argInit_struct1_T();

  // Initialize function input argument 'joint'.
  // Call the entry-point 'getDelta_1D'.
  argInit_1x3_real_T(dv2);
  getDelta_1D(&meta, &data1, &data2, dv2, delta, delta_filt, r_w, stillness);
  emxDestroyArray_real_T(stillness);
  emxDestroyArray_real_T(r_w);
  emxDestroyArray_real_T(delta_filt);
  emxDestroyArray_real_T(delta);
  emxDestroy_struct1_T(data2);
  emxDestroy_struct1_T(data1);
}

//
// Arguments    : int argc
//                const char * const argv[]
// Return Type  : int
//
int main(int, const char * const [])
{
  // Initialize the application.
  // You do not need to do this more than one time.
  getDelta_1D_initialize();

  // Invoke the entry-point functions.
  // You can call entry-point functions multiple times.
  main_getDelta_1D();

  // Terminate the application.
  // You do not need to do this more than one time.
  getDelta_1D_terminate();
  return 0;
}

//
// File trailer for main.cpp
//
// [EOF]
//
