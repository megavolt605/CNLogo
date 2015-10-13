//
//  CNSystemFunctions.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNStatementPrint: CNStatement {
    
    override public var identifier: String {
        return "PRINT"
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try parameters.forEach {
            let desc = try $0.execute().description
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Print(value: desc), fromBlock: self)
        }
        return .unknown
    }
    
}

public class CNStatementVar: CNStatement {
    
    override public var identifier: String {
        return "VAR"
    }
    
    override public var description: String {
        return "\(identifier) \"\(variableName)\" = " + parametersDescription
    }
    
    public var variableName: String
    
    override public func prepare() throws {
        try super.prepare()
        if parameters.count != 1 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 1, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        if let value = try parameters.first?.execute() {
            if let variable = variableByName(variableName) {
                variable.variableValue = value
            } else {
                parentBlock?.variables.append(CNVariable(variableName: variableName, variableValue: value))
            }
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Step, fromBlock: self)
            return value
        } else {
            if let _ = parentBlock?.variableByName(variableName) {
                throw CNError.VariableAlreadyExists(variableName: variableName)
            } else {
                parentBlock?.variables.append(CNVariable(variableName: variableName, variableValue: .unknown))
            }
        }
        CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Step, fromBlock: self)
        return .unknown
    }
    
    override public func store() -> [String: AnyObject] {
        var res = super.store()
        res["variable-name"] = variableName
        return res
    }
    
    public init(variableName: String, parameters: [CNExpression]) {
        self.variableName = variableName
        super.init(parameters: parameters)
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

public class CNStatementPush: CNStatement {
    
    override public var identifier: String {
        return "PUSH"
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try parameters.forEach {
            try parentBlock?.valueStack.push($0.execute())
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
        if parameters.count != 0 {
            throw CNError.StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: parameters.count)
        }
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        if let value = popValue() {
            if let variable = variableByName(variableName) {
                variable.variableValue = value
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

public class CNStatementGlobalPush: CNStatement {
    
    override public var identifier: String {
        return "GPUSH"
    }
    
    override public func execute() throws -> CNValue {
        try super.execute()
        try parameters.forEach {
            try CNEnviroment.defaultEnviroment.currentProgram?.globalStack.push($0.execute())
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


