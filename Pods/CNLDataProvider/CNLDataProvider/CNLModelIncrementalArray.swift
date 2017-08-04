//
//  CNLModelIncrementalArray.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 02/03/2017.
//  Copyright © 2017 Complex Numbers. All rights reserved.
//

import Foundation

import CNLFoundationTools

public protocol CNLModelIncrementalArrayElementStates: CNLModelObject, CNLModelDictionary {
    //func setDefaultState()
}

public protocol CNLModelIncrementalArrayElement: CNLModelObjectPrimaryKey {
    var states: CNLModelIncrementalArrayElementStates { get set }
}

public protocol CNLModelIncrementalArray: class, CNLDataSourceModel {
    associatedtype ArrayElement: CNLModelIncrementalArrayElement, CNLModelDictionary

    typealias CNLModelIncrementalArrayCompletion = (_ model: CNLModelObject, _ status: CNLModel.Error, _ created: [ArrayElement], _ modified: [ArrayElement], _ deleted: [ArrayElement.KeyType]) -> Void
    
    /// List of ArrayElement instances
    var list: [ArrayElement] { get set }
    
    var lastTimestamp: Date? { get set }
    var statesLastTimestamp: Date? { get set }
    
    /// Update data source
    ///
    /// - Parameters:
    ///   - success: Callback when operation was successfull
    ///   - failed: Callback when operation was failed
    func update(success: @escaping CNLModelIncrementalArrayCompletion, failed: @escaping CNLModel.Failed)
    
    /// Resets model
    func reset()
    
    /// Maps (deserialize) received dictionary to the model ArrayElement object
    ///
    /// - Parameter data: Source data dictionary
    /// - Returns: Array if ArrayElement instances
    func createItems(_ data: CNLDictionary) -> [ArrayElement]?
    
    /// Loads model from the dictionary
    ///
    /// - Parameter dictionary: Source dictionary
    func loadFromDictionary(_ data: CNLDictionary) -> [ArrayElement]
    
    /// Stores model to the dictionary
    ///
    /// - Returns: Result dictionary
    func storeToDictionary() -> CNLDictionary
    
    /// Point of making necessary changes after serialize
    ///
    /// - Returns: Updated array
    func afterLoad()
    func preprocessData(_ data: CNLDictionary?) -> CNLDictionary?
    func indexOf(item: ArrayElement) -> Int?
    init()

    // states
    func createStatesAPI() -> CNLModelAPI?
    func updateStates(success: @escaping CNLModel.Success, failed: @escaping CNLModel.Failed)
    func updateStatesFromDictionary(_ data: CNLDictionary)
    
    func createdItems(_ data: CNLDictionary?) -> [ArrayElement]?
    func modifiedItems(_ data: CNLDictionary?) -> [ArrayElement]?
    func deletedItems(_ data: CNLDictionary?) -> [ArrayElement.KeyType]?
}

fileprivate var incrementalArrayLastTimestampKey: String = "incrementalArrayLastTimestampKey"
fileprivate var incrementalArrayStatesLastTimestampKey: String = "incrementalArrayStatesLastTimestampKey"

internal struct CNLModelIncrementalArrayKeys {
    static let statesTimestamp = "states_timestamp"
    static let timestamp = "timestamp"
    static let items = "items"
    static let created = "created"
    static let modified = "modified"
    static let deleted = "deleted"
}

public extension CNLModelObject where Self: CNLModelIncrementalArray {
    
    public var isPagingEnabled: Bool { return false }

