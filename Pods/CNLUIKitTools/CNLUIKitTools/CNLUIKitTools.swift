//
//  CNLUIKitTools.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 13/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

import CNLFoundationTools

public func splashImageName(forOrientation orientation: UIInterfaceOrientation) -> String? {
    var viewSize = UIScreen.main.bounds.size
    var viewOrientation = "Portrait"
    if UIInterfaceOrientationIsLandscape(orientation) {
        viewSize = CGSize(width: viewSize.height, height: viewSize.width)
        viewOrientation = "Landscape"
    }
    
    if let imagesDict = Bundle.main.infoDictionary!["UILaunchImages"] as? [NSDictionary] {
        for dict in imagesDict {
            if let imageSizeString = dict["UILaunchImageSize"] as? String, let launchOrientation = dict["UILaunchImageOrientation"] as? String {
                let imageSize = CGSizeFromString(imageSizeString)
                if imageSize.equalTo(viewSize) && viewOrientation == launchOrientation {
                    return dict["UILaunchImageName"] as? String
                }
            }
        }
    }
    return nil
}

public func splashImage(forOrientation orientation: UIInterfaceOrientation) -> UIImage? {
    if let imageName = splashImageName(forOrientation: orientation) {
        return UIImage(named: imageName)
    }
    return nil
}

public func animationShake(_ views: [UIView], distance: CGFloat = 12.0, repeatCount: Float = 3, duration: CFTimeInterval = 0.1) {
    let anim = CAKeyframeAnimation(keyPath: "transform")
    let shiftLeftValues = NSValue(caTransform3D: CATransform3DMakeTranslation(-distance, 0.0, 0.0))
    let shiftRightValue = NSValue(caTransform3D: CATransform3DMakeTranslation(distance, 0.0, 0.0))
    anim.values = [shiftLeftValues, shiftRightValue]
    anim.autoreverses = true
    anim.repeatCount = repeatCount
    anim.duration = duration
    views.forEach { $0.layer.add(anim, forKey: nil) }
}

public func animationMoving(_ views: [UIView], distance: CGPoint, duration: Double = 0.5, completion: ((Bool) -> Void)? = nil) {
    var orgCenter: [UIView: CGPoint] = [:]
    let dx = distance.x
    let dy = distance.y
    for view in views {
        view.alpha = 0.0
        orgCenter[view] = view.center
        view.center = CGPoint(x: view.center.x - dx, y: view.center.y - dy)
    }
    UIView.animate(
        withDuration: duration,
        delay: 0.01,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 10.0,
        options: UIViewAnimationOptions.curveEaseOut,
        animations: {
            for view in views {
                view.alpha = 1.0
                view.center = orgCenter[view]!
            }
        },
        completion: completion
    )
}

public func animationMoveFromBottom(_ views: [UIView], distance: CGFloat, shift: Bool = true, duration: Double = 0.5, completion: ((Bool) -> Void)? = nil) {
    if shift {
        for view in views {
            view.center = CGPoint(x: view.center.x, y: view.center.y + distance)
        }
    }
    UIView.animate(
        withDuration: duration,
        delay: 0.0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 10.0,
        options: UIViewAnimationOptions.curveEaseOut,
        animations: {
            for view in views {
                view.center = CGPoint(x: view.center.x, y: view.center.y - distance)
            }
        },
        completion: { completed in
            if !shift {
                for view in views {
                    view.center = CGPoint(x: view.center.x, y: view.center.y + distance)
                }
            }
            completion?(completed)
        }
    )
}

public func animationSpin(_ views: [UIView], duration: CFTimeInterval = 3.0, direction: Double = 1.0) {
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    animation.fromValue = 0
    animation.toValue = Double.pi * 2.0 * direction
    animation.duration = duration
    animation.repeatCount = 100000
    
    views.forEach { $0.layer.add(animation, forKey: "SpinAnimation") }
}

public func animationBlink(_ views: [UIView], duration: CFTimeInterval = 1.0) {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.duration = duration
    animation.repeatCount = 100000
    animation.autoreverses = true
    animation.fromValue = 1.0
    animation.toValue = 0.0
    views.forEach { $0.layer.add(animation, forKey: "animateOpacity") }
}

public func gradientWithColors(_ colors: [UIColor], locations: [CGFloat]) -> CGGradient? {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let cgcolors = colors.map { $0.cgColor as AnyObject! } as NSArray
    return CGGradient(colorsSpace: colorSpace, colors: cgcolors, locations: locations)
}
