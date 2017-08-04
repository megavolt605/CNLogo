//
//  CNLCheckBox.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 24/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

import CNLFoundationTools

/// State of the check box
///
/// - empty: not checked
/// - tick: checked with tick
/// - cross: checked with cross
public enum CNLCheckBoxState {
    case empty, tick, cross
}

/// Form of the check box
///
/// - circle: Circle shape
/// - square: Square shape
public enum CNLCheckBoxForm {
    case circle, square
}

/// Check box with set of states (empty, tick, cross) with simple animations
public class CNLCheckBox: UIView {
    
    /// Line width for state icons
    public var lineWidth: [CNLCheckBoxState: CGFloat] = [.empty: 2.0, .tick: 4.0, .cross: 4.0]
    private var currentLineWidth: CGFloat { return lineWidth[state] ?? 0.0 }
    
    /// Line color for state icons
    public var lineColor: [CNLCheckBoxState: UIColor] = [.empty: UIColor.white, .tick: UIColor.white, .cross: UIColor.white]
    private var currentLineColor: UIColor { return lineColor[state] ?? UIColor.white }
    
    /// Fill color of inner circle for empty state
    public var emptyFillColor: UIColor = UIColor.white

    /// Border width for empty state
    public var borderLineWidth: [CNLCheckBoxState: CGFloat] = [.empty: 2.0, .tick: 0.0, .cross: 0.0] {
        didSet {
            updateLayers()
        }
    }
    private var currentBorderLineWidth: CGFloat { return borderLineWidth[state] ?? 0.0 }
    
    /// Border color for empty state, fill color for others
    public var fillColor: [CNLCheckBoxState: UIColor] = [.empty: UIColor.black, .tick: UIColor.green, .cross: UIColor.red] {
        didSet {
            updateLayers()
        }
    }
    private var currentFillColor: UIColor { return fillColor[state] ?? UIColor.white }
    
    /// Sequence for automatic state change, default is [.empty, .tick]
    public var stateSequence: [CNLCheckBoxState] = [.empty, .tick] {
        didSet {
            stateSequenceIndex = 0
            //setState(stateSequence[stateSequenceIndex], animated: false)
        }
    }
    public var stateSequenceIndex: Int = 0
    
    /// Current check box state. When changed, state will change without animation
    public var state: CNLCheckBoxState {
        get { return _state }
        set { setState(newValue, animated: false) }
    }
    private var _state: CNLCheckBoxState = .empty
    
    /// Form of the check box
    public var form: CNLCheckBoxForm = .circle {
        didSet {
            updateLayers()
        }
    }
    
    /// Callback when the state was changed
    public var stateWasChanged: ((_ toState: CNLCheckBoxState) -> Void)?
    
    /// State change animation duration
    public var animationDuration: Double = 0.2
    
    private var borderShape: CAShapeLayer!
    private var centerShape: CAShapeLayer!
    
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var sideWidth: CGFloat = 0.0
    private var doublePi: CGFloat = CGFloat.pi * 2.0
    
