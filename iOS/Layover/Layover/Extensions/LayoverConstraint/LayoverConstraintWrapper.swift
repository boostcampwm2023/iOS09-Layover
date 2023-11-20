//
//  LayoverConstraintWrapper.swift
//  Layover
//
//  Created by 김인환 on 11/20/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

struct LayoverConstraintWrapper<Base> {
    let base: Base
}

protocol LayoverConstraintCompatible {
    associatedtype LayoverConstraintBase

    var lor: LayoverConstraintWrapper<LayoverConstraintBase> { get }
}

extension LayoverConstraintCompatible {
    var lor: LayoverConstraintWrapper<Self> {
        get {
            return LayoverConstraintWrapper(base: self)
        }
    }
}

extension UIView: LayoverConstraintCompatible { }
