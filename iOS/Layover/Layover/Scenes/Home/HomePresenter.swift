//
//  HomePresenter.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol HomePresentationLogic {
    func presentFetchFromLocalDataStore(with response: HomeModels.FetchFromLocalDataStore.Response)
    func presentFetchFromRemoteDataStore(with response: HomeModels.FetchFromRemoteDataStore.Response)
//    func presentTrackAnalytics(with response: HomeModels.TrackAnalytics.Response)
    func presentPerformHome(with response: HomeModels.PerformHome.Response)
}

class HomePresenter: HomePresentationLogic {

    // MARK: - Properties

    typealias Models = HomeModels
    weak var viewController: HomeDisplayLogic?

    // MARK: - Use Case - Fetch From Local DataStore

    func presentFetchFromLocalDataStore(with response: HomeModels.FetchFromLocalDataStore.Response) {
        let translation = "Some localized text."
        let viewModel = Models.FetchFromLocalDataStore.ViewModel(exampleTranslation: translation)
//        viewController?.displayFetchFromLocalDataStore(with: viewModel)
    }

    // MARK: - Use Case - Fetch From Remote DataStore

    func presentFetchFromRemoteDataStore(with response: HomeModels.FetchFromRemoteDataStore.Response) {
        let formattedExampleVariable = response.exampleVariable ?? ""
        let viewModel = Models.FetchFromRemoteDataStore.ViewModel(exampleVariable: formattedExampleVariable)
//        viewController?.displayFetchFromRemoteDataStore(with: viewModel)
    }

    // MARK: - Use Case - Track Analytics

    // MARK: - Use Case - Home

    func presentPerformHome(with response: HomeModels.PerformHome.Response) {
        var responseError = response.error

        if let error = responseError {
            switch error.type {
            case .emptyExampleVariable:
                responseError?.message = "Localized empty/nil error message."

            case .networkError:
                responseError?.message = "Localized network error message."
            }
        }

        let viewModel = Models.PerformHome.ViewModel(error: responseError)
//        viewController?.displayPerformHome(with: viewModel)
    }
}
