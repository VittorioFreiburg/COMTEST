from minimalexample_visualisation.pysend import measurement_ws_provider
#import bin.imu_dump as imuConnection
import numpy as np
#import scipy.io as spio
import argparse
import os
from collections import defaultdict
import time
import json
from dp.oriestimu.oriestimu import OriEstIMU

import asyncio
#import multiprocessing as mp

import headm
headCorr = headm.Heading_Corr()

def multiplyQuat(q1, q2):
    """quat1*quat2"""
    if isinstance(q1, np.ndarray) and q1.shape == (4,):
        q1 = q1[np.newaxis]  # convert to 1x4 matrix
        shape = q2.shape
    elif isinstance(q1, np.ndarray) and q1.shape == (1, 4):
        shape = q2.shape
    elif isinstance(q2, np.ndarray) and q2.shape == (4,):
        q2 = q2[np.newaxis]  # convert to 1x4 matrix
        shape = q1.shape
    elif isinstance(q2, np.ndarray) and q2.shape == (1, 4):
        shape = q1.shape
    else:
        assert q1.shape == q2.shape
        shape = q1.shape
    output = np.zeros(shape=shape)
    output[:, 0] = q1[:, 0] * q2[:, 0] - q1[:, 1] * q2[:, 1] - q1[:, 2] * q2[:, 2] - q1[:, 3] * q2[:, 3]
    output[:, 1] = q1[:, 0] * q2[:, 1] + q1[:, 1] * q2[:, 0] + q1[:, 2] * q2[:, 3] - q1[:, 3] * q2[:, 2]
    output[:, 2] = q1[:, 0] * q2[:, 2] - q1[:, 1] * q2[:, 3] + q1[:, 2] * q2[:, 0] + q1[:, 3] * q2[:, 1]
    output[:, 3] = q1[:, 0] * q2[:, 3] + q1[:, 1] * q2[:, 2] - q1[:, 2] * q2[:, 1] + q1[:, 3] * q2[:, 0]
    return output

class Converter:
    def __init__(self):
        self.parser = argparse.ArgumentParser(description='Tool to convert hex IMU dumps to .mat files.')
        self.parser.add_argument('filename', metavar='FILE', nargs='+', help='filename(s)')
        self.args = self.parser.parse_args()
    def convert(self,allData):
        data = []
        for f in allData:
            mode, samples, log_timestamps, log_messages = parseImuLog([f])
            
            data.append({
                'imu': samples,
                'log': {
                    'timestamps': np.array(log_timestamps, np.float),
                    'messages': np.array(log_messages, np.object),
                }
            })
            if mode == 'raw':
                data[-1]['imu']['meta'] = {'rate': 40.0}
        return data


from collections import deque
class Buffer:
    def __init__(self, names):	
        self.names = names
        self.fifo = dict()
        for each in names:
            self.fifo[each] = deque()
        self.converter = Converter()
    
    def addSample(self,name, data):
        self.fifo[name].append(data)
        
    def addSample_new(self, name,t, data):
        if data is not None:
            self.fifo[name].append([name,t,data])
            #while(len(self.fifo[name])>1):
            #    self.fifo[name].pop()
    
    def checkCompleteness(self):
        return all([self.fifo[each] for each in self.fifo])
    
    def print(self):
        dataQueue = [self.fifo[each].popleft() for each in self.fifo]
        return dataQueue

    def print_new(self):
        for each in self.fifo:
            print(len(self.fifo[each]))
        dataQueue = [self.fifo[each].pop() for each in self.fifo]
        for each in self.fifo:
            self.fifo[each].clear()
        return dataQueue

def convert(allData):
        data = []
        for _name, _t,_data in allData:
            f = str(_t)+" "+_name+" "+str(_data.hex())
            mode, samples, log_timestamps, log_messages = parseImuLog([f])
            
            data.append({
                'imu': samples,
                'log': {
                    'timestamps': np.array(log_timestamps, np.float),
                    'messages': np.array(log_messages, np.object),
                }
            })
            if mode == 'raw':
                data[-1]['imu']['meta'] = {'rate': 40.0}
        return data
