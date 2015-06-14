//
//  MoveMousePacket.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 14-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import Foundation

class MoveMousePacket : Packet
{
    init(var mouseX: Float64, var mouseY: Float64)
    {
        var packetId: UInt8 = PacketType.UpdateNodes.rawValue
        let data = NSData(bytes: &packetId, length: 1)
        
        super.init(data: data)
        self.packetId = PacketType.UpdateNodes // also 16
        
        var zeroValue: UInt32 = 0
        let mutableData = data.mutableCopy() as! NSMutableData
        mutableData.appendBytes(&mouseX, length: 8)
        mutableData.appendBytes(&mouseY, length: 8)
        mutableData.appendBytes(&zeroValue, length: 4)
        self.data = mutableData.copy() as! NSData
    }
}