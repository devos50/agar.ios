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
    private var leaderboardView: LeaderboardView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:1234", path: "/")!)
        socket.delegate = self
        socket.connect()
        
        // add a SKView
        let screenSize = UIScreen.mainScreen().bounds
        let skView = SKView(frame: CGRectMake(0, 0, screenSize.height, screenSize.height))
        skView.showsFPS = true
        skView.layer.borderWidth = 1.0
        skView.layer.borderColor = UIColor.blackColor().CGColor
        self.view.addSubview(skView)
        
        agarScene = AgarScene(size: skView.bounds.size)
        agarScene?.scaleMode = SKSceneScaleMode.AspectFill
        skView.presentScene(agarScene)
        
        // add leaderboard
        leaderboardView = LeaderboardView(frame: CGRectMake(screenSize.height - 90, 10, 80, 142))
        leaderboardView?.alpha = 0.7
        skView.addSubview(leaderboardView!)
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
        
        // send move mouse packet
        let moveMousePacket = MoveMousePacket(mouseX: 0, mouseY: 0)
        socket.writeData(moveMousePacket.data)
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
        
        // println("packet id: \(packetId)")
        
        var packet: Packet?
        if packetId == PacketType.UpdateNodes.rawValue { packet = UpdateNodesPacket(data: data) }
        else if packetId == PacketType.AddNode.rawValue { packet = AddNodePacket(data: data) }
        else if packetId == PacketType.UpdateLeaderboard.rawValue
        {
            packet = UpdateLeaderboardPacket(data: data)
            leaderboardView?.updateLeaderboard(packet as! UpdateLeaderboardPacket)
            return
        }
        else if packetId == PacketType.SetBorder.rawValue { packet = SetBorderPacket(data: data) }
        
        agarScene?.handlePacket(packet!)
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String)
    {
        println("did receive message")
    }
}