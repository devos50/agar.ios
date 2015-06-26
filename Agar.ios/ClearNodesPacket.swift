//
//  ClearNodesPacket.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 26-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import Foundation

class ClearNodesPacket: Packet
{
    override init(data: NSData)
    {
        super.init(data: data)
        self.packetId = .ClearNodes
    }
}