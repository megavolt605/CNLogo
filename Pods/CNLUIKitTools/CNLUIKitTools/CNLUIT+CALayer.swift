//
//  CNLUIT+CALayer.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 11/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

public extension CALayer {
    
    public func recursiveDescription(prefix: String = "") -> String {
        
        if let sl = sublayers {
            var desc = "\(prefix)\(self) (\(sl.count) sublayers)"
            
            for subview in sl {
                let sd = subview.recursiveDescription(prefix: prefix + "  ")
                desc += "\r\n\(sd)"
            }
            return desc
        }
        return "\(prefix)\(self)"
    }
 
}