    public final var lastTimestamp: Date? {
        get {
            if let value = (objc_getAssociatedObject(self, &incrementalArrayLastTimestampKey) as? CNLAssociated<Date?>)?.closure {
                return value
            } else {
                return nil
            }
        }
        set {
            objc_setAssociatedObject(self, &incrementalArrayLastTimestampKey, CNLAssociated<Date?>(closure: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    public final var statesLastTimestamp: Date? {
        get {
            if let value = (objc_getAssociatedObject(self, &incrementalArrayStatesLastTimestampKey) as? CNLAssociated<Date?>)?.closure {
                return value
            } else {
                return nil
            }
        }
        set {
            objc_setAssociatedObject(self, &incrementalArrayStatesLastTimestampKey, CNLAssociated<Date?>(closure: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    public func createItems(_ data: CNLDictionary) -> [ArrayElement]? {
        if let item = ArrayElement(dictionary: data) {
            return [item]
        }
        return nil
    }
    
    public func preprocessData(_ data: CNLDictionary?) -> CNLDictionary? {
        return data
    }

    /// Loads model from the dictionary
    ///
    /// - Parameter dictionary: Source dictionary
    public func loadFromDictionary(_ data: CNLDictionary) -> [ArrayElement] {
        lastTimestamp = data.date(CNLModelIncrementalArrayKeys.timestamp, lastTimestamp)
        statesLastTimestamp = data.date(CNLModelIncrementalArrayKeys.statesTimestamp, statesLastTimestamp)
        if let itemsInfo = data[CNLModelIncrementalArrayKeys.items] as? CNLArray {
            return defaultLoadFrom(itemsInfo)
        }
        return []
    }

    /// Stores model to the dictionary. Default implementation
    ///
    /// - Returns: Result dictionary
    public func storeToDictionary() -> CNLDictionary {
        let items = list.map { $0.storeToDictionary() }
        var result: CNLDictionary = [CNLModelIncrementalArrayKeys.items: items]
        result[CNLModelIncrementalArrayKeys.timestamp] = lastTimestamp?.timeIntervalSince1970
        result[CNLModelIncrementalArrayKeys.statesTimestamp] = statesLastTimestamp?.timeIntervalSince1970
        return result
    }
    
    public func indexOf(item: ArrayElement) -> Int? {
        return self.list.index { return $0.primaryKey == item.primaryKey }
    }

    /// Update data source. Default implementation
    ///
    /// - Parameters:
    ///   - success: Callback when operation was successfull
    ///   - failed: Callback when operation was failed
    public func update(success: @escaping CNLModel.Success, failed: @escaping CNLModel.Failed) {
        update(
            success: { model, error, _, _, _ in success(model, error) },
            failed: failed
        )
    }
    
    /// Update data source
    ///
    /// - Parameters:
    ///   - success: Callback when operation was successfull
    ///   - failed: Callback when operation was failed
    public func update(success: @escaping CNLModelIncrementalArrayCompletion, failed: @escaping CNLModel.Failed) {
        if let localAPI = createAPI() {
            CNLModel.networkProvider?.performRequest(
                api: localAPI,
                success: { apiObject in
                    
                    var createdItems: [ArrayElement] = []
                    var modifiedItems: [ArrayElement] = []
                    var deletedItems: [ArrayElement.KeyType] = []
                    
                    if let data = self.preprocessData(apiObject.answerJSON) {
                        if let created = self.createdItems(data) {
                            #if DEBUG
                                CNLLog("Model new items: \(created.count)", level: .debug)
                            #endif
                            
                            self.list += created
                            createdItems = created
                        }
                        if let modified = self.modifiedItems(data) {
                            #if DEBUG
                                CNLLog("Model changed items: \(modified.count)", level: .debug)
                            #endif
                            
                            modified.forEach { modifiedItem in
                                if let index = self.indexOf(item: modifiedItem) {
                                    modifiedItem.states = self.list[index].states
                                    self.list[index] = modifiedItem
                                    modifiedItems.append(modifiedItem)
                                    return
                                }
                                createdItems.append(modifiedItem)
                                self.list.append(modifiedItem)
                            }
                            
                        }
                        if let deleted = self.deletedItems(data) {
                            #if DEBUG
                                CNLLog("Model removed items: \(deleted.count)", level: .debug)
                            #endif
                            deletedItems = deleted
                            self.list = self.list.filter { item in !deleted.contains(item.primaryKey) }
                        }
                    }
                    if let timestamp: Date = apiObject.answerJSON?.date(CNLModelIncrementalArrayKeys.timestamp) {
                        self.lastTimestamp = timestamp
                    }
                    if let timestamp: Date = apiObject.answerJSON?.date(CNLModelIncrementalArrayKeys.statesTimestamp) {
                        self.statesLastTimestamp = timestamp
                    }

                    self.updateStates(
                        success: { model, status in
                            self.afterLoad()
                            #if DEBUG
                                CNLLog("Model count: \(self.list.count)", level: .debug)
                            #endif
                            success(self, status, createdItems, modifiedItems, deletedItems)
                        },
                        failed: { apiObject, error in failed(self, error) }
                    )
                },
                fail: { apiObject in failed(self, apiObject.errorStatus) },
                networkError: { apiObject, error in failed(self, apiObject.errorStatus(error)) }
            )
        } else {
            success(self, okStatus, [], [], []) //(kind: CNLErrorKind.Ok, success: true))
        }
    }

    public func updateStates(success: @escaping CNLModel.Success, failed: @escaping CNLModel.Failed) {
        if let statesAPI = createStatesAPI() {
            CNLModel.networkProvider?.performRequest(
                api: statesAPI,
                success: { apiObject in
                    if let statesInfo = apiObject.answerJSON {
                        self.updateStatesFromDictionary(statesInfo)
                    }
                    success(self, apiObject.status)
                },
                fail: { apiObject in failed(self, apiObject.errorStatus) },
                networkError: { apiObject, error in failed(self, apiObject.errorStatus(error)) }
            )
        } else {
            success(self, okStatus) //(kind: CNLErrorKind.Ok, success: true))
        }
    }
    
    /// Point of making necessary changes after serialize. Default implementation. Stub, does nothong
    ///
    /// - Returns: Updated array
    public func afterLoad() { }
    
    public func defaultLoadFrom(_ array: CNLArray) -> [ArrayElement] {
        let newListOfList = array.mapSkipNil { return self.createItems($0) }
        let newList = newListOfList.flatMap { return $0 }
        return newList
    }
    
    private func loadItems(_ data: CNLDictionary?, section: String) -> [ArrayElement]? {
        guard let itemsData = data?[section] as? CNLArray else { return nil }
        return defaultLoadFrom(itemsData)
    }
    
    public func createdItems(_ data: CNLDictionary?) -> [ArrayElement]? {
        return loadItems(data, section: CNLModelIncrementalArrayKeys.created)
    }
    
    public func modifiedItems(_ data: CNLDictionary?) -> [ArrayElement]? {
        return loadItems(data, section: CNLModelIncrementalArrayKeys.modified)
    }
    
    public func deletedItems(_ data: CNLDictionary?) -> [ArrayElement.KeyType]? {
        return data?[CNLModelIncrementalArrayKeys.deleted] as? [ArrayElement.KeyType]
    }

    public init?(data: CNLDictionary?) {
        guard let data = data else { return nil }
        self.init()
        list = loadFromDictionary(data)
    }
    
}
