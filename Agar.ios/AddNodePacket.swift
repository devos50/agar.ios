//
//  AddNodePacket.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 13-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import Foundation

class AddNodePacket: Packet
{
    var nodeId: UInt32 = 0
    
    override init(data: NSData)
    {
        super.init(data: data)
        self.packetId = .AddNode
        
        nodeId = readUint32()
    }
}