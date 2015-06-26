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
    var nodes = [Node]()
    var nodesToDestroy = [UInt32]()
    
    override init(data: NSData)
    {
        super.init(data: data)
        self.packetId = .UpdateNodes
        
        // read packet
        let numNodesToDestroy = readUint16()
        for i in 0..<numNodesToDestroy
        {
            let nodeKiller = readUint32()
            let nodeId = readUint32()
            nodesToDestroy.append(nodeId)
        }
        
        while true
        {
            // iterate over all nodes available
            let nodeId = readUint32()
            if nodeId == 0 { break }
            readNodeData(nodeId)
        }
        
        println("-----")
    }
    
    func readNodeData(nodeId: UInt32)
    {
        let newNode = Node(nodeId: nodeId, x: readUint16(), y: readUint16(), size: readUint16(), redColor: readUint8(), greenColor: readUint8(), blueColor: readUint8())
        let flagsValue = readUint8()
        
        newNode.name = readString()
        println("update node \(newNode.nodeId) (\(newNode.name)) to \(newNode.x), \(newNode.y)")
        nodes.append(newNode)
    }
}