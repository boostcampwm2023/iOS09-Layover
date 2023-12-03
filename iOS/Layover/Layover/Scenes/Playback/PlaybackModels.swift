//
//  PlaybackModels.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

enum PlaybackModels {
    // MARK: - Properties Type
    struct PlaybackVideo: Hashable {
        var id: UUID = UUID()
        let post: Post
    }

    enum ParentView {
        case home
        case other
    }

    // MARK: - UseCase Load Video List

    enum LoadPlaybackVideoList {
        struct Request {

        }

        struct Response {
            let videos: [PlaybackVideo]
        }

        struct ViewModel {
            let videos: [PlaybackVideo]
        }
    }

    // MARK: - UseCase Set Init Playback Scene

    enum SetInitialPlaybackCell {
        struct Request {
            let indexPathRow: Int
        }

        struct Response {
            let indexPathRow: Int
        }

        struct ViewModel {
            let indexPathRow: Int
        }
    }

    // MARK: - UseCase Playback Video

    enum DisplayPlaybackVideo {
        struct Request {
            let indexPathRow: Int?
            let curCell: PlaybackCell?
        }

        struct Response {
            let indexPathRow: Int?
            let prevCell: PlaybackCell?
            let curCell: PlaybackCell?

            init(indexPathRow: Int? = nil, prevCell: PlaybackCell?, curCell: PlaybackCell?) {
                self.indexPathRow = indexPathRow
                self.prevCell = prevCell
                self.curCell = curCell
            }
        }

        struct ViewModel {
            let indexPathRow: Int?
            let prevCell: PlaybackCell?
            let curCell: PlaybackCell?

            init(indexPathRow: Int? = nil, prevCell: PlaybackCell?, curCell: PlaybackCell?) {
                self.indexPathRow = indexPathRow
                self.prevCell = prevCell
                self.curCell = curCell
            }
        }
    }

    // MARK: - UseCase Cell Configure

    enum ConfigurePlaybackCell {
        struct Request {
        }

        struct Response {
            let teleportIndex: Int?
        }

        struct ViewModel {
            let teleportIndex: Int?
        }
    }

    // MARK: - UseCase Seek Video

    enum SeekVideo {
        struct Request {
            let currentLocation: Float64
        }

        struct Response {
            let willMoveLocation: Float64
            let curCell: PlaybackCell
        }

        struct ViewModel {
            let willMoveLocation: Float64
            let curCell: PlaybackCell
        }
    }
}
