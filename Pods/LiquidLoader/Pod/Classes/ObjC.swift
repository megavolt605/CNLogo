//
//  ObjC.swift
//  test
//
//  Created by Prasanga Siripala on 9/25/15.
//  Copyright © 2015 PJ Engineering and Business Solutions Pty. Ltd. All rights reserved.
//

import Foundation
import UIKit

@objc public enum ObjCEffect: Int {
    case Line
    case Circle
    case GrowLine
    case GrowCircle
}

extension LiquidLoader {
    
    @objc public convenience init(frame: CGRect, effect: ObjCEffect, color: UIColor) {
        var s: Effect
        
        if effect == .Line {
            s = Effect.Line(color)
        } else if effect == .Circle {
            s = Effect.Circle(color)
        } else if effect == .GrowLine {
            s = Effect.GrowLine(color)
        } else { //if effect == .GrowCircle {
            s = Effect.GrowCircle(color)
        }
        
        self.init(frame: frame, effect: s)
    }
    
}