Sensor communication software:

# if SensorStim is used:
  ## follow the instructions on https://gitlab.com/sensorstim_community/ble_receiver.git


# if XSense is used:
  clone https://gitlab.tubit.tu-berlin.de/csg-imu/xsens_receiver
  run
    sudo lib/MT_Software_Suite_Linux_4.6/mtsdk_linux_4.6.sh
  ## in xsens_receiver folder
    press enter to use default install location
  pip3 install --user -e .
  ## run python interface example script
    LD_LIBRARY_PATH=/usr/local/xsens/lib64 python3 example.py


Build Cython matlab function:
  in /matlab_function/codegen/lib/getDelta_1D : python3 setup.py install


Build Cython OriEstIMU function:
  in /dp : python3 setup.py install

## necessary python packages 
from minimalexample_visualisation.pysend import measurement_ws_provider

# import bin.imu_dump as imuConnection
 - numpy          : pip install numpy
 - argparse       : pip install argparse
 - json           : pip install jsonlib
 - asyncio        : pip install asyncio
 - websockets     : pip install websockets


To start everything:
  Webapp + Websocket starten:
    - /minimalexample_visualisation/ ./webapp.sh HSS_Demo_2_character.html
  Sensordatenverarbeitung starten:
    - LD_LIBRARY_PATH=/usr/local/xsens/lib64 python3 main.py xxxxxxxx
    
    
   LD_LIBRARY_PATH=/usr/local/xsens/lib64 python3 main.py 00B459EA 00B459DD 00B456CA 00B4592C 00B459CA 00B45927 00B45926
    
exchange xxxxxxxx with SensorID. (min two IMU's)




