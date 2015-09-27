//
//  CNVisualElements.swift
//  CNLogo
//
//  Created by Igor Smirnov on 24/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

// experimental 

class CNBubble: UIView {

    var text: String
    var color: UIColor
    var size: CGSize = CGSizeZero
    var bold: Bool
    
    private var strSize: CGSize = CGSizeZero
    
    func textAttrs() -> [String: AnyObject] {
        return [
            NSFontAttributeName: bold ? UIFont.boldSystemFontOfSize(10.0) : UIFont.systemFontOfSize(10.0),
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]
    }
    
    func calcSize() {
        
        let attrs = textAttrs()
        
        let str = NSAttributedString(string: text, attributes: attrs)
        
        let strRect = str.boundingRectWithSize(
            CGSizeMake(CGFloat.infinity, 0.0),
            options: .UsesLineFragmentOrigin, //NSStringDrawingOptions(),
            context: nil
        )
        strSize = CGSizeMake(strRect.width, strRect.height)
        size = CGSizeMake(strRect.width + 10.0, size.height - 1.0)
    }
    
    override func drawRect(rect: CGRect) {
        
        let attrs = textAttrs()
        let str = NSString(string: text)
        let rectanglePath = UIBezierPath(roundedRect: CGRect(origin: CGPointZero, size: size), cornerRadius: size.height / 2.0)
        
        color.setFill()
        rectanglePath.fill()
        let strOrigin = CGPointMake((size.width - strSize.width) / 2.0, (size.height - strSize.height) / 2.0 - 1.0)
        str.drawInRect(CGRect(origin: strOrigin, size: strSize), withAttributes: attrs)
    }
    
    init(text: String, color: UIColor, height: CGFloat, bold: Bool) {
        self.text = text
        self.color = color
        self.size.height = height
        self.bold = bold
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.opaque = false
        self.calcSize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CNBubbleBlockStart: CNBubble {
 
    
    override func calcSize() {
        
        let attrs = textAttrs()
        
        let str = NSAttributedString(string: text, attributes: attrs)
        
        let strRect = str.boundingRectWithSize(
            CGSizeMake(CGFloat.infinity, 0.0),
            options: .UsesLineFragmentOrigin, //NSStringDrawingOptions(),
            context: nil
        )
        strSize = CGSizeMake(strRect.width, strRect.height)
        size = CGSizeMake(strRect.width + 20.0, size.height)
    }
    
    override func drawRect(rect: CGRect) {
        
        let attrs = textAttrs()
        let str = NSString(string: text)

        
        let rectangleRect = CGRect(origin: CGPointZero, size: size)
        let rectanglePath = UIBezierPath(roundedRect: rectangleRect, byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.TopRight, UIRectCorner.BottomRight], cornerRadii: CGSizeMake(size.height / 2.0, size.height / 2.0))
        rectanglePath.closePath()
        color.setFill()
        rectanglePath.fill()
        let strOrigin = CGPointMake((size.width - strSize.width) / 2.0, (size.height - strSize.height) / 2.0)
        str.drawInRect(CGRect(origin: strOrigin, size: strSize), withAttributes: attrs)
    }
    
}

class CNBubbleBlockEnd: CNBubble {
    
    override func calcSize() {
        
        let attrs = textAttrs()
        
        let str = NSAttributedString(string: text, attributes: attrs)
        
        let strRect = str.boundingRectWithSize(
            CGSizeMake(CGFloat.infinity, 0.0),
            options: .UsesLineFragmentOrigin, //NSStringDrawingOptions(),
            context: nil
        )
        strSize = CGSizeMake(strRect.width, strRect.height)
        size = CGSizeMake(strRect.width + 20.0, size.height - 1.0)
    }
    
    override func drawRect(rect: CGRect) {
        
        let attrs = textAttrs()
        let str = NSString(string: text)
        
        
        let rectangleRect = CGRect(origin: CGPointZero, size: size)
        let rectanglePath = UIBezierPath(roundedRect: rectangleRect, byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.TopRight, UIRectCorner.BottomRight], cornerRadii: CGSizeMake(size.height / 2.0, size.height / 2.0))
        rectanglePath.closePath()
        color.setFill()
        rectanglePath.fill()
        let strOrigin = CGPointMake((size.width - strSize.width) / 2.0, (size.height - strSize.height) / 2.0)
        str.drawInRect(CGRect(origin: strOrigin, size: strSize), withAttributes: attrs)
    }
}

class CNBubbleBlockShift: CNBubble {
    
    override func calcSize() {
        
        let attrs = textAttrs()
        
        let str = NSAttributedString(string: text, attributes: attrs)
        
        let strRect = str.boundingRectWithSize(
            CGSizeMake(CGFloat.infinity, 0.0),
            options: .UsesLineFragmentOrigin, //NSStringDrawingOptions(),
            context: nil
        )
        strSize = CGSizeMake(strRect.width, strRect.height)
        size = CGSizeMake(strRect.width + 10.0, size.height)
    }
    
    override func drawRect(rect: CGRect) {
        
        let attrs = textAttrs()
        let str = NSString(string: text)
        
        
        let rectangleRect = CGRect(origin: CGPointZero, size: size)
        let rectanglePath = UIBezierPath(rect: rectangleRect)
        rectanglePath.closePath()
        color.setFill()
        rectanglePath.fill()
        let strOrigin = CGPointMake((size.width - strSize.width) / 2.0, (size.height - strSize.height) / 2.0)
        str.drawInRect(CGRect(origin: strOrigin, size: strSize), withAttributes: attrs)
    }
}


