//
//  UploadPostPresenter.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol UploadPostPresentationLogic {
    func presentFetchFromLocalDataStore(with response: UploadPostModels.FetchFromLocalDataStore.Response)
    func presentFetchFromRemoteDataStore(with response: UploadPostModels.FetchFromRemoteDataStore.Response)
    func presentTrackAnalytics(with response: UploadPostModels.TrackAnalytics.Response)
    func presentPerformUploadPost(with response: UploadPostModels.PerformUploadPost.Response)
}

class UploadPostPresenter: UploadPostPresentationLogic {

    // MARK: - Properties

    typealias Models = UploadPostModels
    weak var viewController: UploadPostDisplayLogic?

    // MARK: - Use Case - Fetch From Local DataStore

    func presentFetchFromLocalDataStore(with response: UploadPostModels.FetchFromLocalDataStore.Response) {
        let translation = "Some localized text."
        let viewModel = Models.FetchFromLocalDataStore.ViewModel(exampleTranslation: translation)
        viewController?.displayFetchFromLocalDataStore(with: viewModel)
    }

    // MARK: - Use Case - Fetch From Remote DataStore

    func presentFetchFromRemoteDataStore(with response: UploadPostModels.FetchFromRemoteDataStore.Response) {
        let formattedExampleVariable = response.exampleVariable ?? ""
        let viewModel = Models.FetchFromRemoteDataStore.ViewModel(exampleVariable: formattedExampleVariable)
        viewController?.displayFetchFromRemoteDataStore(with: viewModel)
    }

    // MARK: - Use Case - Track Analytics

    func presentTrackAnalytics(with response: UploadPostModels.TrackAnalytics.Response) {
        let viewModel = Models.TrackAnalytics.ViewModel()
        viewController?.displayTrackAnalytics(with: viewModel)
    }

    // MARK: - Use Case - UploadPost

    func presentPerformUploadPost(with response: UploadPostModels.PerformUploadPost.Response) {
        var responseError = response.error

        if let error = responseError {
            switch error.type {
            case .emptyExampleVariable:
                responseError?.message = "Localized empty/nil error message."

            case .networkError:
                responseError?.message = "Localized network error message."
            }
        }

        let viewModel = Models.PerformUploadPost.ViewModel(error: responseError)
        viewController?.displayPerformUploadPost(with: viewModel)
    }
}
