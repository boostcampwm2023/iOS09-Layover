//
//  AVFileType+.swift
//  Layover
//
//  Created by kong on 2023/12/14.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import AVFoundation

extension AVFileType {
    static func from(_ url: URL) -> AVFileType? {
        let pathExtension = url.pathExtension
        switch pathExtension {
        case "mp4":
            return .mp4
        case "mov":
            return .mov
        default:
            return nil
        }
    }
}
