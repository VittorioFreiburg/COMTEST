from setuptools import setup, find_packages
from Cython.Build import cythonize
from distutils.extension import Extension
'''
    'rtGetInf.c',
    'rtGetNaN.c',
    'getDelta_1D_data.c',
    'getDelta_1D.c',
    'rt_nonfinite.c'
'''
imu_sources = [
    'heading/headm.pyx',
    'unwrap.cpp',
    'rtGetInf.cpp',
    'headingFilter_extrap.cpp',
    'getQuat.cpp',
    'rt_nonfinite.cpp',
    'getDelta_1D_terminate.cpp',
    'power.cpp',
    'quaternionRotate.cpp',
    'getDelta_1D_emxutil.cpp',
    'bsearch.cpp',
    'getDelta_1D.cpp',
    'sqrt.cpp',
    'quaternionInvert.cpp',
    'getErrorAndJac_1D.cpp',
    'rdivide.cp',
    'exp.cpp',
    'atan2.cpp',
    'rtGetNaN.cpp',
    'interp1.cpp',
    'repmat.cpp',
    'getDelta_1D_emxAPI.cpp',
    'getDelta_1D_initialize.cpp',
    'quaternionMultiply.cpp',
]
sources =  [
            "heading/headm.pyx",
            "unwrap.cpp",
            "rtGetInf.cpp",
            "headingFilter_extrap.cpp",
            "getQuat.cpp",
            "rt_nonfinite.cpp",
            "getDelta_1D_terminate.cpp",
            "power.cpp",
            "quaternionRotate.cpp",
            "getDelta_1D_emxutil.cpp",
            "bsearch.cpp",
            "getDelta_1D.cpp",
            "sqrt.cpp",
            "quaternionInvert.cpp",
            "getErrorAndJac_1D.cpp",
            "rdivide.cpp",
            "exp.cpp",
            "atan2.cpp",
            "rtGetNaN.cpp",
            "interp1.cpp",
            "repmat.cpp",
            "getDelta_1D_emxAPI.cpp",
            "getDelta_1D_initialize.cpp",
            "quaternionMultiply.cpp"
        ]

imu_extension = Extension('headm', sources,
                          include_dirs=[
                          '../getDelta_1D'],
                          language='c++')

ext_modules = cythonize([imu_extension])

setup(
    name='heading',

    version='1',

    packages=find_packages(exclude=['contrib', 'docs', 'tests']),

    install_requires=['numpy', 'scipy', 'matplotlib'],

    ext_modules=ext_modules,

)
