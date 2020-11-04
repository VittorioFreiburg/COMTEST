from setuptools import setup, find_packages
from Cython.Build import cythonize
import numpy as np

ext_modules = cythonize([
    "oriestimu/oriestimu.pyx",
 #   "oriestimu_kai/oriestimu.pyx"
])

for m in ext_modules:
    m.include_dirs = [np.get_include(), '.']

setup(
    name='OriEstIMU',

    version='0.0.1',

    
    license='GPLv3',

    packages=find_packages(exclude=['contrib', 'docs', 'tests']),

    install_requires=['numpy', 'scipy', 'ujson', 'c3d', 'pyzmq', 'msgpack-python','PyYAML'],

    ext_modules=ext_modules,

    include_dirs=[np.get_include()],
)
