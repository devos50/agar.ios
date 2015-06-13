//
//  ViewController.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 13-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    private var socket: WebSocket?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:1234", path: "/")!)
        socket.delegate = self
        socket.connect()
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
        println("type: \(packetId)")
        
        if packetId == PacketType.UpdateNodes.rawValue { let updateNodesPacket = UpdateNodesPacket(data: data) }
        else if packetId == PacketType.AddNode.rawValue { let addNodePacket = AddNodePacket(data: data) }
        else if packetId == PacketType.UpdateLeaderboard.rawValue { let updateLeaderboardPacket = UpdateLeaderboardPacket(data: data) }
        else if packetId == PacketType.SetBorder.rawValue { let setBorderPacket = SetBorderPacket(data: data) }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String)
    {
        println("did receive message")
    }
}