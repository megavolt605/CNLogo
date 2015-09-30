//
//  CNFunction.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

public class CNFunction: CNBlock {
    
    private var _identifier: String
    override public var identifier: String {
        return _identifier
    }
    
    var parametersDesc: [CNValue]
    
    override public var description: String {
        return "\(identifier)(\(parametersDescription))"
    }
    
    func prepareWithParameters(parameters: [CNExpression]) throws {
        guard parameters.count == parametersDesc.count else { throw NSError(domain: "Parameter count mismatch for function \(identifier)", code: 0, userInfo: nil) }
        for i in 0..<parameters.count {
            if !(try parameters[i].execute().isEqualTo(parametersDesc[i])) {
                throw NSError(domain: "Parameter \(i) type mismatch for function \(identifier)", code: 0, userInfo: nil)
            }
        }
    }
    
    func executeWithParameters(parameters: [CNExpression]) throws -> CNValue {
        return CNValue.unknown
    }
    
    init(functionIdentifier: String, parametersDesc: [CNValue] = []) {
        self._identifier = functionIdentifier
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
        super.init(functionIdentifier: "SIN", parametersDesc: [CNValue.double(value: 0)])
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
        super.init(functionIdentifier: "COS", parametersDesc: [CNValue.double(value: 0)])
    }

    public required init(parameters: [CNExpression], statements: [CNStatement], functions: [CNFunction]) {
        fatalError("CNFunctionCos.init(parameters:statements:functions:) has not been implemented")
    }

    public required init(data: [String : AnyObject]) {
        fatalError("CNFunctionCos.init(data:) has not been implemented")
    }
    
}
