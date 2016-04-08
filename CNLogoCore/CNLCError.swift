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
    case Unknown
    
    /// There is no active program
    case NoProgram
    
    /// Variable (variableName: String) not found
    case VariableNotFound(variableName: String)
    
    /// Function (functionName: String) not found
    case FunctionNotFound(functionName: String)
    
    /// Attempt assign value to non-variable object
    case AssignToNonVariable
    
    /// Unknown operator in expression
    case InvalidOperator
    
    /// Malformed expression
    case InvalidExpression
    
    /// Function (functionName: String) parameter count mismatch
    case InvalidParameterCount(functionName: String)
    
    /// Function (functionName: String) parameter (parameterIndex: Int) type mismatch
    case InvalidParameterType(functionName: String, parameterIndex: Int)
    
    /// Expected numeric value in expression
    case NumericValueExpected
    
    /// Expected integer value in expression
    case IntValueExpected

    /// Expected logical value in expression
    case BoolValueExpected
    
    /// Unexpected value in expression
    case InvalidValue
    
    /// Attempt to declare duplicate variable (variableName: String)
    case VariableAlreadyExists(variableName: String)
    
    /// Statement (statementIdentifier: String) parameter count mismatch (excpectedCount: Int, actualCount: Int)
    case StatementParameterCountMismatch(statementIdentifier: String, excpectedCount: Int, actualCount: Int)
    
    /// Error printable description
    public var description: String {
        switch self {
        case Unknown: return "Unknown error"
        case NoProgram: return "No program"
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
