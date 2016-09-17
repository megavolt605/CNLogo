//
//  CNBubbleBlockStartView.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

class CNBubbleBlockStartView: CNBubbleView {
    
    override func calcSize() {
        
        let attrs = textAttrs()
        
        let str = NSAttributedString(string: text, attributes: attrs)
        
        let strRect = str.boundingRect(
            with: CGSize(width: CGFloat.infinity, height: 0.0),
            options: .usesLineFragmentOrigin, //NSStringDrawingOptions(),
            context: nil
        )
        strSize = CGSize(width: strRect.width, height: strRect.height)
        size = CGSize(width: strRect.width + 8.0, height: size.height)
    }
    
    override func draw(_ rect: CGRect) {
        
        let attrs = textAttrs()
        let str = NSString(string: text)
        
        let rectangleRect = CGRect(x: 0.0, y: 5.0, width: size.width, height: size.height - 10.0)
        let rectanglePath = UIBezierPath(
            roundedRect: rectangleRect,
            byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight, UIRectCorner.bottomRight],
            cornerRadii: CGSize(width: size.height / 4.0, height: size.height / 4.0)
        )
        rectanglePath.close()
        rectanglePath.move(to: CGPoint(x: 0.0, y: size.height / 2.0))
        rectanglePath.addLine(to: CGPoint(x: 4.0, y: size.height / 2.0))
        rectanglePath.addLine(to: CGPoint(x: 4.0, y: size.height))
        rectanglePath.addLine(to: CGPoint(x: 0.0, y: size.height))
        rectanglePath.close()
        color.setFill()
        rectanglePath.fill()
        let strOrigin = CGPoint(x: (size.width - strSize.width) / 2.0, y: (size.height - strSize.height) / 2.0)
        str.draw(in: CGRect(origin: strOrigin, size: strSize), withAttributes: attrs)
    }
    
}
