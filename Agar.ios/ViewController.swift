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
    private var agarScene: AgarScene?
    private var leaderboardView: LeaderboardView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let socket = SRWebSocket(URL: NSURL(string: "ws://127.0.0.1:443"))
        socket.delegate = self
        socket.open()
        
        // add a SKView
        let screenSize = UIScreen.mainScreen().bounds
        let skView = SKView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
        skView.showsFPS = true
        self.view.addSubview(skView)
        
        agarScene = AgarScene(size: skView.bounds.size)
        agarScene?.scaleMode = SKSceneScaleMode.AspectFill
        skView.presentScene(agarScene)
        
        // add leaderboard
        leaderboardView = LeaderboardView(frame: CGRectMake(screenSize.width - 110, 10, 100, 142))
        leaderboardView?.alpha = 0.7
        skView.addSubview(leaderboardView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: SRWebSocketDelegate
{
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        println("CLOSED")
    }
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        println("DID OPEN")
        
        // reset connection
        let resetConnectionPacket = ResetConnectionPacket()
        webSocket.send(resetConnectionPacket.data)
        
        // send nickname
        let setNicknamePacket = SetNicknamePacket()
        webSocket.send(setNicknamePacket.data)
        
        // send move mouse packet
        //let moveMousePacket = MoveMousePacket(mouseX: 10, mouseY: 10)
        //webSocket.send(moveMousePacket.data)
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        println("FAILED: \(error)")
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        let data = message as! NSData
        
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
        else if packetId == PacketType.ClearNodes.rawValue { packet = ClearNodesPacket(data: data) }
        
        agarScene?.handlePacket(packet!)
    }
}