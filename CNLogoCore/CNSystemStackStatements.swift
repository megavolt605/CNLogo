//
//  CNSystemStackStatements.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 14/10/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

public class CNStatementPush: CNStatement {
    
    override public var identifier: String {
        return "PUSH"
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try executableParameters.forEach {
            try parentBlock?.valueStack.push($0.variableValue.execute())
        }
        return .unknown
    }
    
}

public class CNStatementPop: CNStatement {
    
    override public var identifier: String {
        return "POP"
    }
    
    public var variableName: String
    
    func popValue() -> CNValue? {
        return parentBlock?.valueStack.pop()
    }
    
    override public func prepare() throws {
        try super.prepare()
        if executableParameters.count != 0 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: executableParameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        if let value = popValue() {
            if let variable = variableByName(variableName) {
                variable.variableValue = CNExpression(source: [CNExpressionParseElement.Value(value: value)])
            } else {
                parentBlock?.variables.append(CNVariable(variableName: variableName, variableValue: value))
            }
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Step, fromBlock: self)
            return value
        } else {
            throw CNError.InvalidValue
        }
    }
    
    override public func store() -> [String: AnyObject] {
        var res = super.store()
        res["variable-name"] = variableName
        return res
    }
    
    public init(variableName: String) {
        self.variableName = variableName
        super.init()
    }
    
    required public init(data: [String : AnyObject]) {
        if let variableName = data["variable-name"] as? String {
            self.variableName = variableName
            super.init(data: data)
        } else {
            fatalError("CNStatementVar.init(data:) variable name not found")
        }
    }
    
}

public class CNStatementGlobalPush: CNStatementPush {
    
    override public var identifier: String {
        return "GPUSH"
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try executableParameters.forEach {
            try CNEnviroment.defaultEnviroment.currentProgram?.globalStack.push($0.variableValue.execute())
        }
        return .unknown
    }
    
}

public class CNStatementGlobalPop: CNStatementPop {
    
    override public var identifier: String {
        return "GPOP"
    }
    
    override func popValue() -> CNValue? {
        return CNEnviroment.defaultEnviroment.currentProgram?.globalStack.pop()
    }
}


