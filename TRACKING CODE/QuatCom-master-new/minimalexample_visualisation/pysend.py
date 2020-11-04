#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 11:59:55 2019

@author: fabi
"""

import json
import asyncio
import websockets
import time



def get_msg_dic(i, dic):
    msg_dic = {}
    for key in dic.keys():
        if isinstance(dic[key][i], list):
            if key == 'hip':
                key_new = 'hip_magQuat'
                msg_dic[key] = dic[key][i]
                msg_dic[key_new] = dic[key][i]
            else:
                msg_dic[key] = dic[key][i]
        else:
            msg_dic[key] = dic[key][i]
        
    return msg_dic

def get_msg_dic_realtime( dic):
    msg_dic = {}
    for key in dic.keys():
        if isinstance(dic[key], list):
            if key == 'hip':
                key_new = 'hip_magQuat'
                msg_dic[key] = dic[key]
                msg_dic[key_new] = dic[key]
            else:
                msg_dic[key] = dic[key]
        else:
            msg_dic[key] = dic[key]
        
    return msg_dic



class measurement_ws_provider():
    def __init__(self, ip, port):
        
        self.ip = ip
        self.port = port
        
        self.uri = 'ws://%s:%d'%(self.ip,self.port)
        asyncio.get_event_loop().run_until_complete(self.connect())
    
    async def connect(self):    
        self.ws = websockets.connect(self.uri)
    
    async def send(self):
        if not self.msg_sent:
            async with self.ws as websocket:
                await websocket.send(self.msg)
            self.msg_sent = True
        else:
            print('Message has already been send.')
    
    def set_msg(self,msg):
        self.msg = msg
        self.msg_sent = False

if __name__== '__main__':
    
    with open('default.json') as file:
        default_json_data = json.load(file)
    
    
    mwp = measurement_ws_provider(ip = 'localhost', port = 8080)
    
    for i in range(len(default_json_data[list(default_json_data.keys())[0]])):
        msg = get_msg_dic(i, default_json_data)
        mwp.set_msg(json.dumps(msg))
        asyncio.get_event_loop().run_until_complete(mwp.send())
        time.sleep(0.1)
