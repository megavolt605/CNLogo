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
    case Error(block: CNLCBlock?, error: CNLCError)
    case Unprepared
    case Success
    
    /// Check for error state
    public var isError: Bool {
        switch self {
        case .Error: return true
        default: return false
        }
    }
    
    /// Check for success state
    public var isSuccess: Bool {
        switch self {
        case .Success: return true
        default: return false
        }
    }
}

/// Abstract code block with (or without) parameters
public class CNLCBlock {
    
    public var formalParameters: [CNLCVariable] = []
    public var executableParameters: [CNLCVariable] = []
    public var statements: [CNLCStatement] = []
    public var variables: [CNLCVariable] = []
    public var functions: [CNLCStatementFunction] = []
    public var valueStack = CNLCStack<CNLCValue>()
    
    public var prepared: CNLCBlockPrepareResult = .Unprepared

    weak public var parentBlock: CNLCBlock?

    public var identifier: String {
        return "Anonymous BLOCK"
    }
    
    public var description: String {
        if executableParameters.count > 0 {
            return "\(identifier) \(parametersDescription)"
        } else {
            return identifier
        }
    }
    
    public var parametersDescription: String {
        return executableParameters.reduce("") {
            let variableName = $1.variableName ?? ""
            return ($0 == "" ? "" : "\($0),") + "\(variableName)\($1.variableValue.description)"
        }
    }
    
    /// Preparing statements within the block (recursively)
    @warn_unused_result
    public func prepare() -> CNLCBlockPrepareResult {
        prepared = .Unprepared
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

    @warn_unused_result
    public func executeStatements() -> CNLCValue {
        //print(self)
        var lastValue: CNLCValue = .Unknown
        statements.forEach {
            lastValue = $0.execute()
        }
        return lastValue
    }
    
    @warn_unused_result
    public func execute(parameters: [CNLCExpression] = []) -> CNLCValue {
        if !prepared.isSuccess {
            switch prepare() {
            case let .Error(block, error): return .Error(block: block, error: error)
            default: break
            }
        }

        return executeStatements()
    }
    
    @warn_unused_result
    public func variableByName(name: String) -> CNLCVariable? {
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
    
    @warn_unused_result
    public func functionByName(name: String) -> CNLCStatementFunction? {
        for f in functions {
            if f.funcName == name {
                return f
            }
        }
        return parentBlock?.functionByName(name)
    }
    
    @warn_unused_result
    public func store() -> [String: AnyObject] {
        var res: [String: AnyObject] = [:]
        if executableParameters.count > 0 {
            res["parameters"] = executableParameters.enumerate().map { (index: Int, param: CNLCVariable) -> [String: AnyObject] in
                return [param.variableName ?? "\(index)": param.variableValue.store()]
            }
        }
        if statements.count > 0 {
            res["statements"] = statements.map { $0.store() }
        }
        if functions.count > 0 {
            res["functions"] = functions.map { $0.store() }
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
    
    public init(data: [String: AnyObject]) {
        executableParameters = []
        if let info = data["parameters"] as? [String: [String: AnyObject]] {
            executableParameters = info.map { name, value in
                return CNLCVariable(variableName: name, variableValue: CNLCExpression(data: value))
            }
        }

        statements = []
        if let info = data["statements"] as? [[String: AnyObject]] {
            statements = info.map { item in
                return CNLCLoader.createStatement(item["statement-id"] as? String, info: item["statement-info"] as? [String: AnyObject])!
            }
        }

        functions = []
        if let info = data["functions"] as? [[String: AnyObject]] {
            functions = info.map { item in
                return functionByName(item["function-name"] as! String)!
            }
        }
    }
    
    
}
