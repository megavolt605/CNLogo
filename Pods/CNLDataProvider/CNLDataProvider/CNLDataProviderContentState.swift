//
//  CNLDataProviderContentState.swift
//  CNLDataProvider
//
//  Created by Igor Smirnov on 23/12/2016.
//  Copyright © 2016 Complex Numbers. All rights reserved.
//

import UIKit

public enum CNLDataProviderContentStateKind {
    case normal, noData, noNetwork
    public var imageName: String? {
        switch self {
        case .normal: return nil
        case .noData: return "CNLDataProvider No Data"
        case .noNetwork: return "CNLDataProvider No Network"
        }
    }
    public var image: UIImage? {
        guard let imageName = imageName else { return nil }
        let i = UIImage(named: imageName, in: Bundle(for: CNLModel.self), compatibleWith: nil)
        return i
    }
}

public protocol CNLDataProviderContentState {

    var isEnabled: Bool { get set }
    var isHidden: Bool { get set }
    var kind: CNLDataProviderContentStateKind { get set }

    var noDataText: String { get set }
    var noNetworkText: String { get set }

    init(view: UIView)

}
