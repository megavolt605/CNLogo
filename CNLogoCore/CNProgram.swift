//
//  CNProgram.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public class CNProgram: CNBlock {

    override public var identifier: String {
        return "PROGRAM"
    }
    
    public var programName: String
    public var player = CNPlayer()
    public var globalStack = CNStack<CNValue>()
    public var executionHistory = CNExecutionHistory()
    public var embedFunctions: [CNStatementFunction] = [
        CNFunctionSin(),
        CNFunctionCos()
    ]
    
    public func clear() -> CNValue {
        let result = player.clear(nil)
        if result.isError { return result }

        return executionHistory.clear()
    }
    
    override public func execute(parameters: [CNExpression] = []) -> CNValue {
        let result = clear()
        if result.isError { return result }
        
        return super.execute()
    }

    override public func functionByName(name: String) -> CNStatementFunction? {
        for f in embedFunctions {
            if f.funcName == name {
                return f
            }
        }
        return super.functionByName(name)
    }
    
    private func internalInit() {
        variables.append(CNVariable(variableName: "PI", variableValue: CNValue.Double(value: M_PI)))
        variables.append(CNVariable(variableName: "2_PI", variableValue: CNValue.Double(value: M_2_PI)))
        variables.append(CNVariable(variableName: "PI_2", variableValue: CNValue.Double(value: M_PI_2)))
        variables.append(CNVariable(variableName: "EXP", variableValue:  CNValue.Double(value: M_E)))
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

    public init(programName: String, statements: [CNStatement]) {
        self.programName = programName
        super.init(statements: statements)
        internalInit()
    }
    
}

