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

open class CNLCProgram: CNLCBlock {

    override open var identifier: String {
        return "PROGRAM"
    }
    
    open var programName: String
    open var player = CNLCPlayer()
    open var globalStack = CNLCStack<CNLCValue>()
    open var executionHistory = CNLCExecutionHistory()
    open var embedFunctions: [CNLCStatementFunction] = [
        CNLCFunctionSin(),
        CNLCFunctionCos()
    ]
    
    @discardableResult
    open func clear() -> CNLCValue {
        let result = player.clear(nil)
        if result.isError { return result }

        return executionHistory.clear()
    }
    
    override open func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        let result = clear()
        if result.isError { return result }
        
        return super.execute()
    }

    override open func functionByName(_ name: String) -> CNLCStatementFunction? {
        for f in embedFunctions {
            if f.funcName == name {
                return f
            }
        }
        return super.functionByName(name)
    }
    
    fileprivate func internalInit() {
        variables.append(CNLCVariable(variableName: "PI", variableValue: CNLCValue.double(value: M_PI)))
        variables.append(CNLCVariable(variableName: "2_PI", variableValue: CNLCValue.double(value: M_2_PI)))
        variables.append(CNLCVariable(variableName: "PI_2", variableValue: CNLCValue.double(value: M_PI_2)))
        variables.append(CNLCVariable(variableName: "EXP", variableValue:  CNLCValue.double(value: M_E)))
    }
    
    public override init() {
        self.programName = "Unnamed program"
        super.init()
    }
    
    override public init(data: [String : Any]) {
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

