//
//  LOImageCacher.swift
//
//
//  Created by kong on 2024/01/17.
//

import Foundation

public struct LOImageCacherWrapper<Base> {

    // MARK: - Properties

    public let base: Base

    // MARK: - Initializers

    public init(base: Base) {
        self.base = base
    }
}

public protocol LOImageCacherCompatible: AnyObject { }

extension LOImageCacherCompatible {

    // swiftlint:disable identifier_name
    public var lo: LOImageCacherWrapper<Self> {
        LOImageCacherWrapper(base: self)
    }
    // swiftlint:enable identifier_name

}
