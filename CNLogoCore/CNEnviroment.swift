//
//  CNEnviroment.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 28/09/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

public class CNEnviroment {
    
    public var storedPrograms: [CNProgram] = []
    public var currentProgram: CNProgram!

    class public var defaultEnviroment: CNEnviroment {
        get {
            struct Static {
                static var instance: CNEnviroment? = nil
                static var token: dispatch_once_t = 0
            }
            dispatch_once(&Static.token) { Static.instance = CNEnviroment() }
            return Static.instance!
        }
    }
    
    
}