    /// Init check box within a frame
    ///
    /// - Parameter frame: frame (CGRect)
    override required public init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeUI()
    }
    
    private func initializeUI() {
        sideWidth = min(frame.size.width, frame.size.height)
        backgroundColor = UIColor.white

        borderShape = CAShapeLayer()
        layer.addSublayer(borderShape)
        
        centerShape = CAShapeLayer()
        layer.addSublayer(centerShape)
        
        updateLayers()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    public func removeAllAnimations() {
        borderShape.removeAllAnimations()
        centerShape.removeAllAnimations()
    }
    
    /// Sets new state to the check box. Animatable.
    ///
    /// - Parameters:
    ///   - state: new state
    ///   - animated: animation flag
    public func setState(_ state: CNLCheckBoxState, animated: Bool) {
        if (self.state != state) || !animated {
            _state = state
            
            if let subLayers = borderShape.sublayers {
                for subLayer in subLayers {
                    subLayer.removeFromSuperlayer()
                }
            }

            //updateLayers()
            startBorderLayerAnimation(animated: animated)
            startScaleBorderLayerAnimaiton(animated: animated)

            addStateSublayers(animated: animated)
            stateWasChanged?(_state)
        }
    }
    
    private var borderPath: UIBezierPath {
        let centerPoint = CGPoint(x: sideWidth / 2.0, y: sideWidth / 2.0)
        let result: UIBezierPath
        switch form {
        case .circle:
            result = UIBezierPath(
                arcCenter: centerPoint,
                radius: sideWidth / 2.0,
                startAngle: 0.0,
                endAngle: doublePi,
                clockwise: true
            )
        case .square:
            result = UIBezierPath(
                rect: CGRect(
                    origin: CGPoint.zero,
                    size: CGSize(width: sideWidth, height: sideWidth)
                )
            )
        }
        return result
    }
    
    private var centerPath: UIBezierPath {
        let centerPoint = CGPoint(x: sideWidth / 2.0, y: sideWidth / 2.0)
        let result: UIBezierPath
        switch form {
        case .circle:
            result = UIBezierPath(
                arcCenter: centerPoint,
                radius: sideWidth / 2.0 - currentBorderLineWidth,
                startAngle: 0.0,
                endAngle: doublePi,
                clockwise: true
            )
        case .square:
            result = UIBezierPath(
                rect: CGRect(
                    origin: CGPoint(x: currentBorderLineWidth, y: currentBorderLineWidth),
                    size: CGSize(width: sideWidth - currentBorderLineWidth * 2.0, height: sideWidth - currentBorderLineWidth * 2.0)
                )
            )
        }
        return result
    }
    
    private func updateLayers() {
        borderShape.path = borderPath.cgPath
        borderShape.fillColor = currentFillColor.cgColor
        
        centerShape.path = centerPath.cgPath
        centerShape.fillColor = emptyFillColor.cgColor
    }
    
    @objc private func tapGestureRecognizerAction() {
        if isUserInteractionEnabled {
            if stateSequenceIndex == (stateSequence.count - 1) {
                stateSequenceIndex = 0
            } else {
                stateSequenceIndex += 1
            }
            setState(stateSequence[stateSequenceIndex], animated: true)
        }
    }
    
    private func startBorderLayerAnimation(animated: Bool) {
        if state == .empty {
            let finalPath = centerPath.cgPath
            /*UIBezierPath(
                arcCenter: CGPoint(x: sideWidth / 2.0, y: sideWidth / 2.0),
                radius: sideWidth / 2.0 - currentBorderLineWidth,
                startAngle: 0.0,
                endAngle: doublePi,
                clockwise: true
            ).cgPath*/
            if animated {
                CABasicAnimation(keyPath: "path") --> {
                    $0.fromValue = UIBezierPath(
                        arcCenter: CGPoint(x: sideWidth / 2.0, y: sideWidth / 2.0),
                        radius: 0.1,
                        startAngle: 0.0,
                        endAngle: doublePi,
                        clockwise: true
                        ).cgPath
                    $0.toValue = finalPath
                    $0.duration = animationDuration / 3.0 * 2.0
                    $0.isRemovedOnCompletion = false
                    $0.fillMode = kCAFillModeForwards
                    centerShape.add($0, forKey: nil)
                }
            } else {
                centerShape.path = finalPath
            }
        } else {
            let finalPath = UIBezierPath(
                arcCenter: CGPoint(x: sideWidth / 2.0, y: sideWidth / 2.0),
                radius: 0.1,
                startAngle: 0.0,
                endAngle: doublePi,
                clockwise: true
            ).cgPath
            if animated {
                CABasicAnimation(keyPath: "path") --> {
                    $0.fromValue = UIBezierPath(
                        arcCenter: CGPoint(x: sideWidth / 2.0, y: sideWidth / 2.0),
                        radius: sideWidth / 2.0 - currentBorderLineWidth,
                        startAngle: 0.0,
                        endAngle: doublePi,
                        clockwise:true
                        ).cgPath
                    $0.toValue = finalPath
                    $0.duration = animationDuration / 3.0 * 2.0
                    $0.isRemovedOnCompletion = false
                    $0.fillMode = kCAFillModeForwards
                    centerShape.add($0, forKey: nil)
                }
            } else {
                centerShape.path = finalPath
            }
        }
        
        if animated {
            CABasicAnimation(keyPath: "fillColor") --> {
                $0.toValue = currentFillColor.cgColor
                $0.duration = animationDuration / 3.0 * 2.0
                $0.isRemovedOnCompletion = false
                $0.fillMode = kCAFillModeForwards
                borderShape.add($0, forKey: nil)
            }
        } else {
            borderShape.fillColor = currentFillColor.cgColor
        }
    }
    
    private func startScaleBorderLayerAnimaiton(animated: Bool) {
        
        var toValue = CATransform3DIdentity
        toValue = CATransform3DTranslate(toValue, bounds.size.width / 2.0, bounds.size.height / 2.0, 0.0)
        toValue = CATransform3DScale(toValue, 1.0, 1.0, 1.0)
        toValue = CATransform3DTranslate(toValue, -bounds.size.width / 2.0, -bounds.size.height / 2.0, 0.0)
        
        if animated {
            var byValue = CATransform3DIdentity
            byValue = CATransform3DTranslate(byValue, bounds.size.width / 2.0, bounds.size.height / 2.0, 0.0)
            byValue = CATransform3DScale(byValue, 0.8, 0.8, 1.0)
            byValue = CATransform3DTranslate(byValue, -bounds.size.width / 2.0, -bounds.size.height / 2.0, 0.0)
            
            let firstScaleAnimation = CABasicAnimation(keyPath: "transform") --> {
                $0.toValue = NSValue(caTransform3D: byValue)
                $0.duration = animationDuration / 2.0
                $0.isRemovedOnCompletion = false
                $0.fillMode = kCAFillModeForwards
            }
            
            let secondScaleAnimation = CABasicAnimation(keyPath: "transform") --> {
                $0.toValue = NSValue(caTransform3D: toValue)
                $0.beginTime = animationDuration / 2.0
                $0.duration = animationDuration / 2.0
                $0.isRemovedOnCompletion = false
                $0.fillMode = kCAFillModeForwards
            }
            
            let scaleAnimationGroup = CAAnimationGroup() --> {
                $0.animations = [firstScaleAnimation, secondScaleAnimation]
                $0.duration = animationDuration
            }
            borderShape.add(scaleAnimationGroup, forKey: nil)
            centerShape.add(scaleAnimationGroup, forKey: nil)
        } else {
            borderShape.transform = toValue
            centerShape.transform = toValue
        }
    }
    
    private func addStateSublayers(animated: Bool) {
        switch state {
        case .tick:
            let unitLength = sideWidth / 30.0
            let beginPoint = CGPoint(x: unitLength * 7.0, y: unitLength * 14.0)
            let transitionPoint = CGPoint(x: unitLength * 13.0, y: unitLength * 20.0)
            let endPoint = CGPoint(x: unitLength * 22.0, y: unitLength * 10.0)
            
            let tickPath = UIBezierPath() --> {
                $0.move(to: beginPoint)
                $0.addLine(to: transitionPoint)
                $0.addLine(to: endPoint)
            }
            
            let tickLayer = CAShapeLayer() --> {
                $0.path = tickPath.cgPath
                $0.lineWidth = currentLineWidth
                $0.lineCap = kCALineCapRound
                $0.lineJoin = kCALineJoinRound
                $0.fillColor = UIColor.clear.cgColor
                $0.strokeColor = currentLineColor.cgColor
                $0.strokeEnd = 0.0
                borderShape.addSublayer($0)
            }
            
            if animated {
                CABasicAnimation(keyPath: "strokeEnd") --> {
                    $0.toValue = 1.0
                    $0.duration = animationDuration
                    $0.isRemovedOnCompletion = false
                    $0.fillMode = kCAFillModeForwards
                    tickLayer.add($0, forKey: nil)
                }
            } else {
                tickLayer.strokeEnd = 1.0
            }
            
        case .cross:
            let datumPoint = sideWidth / 3.0
            let point_TopLeft = CGPoint(x: datumPoint, y: datumPoint)
            let point_TopRight = CGPoint(x: 2.0 * datumPoint, y: datumPoint)
            let point_BottomLeft = CGPoint(x: datumPoint, y: 2.0 * datumPoint)
            let point_BottomRight = CGPoint(x: 2.0 * datumPoint, y: 2.0 * datumPoint)
            
            let tickLayer = CAShapeLayer() --> {
                $0.path = (UIBezierPath() --> {
                    $0.move(to: point_TopLeft)
                    $0.addLine(to: point_BottomRight)
                    $0.move(to: point_TopRight)
                    $0.addLine(to: point_BottomLeft)
                }).cgPath
                $0.lineWidth = currentLineWidth
                $0.lineCap = kCALineCapRound
                $0.lineJoin = kCALineJoinRound
                $0.fillColor = UIColor.clear.cgColor
                $0.strokeColor = currentLineColor.cgColor
                $0.strokeEnd = 0.0
                borderShape.addSublayer($0)
            }
            
            if animated {
                CABasicAnimation(keyPath: "strokeEnd") --> {
                    $0.toValue = 1.0
                    $0.duration = animationDuration
                    $0.isRemovedOnCompletion = false
                    $0.fillMode = kCAFillModeForwards
                    tickLayer.add($0, forKey: nil)
                }
            } else {
                tickLayer.strokeEnd = 1.0
            }
        default: break
        }
    }
    
}
