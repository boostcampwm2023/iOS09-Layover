//
//  LoginPresenter.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit

protocol LoginPresentationLogic {
    func presentFetchFromLocalDataStore(with response: LoginModels.FetchFromLocalDataStore.Response)
    func presentFetchFromRemoteDataStore(with response: LoginModels.FetchFromRemoteDataStore.Response)
    func presentTrackAnalytics(with response: LoginModels.TrackAnalytics.Response)
    func presentPerformLogin(with response: LoginModels.PerformLogin.Response)
}

class LoginPresenter: LoginPresentationLogic {

    // MARK: - Properties

    typealias Models = LoginModels
    weak var viewController: LoginDisplayLogic?

    // MARK: - Use Case - Fetch From Local DataStore

    func presentFetchFromLocalDataStore(with response: LoginModels.FetchFromLocalDataStore.Response) {
        let translation = "Some localized text."
        let viewModel = Models.FetchFromLocalDataStore.ViewModel(exampleTranslation: translation)
        viewController?.displayFetchFromLocalDataStore(with: viewModel)
    }

    // MARK: - Use Case - Fetch From Remote DataStore

    func presentFetchFromRemoteDataStore(with response: LoginModels.FetchFromRemoteDataStore.Response) {
        let formattedExampleVariable = response.exampleVariable ?? ""
        let viewModel = Models.FetchFromRemoteDataStore.ViewModel(exampleVariable: formattedExampleVariable)
        viewController?.displayFetchFromRemoteDataStore(with: viewModel)
    }

    // MARK: - Use Case - Track Analytics

    func presentTrackAnalytics(with response: LoginModels.TrackAnalytics.Response) {
        let viewModel = Models.TrackAnalytics.ViewModel()
        viewController?.displayTrackAnalytics(with: viewModel)
    }

    // MARK: - Use Case - Login

    func presentPerformLogin(with response: LoginModels.PerformLogin.Response) {
        var responseError = response.error

        if let error = responseError {
            switch error.type {
            case .emptyExampleVariable:
                responseError?.message = "Localized empty/nil error message."

            case .networkError:
                responseError?.message = "Localized network error message."
            }
        }

        let viewModel = Models.PerformLogin.ViewModel(error: responseError)
        viewController?.displayPerformLogin(with: viewModel)
    }
}
