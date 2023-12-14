//
//  URL+.swift
//  Layover
//
//  Created by 김인환 on 12/14/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

extension URL {
    func changeScheme(to: String) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.scheme = to
        return components?.url ?? self
    }

    var customHLSURL: URL {
        changeScheme(to: "lhls")
    }

    var originHLSURL: URL {
        changeScheme(to: "https")
    }
}
