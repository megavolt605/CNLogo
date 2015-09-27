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
    
    func append(itemType: CNExecutionHistoryItemType, block: CNBlock?) {
        let playerState = program.player.state.snapshot()
        let item = CNExecutionHistoryItem(type: itemType, playerState: playerState, block: block)
        history.append(item)
    }
    
    func clear() {
        history = []
    }
    
}

// TODO: add call stack snapshot with parameters and variables
struct CNExecutionHistoryItem {

    var type: CNExecutionHistoryItemType
    var playerState: CNPlayerState
    weak var block: CNBlock?

    var description: String {
        switch type {
        case .Clear: return "Clear"
        case let .Move(_, toPoint, _): return String(format: "Forward to %.2f - %.2f", toPoint.x, toPoint.y)
        case let .Rotate(_, toAngle): return String(format: "Rotate to %.2f", toAngle)
        case let .TailState(_, toState): return "Tail down \(toState)"
        case .Color: return "Color"
        case let .Width(_, toWidth): return String(format: "Width %.2f", toWidth)
        case let .Scale(_, toScale): return String(format: "Scale %.2f", toScale)
        case .Step: return "Step"
        case .StepIn: return "Step In"
        case .StepOut: return "Step Out"
        case let .Print(value): return "Print '\(value)'"
        }
    }
    
}

enum CNExecutionHistoryItemType {
    case Clear
    case Move(fromPoint: CGPoint, toPoint: CGPoint, forward: Bool)
    case Rotate(fromAngle: CGFloat, toAngle: CGFloat)
    case TailState(fromState: Bool, toState: Bool)
    case Color(fromColor: CGColor, toColor: CGColor)
    case Width(fromWidth: CGFloat, toWidth: CGFloat)
    case Scale(fromScale: CGFloat, toScale: CGFloat)
    case Step, StepIn, StepOut
    case Print(value: String)
}