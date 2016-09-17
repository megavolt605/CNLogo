//
//  CNLogo+UIImage.swift
//  CNLogo
//
//  Created by Igor Smirnov on 03/10/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

extension UIImage {

    func imageWithColor(_ color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        context?.setBlendMode(CGBlendMode.copy)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.draw(cgImage!, in: rect)
        
        context?.clip(to: rect, mask: cgImage!)
        context?.addRect(rect)
        context?.drawPath(using: CGPathDrawingMode.fill)
        
        let coloredImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return coloredImg!
    }

}

