#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 12:52:04 2019

@author: fabi
"""
import asyncio
import websockets
import argparse


def parse_args():
    parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('--ip' , help="specify ip of websocket server",
                        type=str)
    parser.add_argument('--port' , help="specify port of websocket server",
                        type=int)
    
    args = parser.parse_args()
    if args.ip is not None:
        ip = args.ip
    else:
        ip = 'localhost'

    if args.port is not None:
        port = args.port
    else:
        port = 0
    
    return ip,port


class websocket_server():
    def  __init__(self,ip, port):
        self.USERS = set()
        self.ip = ip
        self.port = port
    
    async def broadcast(self,msg, ws):
        msg_list = []
        for user in self.USERS:
            if user != ws:
                msg_list.append(user.send(msg))
        await asyncio.wait(msg_list)
    
    
    
    def register(self,websocket):
        self.USERS.add(websocket)
    
    
    def unregister(self,websocket):
        self.USERS.remove(websocket)
    
    
    async def accept_con(self,websocket, path):     
        self.register(websocket)
        try:
            async for message in websocket:
                if len(self.USERS)>1:
                    await self.broadcast(message,websocket)
    
        finally:
            self.unregister(websocket)
    
    def start_server(self):
        start_server = websockets.serve(self.accept_con, self.ip, self.port)
        asyncio.get_event_loop().run_until_complete(start_server)
        print('Websocket server started at: ws://%s:%d'%(self.ip,self.port))
        asyncio.get_event_loop().run_forever()
            
    


if __name__== '__main__':
    ip, port = parse_args()
    ws_server = websocket_server(ip,port)
    ws_server.start_server()
    


