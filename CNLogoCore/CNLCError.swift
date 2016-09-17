//
//  CNLCError.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 04/10/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

/// Error enum
public enum CNLCError {
    
    /// Not a error
    case unknown
    
    /// There is no active program
    case noProgram
    
    /// Variable (variableName: String) not found
    case variableNotFound(variableName: String)
    
    /// Function (functionName: String) not found
    case functionNotFound(functionName: String)
    
    /// Attempt assign value to non-variable object
    case assignToNonVariable
    
    /// Unknown operator in expression
    case invalidOperator
    
    /// Malformed expression
    case invalidExpression
    
    /// Function (functionName: String) parameter count mismatch
    case invalidParameterCount(functionName: String)
    
    /// Function (functionName: String) parameter (parameterIndex: Int) type mismatch
    case invalidParameterType(functionName: String, parameterIndex: Int)
    
    /// Expected numeric value in expression
    case numericValueExpected
    
    /// Expected integer value in expression
    case intValueExpected

    /// Expected logical value in expression
    case boolValueExpected
    
    /// Unexpected value in expression
    case invalidValue
    
    /// Attempt to declare duplicate variable (variableName: String)
    case variableAlreadyExists(variableName: String)
    
    /// Statement (statementIdentifier: String) parameter count mismatch (excpectedCount: Int, actualCount: Int)
    case statementParameterCountMismatch(statementIdentifier: String, excpectedCount: Int, actualCount: Int)
    
    /// Error printable description
    public var description: String {
        switch self {
        case .unknown: return "Unknown error"
        case .noProgram: return "No program"
        case let .variableNotFound(variableName): return "Variable not found \(variableName)"
        case let .functionNotFound(functionName): return "Function not found \(functionName)"
        case .assignToNonVariable: return "Assignment allowed to variables only"
        case .invalidOperator: return "Invalid operator"
        case .invalidExpression: return "Invalid expression"
        case let .invalidParameterCount(functionName): return "Parameter count mismatch for function \(functionName)"
        case let .invalidParameterType(functionName, parameterIndex): return "Parameter \(parameterIndex) type mismatch for function \(functionName)"
        case .numericValueExpected: return "Numeric value expected"
        case .intValueExpected: return "Integer value expected"
        case .boolValueExpected: return "Boolean value expected"
        case .invalidValue: return "Invalid value"
        case let .variableAlreadyExists(variableName): return "Variable already exists \(variableName)"
        case let .statementParameterCountMismatch(statementIdentifier, excpectedCount, actualCount): return "Statement \(statementIdentifier) expects \(excpectedCount) parameters, but found \(actualCount)"
        }
    }
}
