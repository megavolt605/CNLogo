//
//  CNLCStatementDraw.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

/// Description:    Move player forward from current position, with current angle
///                 Movement is drawn as line with current color and width
///                 Preserve tail state
/// Arguments:      Distance(Numeric)
open class CNLCStatementDraw: CNLCStatementForward {
    
    override open var identifier: String {
        return "DRAW"
    }
    
    override open func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        
        var result = super.execute(parameters)
        if result.isError { return result }
        
        if let player = CNLCEnviroment.defaultEnviroment.currentProgram?.player {
            let tailDown = player.state.tailDown
            if !tailDown {
                result = player.tailDown(true, fromBlock: self)
                if result.isError { return result }
            }
            result = player.moveForward(executableParameters.first!.variableValue, fromBlock: self)
            if result.isError { return result }
            if !tailDown {
                result = player.tailDown(false, fromBlock: self)
                if result.isError { return result }
            }
        }
        return result
    }
    
}

