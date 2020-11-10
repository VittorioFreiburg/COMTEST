//
// File: interp1.cpp
//
// MATLAB Coder version            : 3.4
// C/C++ source code generated on  : 23-Jan-2020 01:46:52
//

// Include Files
#include "rt_nonfinite.h"
#include "getDelta_1D.h"
#include "interp1.h"
#include "getDelta_1D_emxutil.h"
#include "bsearch.h"

// Function Definitions

//
// Arguments    : const emxArray_real_T *varargin_1
//                const emxArray_real_T *varargin_2
//                const emxArray_real_T *varargin_3
//                emxArray_real_T *Vq
// Return Type  : void
//
void b_interp1(const emxArray_real_T *varargin_1, const emxArray_real_T
               *varargin_2, const emxArray_real_T *varargin_3, emxArray_real_T
               *Vq)
{
  emxArray_real_T *y;
  int nd2;
  int n;
  emxArray_real_T *x;
  int nx;
  unsigned int outsize_idx_0;
  int k;
  int exitg1;
  double r;
  emxInit_real_T1(&y, 1);
  nd2 = y->size[0];
  y->size[0] = varargin_2->size[0];
  emxEnsureCapacity_real_T1(y, nd2);
  n = varargin_2->size[0];
  for (nd2 = 0; nd2 < n; nd2++) {
    y->data[nd2] = varargin_2->data[nd2];
  }

  emxInit_real_T1(&x, 1);
  nd2 = x->size[0];
  x->size[0] = varargin_1->size[0];
  emxEnsureCapacity_real_T1(x, nd2);
  n = varargin_1->size[0];
  for (nd2 = 0; nd2 < n; nd2++) {
    x->data[nd2] = varargin_1->data[nd2];
  }

  nx = varargin_1->size[0];
  outsize_idx_0 = (unsigned int)varargin_3->size[0];
  nd2 = Vq->size[0];
  Vq->size[0] = (int)outsize_idx_0;
  emxEnsureCapacity_real_T1(Vq, nd2);
  n = (int)outsize_idx_0;
  for (nd2 = 0; nd2 < n; nd2++) {
    Vq->data[nd2] = rtNaN;
  }

  if (varargin_3->size[0] != 0) {
    k = 1;
    do {
      exitg1 = 0;
      if (k <= nx) {
        if (rtIsNaN(varargin_1->data[k - 1])) {
          exitg1 = 1;
        } else {
          k++;
        }
      } else {
        if (varargin_1->data[1] < varargin_1->data[0]) {
          nd2 = nx >> 1;
          for (n = 1; n <= nd2; n++) {
            r = x->data[n - 1];
            x->data[n - 1] = x->data[nx - n];
            x->data[nx - n] = r;
          }

          if ((!(varargin_2->size[0] == 0)) && (varargin_2->size[0] > 1)) {
            n = varargin_2->size[0];
            nd2 = varargin_2->size[0] >> 1;
            for (k = 1; k <= nd2; k++) {
              r = y->data[k - 1];
              y->data[k - 1] = y->data[n - k];
              y->data[n - k] = r;
            }
          }
        }

        for (k = 0; k + 1 <= varargin_3->size[0]; k++) {
          if (rtIsNaN(varargin_3->data[k])) {
            Vq->data[k] = rtNaN;
          } else {
            if ((!(varargin_3->data[k] > x->data[x->size[0] - 1])) &&
                (!(varargin_3->data[k] < x->data[0]))) {
              n = b_bsearch(x, varargin_3->data[k]) - 1;
              r = (varargin_3->data[k] - x->data[n]) / (x->data[n + 1] - x->
                data[n]);
              if (r == 0.0) {
                Vq->data[k] = y->data[n];
              } else if (r == 1.0) {
                Vq->data[k] = y->data[n + 1];
              } else if (y->data[n] == y->data[n + 1]) {
                Vq->data[k] = y->data[n];
              } else {
                Vq->data[k] = (1.0 - r) * y->data[n] + r * y->data[n + 1];
              }
            }
          }
        }

        exitg1 = 1;
      }
    } while (exitg1 == 0);
  }

  emxFree_real_T(&x);
  emxFree_real_T(&y);
}

