//
//  CNVisualElements.swift
//  CNLogo
//
//  Created by Igor Smirnov on 24/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit
import CNLogoCore

class CNBubbleView: UIView {

    var text: String
    var color: UIColor
    var size: CGSize = CGSize.zero
    var bold: Bool
    var tiny = false
    
    internal var strSize: CGSize = CGSize.zero
    
    func textAttrs() -> [String: Any] {
        return [
            NSFontAttributeName: bold ? UIFont.boldSystemFont(ofSize: 10.0) : UIFont.systemFont(ofSize: 10.0),
            NSForegroundColorAttributeName: UIColor.black
        ]
    }
    
    func calcSize() {
        let str = NSString(string: text)
        let strRect = str.boundingRect(
            with: CGSize(width: CGFloat.infinity, height: 0.0),
            options: [],
            attributes: textAttrs(),
            context: nil
        )
        strSize = CGSize(width: strRect.width, height: strRect.height)
        size = CGSize(width: strRect.width + (tiny ? -2.0 : 10.0), height: size.height - 1.0)
    }
    
    override func draw(_ rect: CGRect) {
        
        let attrs = textAttrs()
        let str = NSString(string: text)
        let rectanglePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerRadius: size.height / 4.0)
        
        color.setFill()
        rectanglePath.fill()
        let strOrigin = CGPoint(x: (size.width - strSize.width) / 2.0, y: (size.height - strSize.height) / 2.0 - 1.0)
        str.draw(in: CGRect(origin: strOrigin, size: strSize), withAttributes: attrs)
    }
    
    func initialize() {
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        self.calcSize()
    }
    
    init(text: String, color: UIColor, height: CGFloat, bold: Bool, tiny: Bool = false) {
        self.text = text
        self.color = color
        self.size.height = height
        self.bold = bold
        self.tiny = tiny
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CNBubbleView {
    
    static func createBlockBubbles(_ block: CNLCBlock, height: CGFloat, prefix: String = "", bold: Bool = false) -> [CNBubbleView] {
        var res: [CNBubbleView] = []
        let bubbleName = prefix + block.identifier
        if bubbleName != "" {
            let bubble = CNBubbleView(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: bold)
            res.append(bubble)
        }
        
        return res
    }
    
    static func createStatementBubbles(_ statement: CNLCStatement, height: CGFloat, prefix: String = "") -> [CNBubbleView] {
        var res: [CNBubbleView] = []
        let bubbleName = prefix + statement.identifier
        if bubbleName != "" {
            let bubble = CNBubbleView(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: true)
            res.append(bubble)
        }
        
        if prefix == "" {
            res += statement.executableParameters
                .map { createVariableBubbles($0, height: height) }
                .flatMap { return $0 }
        }
        return res
    }
    
    static func createStatementVarBubbles(_ statement: CNLCStatementVar, height: CGFloat, prefix: String = "") -> [CNBubbleView] {
        var res: [CNBubbleView] = []
        let bubbleName = prefix + statement.identifier
        if bubbleName != "" {
            let bubble = CNBubbleView(text: bubbleName, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: true)
            res.append(bubble)
        }
        
        var bubble = CNBubbleView(text: statement.variableName, color: UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0), height: height, bold: false)
        res.append(bubble)
        
        bubble = CNBubbleView(text: "=", color: UIColor(red: 1.0, green: 0.75, blue: 0.75, alpha: 1.0), height: height, bold: false)
        res.append(bubble)
        
        res += statement.executableParameters
            .map { createVariableBubbles($0, height: height) }
            .flatMap { $0 }
        
        return res
    }

    static func createBubblesForStatementFunctionParameter(_ parameter: CNLCVariable, inBlock: CNLCBlock, height: CGFloat) -> [CNBubbleView]  {
        return [CNBubbleView(text: "\(parameter.variableName)", color: UIColor.cyan, height: height, bold: false)]
    }
    
    static func createStatementFunctionBubbles(_ function: CNLCStatementFunction, height: CGFloat, prefix: String = "") -> [CNBubbleView] {
        var res = createBlockBubbles(function, height: height, prefix: prefix, bold: true)
        
        if prefix == "" {
            res.append(CNBubbleView(text: "\(function.funcName) (", color: UIColor.orange, height: height, bold: false))
            function.formalParameters.enumerated().forEach { index, parameter in
                if index > 0 {
                    res.append(CNBubbleView(text: ", ", color: UIColor.clear, height: height, bold: false, tiny: true))
                }
                res += createBubblesForStatementFunctionParameter(parameter, inBlock: function, height: height)
            }
            res.append(CNBubbleView(text: ")", color: UIColor.orange, height: height, bold: false, tiny: false))
        } else {
            res.append(CNBubbleView(text: "\(function.funcName)", color: UIColor.orange, height: height, bold: false))
        }
        return res
    }

    static func createBubblesForStatementCallParameter(_ parameter: CNLCVariable, height: CGFloat) -> [CNBubbleView]  {
        let text = "\(parameter.variableName): \(parameter.variableValue.description)"
        return [CNBubbleView(text: text, color: UIColor.cyan, height: height, bold: false)]
    }
    
    static func createStatementCallBubbles(_ statement: CNLCStatementCall, height: CGFloat, prefix: String = "") -> [CNBubbleView] {
        var res = (createBlockBubbles(statement, height: height, prefix: prefix, bold: true))
        
        res.append(CNBubbleView(text: "\(statement.funcName) (", color: UIColor.orange, height: height, bold: false))
        
        statement.executableParameters.enumerated().forEach { index, parameter in
            if index > 0 {
                res.append(CNBubbleView(text: ", ", color: UIColor.clear, height: height, bold: false, tiny: true))
            }
            res += createBubblesForStatementCallParameter(parameter, height: height) 
        }
        
        res.append(CNBubbleView(text: ")", color: UIColor.orange, height: height, bold: false, tiny: false))
        return res
    }

    static func createVariableBubbles(_ variable: CNLCVariable, height: CGFloat) -> [CNBubbleView] {
        return createExpressionBubbles(variable.variableValue, height: height)
    }

    static func createExpressionBubbles(_ expression: CNLCExpression, height: CGFloat, prefix: String = "") -> [CNBubbleView] {
        var res: [CNBubbleView] = []
        if prefix != "" {
            let bubble = CNBubbleView(text: prefix, color: UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), height: height, bold: false)
            res.append(bubble)
        }
        res += expression.source
            .map { createExpressionElementBubbles($0, inBlock: expression, height: height) }
            .flatMap { $0 }
        return res
    }

    static func createExpressionElementBubbles(_ element: CNLCExpressionParseElement, inBlock: CNLCBlock, height: CGFloat) -> [CNBubbleView] {
        switch element {
        case let .Value(value):
            switch value {
            case let .color(color):
                return [CNBubbleView(text: "  ", color: color, height: height, bold: false)]
            default:
                return [CNBubbleView(
                    text: element.description,
                    color: UIColor(red: 0.75, green: 1.0, blue: 0.75, alpha: 1.0), height: height, bold: false
                    )]
            }
        case let .variable(name):
            return [CNBubbleView(
                text: name,
                color: UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0), height: height, bold: false
                )]
        case let .function(functionName, functionParameters):
            let function = inBlock.functionByName(functionName)
            var res: [CNBubbleView] = [
                CNBubbleView(text: "\(description) (", color: UIColor.orange, height: height, bold: false)
            ]
            functionParameters.enumerated().forEach { index, parameter in
                if index > 0 {
                    res.append(CNBubbleView(text: ", ", color: UIColor.clear, height: height, bold: false))
                }
                if let parameterName = function?.formalParameters[index].variableName {
                    res.append(CNBubbleView(text: parameterName, color: UIColor.cyan, height: height, bold: false))
                }
                res += createExpressionBubbles(parameter, height: height)
            }
            res.append(CNBubbleView(text: ")", color: UIColor.orange, height: height, bold: false))
            return res
        default: break
        }
        
        return [CNBubbleView(
            text: element.description,
            color: UIColor(red: 1.0, green: 0.75, blue: 0.75, alpha: 1.0), height: height, bold: false
            )
        ]
    }

    // coz we don't have normal possibilites to override extensions
    static func bubbleFor(_ block: CNLCBlock, height: CGFloat, prefix: String = "") -> [CNBubbleView] {
        
        if let statement = block as? CNLCStatementVar {
            return createStatementVarBubbles(statement, height: height)
        }
        
        if let statement = block as? CNLCStatementFunction {
            return createStatementFunctionBubbles(statement, height: height)
        }
        
        if let statement = block as? CNLCStatementCall {
            return createStatementCallBubbles(statement, height: height)
        }
        
        if let statement = block as? CNLCStatement {
            return createStatementBubbles(statement, height: height)
        }
        
        var res = createBlockBubbles(block, height: height)
        if prefix == "" {
            res += block.executableParameters
                .map { createVariableBubbles($0, height: height) }
                .flatMap { $0 }
        }
        return res
    }
    
}
