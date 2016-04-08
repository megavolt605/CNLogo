//
//  CNLCExecutionHistory.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 20/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import CoreGraphics

public class CNLCExecutionHistory {
    
    public var history: [CNLCExecutionHistoryItem] = []
    
    public func append(itemType: CNLCExecutionHistoryItemType, block: CNLCBlock?) {
        if let playerState = CNLCEnviroment.defaultEnviroment.currentProgram?.player.state.snapshot() {
            let item = CNLCExecutionHistoryItem(type: itemType, playerState: playerState, block: block)
            history.append(item)
        }
    }
    
    public func clear() -> CNLCValue {
        history = []
        return .Unknown
    }
    
}
