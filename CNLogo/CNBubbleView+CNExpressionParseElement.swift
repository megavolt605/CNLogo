//
//  CNBubbleView+CNExpressionParseElement.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit
import CNLogoCore

extension CNExpressionParseElement {
    
    func createBubbles(inBlock: CNBlock, height: CGFloat) -> [CNBubbleView] {
        switch self {
        case let .Value(value):
            switch value {
            case let .Color(color):
                return [CNBubbleView(text: "  ", color: color, height: height, bold: false)]
            default:
                return [CNBubbleView(
                    text: description,
                    color: UIColor(red: 0.75, green: 1.0, blue: 0.75, alpha: 1.0), height: height, bold: false
                    )]
            }
        case let .Variable(name):
            return [CNBubbleView(
                text: name,
                color: UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0), height: height, bold: false
                )]
        case let .Function(functionName, functionParameters):
            let function = inBlock.functionByName(functionName)
            var res: [CNBubbleView] = [
                CNBubbleView(text: "\(description) (", color: UIColor.orangeColor(), height: height, bold: false)
            ]
            functionParameters.enumerate().forEach { index, parameter in
                if index > 0 {
                    res.append(CNBubbleView(text: ", ", color: UIColor.clearColor(), height: height, bold: false))
                }
                if let parameterName = function?.formalParameters[index].variableName {
                    res.append(CNBubbleView(text: parameterName, color: UIColor.cyanColor(), height: height, bold: false))
                }
                res += (parameter.createBubbles(inBlock, height: height)) ?? []
            }
            res.append(CNBubbleView(text: ")", color: UIColor.orangeColor(), height: height, bold: false))
            return res
        default: break
        }
        return [CNBubbleView(
            text: description,
            color: UIColor(red: 1.0, green: 0.75, blue: 0.75, alpha: 1.0), height: height, bold: false
            )]
    }
    
}
