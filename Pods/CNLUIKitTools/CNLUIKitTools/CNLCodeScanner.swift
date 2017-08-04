//
//  CNLCodeScanner.swift
//  CNLUIKitTools
//
//  Created by Igor Smirnov on 12/11/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO

import CNLFoundationTools

public protocol CNLCodeScannerDelegate: class {
    func codeScanner(_ codeScanner: CNLCodeScanner, didScanCode code: String, ofType type: String, screenshot: UIImage?)
    func codeScanner(_ codeScanner: CNLCodeScanner, didTakePhoto image: UIImage?)
    func codeScannerError(_ codeScanner: CNLCodeScanner)
}

public enum CNLCodeScannerMode {
    case scanCode
    case takePhoto
}

open class CNLCodeScanner: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    open weak var delegate: CNLCodeScannerDelegate?
    
    var captureSession: AVCaptureSession!
    var captureDevice: AVCaptureDevice!
    var captureMetadataOutput: AVCaptureMetadataOutput!
    var captureImageOutput: AVCaptureStillImageOutput!
    var videoPreviewView: UIView!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    open private(set) var isReading = false
    open var userData: Any?
    open var mode: CNLCodeScannerMode = .scanCode
    
    @discardableResult
    open func startReading(_ inView: UIView, isFront: Bool) -> Bool {
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) else { return false }
        guard devices.count != 0 else {
            // most cases: we run in simulator
            delegate?.codeScannerError(self)
            return false
        }
        
        captureDevice = nil
        for device in devices {
            if let device = device as? AVCaptureDevice {
                if isFront {
                    if device.position == .front {
                        captureDevice = device
                        break
                    }
                } else {
                    if device.position == .back {
                        captureDevice = device
                        break
                    }
                }
            }
        }
        
        if captureDevice == nil {
            // most cases: we run in simulator
            delegate?.codeScannerError(self)
            return false
        }
        
        do {
            try captureDevice.lockForConfiguration()
        } catch _ as NSError {
            
        }
        captureDevice.videoZoomFactor = 1.0
        
        // capability check
        if captureDevice.isFocusModeSupported(.continuousAutoFocus) {
            captureDevice.focusMode = .continuousAutoFocus
        } else {
            if captureDevice.isFocusModeSupported(.autoFocus) {
                captureDevice.focusMode = .autoFocus
            } else {
                if captureDevice.isFocusModeSupported(.locked) {
                    captureDevice.focusMode = .locked
                }
            }
        }
        // capability check
        if captureDevice.isExposureModeSupported(.continuousAutoExposure) {
            captureDevice.exposureMode = .continuousAutoExposure
        } else {
            if captureDevice.isExposureModeSupported(.autoExpose) {
                captureDevice.exposureMode = .continuousAutoExposure
            } else {
                if captureDevice.isExposureModeSupported(.locked) {
                    captureDevice.exposureMode = .locked
                }
            }
        }
        
        captureDevice?.unlockForConfiguration()
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession.sessionPreset = AVCaptureSessionPresetHigh
            captureSession.addInput(input)
            
            captureImageOutput = AVCaptureStillImageOutput()
            captureSession?.addOutput(captureImageOutput)
            
            switch mode {
            case .scanCode:
                let dispatchQueue = DispatchQueue(label: "barCodeQueue", attributes: [])
                
                captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue:dispatchQueue)
                captureMetadataOutput.metadataObjectTypes = [
                    AVMetadataObjectTypeQRCode,
                    AVMetadataObjectTypeUPCECode,
                    AVMetadataObjectTypeCode39Code,
                    AVMetadataObjectTypeCode39Mod43Code,
                    AVMetadataObjectTypeEAN13Code,
                    AVMetadataObjectTypeEAN8Code,
                    AVMetadataObjectTypeCode93Code,
                    AVMetadataObjectTypeCode128Code,
                    AVMetadataObjectTypePDF417Code,
                    AVMetadataObjectTypeAztecCode
                ]
            case .takePhoto: break
            }
            captureImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer.frame = inView.layer.bounds
            inView.layer.addSublayer(videoPreviewLayer)
            videoPreviewView = inView
            
            updateOrientation()
            captureSession.startRunning()
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    open func stopReading() {
        captureSession?.stopRunning()
        captureSession = nil
        videoPreviewLayer?.removeFromSuperlayer()
        videoPreviewLayer = nil
        captureMetadataOutput = nil
        captureImageOutput = nil
        videoPreviewView = nil
        isReading = false
    }
    
    // AVCaptureMetadataOutputObjectsDelegate delegate
    open func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if !isReading {
            isReading = true
            if metadataObjects != nil && metadataObjects.count > 0 {
                if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                    asyncMain( {
                        let objectFrame = UIView()
                        objectFrame.backgroundColor = UIColor.clear
                        
                        //self.highlightView.frame = self.videoPreviewLayer.transformedMetadataObjectForMetadataObject(metadataObj).bounds
                        //self.highlightView.hidden = false
                        self.captureImage { image in
                            self.delegate?.codeScanner(self, didScanCode: metadataObj.stringValue, ofType: metadataObj.type, screenshot: image)
                            self.stopReading()
                        }
                    })
                }
            }
        }
        
    }
    
    open func setFocusPoint(_ point: CGPoint) {
        do {
            try captureDevice.lockForConfiguration()
        } catch _ as NSError {
        }
        if captureDevice.isFocusPointOfInterestSupported {
            captureDevice.focusPointOfInterest = point
        }
        if captureDevice.isExposurePointOfInterestSupported {
            captureDevice.exposurePointOfInterest = point
        }
        captureDevice.unlockForConfiguration()
    }
    
    func updateOrientation() {
        if videoPreviewLayer != nil {
            videoPreviewLayer.frame = videoPreviewView.bounds
            switch UIApplication.shared.statusBarOrientation {
            case .portrait: videoPreviewLayer.connection.videoOrientation = .portrait
            case .landscapeLeft: videoPreviewLayer.connection.videoOrientation = .landscapeLeft
            case .landscapeRight: videoPreviewLayer.connection.videoOrientation = .landscapeRight
            case .portraitUpsideDown: videoPreviewLayer.connection.videoOrientation = .portraitUpsideDown
            default: break //videoPreviewLayer.connection.videoOrientation = lastOrientation
            }
        }
    }
    
    open func captureImage(_ completion: @escaping (_ image: UIImage?) -> Void) {
        guard let captureImageOutput = captureImageOutput else {
            completion(nil)
            return
        }
        var videoConnection: AVCaptureConnection? = nil
        for connectionItem in captureImageOutput.connections {
            if let connection = connectionItem as? AVCaptureConnection {
                for portItem in connection.inputPorts {
                    if let port = portItem as? AVCaptureInputPort {
                        if port.mediaType == AVMediaTypeVideo {
                            videoConnection = connection
                            break
                        }
                    }
                }
                if videoConnection != nil {
                    break
                }
            }
        }
        
        captureImageOutput.captureStillImageAsynchronously(from: videoConnection!) { (imageSampleBuffer: CMSampleBuffer?, _: Error?) -> Void in
            //let exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, nil)
            if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer) {
                if let image = UIImage(data: imageData) {
                    completion(image.adoptToDevice(CGSize(width: image.size.width / 2.0, height: image.size.height / 2.0), scale: 1.0))
                    return
                }
            }
            completion(nil)
        }
    }
    
}
