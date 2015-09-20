//
//  CNExecutionHistory.swift
//  CNLogo
//
//  Created by Igor Smirnov on 20/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import CoreGraphics

class CNExecutionHistory {
    
    var history: [CNExecutionHistoryItem] = []
    
    func append(itemType: CNExecutionHistoryItemType) {
        let playerState = program.player.state.snapshot()
        history.append(CNExecutionHistoryItem(type: itemType, playerState: playerState))
    }
    
    func clear() {
        history = []
    }
    
}

// TODO: add call stack snapshot with parameters and variables
struct CNExecutionHistoryItem {

    var type: CNExecutionHistoryItemType
    var playerState: CNPlayerState
    
}

enum CNExecutionHistoryItemType {
    case Clear
    case Move(fromPoint: CGPoint, toPoint: CGPoint, forward: Bool)
    case Rotate(fromAngle: CGFloat, toAngle: CGFloat)
    case TailState(fromState: Bool, toState: Bool)
    case Color(fromColor: CGColor, toColor: CGColor)
    case Width(fromWidth: CGFloat, toWidth: CGFloat)
}