//
//  CNBlockVisual.swift
//  CNLogo
//
//  Created by Igor Smirnov on 27/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import CNLogoCore
import UIKit

extension CNBlock {
    
    func createBlockBubbles(inBlock: CNBlock, height: CGFloat, prefix: String = "", bold: Bool = false) throws -> [CNBubble] {
        var res: [CNBubble] = []
        let bubbleName = prefix + identifier
        if bubbleName != "" {
            let bubble = CNBubble(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: bold)
            res.append(bubble)
        }
        
        return res
    }
    
    @objc func createBubbles(inBlock: CNBlock, height: CGFloat, prefix: String = "") throws -> [CNBubble] {
        var res = try createBlockBubbles(inBlock, height: height)
        if prefix == "" {
            for param in executableParameters {
                res += try param.createBubbles(inBlock, height: height)
            }
        }
        return res
    }
    
    
}

extension CNStatement {
    
    @objc override func createBubbles(inBlock: CNBlock, height: CGFloat, prefix: String = "") throws -> [CNBubble] {
        var res: [CNBubble] = []
        let bubbleName = prefix + identifier
        if bubbleName != "" {
            let bubble = CNBubble(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: true)
            res.append(bubble)
        }
        
        if prefix == "" {
            for param in executableParameters {
                res += try param.createBubbles(inBlock, height: height)
            }
        }
        return res
    }
    
    
}

extension CNVariable {
    
    func createBubbles(inBlock: CNBlock, height: CGFloat) throws -> [CNBubble] {
        return try self.variableValue.createBubbles(inBlock, height: height)
    }
    
}


extension CNExpression {
    
    @objc override func createBubbles(inBlock: CNBlock, height: CGFloat, prefix: String = "") throws -> [CNBubble] {
        var res: [CNBubble] = []
        if prefix != "" {
            let bubble = CNBubble(text: prefix, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: false)
            res.append(bubble)
        }
        for item in source {
            res += try item.createBubbles(inBlock, height: height)
        }
        return res
    }
    
}

/*
extension CNExecutableParameter {
    
    func createBubbles(inBlock: CNBlock, height: CGFloat, prefix: String = "") -> [CNBubble] {
        var res: [CNBubble] = []
        if prefix != "" {
            let bubble = CNBubble(text: prefix, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: false)
            res.append(bubble)
        }
        if let n = name where n != "" {
            let bubble = CNBubble(text: n, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: false)
            res.append(bubble)
        }
        res += (value.createBubbles(inBlock, height: height) ?? [])
        return res
    }
    
}
*/

extension CNStatementVar {
    
    @objc override func createBubbles(inBlock: CNBlock, height: CGFloat, prefix: String = "") throws -> [CNBubble] {
        var res: [CNBubble] = []
        let bubbleName = prefix + identifier
        if bubbleName != "" {
            let bubble = CNBubble(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: true)
            res.append(bubble)
        }

        var bubble = CNBubble(text: variableName, color: UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0), height: height, bold: false)
        res.append(bubble)
        
        bubble = CNBubble(text: "=", color: UIColor(red: 1.0, green: 0.75, blue: 0.75, alpha: 1.0), height: height, bold: false)
        res.append(bubble)
        
        for param in executableParameters {
            res += try param.createBubbles(inBlock, height: height)
        }
        return res
    }
    
    
}

extension CNExpressionParseElement {

    func createBubbles(inBlock: CNBlock, height: CGFloat) throws -> [CNBubble] {
        switch self {
        case let .Value(value):
            switch value {
            case let .Color(color):
                return [CNBubble(text: "  ", color: color, height: height, bold: false)]
            default:
                return [CNBubble(
                    text: description,
                    color: UIColor(red: 0.75, green: 1.0, blue: 0.75, alpha: 1.0), height: height, bold: false
                    )]
            }
        case let .Variable(name):
            return [CNBubble(
                text: name,
                color: UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0), height: height, bold: false
                )]
        case let .Function(functionName, functionParameters):
            let function = inBlock.functionByName(functionName)
            var res: [CNBubble] = [
                CNBubble(text: "\(description) (", color: UIColor.orangeColor(), height: height, bold: false)
            ]
            try functionParameters.enumerate().forEach { index, parameter in
                if index > 0 {
                    res.append(CNBubble(text: ", ", color: UIColor.clearColor(), height: height, bold: false))
                }
                if let parameterName = function?.formalParameters[index].variableName {
                    res.append(CNBubble(text: parameterName, color: UIColor.cyanColor(), height: height, bold: false))
                }
                res += (try parameter.createBubbles(inBlock, height: height)) ?? []
            }
            res.append(CNBubble(text: ")", color: UIColor.orangeColor(), height: height, bold: false))
            return res
        default: break
        }
        return [CNBubble(
            text: description,
            color: UIColor(red: 1.0, green: 0.75, blue: 0.75, alpha: 1.0), height: height, bold: false
        )]
    }
    
}

extension CNStatementFunction {

    func createBubblesForParameter(parameter: CNVariable, inBlock: CNBlock, height: CGFloat) throws -> [CNBubble]  {
        //let typeDescription = try parameter.variableValue.typeDescription
        return [CNBubble(text: "\(parameter.variableName)", color: UIColor.cyanColor(), height: height, bold: false)]
    }

    @objc override func createBubbles(inBlock: CNBlock, height: CGFloat, prefix: String = "") throws -> [CNBubble] {
        var res: [CNBubble] = (try createBlockBubbles(inBlock, height: height, prefix: prefix, bold: true)) ?? []
        
        if prefix == "" {
            res.append(CNBubble(text: "\(funcName) (", color: UIColor.orangeColor(), height: height, bold: false))
            try formalParameters.enumerate().forEach { index, parameter in
                if index > 0 {
                    res.append(CNBubble(text: ", ", color: UIColor.clearColor(), height: height, bold: false, tiny: true))
                }
                res += try createBubblesForParameter(parameter, inBlock: inBlock, height: height) ?? []
            }
            res.append(CNBubble(text: ")", color: UIColor.orangeColor(), height: height, bold: false, tiny: false))
        } else {
            res.append(CNBubble(text: "\(funcName)", color: UIColor.orangeColor(), height: height, bold: false))
        }
        return res
    }
}

extension CNStatementCall {
    
    func createBubblesForParameter(parameter: CNVariable, inBlock: CNBlock, height: CGFloat) throws -> [CNBubble]  {
        let value = parameter.variableValue
        return [CNBubble(text: "\(parameter.variableName): \(value.description)", color: UIColor.cyanColor(), height: height, bold: false)]
//        let value = try parameter.variableValue.execute()
//        return [CNBubble(text: "\(parameter.variableName): \(value.description)", color: UIColor.cyanColor(), height: height, bold: false)]
    }
    
    @objc override func createBubbles(inBlock: CNBlock, height: CGFloat, prefix: String = "") throws -> [CNBubble] {
        var res: [CNBubble] = (try createBlockBubbles(inBlock, height: height, prefix: prefix, bold: true)) ?? []
        
        res.append(CNBubble(text: "\(funcName) (", color: UIColor.orangeColor(), height: height, bold: false))

        try executableParameters.enumerate().forEach { index, parameter in
            if index > 0 {
                res.append(CNBubble(text: ", ", color: UIColor.clearColor(), height: height, bold: false, tiny: true))
            }
            res += try createBubblesForParameter(parameter, inBlock: inBlock, height: height) ?? []
        }

        res.append(CNBubble(text: ")", color: UIColor.orangeColor(), height: height, bold: false, tiny: true))
        return res
    }
}


