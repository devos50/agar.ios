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
    private var nodes = [Node]()
    private var canvas = CGRectZero
    
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
            
        }
        else if packet is SetBorderPacket
        {
            let setBorderPacket = packet as! SetBorderPacket
            canvas = CGRectMake(0.0, 0.0, CGFloat(setBorderPacket.rightPosition), CGFloat(setBorderPacket.topPosition))
        }
        else if packet is UpdateNodesPacket
        {
            let updateNodesPacket = packet as! UpdateNodesPacket
            nodes = updateNodesPacket.nodes
            
            // find you
            var myNode: Node?
            for node in nodes
            {
                if node.name == "test" { myNode = node; break }
            }
            
            if myNode == nil { return }
            
            let leftUnder = CGPointMake(CGFloat(myNode!.x) - 1024, CGFloat(myNode!.y) - 1024)
            
            // draw all nodes
            self.removeAllChildren()
            for node in nodes
            {
                let shapeNode = SKShapeNode(circleOfRadius: CGFloat(node.size) / 5)
                
                let nodePosition = CGPointMake(CGFloat(node.x), CGFloat(node.y))
                let relativePosition = CGPointMake(nodePosition.x - leftUnder.x, nodePosition.y - leftUnder.y)
                
                shapeNode.position = CGPointMake(CGFloat(relativePosition.x) / 2048.0 * self.frame.size.width, CGFloat(relativePosition.y) / 2048.0 * self.frame.size.width)
                shapeNode.fillColor = SKColor(red: CGFloat(node.redColor) / 255.0, green: CGFloat(node.greenColor) / 255.0, blue: CGFloat(node.blueColor) / 255.0, alpha: 1.0)
                self.addChild(shapeNode)
            }
        }
    }
}