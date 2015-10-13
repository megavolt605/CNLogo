//
//  CNBlock.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public struct CNFormalParameter {
    var name: String?
    var value: CNValue.Type
    var isOptional = false /// TODO: !!!

    public init(value: CNValue.Type) {
        self.value = value
    }
    
    public init(name: String, value: CNValue.Type) {
        self.name = name
        self.value = value
    }
    
}

public struct CNExecutableParameter {
    public var name: String?
    public var value: CNExpression
    
    public init(value: CNExpression) {
        self.value = value
    }
    
    public init(name: String, value: CNExpression) {
        self.name = name
        self.value = value
    }
    
}

public class CNBlock {
    
    public var execuableParameters: [CNExecutableParameter] = []
    public var statements: [CNStatement] = [] {
        didSet {
            execuableParameters.forEach {
                $0.value.parentBlock = self
            }
            statements.forEach {
                $0.parentBlock = self
            }
        }
    }
    public var variables: [CNVariable] = []
    public var functions: [CNFunction] = []
    public var valueStack = CNStack<CNValue>()
    
    private var prepared = false

    weak var parentBlock: CNBlock?

    public var identifier: String {
        return "Anonymous BLOCK"
    }
    
    public var description: String {
        if execuableParameters.count > 0 {
            return "\(identifier) \(parametersDescription)"
        } else {
            return identifier
        }
    }
    
    public var parametersDescription: String {
        return execuableParameters.reduce("") {
            if $0 == "" {
                return $1.name ?? "" + $1.value.description
            } else {
                return $0 + "," + ($1.name ?? "") + $1.value.description
            }
        }
    }
    
    public func prepare() throws -> Void {
        try execuableParameters.forEach {
            $0.value.parentBlock = self
            try $0.value.prepare()
        }
        try statements.forEach {
            $0.parentBlock = self
            try $0.prepare()
        }
        prepared = true
    }
    
    public func execute() throws -> CNValue {
        if !prepared {
            try prepare()
        }
        
        try statements.forEach {
            try $0.execute()
        }
        return CNValue.unknown
    }
    
    public func variableByName(name: String) -> CNVariable? {
        for v in variables {
            if v.variableName == name {
                return v
            }
        }
        return parentBlock?.variableByName(name)
    }
    
    public func functionByName(name: String) -> CNFunction? {
        for f in functions {
            if f.funcName == name {
                return f
            }
        }
        return parentBlock?.functionByName(name)
    }
    
    public func store() -> [String: AnyObject] {
        var res: [String: AnyObject] = [:]
        if execuableParameters.count > 0 {
            res["parameters"] = execuableParameters.enumerate().map { (index: Int, param: CNExecutableParameter) -> [String: AnyObject] in
                return [param.name ?? "\(index)": param.value.store()]
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
        
    }
    
    public init(execuableParameters: [CNExecutableParameter]) {
        self.execuableParameters = execuableParameters
    }
    
    public init(statements: [CNStatement]) {
        self.statements = statements
    }
    
    public init(execuableParameters: [CNExecutableParameter], statements: [CNStatement]) {
        self.execuableParameters = execuableParameters
        self.statements = statements
    }
    
    public required init(data: [String: AnyObject]) {
        execuableParameters = []
        if let info = data["parameters"] as? [String: [String: AnyObject]] {
            execuableParameters = info.map { name, value in
                return CNExecutableParameter(name: name, value: CNExpression(data: value))
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
