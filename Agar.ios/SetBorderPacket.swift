//
//  SetBorderPacket.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 13-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import Foundation

class SetBorderPacket: Packet
{
    var leftPosition: Float64 = 0
    var bottomPosition: Float64 = 0
    var rightPosition: Float64 = 0
    var topPosition: Float64 = 0
    
    override init(data: NSData)
    {
        super.init(data: data)
        self.packetId = .SetBorder
        
        self.leftPosition = readFloat64()
        self.bottomPosition = readFloat64()
        self.rightPosition = readFloat64()
        self.topPosition = readFloat64()
    }
}