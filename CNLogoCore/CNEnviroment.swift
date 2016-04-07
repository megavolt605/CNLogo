//
//  CNEnviroment.swift
//  CNLogoCore
//
//  Created by Igor Smirnov on 28/09/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import Foundation

private func _urlForKey(keyName: String) -> NSURL? {
    
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

private func _loadPrograms(key: String) -> [CNProgram] {
    let res: [CNProgram]
    if let storageURL = _urlForKey(key), programs = NSArray(contentsOfURL: storageURL) {
         res = programs.flatMap { item in
            if let programData = item as? [String: AnyObject] {
                return CNProgram(data: programData)
            }
            return nil
        }
    } else {
        res = []
    }
    print("\(res.count) programs loaded for key \(key)")
    return res
}

private func _savePrograms(key: String, programs: [CNProgram]) {
    if let storageURL = _urlForKey(key) {
        let data = NSArray(array: programs, copyItems: false)
        data.writeToURL(storageURL, atomically: true)
    }
}

public class CNEnviroment {
    
    public static let defaultEnviroment = CNEnviroment()

    let kSystemPrograms = "systemPrograms"
    let kUserPrograms = "userPrograms"
    
    public var systemPrograms: [CNProgram]
    public var userPrograms: [CNProgram]
    public var currentProgram: CNProgram?

    func appendExecutionHistory(itemType: CNExecutionHistoryItemType, fromBlock: CNBlock?) {
        currentProgram?.executionHistory.append(itemType, block: fromBlock)
    }
    
    func savePrograms() {
        _savePrograms(kSystemPrograms, programs: systemPrograms)
        _savePrograms(kUserPrograms, programs: userPrograms)
    }
    
    init() {
        systemPrograms = _loadPrograms(kSystemPrograms)
        userPrograms = _loadPrograms(kUserPrograms)
    }
    
}