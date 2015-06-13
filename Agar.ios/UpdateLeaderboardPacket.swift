//
//  UpdateLeaderboardPacket.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 13-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import Foundation

class UpdateLeaderboardPacket: Packet
{
    var leaderboard = [(UInt32, NSString)]()
    
    override init(data: NSData)
    {
        super.init(data: data)
        self.packetId = .UpdateLeaderboard
        
        let leaderboardItems = readUint32()
        for i in 0..<leaderboardItems
        {
            let nodeId = readUint32()
            let nodeName = readString()
            leaderboard.append((nodeId, nodeName))
        }
    }
}