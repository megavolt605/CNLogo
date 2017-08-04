//
//  CNLModelNetwork.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 22/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import Foundation

public struct CNLNetwork {
    public typealias Success = (_ api: CNLModelAPI) -> Void
    public typealias Failed = (_ api: CNLModelAPI) -> Void
    public typealias NetworkError = (_ api: CNLModelAPI, _ error: Error?) -> Void
    
    public struct Download {
        public struct File {
            public typealias Success = (_ url: URL?, _ fileData: Data?, _ userData: Any?) -> Void
            public typealias Failed = (_ url: URL?, _ error: Error?, _ userData: Any?) -> Void
            public typealias Cancel = (_ url: URL?, _ userData: Any?) -> Void
        }
        
        public struct Image {
            public typealias Success = (_ url: URL?, _ image: UIImage, _ imageData: Data, _ userData: Any?) -> Void
        }
    }
}

public protocol CNLModelNetwork {
    func performRequest(
        api: CNLModelAPI,
        success: @escaping CNLNetwork.Success,
        fail: @escaping CNLNetwork.Failed,
        networkError: @escaping CNLNetwork.NetworkError
    )
    func performRequest(
        api: CNLModelAPI,
        maxTries: Int,
        retryDelay: TimeInterval,
        success: @escaping CNLNetwork.Success,
        fail: @escaping CNLNetwork.Failed,
        networkError: @escaping CNLNetwork.NetworkError
    )
    func downloadFileFromURL(
        _ url: URL?,
        priority: Float,
        userData: Any?,
        success: @escaping CNLNetwork.Download.File.Success,
        fail: @escaping CNLNetwork.Download.File.Failed
        ) -> CNLNetwork.Download.File.Cancel?
    var isReachableOnEthernetOrWiFi: Bool { get }
}

public extension CNLModelNetwork {

    public func performRequest(
        api: CNLModelAPI,
        maxTries: Int,
        retryDelay: TimeInterval = 5.0,
        success: @escaping CNLNetwork.Success,
        fail: @escaping CNLNetwork.Failed,
        networkError: @escaping CNLNetwork.NetworkError
        ) {
        
        performRequest(api: api, maxTries: maxTries, retryDelay: retryDelay, success: success, fail: fail, networkError: networkError)
    }
}
