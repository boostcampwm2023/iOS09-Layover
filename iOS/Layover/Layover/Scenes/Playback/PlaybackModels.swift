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
        let playbackInfo: PlaybackInfo
    }

    enum ParentView {
        case home
        case myProfile
        case other
    }

    struct PlaybackInfo: Hashable {
        let boardID: Int
        let title: String
        let content: String
        let profileImageURL: URL?
        let profileName: String
        let tag: [String]
        // location
        let videoURL: URL
    }

    // MARK: - UseCase Load Video List

    enum LoadPlaybackVideoList {
        struct Request {

        }

        struct Response {
            let posts: [Post]
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
            var prevCell: PlaybackCell?
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

    // MARK: - UseCase Report Playback Video

    enum ReportPlaybackVideo {
        struct Request {
            
        }

        struct Response {
            let boardID: Int
        }

        struct ViewModel {
            let boardID: Int
        }
    }

    // MARK: - UseCase Set Seemore button

    enum SetSeemoreButton {
        enum ButtonType {
            case report
            case delete

            var description: String? {
                switch self {
                case .report:
                    "신고"
                case .delete:
                    "삭제"
                }
            }
        }
        struct Request {

        }

        struct Response {
            let parentView: ParentView
        }

        struct ViewModel {
            let buttonType: ButtonType
        }
    }

    // MARK: - UseCase DeleteVideo

    enum DeletePlaybackVideo {
        enum DeleteMessage {
            case success
            case fail

            var description: String {
                switch self {
                case .success:
                    "영상이 삭제되었습니다."
                case .fail:
                    "영상 삭제에 실패했습니다."
                }
            }
        }

        struct Request {
            let playbackVideo: PlaybackVideo
        }

        struct Response {
            let result: Bool
            let playbackVideo: PlaybackVideo
        }

        struct ViewModel {
            let deleteMessage: DeleteMessage
            let playbackVideo: PlaybackVideo
        }
    }
}
