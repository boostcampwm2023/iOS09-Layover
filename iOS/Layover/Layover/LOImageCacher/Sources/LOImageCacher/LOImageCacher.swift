//
//  LOImageCacher.swift
//
//
//  Created by kong on 2024/01/17.
//

import Foundation

public struct LOImageCacherWrapper<Base> {
    public let base: Base
    public init(base: Base) {
        self.base = base
    }
}

public protocol LOImageCacherCompatible: AnyObject { }

extension LOImageCacherCompatible {
    public var lo: LOImageCacherWrapper<Self> {
        LOImageCacherWrapper(base: self)
    }
}
