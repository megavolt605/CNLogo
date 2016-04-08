//
//  CNLCProgram.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public class CNLCProgram: CNLCBlock {

    override public var identifier: String {
        return "PROGRAM"
    }
    
    public var programName: String
    public var player = CNLCPlayer()
    public var globalStack = CNLCStack<CNLCValue>()
    public var executionHistory = CNLCExecutionHistory()
    public var embedFunctions: [CNLCStatementFunction] = [
        CNLCFunctionSin(),
        CNLCFunctionCos()
    ]
    
    public func clear() -> CNLCValue {
        let result = player.clear(nil)
        if result.isError { return result }

        return executionHistory.clear()
    }
    
    override public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        let result = clear()
        if result.isError { return result }
        
        return super.execute()
    }

    override public func functionByName(name: String) -> CNLCStatementFunction? {
        for f in embedFunctions {
            if f.funcName == name {
                return f
            }
        }
        return super.functionByName(name)
    }
    
    private func internalInit() {
        variables.append(CNLCVariable(variableName: "PI", variableValue: CNLCValue.Double(value: M_PI)))
        variables.append(CNLCVariable(variableName: "2_PI", variableValue: CNLCValue.Double(value: M_2_PI)))
        variables.append(CNLCVariable(variableName: "PI_2", variableValue: CNLCValue.Double(value: M_PI_2)))
        variables.append(CNLCVariable(variableName: "EXP", variableValue:  CNLCValue.Double(value: M_E)))
    }
    
    public override init() {
        self.programName = "Unnamed program"
        super.init()
    }
    
    public required init(data: [String : AnyObject]) {
        programName = data["program-name"] as! String
        super.init(data: data["program-body"] as! [String : AnyObject])
        internalInit()
    }

    public init(programName: String, statements: [CNLCStatement]) {
        self.programName = programName
        super.init(statements: statements)
        internalInit()
    }
    
}

