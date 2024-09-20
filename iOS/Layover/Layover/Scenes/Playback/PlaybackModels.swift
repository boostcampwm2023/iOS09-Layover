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
        let displayedPost: DisplayedPost
    }

    enum ParentView {
        case home
        case myProfile
        case otherProfile
        case tag
        case map
    }

    struct DisplayedPost: Hashable {
        let member: PlaybackModels.Member
        let board: PlaybackModels.Board
        let tags: [String]
    }

    struct Member: Hashable {
        let memberID: Int
        let username: String
        let profileImageURL: URL?
    }

    struct Board: Hashable {
        let boardID: Int
        let title: String
        let description: String?
        let videoURL: URL
        let latitude: Double
        let longitude: Double
    }

    struct PlaybackInfo {
        let memberID: Int
        let boardID: Int
    }

    static let fetchPostCount: Int = 15

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
            let currentCell: PlaybackCell?
        }

        struct Response {
            let indexPathRow: Int?
            let previousCell: PlaybackCell?
            let currentCell: PlaybackCell?

            init(indexPathRow: Int? = nil, previousCell: PlaybackCell?, currentCell: PlaybackCell?) {
                self.indexPathRow = indexPathRow
                self.previousCell = previousCell
                self.currentCell = currentCell
            }
        }

        struct ViewModel {
            let indexPathRow: Int?
            var previousCell: PlaybackCell?
            let currentCell: PlaybackCell?

            init(indexPathRow: Int? = nil, previousCell: PlaybackCell?, currentCell: PlaybackCell?) {
                self.indexPathRow = indexPathRow
                self.previousCell = previousCell
                self.currentCell = currentCell
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
            let currentCell: PlaybackCell
        }

        struct ViewModel {
            let willMoveLocation: Float64
            let currentCell: PlaybackCell
        }
    }

    // MARK: - UseCase Report Playback Video

    enum ReportPlaybackVideo {
        struct Request {
            let indexPathRow: Int
        }

        struct Response {

        }

        struct ViewModel {

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
            let indexPathRow: Int
        }

        struct Response {
            let buttonType: ButtonType
            let indexPathRow: Int
        }

        struct ViewModel {
            let buttonType: ButtonType
            let indexPathRow: Int
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
            let indexPathRow: Int
        }

        struct Response {
            let result: Bool
            let playbackVideo: PlaybackVideo
            let nextCellIndex: Int?
            let deleteCellIndex: Int?
            let isNeedReplace: Bool
        }

        struct ViewModel {
            let deleteMessage: DeleteMessage
            let playbackVideo: PlaybackVideo
            let nextCellIndex: Int?
            let deleteCellIndex: Int?
            let isNeedReplace: Bool
        }
    }

    // MARK: - UseCase MoveTo Profile & Tag

    enum MoveToRelativeView {
        struct Request {
            let indexPathRow: Int?
            let selectedTag: String?
        }

        struct Response {

        }

        struct ViewModel {

        }
    }

    // MARK: - UseCase Load ProfileImage & Location

    enum LoadProfileImageAndLocation {
        struct Request {
            let curCell: PlaybackCell
            let profileImageURL: URL?
            let latitude: Double
            let longitude: Double
        }

        struct Response {
            let curCell: PlaybackCell
            let profileImageData: Data?
            let location: String?
        }

        struct ViewModel {
            let curCell: PlaybackCell
            let profileImageData: Data?
            let location: String
        }
    }
}
