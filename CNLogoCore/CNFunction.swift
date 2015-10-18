//
//  CNFunction.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 14/10/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

public class CNStatementFunction: CNStatement {
    
    override public var identifier: String {
        return "FUNC"
    }
    
    public var funcName: String
    
    override public var description: String {
        return "\(identifier) \(funcName)(\(parametersDescription))"
    }
    
    public override func prepare() throws {
        try super.prepare()
        parentBlock?.functions.append(self)
    }
    
    public override func execute() throws -> CNValue {
        // dummy
        return .unknown
    }
    
    func executeWithParameters(parameters: [CNExpression]) throws -> CNValue {
        return CNValue.unknown
    }
    
    public init(funcName: String, formalParameters: [CNVariable] = [], statements: [CNStatement]) {
        self.funcName = funcName
        super.init(statements: statements)
        self.formalParameters = formalParameters
    }

    public required init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
    }
}

public class CNStatementCall: CNStatement {
    
    override public var identifier: String {
        return "CALL"
    }
    
    public var funcName: String
    
    override public var description: String {
        return "\(identifier) \(funcName)(\(parametersDescription))"
    }

    /*
    func prepareWithParameters(parameters: [CNExpression]) throws {
        guard parameters.count == formalParameters.count else {
            throw CNError.InvalidParameterCount(functionName: funcName)
        }
        /*for i in 0..<parameters.count {
        if !(try parameters[i].prepare().isEqualTo(formalParameters[i])) {
        throw CNError.InvalidParameterType(functionName: funcName, parameterIndex: i)
        }
        }*/
    }*/
    
    override public func variableByName(name: String) -> CNVariable? {
        for v in variables {
            if v.variableName == name {
                return v
            }
        }
        return parentBlock?.variableByName(name)
    }
    
    public override func execute() throws -> CNValue {
        try super.execute()
        if let function = functionByName(funcName) {
            function.executableParameters = try executableParameters.map { parameter in
                return CNVariable(
                    variableName: parameter.variableName,
                    variableValue: try parameter.variableValue.execute()
                )
            }
            return try function.executeStatements()
        }
        CNEnviroment.defaultEnviroment.appendExecutionHistory(CNExecutionHistoryItemType.Step, fromBlock: self)
        return .unknown
    }
    
    public init(funcName: String, executableParameters: [CNVariable] = []) {
        self.funcName = funcName
        super.init(executableParameters: executableParameters)
    }
    
    public required init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
    }
    
}
