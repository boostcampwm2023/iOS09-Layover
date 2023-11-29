//
//  EditVideoInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/29.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditVideoBusinessLogic {
    func fetchVideo()
}

protocol EditVideoDataStore {

}

final class EditVideoInteractor: EditVideoBusinessLogic, EditVideoDataStore {

    // MARK: - Properties

    typealias Models = EditVideoModels

    lazy var worker = EditVideoWorker()
    var presenter: EditVideoPresentationLogic?

    func fetchVideo() {
        let response =  Models.FetchVideo.Response(videoURL: URL(string: "https://assets.afcdn.com/video49/20210722/v_645516.m3u8")!)
        presenter?.presentVideo(with: response)
    }

}
