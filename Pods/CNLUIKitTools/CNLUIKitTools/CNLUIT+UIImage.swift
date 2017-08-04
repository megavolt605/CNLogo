//
//  CNLUIT+UIImage.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 11/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

public enum CNLImageType {
    
    case image, jpeg, jpeg2000, tiff, pict, gif, png, qtImage, appleIcon, bmp, ico
    
    public init(_ value: CFString) {
        if value == kUTTypePNG { self = .png; return } // PNG
        if value == kUTTypeJPEG { self = .jpeg; return }
        if value == kUTTypeGIF { self = .gif; return } // GIF
        if value == kUTTypeJPEG2000 { self = .jpeg2000; return } // JPEG-2000
        if value == kUTTypeTIFF { self = .tiff; return } // TIFF
        if value == kUTTypePICT { self = .pict; return } // Quickdraw PICT
        if value == kUTTypeQuickTimeImage { self = .qtImage; return } // QuickTime
        if value == kUTTypeAppleICNS { self = .appleIcon; return } // Apple icon
        if value == kUTTypeBMP { self = .bmp; return } // Windows bitmap
        if value == kUTTypeICO { self = .ico; return } // Windows icon
        self = .image // Abstract image
    }
}

public extension UIImage {
    
    public func adoptToDevice(_ maxSize: CGSize, scale: CGFloat = 2.0) -> UIImage {
        if maxSize.width == 0 || maxSize.height == 0 {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(maxSize, false, scale/*UIScreen.mainScreen().scale*/)
        draw(in: CGRect(x: 0, y: 0, width: maxSize.width, height: maxSize.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    public func cropInCircleWithRect(_ rect: CGRect, scale: CGFloat) -> UIImage {
        let imageWidth = size.width / scale
        let imageHeight = size.height / scale
        let rectWidth = rect.size.width
        let rectHeight = rect.size.height
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rectWidth, height: rectHeight), false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        let radius = max(rectWidth, rectHeight) / 2.0
        context?.beginPath()
        context?.addArc(center: CGPoint(x: rectWidth / 2.0, y: rectHeight / 2.0), radius: radius, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: false)
        context?.closePath()
        context?.clip()
        
        // Draw the IMAGE
        let myRect = CGRect(x: -rect.origin.x, y: -rect.origin.y, width: imageWidth, height: imageHeight)
        draw(in: myRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    public func imageWithColor(_ color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        context?.setBlendMode(CGBlendMode.copy)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.draw(cgImage!, in: rect)
        
        context?.clip(to: rect, mask: cgImage!)
        context?.addRect(rect)
        context?.drawPath(using: CGPathDrawingMode.fill)//CGPathDrawingMode(kCGPathElementMoveToPoint))
        
        let coloredImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return coloredImg!
    }
    
    fileprivate class func UTTypeForImageData(data: Data?) -> CFString? {
        if let data = data, let isrc = CGImageSourceCreateWithData(data as CFData, nil) {
            return CGImageSourceGetType(isrc)
        }
        return nil
    }
    
    public class func CNLImageType(for data: Data?) -> CNLUIKitTools.CNLImageType {
        if let imageType = UTTypeForImageData(data: data) {
            return CNLUIKitTools.CNLImageType(imageType)
        }
        return .image
    }
}

//
//  GIF Image Data to UIImage convertation
//
//  Inspired by:
//
//  iOSDevCenters+GIF.swift
//  GIF-Swift
//
//  Created by iOSDevCenters on 11/12/15.
//  Copyright © 2016 iOSDevCenters. All rights reserved.
//

public extension UIImage {

    public class func gifImage(data: Data) -> UIImage? {
        let nsData = data as NSData
        guard let source = CGImageSourceCreateWithData(nsData, nil) else {
            #if DEBUG
                print("Image doesn't exist")
            #endif
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImage(gifUrlString: String) -> UIImage? {
        guard let bundleURL = URL(string: gifUrlString)
            else {
                #if DEBUG
                    print("Image named \"\(gifUrlString)\" doesn't exist")
                #endif
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            #if DEBUG
                print("Image named \"\(gifUrlString)\" into Data")
            #endif
            return nil
        }
        
        return gifImage(data: imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                #if DEBUG
                    print("Image named \"\(name)\" doesn't exist")
                #endif
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            #if DEBUG
                print("Cannot convert image named \"\(name)\" into Data")
            #endif
            return nil
        }
        
        return gifImage(data: imageData)
    }
    
    fileprivate class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(
                cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
            ),
            to: CFDictionary.self
        )
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(
                gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()
            ),
            to: AnyObject.self
        )
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(
                CFDictionaryGetValue(
                    gifProperties,
                    Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()
                ),
                to: AnyObject.self
            )
        }
        
        return max(delayObject.doubleValue ?? 0.1, 0.1)
    }
    
    fileprivate class func gcdForPair(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a % b
            
            if rest == 0 {
                return b
            } else {
                a = b
                b = rest
            }
        }
    }
    
    fileprivate class func gcdForArray(_ array: [Int]) -> Int {
        guard !array.isEmpty else { return 1 }
        return array.reduce(array[0]) { return UIImage.gcdForPair($0, $1) }
    }
    
    fileprivate class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        var images: [(CGImage, Int)] = []
        
        for i in 0..<CGImageSourceGetCount(source) {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let delaySeconds = UIImage.delayForImageAtIndex(i, source: source)
                images.append((image, Int(delaySeconds * 1000.0))) // Seconds to ms
            }
        }
        
        let delays = images.map { return $0.1 }
        let duration = delays.reduce(0, +)
        
        let gcd = gcdForArray(delays)
        
        var frames: [UIImage] = []
        for image in images {
            let frame = UIImage(cgImage: image.0)
            let frameCount = Int(image.1 / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        return UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
    }
    
}
