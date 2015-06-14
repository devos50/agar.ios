//
//  LeaderboardView.swift
//  Agar.ios
//
//  Created by Martijn de Vos on 14-06-15.
//  Copyright (c) 2015 martijndevos. All rights reserved.
//

import Foundation
import UIKit

class LeaderboardView: UIView
{
    private var leaderboardLabel: UILabel?
    private var entries = [UILabel]()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        
        addLeaderboardLabel()
    }
    
    func addLeaderboardLabel()
    {
        leaderboardLabel = UILabel(frame: CGRectMake(0, 2, self.frame.size.width, 16))
        leaderboardLabel?.text = "Leaderboard"
        leaderboardLabel?.textColor = UIColor.whiteColor()
        leaderboardLabel?.font = UIFont.boldSystemFontOfSize(12)
        leaderboardLabel?.textAlignment = .Center
        self.addSubview(leaderboardLabel!)
    }
    
    func updateLeaderboard(packet: UpdateLeaderboardPacket)
    {
        for label in entries { label.removeFromSuperview() }
        entries = [UILabel]()
        
        var c = 0
        for (nodeId, nodeName) in packet.leaderboard
        {
            let leaderboardEntryLabel = UILabel(frame: CGRectMake(0, CGFloat(17 + 12 * c), self.frame.size.width, 15))
            leaderboardEntryLabel.text = "\(c + 1). \(nodeName as String)"
            leaderboardEntryLabel.textColor = UIColor.whiteColor()
            leaderboardEntryLabel.font = UIFont.boldSystemFontOfSize(10)
            leaderboardEntryLabel.textAlignment = .Center
            
            entries.append(leaderboardEntryLabel)
            self.addSubview(leaderboardEntryLabel)
            c++
        }
        
        
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}