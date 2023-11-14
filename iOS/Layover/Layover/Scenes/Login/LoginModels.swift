//
//  LoginModels.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit

enum LoginModels {

    // MARK: - Use Cases

    enum FetchFromLocalDataStore {
        struct Request {
        }

        struct Response {
        }

        struct ViewModel {
            var exampleTranslation: String?
        }
    }

    enum FetchFromRemoteDataStore {
        struct Request {
        }

        struct Response {
            var exampleVariable: String?
        }

        struct ViewModel {
            var exampleVariable: String?
        }
    }

    enum TrackAnalytics {
        struct Request {
            var event: AnalyticsEvents
        }

        struct Response {
        }

        struct ViewModel {
        }
    }

    enum PerformLogin {
        struct Request {
            var exampleVariable: String?
        }

        struct Response {
            var error: LoginError?
        }

        struct ViewModel {
            var error: LoginError?
        }
    }

    // MARK: - Types

    // replace with `AnalyticsEvents` with `AnalyticsConstants` if needed
    typealias AnalyticsEvents = ExampleAnalyticsEvents
    typealias LoginError = Error<LoginErrorType>

    enum ExampleAnalyticsEvents {
        case screenView
    }

    enum LoginErrorType {
        case emptyExampleVariable, networkError
    }

    struct Error<T> {
        var type: T
        var message: String?

        init(type: T) {
            self.type = type
        }
    }
}
