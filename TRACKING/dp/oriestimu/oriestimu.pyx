# distutils: language = c++
# distutils: sources = oriestimu/CsgOriEstIMU.cpp oriestimu/CSGutilities.cpp
"""
Author: Daniel Laidig <laidig@control.tu-berlin.de>
License: GPLv3+
"""


import numpy as np
cimport numpy as np

ctypedef np.double_t DOUBLE_t

cdef extern from "CsgOriEstIMU.hpp":
    cdef cppclass CCsgOriEstIMU:
        CCsgOriEstIMU(double, double[4], double[3], double) except +
        signed char setFilterParameter(double, double, double)
        signed char updateCsgOriEstIMU(double[3], double[3], double[3], double*, double*, double*)
        void resetEstimation(double[4], double[3])
        void setRating(double rating)


cdef class OriEstIMU:
    cdef CCsgOriEstIMU* c_oriEstImu
    cdef public object quat
    cdef public object bias
    cdef public object error

    def __cinit__(self, double rate, double tauAcc, double tauMag, double zeta, double useMeasRawRating):
        self.c_oriEstImu = new CCsgOriEstIMU(rate, [0.5, 0.5, 0.5, 0.5], [0.0, 0.0, 0.0], useMeasRawRating)
        self.c_oriEstImu.setFilterParameter(tauAcc, tauMag, zeta)
        self.quat = None
        self.bias = None
        self.error = None

    def __dealloc__(self):
        del self.c_oriEstImu

    def update(self, np.ndarray[DOUBLE_t, ndim=1, mode="c"] acc not None, np.ndarray[DOUBLE_t, ndim=1, mode="c"] gyr not None, np.ndarray[DOUBLE_t, ndim=1, mode="c"] mag not None):#, double[3] gyr, double[3] mag):
        if acc.shape[0] != 3 or gyr.shape[0] != 3 or mag.shape[0] != 3 :
            raise ValueError("acc, gyr and mag must have length 3")
        cdef double[4] quat
        cdef double[3] bias
        cdef double[2] error
        #self.c_oriEstImu.updateCsgOriEstIMU(acc, gyr, mag, quat, bias, error)
        self.c_oriEstImu.updateCsgOriEstIMU(<double*> np.PyArray_DATA(acc), <double*> np.PyArray_DATA(gyr), <double*> np.PyArray_DATA(mag), quat, bias, error)
        #self.c_oriEstImu.updateCsgOriEstIMU(acc, gyr, mag, None, None, None)
        self.quat = quat
        self.bias = bias
        self.error = error
        return quat, bias, error

    def resetEstimation(self, np.ndarray[DOUBLE_t, ndim=1, mode="c"] newQuat not None, np.ndarray[DOUBLE_t, ndim=1, mode="c"] newBias not None):
        if newQuat.shape[0] != 4 or newBias.shape[0] != 3:
            raise ValueError("newQuat must have length 4 and newBias must have length 3")
        self.c_oriEstImu.resetEstimation(<double*> np.PyArray_DATA(newQuat), <double*> np.PyArray_DATA(newBias))

    def setFilterParameter(self, double tauAcc, double tauMag, double zeta):
        self.c_oriEstImu.setFilterParameter(tauAcc, tauMag, zeta)

    def setRating(self, double rating):
        self.c_oriEstImu.setRating(rating)
