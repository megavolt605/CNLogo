//
//  CNLModelIncrementalTokenizedArray.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 19/04/2017.
//  Copyright © 2017 Complex Numbers. All rights reserved.
//

import Foundation

import CNLFoundationTools

public typealias CNLModelObjectToken = String

public protocol CNLModelIncrementalTokenizedArray: CNLModelIncrementalArray where ArrayElement: CNLModelObjectTokenized {
    
    var tokens: [String] { get set }
    func reset()

    /// Maps (deserialize) received dictionary to the model ArrayElement object
    ///
    /// - Parameters:
    ///   - data: Source data dictionary
    ///   - token: Token of the data
    /// - Returns: Array if ArrayElement instances
    func createItems(_ data: CNLDictionary, withToken token: CNLModelObjectToken) -> [ArrayElement]?
    
    // MARK: CNLModelDictionary protocol
    /// Loads model from the dictionary
    ///
    /// - Parameter dictionary: Source dictionary
    func loadFromDictionary(_ data: CNLDictionary) -> [ArrayElement]
    /// Stores model to the dictionary
    ///
    /// - Returns: Result dictionary
    func storeToDictionary() -> CNLDictionary
    
    // states
    func updateStatesFromDictionary(_ data: CNLDictionary, forItemKey itemKey: ArrayElement.KeyType, withToken token: CNLModelObjectToken)
    
}

public protocol CNLModelObjectTokenized: CNLModelIncrementalArrayElement {
    var token: CNLModelObjectToken { get set }
}

public extension CNLModelObject where Self: CNLModelIncrementalTokenizedArray {
    
    public func reset() {
        list = []
    }
    
    /// Maps (deserialize) received dictionary to the model ArrayElement object
    ///
    /// - Parameters:
    ///   - data: Source data dictionary
    ///   - token: Token of the data
    /// - Returns: Array if ArrayElement instances
    public func createItems(_ data: CNLDictionary, withToken token: CNLModelObjectToken) -> [ArrayElement]? {
        if let item = ArrayElement(dictionary: data) {
            item.token = token
            return [item]
        }
        return nil
    }

    public func defaultLoadFrom(_ array: CNLArray, withToken token: String) -> [ArrayElement] {
        let newListOfList = array.mapSkipNil { return self.createItems($0, withToken: token) }
        let newList = newListOfList.flatMap { return $0 }
        return newList
    }

    public func defaultLoadFrom(_ data: CNLDictionary) -> [ArrayElement] {
        let items: [[ArrayElement]] = tokens.flatMap {
            guard let itemsData = data[$0] as? CNLArray else { return nil }
            return defaultLoadFrom(itemsData, withToken: $0)
        }
        let result = items.flatMap { return $0 }
        return result
    }
    
    private func loadItems(_ data: CNLDictionary?, section: String) -> [ArrayElement]? {
        guard let itemsData = data?[section] as? CNLDictionary else { return nil }
        return defaultLoadFrom(itemsData)
    }
    
    public func createdItems(_ data: CNLDictionary?) -> [ArrayElement]? {
        return loadItems(data, section: CNLModelIncrementalArrayKeys.created)
    }
    
    public func modifiedItems(_ data: CNLDictionary?) -> [ArrayElement]? {
        return loadItems(data, section: CNLModelIncrementalArrayKeys.modified)
    }
    
    public func deletedItems(_ data: CNLDictionary?) -> [ArrayElement.KeyType]? {
        guard let idsData = data?[CNLModelIncrementalArrayKeys.deleted] as? CNLDictionary else { return nil }
        let ids: [[ArrayElement.KeyType]] = tokens.flatMap { token in
            return idsData[token] as? [ArrayElement.KeyType]
        }
        let result = ids.flatMap { return $0 }
        return result
    }
    
    /// Loads model from the dictionary
    ///
    /// - Parameter dictionary: Source dictionary
    public func loadFromDictionary(_ data: CNLDictionary) -> [ArrayElement] {
        lastTimestamp = data.date(CNLModelIncrementalArrayKeys.timestamp, lastTimestamp)
        statesLastTimestamp = data.date(CNLModelIncrementalArrayKeys.statesTimestamp, statesLastTimestamp)
        return defaultLoadFrom(data)
    }
    
    /// Stores model to the dictionary. Default implementation
    ///
    /// - Returns: Result dictionary
    public func storeToDictionary() -> CNLDictionary {
        var result: CNLDictionary = [:]
        tokens.forEach { token in
            result[token] = list
                .filter { item in return item.token == token }
                .map { item in return item.storeToDictionary() }
        }
        result[CNLModelIncrementalArrayKeys.timestamp] = lastTimestamp?.timeIntervalSince1970
        result[CNLModelIncrementalArrayKeys.statesTimestamp] = statesLastTimestamp?.timeIntervalSince1970
        return result
    }

    public func indexOf(item: ArrayElement) -> Int? {
        return self.list.index { return $0.primaryKey == item.primaryKey && $0.token == item.token }
    }

    // states
    public func updateStatesFromDictionary(_ data: CNLDictionary) {
        if let timestamp: Date = data.date(CNLModelIncrementalArrayKeys.timestamp) {
            self.lastTimestamp = timestamp
        }
        if let timestamp: Date = data.date(CNLModelIncrementalArrayKeys.statesTimestamp) {
            self.statesLastTimestamp = timestamp
        }
        // modified
        //if let modifiedInfo = data["modified"] as? CNLDictionary {
            tokens.forEach { token in
                if let tokenData = data[token] as? CNLArray {
                    tokenData.forEach { itemInfo in
                        guard let key: ArrayElement.KeyType = itemInfo.value("id") else { return }
                        self.updateStatesFromDictionary(itemInfo, forItemKey: key, withToken: token)
                    }
                }
            }
        //}
        // deleted
    }
    
    public func updateStatesFromDictionary(_ data: CNLDictionary, forItemKey itemKey: ArrayElement.KeyType, withToken token: CNLModelObjectToken) {
        let items = list.filter { item in return item.token == token && item.primaryKey == itemKey }
        items.forEach { item in
            item.states.loadFromDictionary(data)
        }
    }

    public init?(dictionary: CNLDictionary?) {
        self.init()
        if let data = dictionary {
            list = loadFromDictionary(data)
        } else {
            return nil
        }
    }
    
}
