//
//  CNFieldView.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import CNLogoCore
import UIKit

typealias CNAnimationCompletion = () -> Void

protocol CNFieldViewDelegate: class {
    
    func willExecuteHistoryItem(item: CNLCExecutionHistoryItem)
    func didFinishExecution()
    
}

class CNFieldView: UIView {
    
    var snapshotView = UIImageView()
    var drawingView = UIView()
    var playerLayer = CALayer()
    
    var layers: [CALayer] = []

    var currentIndex = 0
    var runState = CNRunState.Stopped
    weak var delegate: CNFieldViewDelegate?
    
    func addPlayerAnimation(fromPoint: CGPoint, toPoint: CGPoint) {

        let playerAnimationX = CABasicAnimation(keyPath: "position.x")
        playerAnimationX.fromValue = fromPoint.x
        playerAnimationX.toValue = toPoint.x
        playerAnimationX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        playerAnimationX.fillMode = kCAFillModeForwards
        playerAnimationX.removedOnCompletion = false
        playerLayer.addAnimation(playerAnimationX, forKey: "playerAnimationX")
        
        let playerAnimationY = CABasicAnimation(keyPath: "position.y")
        playerAnimationY.fromValue = fromPoint.y
        playerAnimationY.toValue = toPoint.y
        playerAnimationY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        playerAnimationY.fillMode = kCAFillModeForwards
        playerAnimationY.removedOnCompletion = false
        playerLayer.addAnimation(playerAnimationY, forKey: "playerAnimationY")
        
    }
    
