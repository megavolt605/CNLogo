//
//  CNLModelError.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 22/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import Foundation

import CNLFoundationTools

public struct CNLModelErrorAlert {
    
    public enum Style {
        case info, error, warning
    }
    
    public var type: Style
    public var title: String?
    public var message: String

    public init?(type: Style, title: String?, message: String?) {
        guard let message = message else { return nil }
        self.type = type
        self.title = title
        self.message = message
    }
}

public protocol CNLModelErrorKind {
    var identifier: String { get }
}

public protocol CNLModelError {
    var alertStruct: CNLModel.ErrorAlert? { get }
    var json: CNLDictionary? { get  }
    var kind: CNLModel.ErrorKind { get }
    var success: Bool { get }
}
