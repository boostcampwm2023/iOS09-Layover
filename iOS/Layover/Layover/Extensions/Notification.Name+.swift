//
//  Notification.Name+.swift
//  Layover
//
//  Created by 김인환 on 11/27/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let refreshTokenDidExpired = Notification.Name("refreshTokenDidExpired")
    static let uploadTaskStart = Notification.Name("uploadTaskStart")
    static let progressChanged = Notification.Name("progressChanged")
}
