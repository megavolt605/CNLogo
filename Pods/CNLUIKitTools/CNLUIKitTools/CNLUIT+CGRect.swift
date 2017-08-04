//
//  CNLUIT+CGRect.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 11/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import CoreGraphics

public extension CGRect {
    
    public var center: CGPoint { return CGPoint(x: midX, y: midY) }
    
    public func centeredRect(_ center: CGPoint) -> CGRect {
        return CGRect(
            x: center.x - size.width / 2.0,
            y: center.y - size.height / 2.0,
            width: size.width,
            height: size.height
        )
    }
    
}
