//
//  ResetConnectionPacket.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 13-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import Foundation

class ResetConnectionPacket : Packet
{
    init()
    {
        var value: UInt8 = 255
        let data = NSData(bytes: &value, length: 1)
        
        super.init(data: data)
        self.packetId = .ResetConnection
        
    }
}