def sendMessage(data,_buffer):
    abc =0
    validData = True
    h_quat = [1,0,0,0]
    tr_quat= [1,0,0,0]
    tl_quat= [1,0,0,0]
    sr_quat = [1,0,0,0]
    sl_quat= [1,0,0,0]
    fr_quat = [1,0,0,0]
    fl_quat= [1,0,0,0]
    quats = [h_quat, tr_quat, tl_quat, sr_quat, sl_quat, fr_quat, fl_quat ]
    battery = []
    for idx, each in enumerate(_buffer.names):
        if "quat_onchip" in data[idx]['imu']['imu'+each].keys():
            validData = True and validData
            quats[idx] = np.around(data[idx]['imu']['imu'+each]["quat_onchip"],decimals = 3).tolist()[-1]  
            x = quats[idx][1]  
            y = quats[idx][2]
            z = quats[idx][3]
            quats[idx][1] = x
            quats[idx][2] = y
            quats[idx][3] = z
            
            battery.append(data[idx]['imu']['imu'+each]['battery'])
        else:
            validData = False

    if validData:
            
        [h_quat, tr_quat, tl_quat, sr_quat, sl_quat, fr_quat, fl_quat ] = quats
        print("Battery status: "+ str(battery))
        
    default_json_data = dict({"hip":h_quat,"thigh_left":tl_quat, "thigh_right":tr_quat,"shank_left":sl_quat, "shank_right":sr_quat,"foot_left":fl_quat, "foot_right":fr_quat})
    
    
    
    mwp.set_msg(json.dumps(default_json_data))
    asyncio.get_event_loop().run_until_complete(mwp.send())


def send_directly(  h_quat,tl_quat,tr_quat,sl_quat,sr_quat,fl_quat,fr_quat,
                    tl_delta,tr_delta,sl_delta,sr_delta,fl_delta,fr_delta,
                    tl_quat_corr,tr_quat_corr,sl_quat_corr,sr_quat_corr,fl_quat_corr,fr_quat_corr,
                    ):
    #h_quat[-1,:] =  applyHeading(np.pi,Quaternion(h_quat[-1,:]))
    print(h_quat)
    print(h_quat.shape)
    print(h_quat[-1,:])
    print(np.linalg.norm(h_quat[-1,:]))
    print(tl_quat)
    print(tl_quat[-1,:])
    print(tl_quat_corr[-1,:])
    default_json_data = dict({\
                        "hip":h_quat[-1,:],\
                        "thigh_left":tl_quat[-1,:], \
                        "thigh_right":tr_quat[-1,:], \
                        "shank_left":sl_quat[-1,:], \
                        "shank_right":sr_quat[-1,:], \
                        "foot_left":fl_quat[-1,:], \
                        "foot_right":fr_quat[-1,:],\
                        "thigh_left_deltaFilt_rt_corrected":tl_quat_corr[-1,:], \
                        "thigh_right_deltaFilt_rt_corrected":tr_quat_corr[-1,:], \
                        "shank_left_deltaFilt_rt_corrected":sl_quat_corr[-1,:], \
                        "shank_right_deltaFilt_rt_corrected":sr_quat_corr[-1,:], \
                        "foot_left_deltaFilt_rt_corrected":fl_quat_corr[-1,:], \
                        "foot_right_deltaFilt_rt_corrected":fr_quat_corr[-1,:]\
                                                
})  
    
    for each in default_json_data:
        default_json_data[each] = multiplyQuat(np.array(default_json_data[each]), np.array([[0.707,0,0.707,0]]))
        default_json_data[each] = np.around(default_json_data[each],decimals = 3).squeeze().tolist()
        print(default_json_data[each])
      
    mwp.set_msg(json.dumps(default_json_data))
    asyncio.get_event_loop().run_until_complete(mwp.send())  



def sendMessage_task(dataQueue,_buffer):
    if _buffer.checkCompleteness():
        dataQueue = _buffer.print_new()
    if dataQueue is not None:
        imu_data =  convert(dataQueue)
        print(imu_data)
        sendMessage(imu_data, _buffer)
        print("send Message")

