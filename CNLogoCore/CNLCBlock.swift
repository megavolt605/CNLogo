//
//  CNLCBlock.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

/// Result of preparing CNBlock
///
/// Values:
/// - Error: there is some error
/// - Unprepared: block is unprepared yet
/// - Success: preparing completed with success
public enum CNLCBlockPrepareResult {
    case error(block: CNLCBlock?, error: CNLCError)
    case unprepared
    case success
    
    /// Check for error state
    public var isError: Bool {
        switch self {
        case .error: return true
        default: return false
        }
    }
    
    /// Check for success state
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        default: return false
        }
    }
}

/// Abstract code block with (or without) parameters
open class CNLCBlock {
    
    open var formalParameters: [CNLCVariable] = []
    open var executableParameters: [CNLCVariable] = []
    open var statements: [CNLCStatement] = []
    open var variables: [CNLCVariable] = []
    open var functions: [CNLCStatementFunction] = []
    open var valueStack = CNLCStack<CNLCValue>()
    
    open var prepared: CNLCBlockPrepareResult = .unprepared

    weak open var parentBlock: CNLCBlock?

    open var identifier: String {
        return "Anonymous BLOCK"
    }
    
    open var description: String {
        if executableParameters.count > 0 {
            return "\(identifier) \(parametersDescription)"
        } else {
            return identifier
        }
    }
    
    open var parametersDescription: String {
        return executableParameters.reduce("") {
            let variableName = $1.variableName ?? ""
            return ($0 == "" ? "" : "\($0),") + "\(variableName)\($1.variableValue.description)"
        }
    }
    
    /// Preparing statements within the block (recursively)
    
    open func prepare() -> CNLCBlockPrepareResult {
        prepared = .unprepared
        // prepare parameters
        for parameter in executableParameters {
            parameter.variableValue.parentBlock = self
            prepared = parameter.variableValue.prepare()
            if prepared.isError { return prepared }
        }
        
        // prepare statements
        for statement in statements {
            statement.parentBlock = self
            prepared = statement.prepare()
            if prepared.isError { return prepared }
        }
        return prepared
    }

    
    open func executeStatements() -> CNLCValue {
        //print(self)
        var lastValue: CNLCValue = .unknown
        statements.forEach {
            lastValue = $0.execute()
        }
        return lastValue
    }
    
    
    open func execute(_ parameters: [CNLCExpression] = []) -> CNLCValue {
        if !prepared.isSuccess {
            switch prepare() {
            case let .error(block, error): return .error(block: block, error: error)
            default: break
            }
        }

        return executeStatements()
    }
    
    
    open func variableByName(_ name: String) -> CNLCVariable? {
        for v in variables {
            if v.variableName == name {
                return v
            }
        }
        for v in executableParameters {
            if v.variableName == name {
                return v
            }
        }
        
        return parentBlock?.variableByName(name)
    }
    
    
    open func functionByName(_ name: String) -> CNLCStatementFunction? {
        for f in functions {
            if f.funcName == name {
                return f
            }
        }
        return parentBlock?.functionByName(name)
    }
    
    
    open func store() -> [String: Any] {
        var res: [String: Any] = [:]
        if executableParameters.count > 0 {
            res["parameters"] = executableParameters.enumerated().map { (index: Int, param: CNLCVariable) -> [String: Any] in
                return [param.variableName ?? "\(index)": param.variableValue.store()]
            }
        }
        if statements.count > 0 {
            res["statements"] = statements.map { return $0.store() }
        }
        if functions.count > 0 {
            res["functions"] = functions.map { return $0.store() }
        }
        return res
    }

    public init() {
        //
    }
    
    public init(executableParameters: [CNLCVariable]) {
        self.executableParameters = executableParameters
    }
    
    public init(statements: [CNLCStatement]) {
        self.statements = statements
    }
    
    public init(executableParameters: [CNLCVariable], statements: [CNLCStatement]) {
        self.executableParameters = executableParameters
        self.statements = statements
    }
    
    public init(data: [String: Any]) {
        executableParameters = []
        if let info = data["parameters"] as? [String: [String: Any]] {
            executableParameters = info.map { name, value in
                return CNLCVariable(variableName: name, variableValue: CNLCExpression(data: value))
            }
        }

        statements = []
        if let info = data["statements"] as? [[String: Any]] {
            statements = info.map { item in
                return CNLCLoader.createStatement(item["statement-id"] as? String, info: item["statement-info"] as? [String: Any])!
            }
        }

        functions = []
        if let info = data["functions"] as? [[String: Any]] {
            functions = info.map { item in
                return functionByName(item["function-name"] as! String)!
            }
        }
    }
    
    
}
