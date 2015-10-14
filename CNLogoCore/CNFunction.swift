//
//  CNFunction.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 14/10/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

public class CNFunction: CNStatement {
    
    override public var identifier: String {
        return "FUNC"
    }
    
    var funcName: String
    
    override public var description: String {
        return "\(identifier) \(funcName)(\(parametersDescription))"
    }
    
    func prepareWithParameters(parameters: [CNExpression]) throws {
        guard parameters.count == formalParameters.count else {
            throw CNError.InvalidParameterCount(functionName: funcName)
        }
        /*for i in 0..<parameters.count {
            if !(try parameters[i].prepare().isEqualTo(formalParameters[i])) {
                throw CNError.InvalidParameterType(functionName: funcName, parameterIndex: i)
            }
        }*/
    }
    
    func executeWithParameters(parameters: [CNExpression]) throws -> CNValue {
        return CNValue.unknown
    }
    
    init(funcName: String, formalParameters: [CNFormalParameter] = []) {
        self.funcName = funcName
        super.init()
        self.formalParameters = formalParameters
    }
    
    public required init(data: [String : AnyObject]) {
        fatalError("init(data:) has not been implemented")
    }
}