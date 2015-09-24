//
//  CNFieldView.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

typealias CNAnimationCompletion = (Bool) -> Void

class CNFieldView: UIView {
    
    var snapshotView = UIImageView()
    var drawingView = UIView()
    var playerLayer = CALayer()
    
    var layers: [CALayer] = []
    
    func clear() {
        
        if snapshotView.superview == nil {
            snapshotView.opaque = false
            snapshotView.frame = UIScreen.mainScreen().bounds
            addSubview(snapshotView)
        }
        snapshotView.image = nil
        
        if drawingView.superview == nil {
            drawingView.opaque = false
            drawingView.frame = UIScreen.mainScreen().bounds
            addSubview(drawingView)
        }
        
        if playerLayer.superlayer == nil {
            let image = UIImage(named: "player")!.CGImage
            playerLayer.opaque = false
            playerLayer.contents = image
            playerLayer.anchorPoint = CGPointMake(0.5, 1.0)
            playerLayer.frame = CGRectMake(0.0, 0.0, 20.0, 20.0)
            playerLayer.position = CGPointMake(program.player.startState.position.x, program.player.startState.position.y)
            layer.addSublayer(playerLayer)
        }
        
        drawingView.layer.removeAllAnimations()
        layers.forEach {
            $0.removeAllAnimations()
            $0.removeFromSuperlayer()
        }
        
        layers = []
        
        setNeedsDisplay()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawingView.frame = bounds
        snapshotView.frame = bounds
    }
    
    func makeSnapshot(force: Bool = false) {
        if (layers.count > 200) || force {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
            // Render the layer hierarchy to the current context
            snapshotView.drawViewHierarchyInRect(bounds, afterScreenUpdates: false)
            drawingView.drawViewHierarchyInRect(bounds, afterScreenUpdates: false)
            let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        
            snapshotView.image = viewImage

            layers.forEach {
                $0.removeFromSuperlayer()
            }
            layers = []
        }
    }
    
    func addStrokeWithItem(item: CNExecutionHistoryItem, fromPoint: CGPoint, toPoint: CGPoint, duration: CFTimeInterval, completion: CNAnimationCompletion?) {
        let layer = CAShapeLayer()
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, fromPoint.x, fromPoint.y)
        CGPathAddLineToPoint(path, nil, toPoint.x, toPoint.y)
        layer.path = path
        layer.strokeColor = item.playerState.color
        layer.lineWidth = item.playerState.width
        layer.strokeEnd = duration > 0.01 ? 0.0 : 1.0
        drawingView.layer.addSublayer(layer)
        layers.append(layer)
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = duration
        strokeAnimation.fromValue = 0.0
        strokeAnimation.toValue = 1.0
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        strokeAnimation.fillMode = kCAFillModeForwards
        strokeAnimation.removedOnCompletion = false
        strokeAnimation.completion = completion
        layer.addAnimation(strokeAnimation, forKey: "strokeAnimation")
        addPlayerMoveWithItem(item, fromPoint: fromPoint, toPoint: toPoint, duration: duration, completion: nil)

    }
    
    func addPlayerMoveWithItem(item: CNExecutionHistoryItem, fromPoint: CGPoint, toPoint: CGPoint, duration: CFTimeInterval, completion: CNAnimationCompletion?) {
        let playerAnimationX = CABasicAnimation(keyPath: "position.x")
        playerAnimationX.duration = duration
        playerAnimationX.fromValue = fromPoint.x
        playerAnimationX.toValue = toPoint.x
        playerAnimationX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        playerAnimationX.fillMode = kCAFillModeForwards
        playerAnimationX.removedOnCompletion = false
        playerAnimationX.completion = completion
        playerLayer.addAnimation(playerAnimationX, forKey: "playerAnimationX")
        
        let playerAnimationY = CABasicAnimation(keyPath: "position.y")
        playerAnimationY.duration = duration
        playerAnimationY.fromValue = fromPoint.y
        playerAnimationY.toValue = toPoint.y
        playerAnimationY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        playerAnimationY.fillMode = kCAFillModeForwards
        playerAnimationY.removedOnCompletion = false
        playerLayer.addAnimation(playerAnimationY, forKey: "playerAnimationY")
    }

    func addPlayerRotationWithItem(item: CNExecutionHistoryItem, fromAngle: CGFloat, toAngle: CGFloat, duration: CFTimeInterval, completion: CNAnimationCompletion?) {
        let playerAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        playerAnimation.duration = duration
        playerAnimation.fromValue = fromAngle
        playerAnimation.toValue = toAngle
        playerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        playerAnimation.fillMode = kCAFillModeForwards
        playerAnimation.removedOnCompletion = false
        playerAnimation.completion = completion
        playerLayer.addAnimation(playerAnimation, forKey: "playerRotation")
    }
}

