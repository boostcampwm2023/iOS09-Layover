//
//  OSLog+.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import OSLog

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "kr.codesquad.boostcamp8.Layover"

    // add more OSLog if you need.
    static let ui = OSLog(subsystem: subsystem, category: "UI")
    static let data = OSLog(subsystem: subsystem, category: "Data")
}
