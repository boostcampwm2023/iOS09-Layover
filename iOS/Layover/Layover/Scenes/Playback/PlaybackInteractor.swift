//
//  PlaybackInteractor.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol PlaybackBusinessLogic {

}

protocol PlaybackDataStore {

}

final class PlaybackInteractor: PlaybackBusinessLogic, PlaybackDataStore {

    // MARK: - Properties

    typealias Models = PlaybackModels

    lazy var worker = PlaybackWorker()
    var presenter: PlaybackPresentationLogic?

}
