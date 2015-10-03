//
//  CNLoader.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 30/09/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

struct CNLoader {
    
    static let knownStatements: [String: CNStatement.Type] = [
        "FORWARD": CNStatementForward.self,
        "BACKWARD": CNStatementBackward.self,
        "CLEAR": CNStatementClear.self,
        "COLOR": CNStatementColor.self,
        "IF": CNStatementIf.self,
        "PRINT": CNStatementPrint.self,
        "REPEAT": CNStatementRepeat.self,
        "ROTATE": CNStatementRotate.self,
        "SCALE": CNStatementScale.self,
        "TAIL DOWN": CNStatementTailDown.self,
        "TAIL UP": CNStatementTailUp.self,
        "VAR": CNStatementVar.self,
        "WHILE": CNStatementWhile.self,
        "WIDTH": CNStatementWidth.self
    ]
    
    static func createStatement(identifier: String?, info: [String: AnyObject]?) -> CNStatement? {
        if let id = identifier, data = info, statement = knownStatements[id] {
            let res = statement.init(data: data)
            if res.identifier == id {
                return res
            }
        }
        return nil
    }
    
}