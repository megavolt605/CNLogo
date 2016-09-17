//
//  CNLCEnviroment.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 28/09/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

open class CNLCEnviroment {
    
    open static let defaultEnviroment = CNLCEnviroment()

    let kSystemPrograms = "systemPrograms"
    let kUserPrograms = "userPrograms"
    
    open var systemPrograms: [CNLCProgram]
    open var userPrograms: [CNLCProgram]
    open var currentProgram: CNLCProgram?

    func appendExecutionHistory(_ itemType: CNLCExecutionHistoryItemType, fromBlock: CNLCBlock?) {
        currentProgram?.executionHistory.append(itemType, block: fromBlock)
    }
    
    func savePrograms() {
        CNLCEnviroment._savePrograms(kSystemPrograms, programs: systemPrograms)
        CNLCEnviroment._savePrograms(kUserPrograms, programs: userPrograms)
    }
    
    fileprivate static func _urlForKey(_ keyName: String) -> URL? {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let path = paths.first {
            let url: URL
            if keyName != "" {
                url = URL(fileURLWithPath: path).appendingPathComponent("\(keyName).plist")
            } else {
                url = URL(fileURLWithPath: path)
            }
            
            do {
                try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
                return url
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    fileprivate static func _loadPrograms(_ key: String) -> [CNLCProgram] {
        let res: [CNLCProgram]
        if let storageURL = _urlForKey(key), let programs = NSArray(contentsOf: storageURL) {
            res = programs.flatMap { item in
                if let programData = item as? [String: Any] {
                    return CNLCProgram(data: programData)
                }
                return nil
            }
        } else {
            res = []
        }
        print("\(res.count) programs loaded for key \(key)")
        return res
    }
    
    fileprivate static func _savePrograms(_ key: String, programs: [CNLCProgram]) {
        if let storageURL = _urlForKey(key) {
            let data = NSArray(array: programs, copyItems: false)
            data.write(to: storageURL, atomically: true)
        }
    }
    
    init() {
        systemPrograms = CNLCEnviroment._loadPrograms(kSystemPrograms)
        userPrograms = CNLCEnviroment._loadPrograms(kUserPrograms)
    }
    
}
