from cpython cimport array

cdef extern from "rtwtypes.h":
    ctypedef char boolean_T 'boolean_T'

cdef extern from "getDelta_1D_types.h":
    ctypedef struct emxArray_real_T 'emxArray_real_T':
        double* data
        int* size
        int allocatedSize
        int numDimensions
        boolean_T canFreeData

    ctypedef struct struct0_T 'struct0_T':
        double rate
    
    ctypedef struct struct1_T 'struct1_T':
        emxArray_real_T* time
        emxArray_real_T* quat


                   

cdef extern from "getDelta_1D_initialize.h":   
    void getDelta_1D_initialize();


cdef extern from "getDelta_1D_terminate.h":
    void getDelta_1D_terminate();

cdef extern from "getDelta_1D.h":
    void getDelta_1D(const struct0_T *meta, const struct1_T *data1, const
                struct1_T *data2, const double joint[3], emxArray_real_T *delta,
                emxArray_real_T *delta_filt, emxArray_real_T *r_w, emxArray_real_T *stillness);

cdef extern from "getDelta_1D_emxAPI.h":
    void emxInitArray_real_T(emxArray_real_T **pEmxArray, int numDimensions);
    void emxInit_struct1_T(struct1_T *pStruct);
    emxArray_real_T *emxCreate_real_T(int rows, int cols);

cdef class Heading_Corr:
   
    cdef struct0_T meta 
    cdef struct1_T data1
    cdef struct1_T data2
    cdef double joint[3]
    cdef emxArray_real_T* delta
    cdef emxArray_real_T* delta_filt
    cdef emxArray_real_T* r_w
    cdef emxArray_real_T* stillness


    
    def __cinit__(self):
        getDelta_1D_initialize()
        
        emxInit_struct1_T(&self.data1)
        emxInit_struct1_T(&self.data2)

        self.joint = [0,1,0]
 
        emxInitArray_real_T(&self.delta,1)
        emxInitArray_real_T(&self.delta_filt,1)
        emxInitArray_real_T(&self.r_w,1)
        emxInitArray_real_T(&self.stillness,1)
        
 
    def set_input(self, time, q1, q2,rate):
        self.meta.rate = rate #TODO
        self.data1.time = emxCreate_real_T( len(time),1)
        self.data2.time = emxCreate_real_T( len(time),1)
        self.data1.quat = emxCreate_real_T(len(time),4)
        self.data2.quat = emxCreate_real_T(len(time),4)
        self.delta = emxCreate_real_T( len(time),1)
        self.delta_filt = emxCreate_real_T( len(time),1)
        self.r_w = emxCreate_real_T( len(time),1)
        self.stillness = emxCreate_real_T( len(time),1)
        for i in range(len(time)):
            self.data1.time.data[i] = time[i]
            self.data2.time.data[i] = time[i]
        for i in range(len(q1)):
            self.data1.quat.data[i] = q1[i]
        for i in range(len(q2)):
            self.data2.quat.data[i] = q2[i]

        #print('inputs set')

    
    def step(self):
        getDelta_1D(&self.meta, &self.data1, &self.data2, self.joint,
                    self.delta,self.delta_filt,self.r_w,self.stillness)
        delta_out = []
        delta_filt_out = []
        r_w = []
        stillness = []
        #for i in range(self.data1.time.size[0]):
        for i in range(self.data1.time.size[0]):
            delta_out.append(self.delta.data[i])
            delta_filt_out.append(self.delta_filt.data[i])
            r_w.append(self.r_w.data[i])
            stillness.append(self.stillness.data[i])
        
        return delta_out,delta_filt_out,r_w,stillness
    
    def __cdel__(self):
        getDelta_1D_terminate()

