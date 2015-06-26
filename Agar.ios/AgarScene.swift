//
//  AgarScene.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 14-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import Foundation
import SpriteKit

class AgarScene : SKScene
{
    private var playerCells = [Node]()
    private var nodesOnScreen = [UInt32]()
    
    private var canvas = CGRectZero
    private var yourPosition = CGPointZero
    
    override init(size: CGSize)
    {
        super.init(size: size)
        self.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handlePacket(packet: Packet)
    {
        if packet is AddNodePacket
        {
            let addNodePacket = packet as! AddNodePacket
            yourNodeId = addNodePacket.nodeId
            println("Your node id: \(yourNodeId)")
        }
        else if packet is ClearNodesPacket
        {
            playerCells = []
            nodesOnScreen = []
        }
        else if packet is SetBorderPacket
        {
            let setBorderPacket = packet as! SetBorderPacket
            canvas = CGRectMake(0.0, 0.0, CGFloat(setBorderPacket.rightPosition), CGFloat(setBorderPacket.topPosition))
        }
        else if packet is UpdateNodesPacket
        {
            let updateNodesPacket = packet as! UpdateNodesPacket
            let nodes = updateNodesPacket.nodes
            
            // remove some of the nodes from the field
            for nodeIdToRemove in updateNodesPacket.nodesToDestroy
            {
                if nodeIdToRemove == yourNodeId
                {
                    println("DEATH")
                }
                
                if nodesOnScreen[nodeIdToRemove] != nil
                {
                    let nodeToRemove = nodesOnScreen[nodeIdToRemove]
                    nodeToRemove!.removeFromParent()
                    nodesOnScreen[nodeIdToRemove] = nil
                }
            }
            
            // find you
            for node in nodes
            {
                if node.nodeId == yourNodeId
                {
                    yourPosition = CGPointMake(CGFloat(node.x), CGFloat(node.y))
                }
            }
            
            let leftUnder = CGPointMake(yourPosition.x - 512, yourPosition.y - 512)
            
            // iterate over nodes
            for node in nodes
            {
                //println("node position: \(yourPosition.x), \(yourPosition.y)")
                let nodeId = node.nodeId
                if nodesOnScreen[nodeId] == nil
                {
                    // we have a new node - create a new SKShapeNode and add it to the list
                    let shapeNode = SKShapeNode(circleOfRadius: CGFloat(node.size) / 2.0)
                    
                    let nodePosition = CGPointMake(CGFloat(node.x), CGFloat(node.y))
                    let relativePosition = CGPointMake(nodePosition.x - leftUnder.x, nodePosition.y - leftUnder.y)
                    
                    shapeNode.position = CGPointMake(CGFloat(relativePosition.x) / 1024.0 * self.frame.size.width, CGFloat(relativePosition.y) / 1024.0 * self.frame.size.height)
                    shapeNode.fillColor = SKColor(red: CGFloat(node.redColor) / 255.0, green: CGFloat(node.greenColor) / 255.0, blue: CGFloat(node.blueColor) / 255.0, alpha: 1.0)
                    self.addChild(shapeNode)
                    nodesOnScreen[nodeId] = shapeNode
                }
                else
                {
                    // update the position of this node
                    let shapeNode = nodesOnScreen[nodeId]
                    let nodePosition = CGPointMake(CGFloat(node.x), CGFloat(node.y))
                    let relativePosition = CGPointMake(nodePosition.x - leftUnder.x, nodePosition.y - leftUnder.y)
                    
                    shapeNode!.position = CGPointMake(CGFloat(relativePosition.x) / 1024.0 * self.frame.size.width, CGFloat(relativePosition.y) / 1024.0 * self.frame.size.height)
                }
            }
        }
    }
}