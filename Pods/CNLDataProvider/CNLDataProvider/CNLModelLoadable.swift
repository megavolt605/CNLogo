//
//  CNLModelLoadable.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 28/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit
import CoreTelephony

import CNLFoundationTools

fileprivate var cancelLoadingTaskCallbacksFunc = "cancelLoadingTaskCallbacksFunc"

public protocol CNLModelDataLoadable: class {
    func loadData(_ url: URL?, priority: Float?, userData: Any?, success: @escaping CNLNetwork.Download.File.Success, fail: @escaping CNLNetwork.Download.File.Failed)
    func cancelLoading()
}

public extension CNLModelDataLoadable {
    
    public func loadData(_ url: URL?, priority: Float?, userData: Any?, success: @escaping CNLNetwork.Download.File.Success, fail: @escaping CNLNetwork.Download.File.Failed) {
        let cancelTask = CNLModel.networkProvider?.downloadFileFromURL(
            url,
            priority: priority ?? 1.0,
            userData: userData,
            success: { url, data, userData in
                success(url, data, userData)
                if let key = url?.absoluteString {
                    self.cancelLoadingTaskCallbacks[key] = nil
                }
            },
            fail: { url, error, userData in
                fail(url, error, userData)
                if let key = url?.absoluteString {
                    self.cancelLoadingTaskCallbacks[key] = nil
                }
            }
        )
        if let cancelTask = cancelTask {
            if let key = url?.absoluteString {
                cancelLoadingTaskCallbacks[key] = { [url, userData] in cancelTask(url, userData) }
            }
        }
    }
    
    fileprivate typealias CNLCancelLoadingCallbacks = [String: () -> Void]
    
    fileprivate var cancelLoadingTaskCallbacks: CNLCancelLoadingCallbacks {
        get {
            if let value = (objc_getAssociatedObject(self, &cancelLoadingTaskCallbacksFunc) as? CNLAssociated<CNLCancelLoadingCallbacks>)?.closure {
                return value
            } else {
                return [:]
            }
        }
        set {
            objc_setAssociatedObject(self, &cancelLoadingTaskCallbacksFunc, CNLAssociated<CNLCancelLoadingCallbacks>(closure: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func cancelLoading() {
        for task in cancelLoadingTaskCallbacks {
            task.value()
        }
        cancelLoadingTaskCallbacks = [:]
    }
    
}

public protocol CNLModelImageLoadable: CNLModelDataLoadable {
    func loadImage(_ url: URL?, priority: Float?, userData: Any?, success: @escaping CNLNetwork.Download.Image.Success, fail: @escaping CNLNetwork.Download.File.Failed)
}

public extension CNLModelImageLoadable {
    
    public func loadImage(_ url: URL?, priority: Float?, userData: Any?, success: @escaping CNLNetwork.Download.Image.Success, fail: @escaping CNLNetwork.Download.File.Failed) {
        let start = Date()
        
        guard let url = url else {
            fail(nil, nil, userData)
            return
        }
        
        loadData(
            url,
            priority: priority,
            userData: userData,
            success: { url, fileData, userData in
                let networkStop = Date().timeIntervalSince(start)
                if let data = fileData, let img = UIImage(data: data) {
                    #if DEBUG
                        let stop = Date().timeIntervalSince(start)
                        CNLLog(
                            "\(url!.absoluteString) loaded, network time: \(floor(networkStop * 1000.0 * 1000.0) / 1000.0), " +
                            "total time: \(floor(stop * 1000.0 * 1000.0) / 1000.0) size: \(img.size.width) x \(img.size.height) \(data.count) ",
                            level: .debug
                        )
                    #endif
                    success(url, img, data, userData)
                } else {
                    #if DEBUG
                        CNLLog("\(url!.absoluteString) loading error", level: .error)
                        if let data = fileData, let dataString = NSString(data: data, encoding: String.Encoding.utf16.rawValue) {
                            CNLLog("Received data:\n\(dataString)", level: .error)
                        }
                    #endif
                    fail(url, nil, userData)
                }
            },
            fail: fail
        )
    }
    
}

public protocol CNLModelResizableImageLoadable: CNLModelImageLoadable {
    func loadImage(
        _ url: URL?,
        priority: Float?,
        userData: Any?,
        size: CGSize,
        scale: CGFloat?,
        success: @escaping CNLNetwork.Download.Image.Success,
        fail: @escaping CNLNetwork.Download.File.Failed
    )
}

public extension CNLModelResizableImageLoadable {
    
    public func loadImage(
        _ url: URL?,
        priority: Float?,
        userData: Any?,
        size: CGSize,
        scale: CGFloat?,
        success: @escaping CNLNetwork.Download.Image.Success,
        fail: @escaping CNLNetwork.Download.File.Failed
        ) {
        
        guard let url = url else {
            fail(nil, nil, userData)
            return
        }
            
        let scale = scale ?? imageScale()
        var newURL = url
        let urlString = newURL.absoluteString
        if size.width != 0 && size.height != 0 && !urlString.contains(".gif") {
            let newURLString = urlString.appendSuffixBeforeExtension("@\(Int(scale * size.width))x\(Int(scale * size.height))")
            if let updatedURL = URL(string: newURLString) {
                newURL = updatedURL
            } else {
                fail(url, nil, userData)
                return
            }
        }
        loadImage(
            newURL,
            priority: priority,
            userData: userData,
            success: { newURL, image, imageData, userData in
                success(url, image, imageData, userData)
            },
            fail: { newURL, error, userData in
                fail(url, error, userData)
            }
        )
    }
    
    public func imageScale() -> CGFloat {
        var scale: CGFloat = 0.0
        if !(CNLModel.networkProvider?.isReachableOnEthernetOrWiFi ?? true) {
            if let networkType = CTTelephonyNetworkInfo().currentRadioAccessTechnology {
                switch networkType {
                case CTRadioAccessTechnologyGPRS: scale = 1.5
                case CTRadioAccessTechnologyEdge: scale = 1.0
                case CTRadioAccessTechnologyWCDMA: scale = 1.5
                case CTRadioAccessTechnologyHSDPA: scale = 1.5
                case CTRadioAccessTechnologyHSUPA: scale = 1.5
                case CTRadioAccessTechnologyCDMA1x: scale = 0.0
                case CTRadioAccessTechnologyCDMAEVDORev0: scale = 1.0
                case CTRadioAccessTechnologyCDMAEVDORevA: scale = 1.5
                case CTRadioAccessTechnologyCDMAEVDORevB: scale = 1.5
                case CTRadioAccessTechnologyeHRPD: scale = 1.0
                case CTRadioAccessTechnologyLTE: scale = 0.0
                default: scale = 0.0
                }
            }
        }
        if scale < 0.1 {
            scale = UIScreen.main.scale
        }
        return scale
    }
    
}
