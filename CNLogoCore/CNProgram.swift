//
//  CNProgram.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public enum CNError: ErrorType {
    case Unknown
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

public class CNProgram: CNBlock {

    override public var identifier: String {
        return "PROGRAM"
    }
    
    public var player = CNPlayer()

    public var executionHistory = CNExecutionHistory()
    
    public func clear() {
        player.clear(nil)
        executionHistory.clear()
    }
    
    override public func execute() throws -> CNValue {
        clear()
        return try super.execute()
    }
    
    override public func commonInit() {
        variables.append(CNVariable(variableName: "PI", variableValue: CNValue.double(value: M_PI)))
        variables.append(CNVariable(variableName: "2_PI", variableValue: CNValue.double(value: M_2_PI)))
        variables.append(CNVariable(variableName: "PI_2", variableValue: CNValue.double(value: M_PI_2)))
        variables.append(CNVariable(variableName: "EXP", variableValue:  CNValue.double(value: M_E)))
    }
    
}

