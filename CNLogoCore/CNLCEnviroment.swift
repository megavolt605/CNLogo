//
//  CNLCEnviroment.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 28/09/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

public class CNLCEnviroment {
    
    public static let defaultEnviroment = CNLCEnviroment()

    let kSystemPrograms = "systemPrograms"
    let kUserPrograms = "userPrograms"
    
    public var systemPrograms: [CNLCProgram]
    public var userPrograms: [CNLCProgram]
    public var currentProgram: CNLCProgram?

    func appendExecutionHistory(itemType: CNLCExecutionHistoryItemType, fromBlock: CNLCBlock?) {
        currentProgram?.executionHistory.append(itemType, block: fromBlock)
    }
    
    func savePrograms() {
        CNLCEnviroment._savePrograms(kSystemPrograms, programs: systemPrograms)
        CNLCEnviroment._savePrograms(kUserPrograms, programs: userPrograms)
    }
    
    private static func _urlForKey(keyName: String) -> NSURL? {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if let path = paths.first {
            let url: NSURL
            if keyName != "" {
                url = NSURL(fileURLWithPath: path).URLByAppendingPathComponent("\(keyName).plist")
            } else {
                url = NSURL(fileURLWithPath: path)
            }
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtURL(url.URLByDeletingLastPathComponent!, withIntermediateDirectories: true, attributes: nil)
                return url
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    private static func _loadPrograms(key: String) -> [CNLCProgram] {
        let res: [CNLCProgram]
        if let storageURL = _urlForKey(key), programs = NSArray(contentsOfURL: storageURL) {
            res = programs.flatMap { item in
                if let programData = item as? [String: AnyObject] {
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
    
    private static func _savePrograms(key: String, programs: [CNLCProgram]) {
        if let storageURL = _urlForKey(key) {
            let data = NSArray(array: programs, copyItems: false)
            data.writeToURL(storageURL, atomically: true)
        }
    }
    
    init() {
        systemPrograms = CNLCEnviroment._loadPrograms(kSystemPrograms)
        userPrograms = CNLCEnviroment._loadPrograms(kUserPrograms)
    }
    
}