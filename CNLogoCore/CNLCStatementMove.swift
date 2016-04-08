//
//  CNLCStatementMove.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Number. All rights reserved.
//

import Foundation

/// Description:    Move player forward from current position, with current angle
///                 Nothing is drawn
///                 Preserve tail state
/// Arguments:      Distance(Numeric)
public class CNLCStatementMove: CNLCStatementForward {
    
    override public var identifier: String {
        return "MOVE"
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        
        var result = super.execute(parameters)
        if result.isError { return result }
        
        if let player = CNLCEnviroment.defaultEnviroment.currentProgram?.player {
            let tailDown = player.state.tailDown
            if tailDown {
                result = player.tailDown(false, fromBlock: self)
                if result.isError { return result }
            }
            player.moveForward(executableParameters.first!.variableValue, fromBlock: self)
            if tailDown {
                result = player.tailDown(true, fromBlock: self)
                if result.isError { return result }
            }
        }
        return result
    }
    
}