//
// Arguments    : const emxArray_real_T *varargin_1
//                const emxArray_real_T *varargin_2
//                const emxArray_real_T *varargin_3
//                emxArray_real_T *Vq
// Return Type  : void
//
void interp1(const emxArray_real_T *varargin_1, const emxArray_real_T
             *varargin_2, const emxArray_real_T *varargin_3, emxArray_real_T *Vq)
{
  emxArray_real_T *y;
  int j2;
  int nd2;
  emxArray_real_T *x;
  int nx;
  unsigned int outsize_idx_0;
  int exitg1;
  int b_j1;
  double r;
  emxInit_real_T(&y, 2);
  j2 = y->size[0] * y->size[1];
  y->size[0] = 1;
  y->size[1] = varargin_2->size[1];
  emxEnsureCapacity_real_T(y, j2);
  nd2 = varargin_2->size[0] * varargin_2->size[1];
  for (j2 = 0; j2 < nd2; j2++) {
    y->data[j2] = varargin_2->data[j2];
  }

  emxInit_real_T1(&x, 1);
  j2 = x->size[0];
  x->size[0] = varargin_1->size[0];
  emxEnsureCapacity_real_T1(x, j2);
  nd2 = varargin_1->size[0];
  for (j2 = 0; j2 < nd2; j2++) {
    x->data[j2] = varargin_1->data[j2];
  }

  nx = varargin_1->size[0];
  outsize_idx_0 = (unsigned int)varargin_3->size[0];
  j2 = Vq->size[0];
  Vq->size[0] = (int)outsize_idx_0;
  emxEnsureCapacity_real_T1(Vq, j2);
  nd2 = (int)outsize_idx_0;
  for (j2 = 0; j2 < nd2; j2++) {
    Vq->data[j2] = rtNaN;
  }

  if (varargin_3->size[0] != 0) {
    j2 = 1;
    do {
      exitg1 = 0;
      if (j2 <= nx) {
        if (rtIsNaN(varargin_1->data[j2 - 1])) {
          exitg1 = 1;
        } else {
          j2++;
        }
      } else {
        if (varargin_1->data[1] < varargin_1->data[0]) {
          j2 = nx >> 1;
          for (b_j1 = 1; b_j1 <= j2; b_j1++) {
            r = x->data[b_j1 - 1];
            x->data[b_j1 - 1] = x->data[nx - b_j1];
            x->data[nx - b_j1] = r;
          }

          nd2 = varargin_2->size[1] >> 1;
          for (b_j1 = 1; b_j1 <= nd2; b_j1++) {
            j2 = varargin_2->size[1] - b_j1;
            r = y->data[b_j1 - 1];
            y->data[b_j1 - 1] = y->data[j2];
            y->data[j2] = r;
          }
        }

        for (j2 = 0; j2 + 1 <= varargin_3->size[0]; j2++) {
          if (rtIsNaN(varargin_3->data[j2])) {
            Vq->data[j2] = rtNaN;
          } else {
            if ((!(varargin_3->data[j2] > x->data[x->size[0] - 1])) &&
                (!(varargin_3->data[j2] < x->data[0]))) {
              nd2 = b_bsearch(x, varargin_3->data[j2]) - 1;
              r = (varargin_3->data[j2] - x->data[nd2]) / (x->data[nd2 + 1] -
                x->data[nd2]);
              if (r == 0.0) {
                Vq->data[j2] = y->data[nd2];
              } else if (r == 1.0) {
                Vq->data[j2] = y->data[nd2 + 1];
              } else if (y->data[nd2] == y->data[nd2 + 1]) {
                Vq->data[j2] = y->data[nd2];
              } else {
                Vq->data[j2] = (1.0 - r) * y->data[nd2] + r * y->data[nd2 + 1];
              }
            }
          }
        }

        exitg1 = 1;
      }
    } while (exitg1 == 0);
  }

  emxFree_real_T(&x);
  emxFree_real_T(&y);
}

//
// File trailer for interp1.cpp
//
// [EOF]
//
