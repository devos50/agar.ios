//
//  Node.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 13-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import Foundation

class Node
{
    var nodeId: UInt32
    var x: UInt16
    var y: UInt16
    var size: UInt16
    var redColor: UInt8
    var greenColor: UInt8
    var blueColor: UInt8
    var flags = [UInt8]()
    var name: NSString = ""
    
    init(nodeId: UInt32, x: UInt16, y: UInt16, size: UInt16, redColor: UInt8, greenColor: UInt8, blueColor: UInt8)
    {
        self.nodeId = nodeId
        self.x = x
        self.y = y
        self.size = size
        self.redColor = redColor
        self.greenColor = greenColor
        self.blueColor = blueColor
    }
}