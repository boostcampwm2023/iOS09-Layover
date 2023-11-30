//
//  SettingSceneInteractor.swift
//  Layover
//
//  Created by 황지웅 on 11/30/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol SettingSceneBusinessLogic {

}

protocol SettingSceneDataStore {

}

final class SettingSceneInteractor: SettingSceneBusinessLogic, SettingSceneDataStore {

    // MARK: - Properties

    typealias Models = SettingSceneModels

    lazy var worker = SettingSceneWorker()
    var presenter: SettingScenePresentationLogic?
}
