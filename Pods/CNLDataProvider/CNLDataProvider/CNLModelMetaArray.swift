//
//  CNLModelMetaArray.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import Foundation

import CNLFoundationTools

public protocol CNLModelMetaArrayItem: CNLModelArray {
    
}

public protocol CNLModelMetaArray: class, CNLModelObject, CNLModelArray {
    
    associatedtype MetaArrayItem: CNLModelMetaArrayItem
    
    associatedtype ArrayElement = MetaArrayItem.ArrayElement

    /// List of MetaArrayItem.ArrayElement instances
    var list: [MetaArrayItem.ArrayElement] { get set }
    
    var metaInfos: [MetaArrayItem] { get set }
    
    var ignoreFails: Bool { get }
}

fileprivate var ignoreFailsKey = "ignoreFails"
fileprivate var pagingArrayFromIndex = "fromIndex"

public extension CNLModelMetaArray {

    public var ignoreFails: Bool {
        get {
            if let value = (objc_getAssociatedObject(self, &ignoreFailsKey) as? CNLAssociated<Bool>)?.closure {
                return value
            } else {
                return false
            }
        }
        set {
            objc_setAssociatedObject(self, &ignoreFailsKey, CNLAssociated<Bool>(closure: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    public var fromIndex: Int {
        get {
            if let value = (objc_getAssociatedObject(self, &pagingArrayFromIndex) as? CNLAssociated<Int>)?.closure {
                return value
            } else {
                return 0
            }
        }
        set {
            objc_setAssociatedObject(self, &pagingArrayFromIndex, CNLAssociated<Int>(closure: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            if let index = (metaInfos.index { return $0.isPagingEnabled }) {
                let pager = metaInfos[index]
                pager.fromIndex = newValue//pager.count
            }
        }
    }
    
    /// Update data source. Default implementation
    ///
    /// - Parameters:
    ///   - success: Callback when operation was successfull
    ///   - failed: Callback when operation was failed
    public func update(success: @escaping CNLModel.Success, failed: @escaping CNLModel.Failed) {
        updateMetaArray(success: success, failed: failed)
    }
    
    public func updateMetaArray(success: @escaping CNLModel.Success, failed: @escaping CNLModel.Failed) {
        
        var count = metaInfos.count
        
        let sem = DispatchSemaphore(value: 0)
        let signal: () -> Void = { count -= 1; if count == 0 { sem.signal() } }
        
        var wasFailed = false
        var wasFailedError: CNLModel.Error?
        var successStatus: CNLModel.Error?
        
        list = []
        
        metaInfos.forEach { item in
            item.update(
                success: { _, status in
                    successStatus = status
                    signal()
                },
                failed: { _, error in
                    wasFailed = true
                    wasFailedError = error
                    signal()
                }
            )
        }
        asyncGlobal {
            sem.wait()
            syncMain {
                if !self.ignoreFails && wasFailed {
                    failed(self, wasFailedError)
                } else {
                    self.list = self.metaInfos.flatMap { return $0.list }
                    self.totalRecords = self.metaInfos.reduce(0) { (value: Int?, item: MetaArrayItem) -> Int in
                        if !item.isPagingEnabled {
                            return value ?? 0
                        }
                        return (value ?? 0) + (item.totalRecords ?? 0)
                    }
                    self.metaInfos.forEach {
                        if !$0.isPagingEnabled {
                            self.additionalRecords += $0.list.count
                        }
                    }
                    if let status = successStatus {
                        success(self, status)
                    }
                }
            }
        }
    }

    public func reset() {
        list = []
        totalRecords = nil
        additionalRecords = 0
        metaInfos.forEach {
            $0.reset()
        }
    }
    
    public func pagingReset() {
        reset()
    }
    
}
