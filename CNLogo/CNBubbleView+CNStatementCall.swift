//
//  CNBubbleView+CNStatementCall.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit
import CNLogoCore

extension CNStatementCall {
    
    func createBubblesForParameter(parameter: CNVariable, inBlock: CNBlock, height: CGFloat) -> [CNBubbleView]  {
        let value = parameter.variableValue
        return [CNBubbleView(text: "\(parameter.variableName): \(value.description)", color: UIColor.cyanColor(), height: height, bold: false)]
        //        let value = try parameter.variableValue.execute()
        //        return [CNBubbleView(text: "\(parameter.variableName): \(value.description)", color: UIColor.cyanColor(), height: height, bold: false)]
    }
    
    @objc override func createBubbles(inBlock: CNBlock, height: CGFloat, prefix: String = "") -> [CNBubbleView] {
        var res: [CNBubbleView] = (createBlockBubbles(inBlock, height: height, prefix: prefix, bold: true)) ?? []
        
        res.append(CNBubbleView(text: "\(funcName) (", color: UIColor.orangeColor(), height: height, bold: false))
        
        executableParameters.enumerate().forEach { index, parameter in
            if index > 0 {
                res.append(CNBubbleView(text: ", ", color: UIColor.clearColor(), height: height, bold: false, tiny: true))
            }
            res += createBubblesForParameter(parameter, inBlock: inBlock, height: height) ?? []
        }
        
        res.append(CNBubbleView(text: ")", color: UIColor.orangeColor(), height: height, bold: false, tiny: true))
        return res
    }
}

