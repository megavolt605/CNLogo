//
//  CNBubbleBlockShiftView.swift
//  CNLogo
//
//  Created by Igor Smirnov on 08/04/16.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

class CNBubbleBlockShiftView: CNBubbleView {
    
    override func calcSize() {
        
        let attrs = textAttrs()
        
        let str = NSAttributedString(string: text, attributes: attrs)
        
        let strRect = str.boundingRect(
            with: CGSize(width: CGFloat.infinity, height: 0.0),
            options: .usesLineFragmentOrigin, //NSStringDrawingOptions(),
            context: nil
        )
        strSize = CGSize(width: strRect.width, height: strRect.height)
        size = CGSize(width: strRect.width + 12.0, height: size.height)
    }
    
    override func draw(_ rect: CGRect) {
        
        let attrs = textAttrs()
        let str = NSString(string: text)
        let size = CGSize(width: self.size.width - 8.0, height: self.size.height)
        
        let rectangleRect = CGRect(origin: CGPoint.zero, size: size)
        let rectanglePath = UIBezierPath(rect: rectangleRect)
        rectanglePath.close()
        color.setFill()
        rectanglePath.fill()
        let strOrigin = CGPoint(x: (size.width - strSize.width) / 2.0, y: (size.height - strSize.height) / 2.0)
        str.draw(in: CGRect(origin: strOrigin, size: strSize), withAttributes: attrs)
    }
}
