//
//  CNLogo+UIImage.swift
//  CNLogo
//
//  Created by Igor Smirnov on 03/10/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

extension UIImage {

    func imageWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        
        CGContextTranslateCTM(context, 0, size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        
        CGContextSetBlendMode(context, CGBlendMode.Copy)
        let rect = CGRectMake(0, 0, size.width, size.height)
        CGContextDrawImage(context, rect, CGImage)
        
        CGContextClipToMask(context, rect, CGImage)
        CGContextAddRect(context, rect)
        CGContextDrawPath(context, CGPathDrawingMode.Fill)
        
        let coloredImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return coloredImg
    }

}

