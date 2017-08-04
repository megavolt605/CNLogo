//
//  CNLModelObject.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 22/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import Foundation

import CNLFoundationTools

/// Common class used for access to resources through class bundle reference, holding the singletone for network provider
open class CNLModel {
    /// Callback type for success network request completion
    public typealias Success = (_ model: CNLModelObject, _ status: Error) -> Void
    /// Callback type for failed network request
    public typealias Failed = (_ model: CNLModelObject, _ error: Error?) -> Void

    /// Type alias for CNLModelError
    public typealias Error = CNLModelError
    
    /// Type alias for CNLModelErrorKind
    public typealias ErrorKind = CNLModelErrorKind
    
    /// Type alias for CNLModelErrorAlert
    public typealias ErrorAlert = CNLModelErrorAlert
    
    /// Common network provider
    open static var networkProvider: CNLModelNetwork?
}

/// Common model object
public protocol CNLModelObject: class {
    
    /// Creates an API struct instance for the model
    ///
    /// - Returns: CNLModelAPI instance
    func createAPI() -> CNLModelAPI?
    
    /// Successfull response status
    var okStatus: CNLModel.Error { get }
    
    /// Default initializer
    init()
}

// MARK: - Default implementations
public extension CNLModelObject {
    
    /// Default implementation. Returns nil
    ///
    /// - Returns: Returns CNLModelAPI instance
    public func createAPI() -> CNLModelAPI? {
        return nil
    }
    
    /// Default implementation. Just mirror to CNLModel.networkProvider.performRequest
    ///
    /// - Parameters:
    ///   - api: CNLModelAPI instance
    ///   - success: Callback when operation was successfull
    ///   - fail: Callback when operation was failed
    public func defaultAPIPerform(_ api: CNLModelAPI, success: @escaping CNLModel.Success, fail: @escaping CNLModel.Failed) {
        CNLModel.networkProvider?.performRequest(
            api: api,
            success: { apiObject in success(self, apiObject.status) },
            fail: { apiObject in fail(self, apiObject.errorStatus) },
            networkError: { apiObject, error in fail(self, apiObject.errorStatus(error)) }
        )
    }
    
}

/// Model with primary (uniquie) key
public protocol CNLModelObjectPrimaryKey: class, CNLModelObject {
    /// Primary key type
    associatedtype KeyType: CNLDictionaryValue
    
    /// Primary key value
    var primaryKey: KeyType { get }

    /// Initializer with primary key
    init?(keyValue: KeyType)
    
    /// String representation of the primary key
    var encodedPrimaryKey: String? { get }
}

// MARK: - Default implementations
public extension CNLModelObjectPrimaryKey {
    
    /// By default, encodedPrimaryKey equals string reporesentation of primaryKey property
    public var encodedPrimaryKey: String? { return "\(primaryKey)" }
    
}

/// Editable model protocol
public protocol CNLModelObjectEditable {
    var editing: Bool { get set }
    func updateList()
}
