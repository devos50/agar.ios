//
//  ViewController.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 13-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController
{
    private var socket: WebSocket?
    private var agarScene: AgarScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:1234", path: "/")!)
        socket.delegate = self
        socket.connect()
        
        // add a SKView
        let screenSize = UIScreen.mainScreen().bounds
        let skView = SKView(frame: CGRectMake(0, 100, screenSize.width, screenSize.width))
        skView.showsFPS = true
        skView.layer.borderWidth = 1.0
        skView.layer.borderColor = UIColor.blackColor().CGColor
        self.view.addSubview(skView)
        
        agarScene = AgarScene(size: skView.bounds.size)
        agarScene?.scaleMode = SKSceneScaleMode.AspectFill
        skView.presentScene(agarScene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: WebSocketDelegate
{
    func websocketDidConnect(socket: WebSocket)
    {
        println("connected")
        
        // reset connection
        let resetConnectionPacket = ResetConnectionPacket()
        socket.writeData(resetConnectionPacket.data)
        
        // send nickname
        let setNicknamePacket = SetNicknamePacket()
        socket.writeData(setNicknamePacket.data)
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?)
    {
        println("disconnected")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData)
    {
        let length = data.length / sizeof(UInt8)
        
        var packetId = UInt8()
        data.getBytes(&packetId, length: sizeof(UInt8))
        
        var packet: Packet?
        if packetId == PacketType.UpdateNodes.rawValue { packet = UpdateNodesPacket(data: data) }
        else if packetId == PacketType.AddNode.rawValue { packet = AddNodePacket(data: data) }
        else if packetId == PacketType.UpdateLeaderboard.rawValue { packet = UpdateLeaderboardPacket(data: data) }
        else if packetId == PacketType.SetBorder.rawValue { packet = SetBorderPacket(data: data) }
        
        agarScene?.handlePacket(packet!)
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String)
    {
        println("did receive message")
    }
}