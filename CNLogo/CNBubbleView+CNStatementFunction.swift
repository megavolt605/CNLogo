//
//  CNBubbleView+CNStatementFunction.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit
import CNLogoCore

extension CNStatementFunction {
    
    func createBubblesForParameter(parameter: CNVariable, inBlock: CNBlock, height: CGFloat) -> [CNBubbleView]  {
        //let typeDescription = try parameter.variableValue.typeDescription
        return [CNBubbleView(text: "\(parameter.variableName)", color: UIColor.cyanColor(), height: height, bold: false)]
    }
    
    @objc override func createBubbles(inBlock: CNBlock, height: CGFloat, prefix: String = "") -> [CNBubbleView] {
        var res: [CNBubbleView] = (createBlockBubbles(inBlock, height: height, prefix: prefix, bold: true)) ?? []
        
        if prefix == "" {
            res.append(CNBubbleView(text: "\(funcName) (", color: UIColor.orangeColor(), height: height, bold: false))
            formalParameters.enumerate().forEach { index, parameter in
                if index > 0 {
                    res.append(CNBubbleView(text: ", ", color: UIColor.clearColor(), height: height, bold: false, tiny: true))
                }
                res += createBubblesForParameter(parameter, inBlock: inBlock, height: height) ?? []
            }
            res.append(CNBubbleView(text: ")", color: UIColor.orangeColor(), height: height, bold: false, tiny: false))
        } else {
            res.append(CNBubbleView(text: "\(funcName)", color: UIColor.orangeColor(), height: height, bold: false))
        }
        return res
    }
}
