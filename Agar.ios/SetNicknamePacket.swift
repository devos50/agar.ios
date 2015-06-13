//
//  SetNicknamePacket.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 13-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import Foundation

class SetNicknamePacket : Packet
{
    init()
    {
        var zeroValue: UInt8 = 0
        let data = NSData(bytes: &zeroValue, length: 1)
        
        super.init(data: data)
        self.packetId = .SetNickname
        
    }
}