def headingCorr1D(quat1,quat2,rate):
    
    timeVec = list(np.arange(0,quat1.shape[0]/rate,1/rate))
    
    q1 = list(quat1.transpose().flatten())
    q2 = list(quat2.transpose().flatten())
    headCorr.set_input(timeVec,q1,q2,rate)
    
    delta,df,rw,still = headCorr.step()
    delta = np.array(df)

    if len(delta[~np.isnan(delta)]) !=0:
        retVal_delta = delta[~np.isnan(delta)][-1]
    else:
        print("Nan Value")
        retVal_delta = np.nan
    return retVal_delta

def applyHeading(delta,quat):
    delta = np.sum(delta)
    quat_delta = np.array([np.cos(delta/2),0,0,np.sin(delta/2)])
    quat_corr = multiplyQuat(np.array([quat_delta]),np.array([quat]))
    quat_corr = np.array([quat_corr])
    return quat_corr

def deltaFilter(delta):
    delta = delta.squeeze()
    if delta.shape[0]> 2:
      maxMean = delta.shape[0] if delta.shape[0]<10 else delta.shape[0]
      deltaMean = np.nanmean(delta[-maxMean:])
      mask = np.where(np.abs(delta-deltaMean)<0.25*np.pi)
      retVal = np.nanmean(delta[mask])
      return retVal
    else:
      return delta[-1]#retVal#d_out[-1]

def deltaEstimation(dic_measurements ,rate, estimateNewDelta):
    libs = ["h","t","s","f"]
    for side in ["l","r"]:
        deltaEstimations = []
        
        for upper_lib,lib in zip(libs[:-1],libs[1:]):
            if list(dic_measurements[lib+side+"_quat"][-1,:]) == [1,0,0,0]:
                continue
            upper_side = "" if upper_lib == "h" else side
            q1 = dic_measurements[upper_lib+upper_side+"_quat"]
            q2 = dic_measurements[lib+side+"_quat"]
            maxEntries = q1.shape[0] if q1.shape[0] < q2.shape[0] else q2.shape[0]
            maxEntries = maxEntries if maxEntries < (10* rate)+ 2/5 * rate else (10* rate)+ 2/5 * rate
            maxEntries = int(maxEntries)
            
            if maxEntries < (10* rate)+ 1/5 * rate:
              continue
            
            if estimateNewDelta:
              newDelta = headingCorr1D(q1[-maxEntries:,:],q2[-maxEntries:,:],rate)
            else:
              newDelta = dic_measurements[lib+side+"_delta"][-1]
            dic_measurements[lib+side+"_delta"] = np.row_stack((dic_measurements[lib+side+"_delta"], newDelta))
            if np.isnan(newDelta):
              newDelta = dic_measurements[lib+side+"_delta"][-1]
            dic_measurements[lib+side+"_delta"] = np.row_stack((dic_measurements[lib+side+"_delta"], newDelta))
            
            usedDelta = deltaFilter(dic_measurements[lib+side+"_delta"])
            
            deltaEstimations.append(usedDelta)
            quat_corrected = applyHeading(deltaEstimations,dic_measurements[lib+side+"_quat"][-1,:]).squeeze()            
            dic_measurements[lib+side+"_quat_corr"] = np.row_stack((dic_measurements[lib+side+"_quat_corr"], quat_corrected))
    if estimateNewDelta:
      estimateNewDelta = not estimateNewDelta 

    return estimateNewDelta
    
def initOriEstIMU():
    rate = 40
    tauAcc = 3
    tauMag = 3
    zeta = 0
    useMeasRating = 1

    return OriEstIMU(rate, tauAcc, tauMag, zeta, useMeasRating)

def calcImuQuat(acc,gyr,OriEstIMU,rate = 40):
    mag = np.zeros_like(acc)
    acc = acc.astype("double")
    gyr = gyr.astype("double")
    mag = mag.astype("double")
    quat, bias, error = OriEstIMU.update(acc, gyr, mag)
    
    return quat

