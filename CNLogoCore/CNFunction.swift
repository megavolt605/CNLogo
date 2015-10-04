//
//  CNFunction.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNFunction: CNBlock {
    
    override public var identifier: String {
        return "FUNC"
    }

    var funcName: String
    var parametersDesc: [CNValue]
    
    override public var description: String {
        return "\(identifier) \(funcName)(\(parametersDescription))"
    }
    
    func prepareWithParameters(parameters: [CNExpression]) throws {
        guard parameters.count == parametersDesc.count else {
            throw CNError.InvalidParameterCount(functionName: funcName)
        }
        for i in 0..<parameters.count {
            if !(try parameters[i].execute().isEqualTo(parametersDesc[i])) {
                throw CNError.InvalidParameterType(functionName: funcName, parameterIndex: i)
            }
        }
    }
    
    func executeWithParameters(parameters: [CNExpression]) throws -> CNValue {
        return CNValue.unknown
    }
    
    init(funcName: String, parametersDesc: [CNValue] = []) {
        self.funcName = funcName
        self.parametersDesc = parametersDesc
        super.init(parameters: [], statements: [], functions: [])
    }

    public required init(parameters: [CNExpression], statements: [CNStatement], functions: [CNFunction]) {
        fatalError("CNFunction.init(parameters:statements:functions:) has not been implemented")
    }

    public required init(data: [String : AnyObject]) {
        fatalError("CNFunction.init(data:) has not been implemented")
    }
    
}

public class CNFunctionSin: CNFunction {

    override func executeWithParameters(parameters: [CNExpression]) throws -> CNValue {
        if let firstValue = try parameters.first?.execute() {
            switch firstValue {
            case let .double(value): return CNValue.double(value: sin(value))
            case let .int(value): return CNValue.double(value: sin(Double(value)))
            case let .string(value): return CNValue.double(value: sin(value.doubleValue))
            default: break
            }
        }
        return try super.executeWithParameters(parameters)
    }
    
    init() {
        super.init(funcName: "SIN", parametersDesc: [CNValue.double(value: 0)])
    }

    public required init(parameters: [CNExpression], statements: [CNStatement], functions: [CNFunction]) {
        fatalError("CNFunctionSin.init(parameters:statements:functions:) has not been implemented")
    }

    public required init(data: [String : AnyObject]) {
        fatalError("CNFunctionSin.init(data:) has not been implemented")
    }
    
}

public class CNFunctionCos: CNFunction {
    
    override func executeWithParameters(parameters: [CNExpression]) throws -> CNValue {
        if let firstValue = try parameters.first?.execute() {
            switch firstValue {
            case let .double(value): return CNValue.double(value: cos(value))
            case let .int(value): return CNValue.double(value: cos(Double(value)))
            case let .string(value): return CNValue.double(value: cos(value.doubleValue))
            default: break
            }
        }
        return try super.executeWithParameters(parameters)
    }
    
    init() {
        super.init(funcName: "COS", parametersDesc: [CNValue.double(value: 0)])
    }

    public required init(parameters: [CNExpression], statements: [CNStatement], functions: [CNFunction]) {
        fatalError("CNFunctionCos.init(parameters:statements:functions:) has not been implemented")
    }

    public required init(data: [String : AnyObject]) {
        fatalError("CNFunctionCos.init(data:) has not been implemented")
    }
    
}
