//
//  CNLCLoader.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 30/09/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

struct CNLCLoader {
    
    static let knownStatements: [String: CNLCStatement.Type] = [
        "FORWARD": CNLCStatementForward.self,
        "BACKWARD": CNLCStatementBackward.self,
        "CLEAR": CNLCStatementClear.self,
        "COLOR": CNLCStatementColor.self,
        "IF": CNLCStatementIf.self,
        "PRINT": CNLCStatementPrint.self,
        "REPEAT": CNLCStatementRepeat.self,
        "ROTATE": CNLCStatementRotate.self,
        "SCALE": CNLCStatementScale.self,
        "TAIL DOWN": CNLCStatementTailDown.self,
        "TAIL UP": CNLCStatementTailUp.self,
        "VAR": CNLCStatementVar.self,
        "WHILE": CNLCStatementWhile.self,
        "WIDTH": CNLCStatementWidth.self
    ]
    
    static func createStatement(identifier: String?, info: [String: AnyObject]?) -> CNLCStatement? {
        if let id = identifier, data = info, statement = knownStatements[id] {
            let res = statement.init(data: data)
            if res.identifier == id {
                return res
            }
        }
        return nil
    }
    
}