//
//  CNLModelArray.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import Foundation

import CNLFoundationTools

/// Base array model, class only
/// Declares basic functions to map, load and store received data
public protocol CNLModelArray: class, CNLDataSourceModel {
    
    /// Maps (deserialize) received dictionary to the model ArrayElement object
    ///
    /// - Parameter data: Source data dictionary
    /// - Returns: Array if ArrayElement instances
    func createItems(_ data: CNLDictionary) -> [ArrayElement]?
    
    /// Maps (deserialize) received array to the model ArrayElement item instances
    ///
    /// - Parameter array: Source data array
    /// - Returns: Array of ArrayElement instances
    func loadFromArray(_ array: CNLArray) -> [ArrayElement]
    
    /// Returns mapped (serialized) array
    func storeToArray() -> CNLArray
    
    /// Point of making necessary changes after serialize
    ///
    /// - Parameter newList: Source array of model items (ArrayElement)
    /// - Returns: Updated array
    func afterLoad(_ newList: [ArrayElement]) -> [ArrayElement]
    
    /// Extract dictionary element to perform desealisation by loadFromArray(_:), createItems(_:), etc.
    ///
    /// - Parameter json: Source dictionary
    /// - Returns: New array
    func rows(_ json: CNLDictionary?) -> CNLArray?
    
    /// Preprocess incoming dictionary data
    ///
    /// - Parameter data: Source dictionary
    /// - Returns: Updated dictionary
    func preprocessData(_ data: CNLDictionary?) -> CNLDictionary?
    
    /// Default initializer
    init()
}

public extension CNLModelObject where Self: CNLModelArray {
    
    /// Maps (deserialize) received dictionary to the model ArrayElement object
    ///
    /// - Parameter data: Source data dictionary
    /// - Returns: Array if ArrayElement instances
    public func createItems(_ data: CNLDictionary) -> [ArrayElement]? {
        if let item = ArrayElement(dictionary: data) {
            return [item]
        }
        return nil
    }
    
    /// Maps (deserialize) received array to the model ArrayElement item instances
    /// Default implementation
    ///
    /// - Parameter array: Source data array
    /// - Returns: Array of ArrayElement instances
    public func loadFromArray(_ array: CNLArray) -> [ArrayElement] {
        return defaultLoadFrom(array)
    }
    
    /// Returns mapped (serialized) array
    public func afterLoad(_ newList: [ArrayElement]) -> [ArrayElement] { return newList }
    
    public func rows(_ json: CNLDictionary?) -> CNLArray? {
        return json?["rows"] as? CNLArray
    }
    
    public func preprocessData(_ data: CNLDictionary?) -> CNLDictionary? {
        return data
    }
    
    /// Returns mapped (serialized) array
    public func storeToArray() -> CNLArray {
        let captureList = list
        return captureList.map { $0.storeToDictionary() }
    }
    
    /// Loads model from the array
    ///
    /// - Parameter dictionary: source array
    /// - Returns: Array of ArrayElement instances
    public static func loadFromArray(_ array: CNLArray?) -> Self? {
        guard let array = array else { return nil }
        let result = Self()
        result.list = result.loadFromArray(array)
        return result
    }
    
    /// Update data source. Default implementation
    ///
    /// - Parameters:
    ///   - success: Callback when operation was successfull
    ///   - failed: Callback when operation was failed
    public func update(success: @escaping CNLModel.Success, failed: @escaping CNLModel.Failed) {
        if let localAPI = createAPI() {
            CNLModel.networkProvider?.performRequest(
                api: localAPI,
                success: { apiObject in
                    let data = self.preprocessData(apiObject.answerJSON)
                    if let json = self.rows(data) {
                        self.list = self.loadFromArray(json)
                    } else {
                        self.list = self.loadFromArray([])
                    }
                    #if DEBUG
                        CNLLog("Model count: \(self.list.count)", level: .debug)
                    #endif
                    if let value: Int = data?.value("total") {
                        self.totalRecords = value
                    } else {
                        self.totalRecords = self.list.count
                    }
                    success(self, apiObject.status)
            },
                fail: { apiObject in
                    failed(self, apiObject.errorStatus)
            },
                networkError: { apiObject, error in
                    failed(self, apiObject.errorStatus(error))
            }
            )
        } else {
            list = loadFromArray([])
            success(self, okStatus) //(kind: CNLErrorKind.Ok, success: true))
        }
    }
    
    public func defaultLoadFrom(_ array: CNLArray) -> [ArrayElement] {
        let newListOfList = array.mapSkipNil { return self.createItems($0) }
        let newList = newListOfList.flatMap { return $0 }
        additionalRecords += newList.count - newListOfList.count
        return afterLoad(newList)
    }
    
    public init?(array: CNLArray?) {
        self.init()
        if let data = array {
            list = loadFromArray(data)
        } else {
            return nil
        }
    }
    
}

public extension CNLModelArray where ArrayElement: CNLModelObjectPrimaryKey {
    
    public func item(withPrimaryKey primaryKey: ArrayElement.KeyType) -> ArrayElement? {
        return list.lookup { $0.primaryKey == primaryKey }
    }
    
    public func index(ofItem primaryKey: ArrayElement.KeyType) -> Int? {
        return list.index { $0.primaryKey == primaryKey }
    }
    
    public func remove(withPrimaryKey primaryKey: ArrayElement.KeyType) {
        if let index = index(ofItem: primaryKey) {
            list.remove(at: index)
        }
    }
    
    @discardableResult
    public func replace(arrayElement: ArrayElement) -> Bool {
        if let index = index(ofItem: arrayElement.primaryKey) {
            list[index] = arrayElement
            return true
        }
        list.append(arrayElement)
        return false
    }
    
}
