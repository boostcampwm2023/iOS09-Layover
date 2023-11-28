//
//  PlaybackPresenter.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol PlaybackPresentationLogic {
}

class PlaybackPresenter: PlaybackPresentationLogic {

    // MARK: - Properties

    typealias Models = PlaybackModels
    weak var viewController: PlaybackDisplayLogic?

}
