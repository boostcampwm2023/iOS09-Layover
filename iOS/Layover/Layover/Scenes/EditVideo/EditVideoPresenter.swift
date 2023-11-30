//
//  EditVideoPresenter.swift
//  Layover
//
//  Created by kong on 2023/11/29.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol EditVideoPresentationLogic {
    func presentVideo(with response: EditVideoModels.FetchVideo.Response)
}

final class EditVideoPresenter: EditVideoPresentationLogic {

    // MARK: - Properties

    typealias Models = EditVideoModels
    weak var viewController: EditVideoDisplayLogic?

    func presentVideo(with response: EditVideoModels.FetchVideo.Response) {
        let viewModel = Models.FetchVideo.ViewModel(isEdited: response.isEdited,
                                                    videoURL: response.videoURL,
                                                    duration: response.duration,
                                                    canNext: response.isWithinRange)
        viewController?.displayVideo(viewModel: viewModel)
    }
}
