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
    
    func willExecuteHistoryItem(_ item: CNLCExecutionHistoryItem)
    func didFinishExecution()
    
}

class CNFieldView: UIView {
    
    var snapshotView = UIImageView()
    var drawingView = UIView()
    var playerLayer = CALayer()
    
    var layers: [CALayer] = []

    var currentIndex = 0
    var runState = CNRunState.stopped
    weak var delegate: CNFieldViewDelegate?
    
    func addPlayerAnimation(_ fromPoint: CGPoint, toPoint: CGPoint) {

        let playerAnimationX = CABasicAnimation(keyPath: "position.x")
        playerAnimationX.fromValue = fromPoint.x
        playerAnimationX.toValue = toPoint.x
        playerAnimationX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        playerAnimationX.fillMode = kCAFillModeForwards
        playerAnimationX.isRemovedOnCompletion = false
        playerLayer.add(playerAnimationX, forKey: "playerAnimationX")
        
        let playerAnimationY = CABasicAnimation(keyPath: "position.y")
        playerAnimationY.fromValue = fromPoint.y
        playerAnimationY.toValue = toPoint.y
        playerAnimationY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        playerAnimationY.fillMode = kCAFillModeForwards
        playerAnimationY.isRemovedOnCompletion = false
        playerLayer.add(playerAnimationY, forKey: "playerAnimationY")
        
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
            snapshotView.isOpaque = false
            snapshotView.frame = UIScreen.main.bounds
            snapshotView.contentMode = .scaleAspectFit
            addSubview(snapshotView)
        }
        snapshotView.image = nil
        
        if drawingView.superview == nil {
            drawingView.isOpaque = false
            drawingView.frame = UIScreen.main.bounds
            addSubview(drawingView)
        }
        
        if playerLayer.superlayer == nil {
            let image = UIImage(named: "player")!.cgImage
            playerLayer.isOpaque = false
            playerLayer.contents = image
            playerLayer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            playerLayer.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
            layer.addSublayer(playerLayer)
        }
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.0)
        let playerAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        playerAnimation.fromValue = 0.0
        playerAnimation.toValue = 0.0
        playerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        playerAnimation.fillMode = kCAFillModeForwards
        playerAnimation.isRemovedOnCompletion = false
        playerLayer.add(playerAnimation, forKey: "playerRotation")
        CATransaction.commit()
        
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            playerLayer.position = CGPoint(
                x: program.player.startState.position.x,
                y: program.player.startState.position.y
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
    
    func makeSnapshot(_ force: Bool = false) {
        if (layers.count > 200) || force {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
            // Render the layer hierarchy to the current context
            snapshotView.drawHierarchy(in: bounds, afterScreenUpdates: false)
            drawingView.drawHierarchy(in: bounds, afterScreenUpdates: true)
            let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        
            snapshotView.image = viewImage

            layers.forEach {
                $0.removeFromSuperlayer()
            }
            layers = []
        }
    }
    
    func addStrokeWithItem(_ item: CNLCExecutionHistoryItem, fromPoint: CGPoint, toPoint: CGPoint, options: CNOptions, completion: CNAnimationCompletion?) {
        if options.shouldAnimate {
            CATransaction.begin()
            CATransaction.setAnimationDuration(options.duration)
            CATransaction.setCompletionBlock(completion)
            let layer = CAShapeLayer()
            let path = CGMutablePath()
            path.move(to: fromPoint)
            path.addLine(to: toPoint)
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
            strokeAnimation.isRemovedOnCompletion = false
            layer.add(strokeAnimation, forKey: "strokeAnimation")
            addPlayerMoveWithItem(item, fromPoint: fromPoint, toPoint: toPoint, options: options, completion: nil)
            CATransaction.commit()
        } else {
            let layer = CAShapeLayer()
            let path = CGMutablePath()
            path.move(to: fromPoint)
            path.addLine(to: toPoint)
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
    
    func addPlayerMoveWithItem(_ item: CNLCExecutionHistoryItem, fromPoint: CGPoint, toPoint: CGPoint, options: CNOptions, completion: CNAnimationCompletion?) {
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

    func addPlayerRotationWithItem(_ item: CNLCExecutionHistoryItem, fromAngle: CGFloat, toAngle: CGFloat, options: CNOptions, completion: CNAnimationCompletion?) {
        if options.shouldAnimate {
            CATransaction.begin()
            CATransaction.setAnimationDuration(options.duration)
            CATransaction.setCompletionBlock(completion)
            let playerAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            playerAnimation.fromValue = fromAngle
            playerAnimation.toValue = toAngle
            playerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            playerAnimation.fillMode = kCAFillModeForwards
            playerAnimation.isRemovedOnCompletion = false
            playerLayer.add(playerAnimation, forKey: "playerRotation")
            CATransaction.commit()
        } else {
            completion?()
        }
    }
    
    func visualizeResult(_ options: CNOptions) {
        currentIndex = 0
        visualizeStep(options)
    }
    
    func visualizeStep(_ options: CNOptions) {
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            let history = program.executionHistory
            if currentIndex < history.history.count {
                if runState == .executing {
                    makeSnapshot()
                    var shouldBreak = true
                    repeat {
                        shouldBreak = true
                        let item = history.history[currentIndex]
                        delegate?.willExecuteHistoryItem(item)
                        switch item.type {
                        case .clear:
                            clear()
                            currentIndex += 1
                            shouldBreak = false
                        case let .move(fromPoint, toPoint, _):
                            if item.playerState.tailDown {
                                addStrokeWithItem(item, fromPoint: fromPoint, toPoint: toPoint, options: options) {
                                    self.currentIndex += 1
                                    if !options.shouldAnimate {
                                        shouldBreak = false
                                    } else {
                                        DispatchQueue.main.async { self.visualizeStep(options) }
                                    }
                                }
                            } else {
                                addPlayerMoveWithItem(item, fromPoint: fromPoint, toPoint: toPoint, options: options) {
                                    self.currentIndex += 1
                                    if !options.shouldAnimate {
                                        shouldBreak = false
                                    } else {
                                        DispatchQueue.main.async { self.visualizeStep(options) }
                                    }
                                }
                            }
                        case let .rotate(fromAngle, toAngle):
                            addPlayerRotationWithItem(item, fromAngle: fromAngle, toAngle: toAngle, options: options) { 
                                self.currentIndex += 1
                                if !options.shouldAnimate {
                                    shouldBreak = false
                                } else {
                                    DispatchQueue.main.async { self.visualizeStep(options) }
                                }
                            }
                        case let .print(value):
                            print(value)
                            currentIndex += 1
                            shouldBreak = false
                        case .tailState, .color, .width, .scale, .step, .stepIn, .stepOut:
                            currentIndex += 1
                            shouldBreak = false
                            break
                        }
                        
                    } while !shouldBreak && (currentIndex < program.executionHistory.history.count)
                }
            }
            
            if currentIndex >= history.history.count {
                makeSnapshot(true)
                runState = .stopped
                delegate?.didFinishExecution()
            }
        }
    }
    
    func execute(_ options: CNOptions) -> CNLCValue {
        if let program = CNLCEnviroment.defaultEnviroment.currentProgram {
            program.clear()
            program.player.startState.position = CGPoint(x: bounds.midX, y: bounds.midY)
            clear()
            let result = program.execute()
            if !options.shouldAnimate {
                updatePlayerPosition()
            }
            visualizeResult(options)
            return result
        }
        return CNLCValue.error(block: nil, error: .noProgram)
    }
    
}

