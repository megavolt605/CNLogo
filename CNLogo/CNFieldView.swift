//
//  CNFieldView.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

class CNFieldView: UIView {
    
    var drawingLayer = CALayer()
    var playerLayer = CALayer()
    
    var layers: [CALayer] = []
    
    func clear() {
        
        if drawingLayer.superlayer == nil {
            layer.addSublayer(drawingLayer)
        }
        
        if playerLayer.superlayer == nil {
            let image = UIImage(named: "player")!.CGImage
            playerLayer.contents = image
            playerLayer.anchorPoint = CGPointMake(0.5, 1.0)
            playerLayer.frame = CGRectMake(0.0, 0.0, 20.0, 20.0)
            playerLayer.position = CGPointMake(program.player.startState.position.x, program.player.startState.position.y)
            layer.addSublayer(playerLayer)
        }
        
        drawingLayer.removeAllAnimations()
        layers.forEach {
            $0.removeAllAnimations()
            $0.removeFromSuperlayer()
        }
        
        setNeedsDisplay()
    }
    
}
