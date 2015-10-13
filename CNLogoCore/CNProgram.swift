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

public class CNProgram: CNBlock {

    override public var identifier: String {
        return "PROGRAM"
    }
    
    public var programName: String
    
    public var player = CNPlayer()

    public var globalStack = CNStack<CNValue>()
    
    public var executionHistory = CNExecutionHistory()
    
    public func clear() {
        player.clear(nil)
        executionHistory.clear()
    }
    
    override public func execute() throws -> CNValue {
        clear()
        return try super.execute()
    }

    private func internalInit() {
        variables.append(CNVariable(variableName: "PI", variableValue: CNValue.double(value: M_PI)))
        variables.append(CNVariable(variableName: "2_PI", variableValue: CNValue.double(value: M_2_PI)))
        variables.append(CNVariable(variableName: "PI_2", variableValue: CNValue.double(value: M_PI_2)))
        variables.append(CNVariable(variableName: "EXP", variableValue:  CNValue.double(value: M_E)))
    }
    
    public override init() {
        self.programName = "Unnamed program"
        super.init()
    }
    
    public required init(data: [String : AnyObject]) {
        programName = data["program-name"] as! String
        super.init(data: data["program-body"] as! [String : AnyObject])
        internalInit()
    }

    public init(programName: String, statements: [CNStatement]) {
        self.programName = programName
        super.init(statements: statements)
        internalInit()
    }
    
}

