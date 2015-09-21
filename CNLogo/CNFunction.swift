//
//  CNFunction.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

class CNFunction: CNBlock {
    
    var name: String
    var parametersDesc: [CNValue]
    
    override var description: String {
        return "\(name)(\(parametersDescription))"
    }
    
    func prepareWithParameters(parameters: [CNExpression]) throws {
        guard parameters.count == parametersDesc.count else { throw NSError(domain: "Parameter count mismatch for function \(name)", code: 0, userInfo: nil) }
        for i in 0..<parameters.count {
            if !(try parameters[i].execute() ~= parametersDesc[i]) {
                throw NSError(domain: "Parameter \(i) type mismatch for function \(name)", code: 0, userInfo: nil)
            }
        }
    }
    
    func executeWithParameters(parameters: [CNExpression]) throws -> CNValue {
        return CNValue.unknown
    }
    
    init(name: String, parametersDesc: [CNValue] = []) {
        self.name = name
        self.parametersDesc = parametersDesc
        super.init(parameters: [], statements: [], functions: [])
    }
    
}

class CNFunctionSin: CNFunction {

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
        super.init(name: "SIN", parametersDesc: [CNValue.double(value: 0)])
    }
    
}

class CNFunctionCos: CNFunction {
    
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
        super.init(name: "COS", parametersDesc: [CNValue.double(value: 0)])
    }
    
}
