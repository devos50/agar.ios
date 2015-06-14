//
//  NodePacket.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 13-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import Foundation

class UpdateNodesPacket: Packet
{
    var nodesToDestroy: UInt16 = 0
    var nodes = [Node]()
    var activeNodes = [UInt32]()
    
    override init(data: NSData)
    {
        super.init(data: data)
        self.packetId = .UpdateNodes
        
        // read packet
        nodesToDestroy = readUint16()
        for i in 0..<nodesToDestroy
        {
            let nodeKiller = readUint32()
            let nodeId = readUint32()
        }
        
        while true
        {
            // iterate over all nodes available
            let nodeId = readUint32()
            if nodeId == 0 { break; }
            readNodeData(nodeId)
        }
    }
    
    func readNodeData(nodeId: UInt32)
    {
        let newNode = Node(nodeId: nodeId, x: readUint16(), y: readUint16(), size: readUint16(), redColor: readUint8(), greenColor: readUint8(), blueColor: readUint8())
        let flagsValue = readUint8()
        
        newNode.name = readString()
        nodes.append(newNode)
    }
}