    func updatePlayerPosition() {
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.0)// setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            addPlayerAnimation(playerLayer.position, toPoint: program.player.state.position)
            CATransaction.commit()
        }
    }
    
    func clear() {
        
        drawingView.layer.removeAllAnimations()
        layers.forEach {
            $0.removeAllAnimations()
            $0.removeFromSuperlayer()
        }
        
        if snapshotView.superview == nil {
            snapshotView.opaque = false
            snapshotView.frame = UIScreen.mainScreen().bounds
            snapshotView.contentMode = .ScaleAspectFit
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
            layer.addSublayer(playerLayer)
        }
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.0)
        let playerAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        playerAnimation.fromValue = 0.0
        playerAnimation.toValue = 0.0
        playerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        playerAnimation.fillMode = kCAFillModeForwards
        playerAnimation.removedOnCompletion = false
        playerLayer.addAnimation(playerAnimation, forKey: "playerRotation")
        CATransaction.commit()
        
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            playerLayer.position = CGPointMake(
                program.player.startState.position.x,
                program.player.startState.position.y
            )
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
            drawingView.drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
            let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        
            snapshotView.image = viewImage

            layers.forEach {
                $0.removeFromSuperlayer()
            }
            layers = []
        }
    }
    
    func addStrokeWithItem(item: CNLCExecutionHistoryItem, fromPoint: CGPoint, toPoint: CGPoint, options: CNOptions, completion: CNAnimationCompletion?) {
        if options.shouldAnimate {
            CATransaction.begin()
            CATransaction.setAnimationDuration(options.duration)
            CATransaction.setCompletionBlock(completion)
            let layer = CAShapeLayer()
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, fromPoint.x, fromPoint.y)
            CGPathAddLineToPoint(path, nil, toPoint.x, toPoint.y)
            layer.path = path
            layer.strokeColor = item.playerState.color
            layer.lineWidth = item.playerState.width
            layer.strokeEnd = options.shouldAnimate ? 0.0 : 1.0
            layer.lineCap = kCALineCapRound
            drawingView.layer.addSublayer(layer)
            layers.append(layer)
            let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeAnimation.fromValue = 0.0
            strokeAnimation.toValue = 1.0
            strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            strokeAnimation.fillMode = kCAFillModeForwards
            strokeAnimation.removedOnCompletion = false
            layer.addAnimation(strokeAnimation, forKey: "strokeAnimation")
            addPlayerMoveWithItem(item, fromPoint: fromPoint, toPoint: toPoint, options: options, completion: nil)
            CATransaction.commit()
        } else {
            let layer = CAShapeLayer()
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, fromPoint.x, fromPoint.y)
            CGPathAddLineToPoint(path, nil, toPoint.x, toPoint.y)
            layer.path = path
            layer.strokeColor = item.playerState.color
            layer.lineWidth = item.playerState.width
            layer.strokeEnd = 1.0
            layer.lineCap = kCALineCapRound
            drawingView.layer.addSublayer(layer)
            layers.append(layer)
            completion?()
        }
    }
    
    func addPlayerMoveWithItem(item: CNLCExecutionHistoryItem, fromPoint: CGPoint, toPoint: CGPoint, options: CNOptions, completion: CNAnimationCompletion?) {
        if options.shouldAnimate {
            CATransaction.begin()
            CATransaction.setAnimationDuration(options.duration)
            CATransaction.setCompletionBlock(completion)
            addPlayerAnimation(fromPoint, toPoint: toPoint)
            CATransaction.commit()
        } else {
            completion?()
        }
    }

    func addPlayerRotationWithItem(item: CNLCExecutionHistoryItem, fromAngle: CGFloat, toAngle: CGFloat, options: CNOptions, completion: CNAnimationCompletion?) {
        if options.shouldAnimate {
            CATransaction.begin()
            CATransaction.setAnimationDuration(options.duration)
            CATransaction.setCompletionBlock(completion)
            let playerAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            playerAnimation.fromValue = fromAngle
            playerAnimation.toValue = toAngle
            playerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            playerAnimation.fillMode = kCAFillModeForwards
            playerAnimation.removedOnCompletion = false
            playerLayer.addAnimation(playerAnimation, forKey: "playerRotation")
            CATransaction.commit()
        } else {
            completion?()
        }
    }
    
    func visualizeResult(options: CNOptions) {
        currentIndex = 0
        visualizeStep(options)
    }
    
    func visualizeStep(options: CNOptions) {
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            let history = program.executionHistory
            if currentIndex < history.history.count {
                if runState == .Executing {
                    makeSnapshot()
                    var shouldBreak = true
                    repeat {
                        shouldBreak = true
                        let item = history.history[currentIndex]
                        delegate?.willExecuteHistoryItem(item)
                        switch item.type {
                        case .Clear:
                            clear()
                            currentIndex += 1
                            shouldBreak = false
                        case let .Move(fromPoint, toPoint, _):
                            if item.playerState.tailDown {
                                addStrokeWithItem(item, fromPoint: fromPoint, toPoint: toPoint, options: options) { done in
                                    self.currentIndex += 1
                                    if !options.shouldAnimate {
                                        shouldBreak = false
                                    } else {
                                        dispatch_async(dispatch_get_main_queue()) { self.visualizeStep(options) }
                                    }
                                }
                            } else {
                                addPlayerMoveWithItem(item, fromPoint: fromPoint, toPoint: toPoint, options: options) { done in
                                    self.currentIndex += 1
                                    if !options.shouldAnimate {
                                        shouldBreak = false
                                    } else {
                                        dispatch_async(dispatch_get_main_queue()) { self.visualizeStep(options) }
                                    }
                                }
                            }
                        case let .Rotate(fromAngle, toAngle):
                            addPlayerRotationWithItem(item, fromAngle: fromAngle, toAngle: toAngle, options: options) { done in
                                self.currentIndex += 1
                                if !options.shouldAnimate {
                                    shouldBreak = false
                                } else {
                                    dispatch_async(dispatch_get_main_queue()) { self.visualizeStep(options) }
                                }
                            }
                        case let .Print(value):
                            print(value)
                            currentIndex += 1
                            shouldBreak = false
                        case .TailState, .Color, .Width, .Scale, .Step, .StepIn, .StepOut:
                            currentIndex += 1
                            shouldBreak = false
                            break
                        }
                        
                    } while !shouldBreak && (currentIndex < program.executionHistory.history.count)
                }
            }
            
            if currentIndex >= history.history.count {
                makeSnapshot(true)
                runState = .Stopped
                delegate?.didFinishExecution()
            }
        }
    }
    
    func execute(options: CNOptions) -> CNLCValue {
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            program.clear()
            program.player.startState.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
            clear()
            let result = program.execute()
            if !options.shouldAnimate {
                updatePlayerPosition()
            }
            visualizeResult(options)
            return result
        }
        return CNLCValue.Error(block: nil, error: .NoProgram)
    }
    
}

