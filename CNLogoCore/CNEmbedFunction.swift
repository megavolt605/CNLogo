//
//  CNEmbedFunction.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation

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

    public required init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
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

    public required init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
    }

}
