//
//  CNBlock.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public enum CNBlockPrepareResult {
    case Error(block: CNBlock?, error: CNError)
    case Unprepared
    case Success
    var isError: Bool {
        switch self {
        case .Error: return true
        default: return false
        }
    }
    var isSuccess: Bool {
        switch self {
        case .Success: return true
        default: return false
        }
    }
}

@objc public class CNBlock: NSObject {
    
    public var formalParameters: [CNVariable] = []
    public var executableParameters: [CNVariable] = []
    public var statements: [CNStatement] = []
    public var variables: [CNVariable] = []
    public var functions: [CNStatementFunction] = []
    public var valueStack = CNStack<CNValue>()
    
    public var prepared: CNBlockPrepareResult = .Unprepared

    weak public var parentBlock: CNBlock?

    public var identifier: String {
        return "Anonymous BLOCK"
    }
    
    override public var description: String {
        if executableParameters.count > 0 {
            return "\(identifier) \(parametersDescription)"
        } else {
            return identifier
        }
    }
    
    public var parametersDescription: String {
        return executableParameters.reduce("") {
            if $0 == "" {
                return $1.variableName ?? "" + $1.variableValue.description
            } else {
                return $0 + "," + ($1.variableName ?? "") + $1.variableValue.description
            }
        }
    }
    
    @warn_unused_result
    public func prepare() -> CNBlockPrepareResult {
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
    public func executeStatements() -> CNValue {
        print(self)
        var lastValue: CNValue = CNValue.unknown
        statements.forEach {
            lastValue = $0.execute()
        }
        return lastValue
    }
    
    @warn_unused_result
    public func execute() -> CNValue {
        if prepared.isSuccess {
            prepare()
        }

        return executeStatements()
    }
    
    @warn_unused_result
    public func variableByName(name: String) -> CNVariable? {
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
    public func functionByName(name: String) -> CNStatementFunction? {
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
            res["parameters"] = executableParameters.enumerate().map { (index: Int, param: CNVariable) -> [String: AnyObject] in
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

    override public init() {
        super.init()
    }
    
    deinit {
    }
    
    public init(executableParameters: [CNVariable]) {
        self.executableParameters = executableParameters
    }
    
    public init(statements: [CNStatement]) {
        self.statements = statements
    }
    
    public init(executableParameters: [CNVariable], statements: [CNStatement]) {
        self.executableParameters = executableParameters
        self.statements = statements
    }
    
    public required init(data: [String: AnyObject]) {
        super.init()
        executableParameters = []
        if let info = data["parameters"] as? [String: [String: AnyObject]] {
            executableParameters = info.map { name, value in
                return CNVariable(variableName: name, variableValue: CNExpression(data: value))
            }
        }

        statements = []
        if let info = data["statements"] as? [[String: AnyObject]] {
            statements = info.map { item in
                return CNLoader.createStatement(item["statement-id"] as? String, info: item["statement-info"] as? [String: AnyObject])!
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
