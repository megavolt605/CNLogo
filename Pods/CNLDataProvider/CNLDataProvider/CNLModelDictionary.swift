//
//  CNLModelDictionary.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import Foundation

import CNLFoundationTools

/// Base dictionary model
public protocol CNLModelDictionary {
    
    /// Default initializer
    init()
    
    /// Initializer with values from the dictionary
    /// Calls loadFromDictionary(_:) by default
    init?(dictionary: CNLDictionary?)
    
    /// Loads (deserialize) values from the dictionary
    ///
    /// - Parameter dictionary: Source dictionary
    func loadFromDictionary(_ dictionary: CNLDictionary)

    /// Stores (serialize) values to the dictionary
    ///
    /// - Returns: Result dictionart
    func storeToDictionary() -> CNLDictionary
    
    /// Updates model values. By default, calls updateDictionary(success:failed:) with empty closures.
    func updateDictionary()

    /// Updates model values
    /// By default, creates API struct instance returned by createAPI() function,
    /// perform network request by CNLModel.networkProvider?.performRequest function.
    /// When successed, try to deserialize values with loadFromDictionary(_:) function and invokes success callback.
    /// Calls failed callback if any error occured during request
    ///
    /// - Parameters:
    ///   - success: Callback when operation was successfull
    ///   - failed: Callback when operation was failed
    func updateDictionary(success: @escaping CNLModel.Success, failed: @escaping CNLModel.Failed)
}

// MARK: - CNLModelObject
public extension CNLModelDictionary where Self: CNLModelObject {
    
    /// Default implementation. Initializer with values from the dictionary
    /// Calls loadFromDictionary(_:) by default
    public init?(dictionary: CNLDictionary?) {
        self.init()
        if let data = dictionary {
            loadFromDictionary(data)
        } else {
            return nil
        }
    }
    
    /// Default implementation. Stub: does nothing.
    ///
    /// - Parameter dictionary: Source dictionary
    public func loadFromDictionary(_ dictionary: CNLDictionary) {
        // dummy
    }
    
    /// Default implementation. Stub: returns empty dictionary
    ///
    /// - Returns: Result dictionary
    public func storeToDictionary() -> CNLDictionary {
        return [:] // dummy
    }
    
    /// Default implementation. Calls updateDictionary(success:failed:) with empty closures.
    public func updateDictionary() {
        updateDictionary(success: { _, _ in }, failed: { _, _ in })
    }
    
    /// Default implementation. Updates model values
    /// Creates API struct instance returned by createAPI() function,
    /// perform network request by CNLModel.networkProvider?.performRequest function.
    /// When successed, try to deserialize values with loadFromDictionary(_:) function and invokes success callback.
    /// Calls failed callback if any error occured during request
    ///
    /// - Parameters:
    ///   - success: Callback when operation was successfull
    ///   - failed: Callback when operation was failed
    public func updateDictionary(success: @escaping CNLModel.Success, failed: @escaping CNLModel.Failed) {
        if let localAPI = createAPI() {
            CNLModel.networkProvider?.performRequest(
                api: localAPI,
                success: { apiObject in
                    if let json = apiObject.answerJSON {
                        self.loadFromDictionary(json)
                    }
                    success(self, apiObject.status)
            },
                fail: { (apiObject) in
                    failed(self, apiObject.errorStatus)
            },
                networkError: { apiObject, error in
                    failed(self, apiObject.errorStatus(error))
            }
            )
        }
    }
    
}

/// CNLModelDictionaryKeyStored: CNLModelDictionary protocol with CNLModelObjectPrimaryKey protocol requirements
public protocol CNLModelDictionaryKeyStored: CNLModelDictionary, CNLModelObjectPrimaryKey {
    
}
