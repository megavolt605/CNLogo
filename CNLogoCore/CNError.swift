//
//  CNError.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 04/10/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

public enum CNError {
    case Unknown
    case NoProgram
    case VariableNotFound(variableName: String)
    case FunctionNotFound(functionName: String)
    case AssignToNonVariable
    case InvalidOperator
    case InvalidExpression
    case InvalidParameterCount(functionName: String)
    case InvalidParameterType(functionName: String, parameterIndex: Int)
    case NumericValueExpected
    case IntValueExpected
    case BoolValueExpected
    case InvalidValue
    case VariableAlreadyExists(variableName: String)
    case StatementParameterCountMismatch(statementIdentifier: String, excpectedCount: Int, actualCount: Int)
    
    public var description: String {
        switch self {
        case Unknown: return "Unknown error"
        case .NoProgram: return "No program"
        case let VariableNotFound(variableName): return "Variable not found \(variableName)"
        case let FunctionNotFound(functionName): return "Function not found \(functionName)"
        case AssignToNonVariable: return "Assignment allowed to variables only"
        case InvalidOperator: return "Invalid operator"
        case InvalidExpression: return "Invalid expression"
        case let InvalidParameterCount(functionName): return "Parameter count mismatch for function \(functionName)"
        case let InvalidParameterType(functionName, parameterIndex): return "Parameter \(parameterIndex) type mismatch for function \(functionName)"
        case NumericValueExpected: return "Numeric value expected"
        case IntValueExpected: return "Integer value expected"
        case BoolValueExpected: return "Boolean value expected"
        case InvalidValue: return "Invalid value"
        case let VariableAlreadyExists(variableName): return "Variable already exists \(variableName)"
        case let StatementParameterCountMismatch(statementIdentifier, excpectedCount, actualCount): return "Statement \(statementIdentifier) expects \(excpectedCount) parameters, but found \(actualCount)"
        }
    }
}
