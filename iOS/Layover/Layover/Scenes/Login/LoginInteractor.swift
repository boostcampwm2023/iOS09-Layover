//
//  LoginInteractor.swift
//  Layover
//
//  Created by 김인환 on 11/14/23.
//

import UIKit

protocol LoginBusinessLogic {
    func fetchFromLocalDataStore(with request: LoginModels.FetchFromLocalDataStore.Request)
    func fetchFromRemoteDataStore(with request: LoginModels.FetchFromRemoteDataStore.Request)
    func trackAnalytics(with request: LoginModels.TrackAnalytics.Request)
    func performLogin(with request: LoginModels.PerformLogin.Request)
}

protocol LoginDataStore {
    var exampleVariable: String? { get set }
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {

    // MARK: - Properties

    typealias Models = LoginModels

    lazy var worker = LoginWorker()
    var presenter: LoginPresentationLogic?

    var exampleVariable: String?

    // MARK: - Use Case - Fetch From Local DataStore

    func fetchFromLocalDataStore(with request: LoginModels.FetchFromLocalDataStore.Request) {
        let response = Models.FetchFromLocalDataStore.Response()
        presenter?.presentFetchFromLocalDataStore(with: response)
    }

    // MARK: - Use Case - Fetch From Remote DataStore

    func fetchFromRemoteDataStore(with request: LoginModels.FetchFromRemoteDataStore.Request) {
        // fetch something from backend and return the values here
        // <#Network Worker Instance#>.fetchFromRemoteDataStore(completion: { [weak self] code in
        //     let response = Models.FetchFromRemoteDataStore.Response(exampleVariable: code)
        //     self?.presenter?.presentFetchFromRemoteDataStore(with: response)
        // })
    }

    // MARK: - Use Case - Track Analytics

    func trackAnalytics(with request: LoginModels.TrackAnalytics.Request) {
        // call analytics library/wrapper here to track analytics
        // <#Analytics Worker Instance#>.trackAnalytics(event: request.event)

        let response = Models.TrackAnalytics.Response()
        presenter?.presentTrackAnalytics(with: response)
    }

    // MARK: - Use Case - Login

    func performLogin(with request: LoginModels.PerformLogin.Request) {
        let error = worker.validate(exampleVariable: request.exampleVariable)

        if let error = error {
            let response = Models.PerformLogin.Response(error: error)
            presenter?.presentPerformLogin(with: response)
            return
        }

        // <#Network Worker Instance#>.performLogin(completion: { [weak self, weak request] isSuccessful, error in
        //     self?.completion(request?.exampleVariable, isSuccessful, error)
        // })
    }

    private func completion(_ exampleVariable: String?, _ isSuccessful: Bool, _ error: Models.LoginError?) {
        if isSuccessful {
            // do something on success
            let goodExample = exampleVariable ?? ""
            self.exampleVariable = goodExample
        }

        let response = Models.PerformLogin.Response(error: error)
        presenter?.presentPerformLogin(with: response)
    }
}
