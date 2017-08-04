//
//  CNLUIT+UIView.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 11/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

import CNLFoundationTools

public extension UIView {
    
    public func recursiveDescription(prefix: String = "") -> String {
        
        var desc = "\(prefix)\(self) (\(subviews.count) subviews)"
        
        for subview in subviews {
            let sd = subview.recursiveDescription(prefix: prefix + "  ")
            desc += "\r\n\(sd)"
            desc += "Layers: frame = \(subview.layer.frame) \(subview.layer)"
        }
        return desc
        
    }
    
    public func addSubViews(_ subViews: [UIView]) {
        subViews.forEach { self.addSubview($0) }
    }
    
    public func setHidden(_ hidden: Bool, animated: Bool, duration: TimeInterval = 0.0, visibleAlpha: CGFloat = 1.0, completion: ((_ finished: Bool) -> Void)? = nil) {
        //UIView.setAnimationsEnabled(animated)
        if self.isHidden != hidden {
            if hidden {
                if (layer.animationKeys() == nil) || (layer.animationKeys()!.count == 0) {
                    if animated {
                        UIView.animate(
                            withDuration: duration,
                            animations: { self.alpha = 0.0 },
                            completion: { completed in
                                self.isHidden = true
                                completion?(completed)
                        }
                        )
                    } else {
                        self.alpha = 0.0
                        self.isHidden = true
                        completion?(true)
                    }
                }
            } else {
                if animated {
                    alpha = 0.0
                    self.isHidden = false
                    UIView.animate(
                        withDuration: duration,
                        animations: { self.alpha = visibleAlpha },
                        completion: completion
                    )
                } else {
                    self.alpha = visibleAlpha
                    completion?(true)
                }
            }
        }
    }
    
    public func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        if let ctx = UIGraphicsGetCurrentContext() {
            layer.render(in: ctx)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    
    public func alignRight(_ view: UIView, frame: CGRect) {
        var r = frame
        r.origin.x = frame.origin.x + bounds.size.width - frame.size.width
        view.frame = r
    }
    
    public func addParallax(_ amount: Double = 100.0, keyPathX: String = "center.x", keyPathY: String = "center.y") {
        let horizontal = UIInterpolatingMotionEffect(keyPath: keyPathX, type: .tiltAlongHorizontalAxis) --> {
            $0.minimumRelativeValue = -amount
            $0.maximumRelativeValue = amount
        }
        
        let vertical = UIInterpolatingMotionEffect(keyPath: keyPathY, type: .tiltAlongVerticalAxis) --> {
            $0.minimumRelativeValue = -amount
            $0.maximumRelativeValue = amount
        }

        UIMotionEffectGroup() --> {
            $0.motionEffects = [horizontal, vertical]
            self.addMotionEffect($0)
        }
    }
    
    public var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    public func startQuiveringAnimation() {
        let startAngle: Float = -1.0 *  Float.pi / 180.0
        let stopAngle: Float = -startAngle
        let timeOffset: CFTimeInterval = (Double(arc4random_uniform(100)) - 50.0) / 100.0
        CABasicAnimation(keyPath: "transform.rotation") --> {
            $0.fromValue = startAngle
            $0.toValue = stopAngle * 3.0
            $0.autoreverses = true
            $0.duration = 0.15
            $0.repeatCount = Float.infinity
            $0.timeOffset = timeOffset
            layer.add($0, forKey: "quivering")
        }
    }
    
    public func stopQuiveringAnimation() {
        layer.removeAnimation(forKey: "quivering")
    }

    public func startBounceAnimation(_ values: [Any] = [0.05, 1.3, 0.9, 1.0], duration: CFTimeInterval = 0.6) {
        CAKeyframeAnimation(keyPath: "transform.scale") --> {
            $0.values = values
            $0.duration = duration
            $0.timingFunctions = values.map { _ in return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) }
            $0.isRemovedOnCompletion = false
            layer.add($0, forKey: "bounce")
        }
    }
    
    public func stopBounceAnimation() {
        layer.removeAnimation(forKey: "bounce")
    }
    
}
