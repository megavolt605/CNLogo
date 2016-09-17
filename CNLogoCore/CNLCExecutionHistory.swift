//
//  CNLCExecutionHistory.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 20/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import CoreGraphics

open class CNLCExecutionHistory {
    
    open var history: [CNLCExecutionHistoryItem] = []
    
    open func append(_ itemType: CNLCExecutionHistoryItemType, block: CNLCBlock?) {
        if let playerState = CNLCEnviroment.defaultEnviroment.currentProgram?.player.state.snapshot() {
            let item = CNLCExecutionHistoryItem(type: itemType, playerState: playerState, block: block)
            history.append(item)
        }
    }
    
    open func clear() -> CNLCValue {
        history = []
        return .unknown
    }
    
}
