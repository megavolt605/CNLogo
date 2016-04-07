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
    
    override public func execute() -> CNValue {
        
        var result = super.execute()
        if result.isError { return result }

        for parameter in executableParameters {
            result = parameter.variableValue.execute()
            if result.isError { return result }
            parentBlock?.valueStack.push(result)
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
    
    override public func prepare() -> CNBlockPrepareResult {
        let result = super.prepare()
        if result.isError { return result }

        if executableParameters.count != 0 {
            return CNBlockPrepareResult.Error(block: self, error: .StatementParameterCountMismatch(statementIdentifier: identifier, excpectedCount: 0, actualCount: executableParameters.count))
        }
        return result
    }
    
    override public func execute() -> CNValue {
        let result = super.execute()
        if result.isError { return result }
        
        if let value = popValue() {
            if let variable = variableByName(variableName) {
                variable.variableValue = CNExpression(source: [CNExpressionParseElement.Value(value: value)])
            } else {
                parentBlock?.variables.append(CNVariable(variableName: variableName, variableValue: value))
            }
            CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Step, fromBlock: self)
            return value
        } else {
            return CNValue.error(block: self, error: .InvalidValue)
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
    
    override public func execute() -> CNValue {
        var result = super.execute()
        if result.isError { return result }

        for parameter in executableParameters {
            result = parameter.variableValue.execute()
            if result.isError { return result }
            CNEnviroment.defaultEnviroment.currentProgram?.globalStack.push(result)
        }
        return result
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