def main():
    print(argparse)
    filename = 'IMU_' + time.strftime("%Y%m%d_%H%M%S") + '.txt'

    parser = argparse.ArgumentParser(description='BLE IMU raw data dumping tool.')
   
    parser.add_argument('imus', metavar='IMU', nargs='+', help='last 6 digits of IMU mac addresses')
    parser.add_argument('-receiver', default='xsense', help='Receiver type (xsense/sensorstim) (default: %(default))')
    
    parser.add_argument('--prefix', default='94:54:93', help='prefix for mac addresses (default: %(default)s)')
    parser.add_argument('-f', '--freq', default='FREQ40Hz', help='sending frequency (default: %(default)s)') #TODO in abhängigkeit von xsense und sensorstim bringen (100Hz / 10Hz)
    parser.add_argument('-s', '--state', default='OriestWithoutMagOnly', help='measurement state (default: %(default)s)')
    parser.add_argument('-o', '--out', default=filename, help='output filename (default: %(default)s)')
    parser.add_argument('-v', '--verbose', action='store_true', help='enables debug output in IMUSensor class')
    args = parser.parse_args()
    print(args.receiver)
    if "sensorstim" == args.receiver:
      from ssn_ble.parse import parseImuLog
      from ssn_ble.imu import IMUSensor
      from ssn_ble.utils import macFromString, macToString, imuName

      freq = getattr(IMUSensor, args.freq)
      state = getattr(IMUSensor, args.state)
    else:
      freq = "FREQ40Hz"
    #out = open(args.out, 'w')
    print('writing received data to', args.out)
    
    
    imus = {}
    imuNames = []
    for i, suffix in enumerate(args.imus):
        if "xsense" == args.receiver:
          imuNames.append(suffix)
        elif "sensorstim" == args.receiver:
          mac = macFromString(args.prefix + suffix)        
          imus[imuName(i, mac)] = IMUSensor(macToString(mac))
          imuNames.append(imuName(i, mac))
    
    if "xsense" == args.receiver:
      from csg_xsens_receiver.imu import XsensMTW

      xsens = XsensMTW(40, 19)
      if not xsens.init():
        print('Warning: init() returned false')
        
      if not xsens.connect(imuNames, 10000):
        print('Warning: connect() returned false')
      
                
    elif "sensorstim" == args.receiver:
      for name, imu in imus.items():
          print('connecting to', name)
          if args.verbose:
              imu.set_debug_output_enabled(False)
          imu.connect(10)
          imu.start_notifications()  
          imu.stop_measurement()

      for name, imu in imus.items():
          print('starting measurement for', name)
          imu.start_measurement(state, freq)
          imu.set_log_enabled(False)

    #stats = Stats(sorted(imus.keys()))
    _buffer = Buffer(imuNames)

    ###
    dic_map_sensor2bodypart = dict()
    dic_map_sensor2OriEstIMU = dict()
    estimateNewDelta = True
    for idx, bodypart in enumerate(['h_quat', 'tl_quat', 'tr_quat', 'sl_quat', 'sr_quat', 'fl_quat', 'fr_quat']):
      if idx < len(imuNames):
        dic_map_sensor2bodypart[imuNames[idx]] = bodypart
        dic_map_sensor2OriEstIMU[imuNames[idx]] = initOriEstIMU()
      else:
        dic_map_sensor2bodypart["xxxxx"+str(idx)] = bodypart
      
    dic_measurements ={
                        'h_quat': np.array([[1,0,0,0],[1,0,0,0]]),
                        'tr_quat': np.array([[1,0,0,0],[1,0,0,0]]),
                        'tl_quat': np.array([[1,0,0,0],[1,0,0,0]]),
                        'sr_quat': np.array([[1,0,0,0],[1,0,0,0]]),
                        'sl_quat': np.array([[1,0,0,0],[1,0,0,0]]),
                        'fr_quat': np.array([[1,0,0,0],[1,0,0,0]]),
                        'fl_quat': np.array([[1,0,0,0],[1,0,0,0]]),  
                        'tr_delta': np.array([0]),
                        'tl_delta': np.array([0]),
                        'sr_delta': np.array([0]),
                        'sl_delta': np.array([0]),
                        'fr_delta': np.array([0]),
                        'fl_delta': np.array([0]),
                        'tr_quat_corr': np.array([[1,0,0,0],[1,0,0,0]]),
                        'tl_quat_corr': np.array([[1,0,0,0],[1,0,0,0]]),
                        'sr_quat_corr': np.array([[1,0,0,0],[1,0,0,0]]),
                        'sl_quat_corr': np.array([[1,0,0,0],[1,0,0,0]]),
                        'fr_quat_corr': np.array([[1,0,0,0],[1,0,0,0]]),
                        'fl_quat_corr': np.array([[1,0,0,0],[1,0,0,0]]),   
                        }
    try:
        interval_length = 2/float(args.freq[4:-2])
        rate = int(args.freq[4:-2])
        time.sleep(1)
        idx = 0
        
        
        
        corr_quat = dict()
            
        while True:
            idx += 1
            start_interval_time = time.time()
            if "xsense" == args.receiver and xsens.pollData():
              data = xsens.getData()
              
              for i, sensorData in enumerate(data):
                for i_test, package in enumerate(sensorData):
                  bodypart = dic_map_sensor2bodypart[package["deviceName"].decode("utf-8")]
                  
                  acc = np.array([package["acc_x"],package["acc_y"],package["acc_z"]])
                  gyr = np.array([package["gyro_x"],package["gyro_y"],package["gyro_z"]]) 
                  
                  [acc_x,acc_y,acc_z] = acc.tolist()
                  [gyr_x,gyr_y,gyr_z] = gyr.tolist()
                  if bodypart == "h_quat": # alignment hack for torso 
                    print("hip")
                    acc = np.array([-acc_y,-acc_x,-acc_z])
                    gyr = np.array([-gyr_y,-gyr_x,-gyr_z])                  
                  else:
                    acc = np.array([-acc_y,acc_x,acc_z])
                    gyr = np.array([-gyr_y,gyr_x,gyr_z])
                 
          
                  if not package["deviceName"].decode("utf-8") in corr_quat.keys():
                    for each in range(10):
                      quat = calcImuQuat(acc,gyr,dic_map_sensor2OriEstIMU[package["deviceName"].decode("utf-8")])
                          
                    corr_quat[package["deviceName"].decode("utf-8")] = np.array([[1,0,0,0]])
                    
                    quat = multiplyQuat(np.array([quat]), np.array([[0.7071,-0.7071,0,  0]]))
                    
                    quat  = multiplyQuat(np.array(quat), np.array([[0.707,0,0,0.707]]))
                    dic_measurements[bodypart] = np.row_stack([quat,quat])
                    
                  else:
                    quat = calcImuQuat(acc,gyr,dic_map_sensor2OriEstIMU[package["deviceName"].decode("utf-8")])        
                    quat = multiplyQuat(np.array(quat), np.array([[0.7071,-0.7071,0,  0]]))
                    quat  = multiplyQuat(np.array(quat), np.array([[0.707,0,0,0.707]]))
                    dic_measurements[bodypart] = np.row_stack((dic_measurements[bodypart],quat.squeeze()))
                    
            elif "sensorstim" == args.receiver:
              for i, (name, imu) in enumerate(imus.items()):
                  data,t =imu.getOrientation()
                  bodypart = dic_map_sensor2bodypart[name.split('_')[-1]]
                  dic_measurements[bodypart] = np.row_stack((dic_measurements[bodypart],data))
            
            if not idx%5:
              estimateNewDelta = not estimateNewDelta
            estimateNewDelta  = deltaEstimation(dic_measurements ,40, estimateNewDelta)

    
            
            send_directly(**dic_measurements)
            sleep_time = max(interval_length-(time.time()-start_interval_time),0)
            #print('sleeping for %.3f seconds'%(sleep_time))
            time.sleep(sleep_time)
            
            #data = dict()
            for each in dic_measurements:
              if dic_measurements[each].shape[0]>1000:  
                dic_measurements[each] = dic_measurements[each][-1000:,:]
              #data[each] = dic_measurements[each]
                
            #if dic_measurements["h_quat"].shape[0]>5000:  
            #  data.save("data.mat")
            #  exit()
            
    except KeyboardInterrupt:
        print('\nctrl+c pressed. stopping...')
        if "xsense" == args.receiver and xsens.pollData():
          xsens.disconnect()
        elif "sensorstim" == args.receiver:
            
          for name, imu in imus.items():
              print('disconnecting', name)
              imu.disconnect()
import psutil
mwp = measurement_ws_provider(ip = 'localhost', port = 8080)
if __name__== '__main__':
    
    
    
    #with open('default.json') as file:
    #    default_json_data = json.load(file)
    #print(default_json_data.keys())
    main()
    
    
   
