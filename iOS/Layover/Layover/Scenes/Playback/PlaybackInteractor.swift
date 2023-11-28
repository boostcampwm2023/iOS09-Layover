//
//  PlaybackInteractor.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol PlaybackBusinessLogic {
    func displayVideoList()
}

protocol PlaybackDataStore: AnyObject {
    var videos: [PlaybackModels.Board]? { get set }
    var parentView: PlaybackModels.ParentView? { get set }
    var index: Int? { get set }
}

final class PlaybackInteractor: PlaybackBusinessLogic, PlaybackDataStore {

    // MARK: - Properties

    typealias Models = PlaybackModels

    lazy var worker = PlaybackWorker()
    var presenter: PlaybackPresentationLogic?
    var videos: [Models.Board]?
    var parentView: Models.ParentView?
    var index: Int?

    func displayVideoList() {
        guard let parentView: Models.ParentView else {
            return
        }
        guard var videos: [PlaybackModels.Board] else {
            return
        }
        if parentView == .other {
            videos = worker.makeInfiniteScroll(videos: videos)
        }
        let response: Models.PlaybackVideoList.Response = Models.PlaybackVideoList.Response(videos: videos)
        presenter?.presentVideoList(with: response)
    }

}
