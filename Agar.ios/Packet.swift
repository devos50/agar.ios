//
//  Packet.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 13-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import Foundation

enum PacketType: UInt8
{
    case None = 2
    case SetNickname = 0
    case UpdateNodes = 16
    case AddNode = 32
    case UpdateLeaderboard = 49
    case SetBorder = 64
    case ResetConnection = 255
}

class Packet
{
    var data: NSData
    var readingOffset = 1
    var packetId: PacketType = .None
    
    init(data: NSData)
    {
        self.data = data
    }
    
    func readUint8() -> UInt8
    {
        var uint = UInt8()
        data.getBytes(&uint, range: NSMakeRange(readingOffset, 1))
        readingOffset++
        return uint
    }
    
    func readUint16() -> UInt16
    {
        var uint = UInt16()
        data.getBytes(&uint, range: NSMakeRange(readingOffset, 2))
        readingOffset += 2
        return uint
    }
    
    func readUint32() -> UInt32
    {
        var uint = UInt32()
        data.getBytes(&uint, range: NSMakeRange(readingOffset, 4))
        readingOffset += 4
        return uint
    }
    
    func readFloat32() -> Float32
    {
        var floatval = Float32()
        data.getBytes(&floatval, range: NSMakeRange(readingOffset, 4))
        readingOffset += 4
        return floatval
    }
    
    func readFloat64() -> Float64
    {
        var floatval = Float64()
        data.getBytes(&floatval, range: NSMakeRange(readingOffset, 8))
        readingOffset += 8
        return floatval
    }
    
    func readString() -> NSString
    {
        var nameLength = 0
        while true
        {
            let v = readUint16()
            nameLength += 2
            if(v == 0) { break }
        }
        
        let subData = data.subdataWithRange(NSMakeRange(readingOffset - nameLength, nameLength))
        return NSString(data: subData, encoding: NSUTF16LittleEndianStringEncoding)!
    }
}