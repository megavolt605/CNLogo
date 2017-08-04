//
//  CNLQRCodeGenerator.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 12/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

/// Amount of excess information
public enum CNLQRCodeCorrectionLevel: String {
    case percent7 = "L"
    case percent15 = "M"
    case percent25 = "Q"
    case percent30 = "H"
}

/// Class for generation QR code
public struct CNLQRCodeGenerator {
    
    ///  Generates UIImage with QR code of the string with specified size and correction level
    ///
    /// - Parameters:
    ///   - qrString: Source string. Must have UTF8 representation
    ///   - size: Width and height of generated image
    ///   - correctionLevel: Amount of excess information
    /// - Returns: UIImage with QR code
    public static func generate(forString qrString: String, withSize size: CGFloat = 200.0, correctionLevel: CNLQRCodeCorrectionLevel = .percent25) -> UIImage? {
        if let stringData = qrString.data(using: String.Encoding.utf8), let qrFilter = CIFilter(name:"CIQRCodeGenerator") {
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue(correctionLevel.rawValue, forKey: "inputCorrectionLevel")
            guard let image = qrFilter.outputImage else { return nil }
            let scale = size / image.extent.width
            guard let cgImage = CIContext(options: nil).createCGImage(image, from: image.extent) else { return nil }
            UIGraphicsBeginImageContext(CGSize(
                width: image.extent.size.width * scale,
                height: image.extent.size.width * scale
            ))
            
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            context.interpolationQuality = CGInterpolationQuality.none
            context.draw(cgImage, in: context.boundingBoxOfClipPath)
            let qrImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return qrImage
        } else {
            return nil
        }
    }
}
