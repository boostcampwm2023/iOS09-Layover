//
//  HomeInteractor.swift
//  Layover
//
//  Created by 김인환 on 11/15/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol HomeBusinessLogic {
    func fetchFromLocalDataStore(with request: HomeModels.FetchFromLocalDataStore.Request)
    func fetchFromRemoteDataStore(with request: HomeModels.FetchFromRemoteDataStore.Request)
    func trackAnalytics(with request: HomeModels.TrackAnalytics.Request)
    func performHome(with request: HomeModels.PerformHome.Request)
}

protocol HomeDataStore {
    var exampleVariable: String? { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {

    // MARK: - Properties

    typealias Models = HomeModels

    lazy var worker = HomeWorker()
    var presenter: HomePresentationLogic?

    var exampleVariable: String?

    // MARK: - Use Case - Fetch From Local DataStore

    func fetchFromLocalDataStore(with request: HomeModels.FetchFromLocalDataStore.Request) {
        let response = Models.FetchFromLocalDataStore.Response()
        presenter?.presentFetchFromLocalDataStore(with: response)
    }

    // MARK: - Use Case - Fetch From Remote DataStore

    func fetchFromRemoteDataStore(with request: HomeModels.FetchFromRemoteDataStore.Request) {
        // fetch something from backend and return the values here
        // <#Network Worker Instance#>.fetchFromRemoteDataStore(completion: { [weak self] code in
        //     let response = Models.FetchFromRemoteDataStore.Response(exampleVariable: code)
        //     self?.presenter?.presentFetchFromRemoteDataStore(with: response)
        // })
    }

    // MARK: - Use Case - Track Analytics

    func trackAnalytics(with request: HomeModels.TrackAnalytics.Request) {
        // call analytics library/wrapper here to track analytics
        // <#Analytics Worker Instance#>.trackAnalytics(event: request.event)

        let response = Models.TrackAnalytics.Response()
    }

    // MARK: - Use Case - Home

    func performHome(with request: HomeModels.PerformHome.Request) {
        let error = worker.validate(exampleVariable: request.exampleVariable)

        if let error = error {
            let response = Models.PerformHome.Response(error: error)
            presenter?.presentPerformHome(with: response)
            return
        }

        // <#Network Worker Instance#>.performHome(completion: { [weak self, weak request] isSuccessful, error in
        //     self?.completion(request?.exampleVariable, isSuccessful, error)
        // })
    }

    private func completion(_ exampleVariable: String?, _ isSuccessful: Bool, _ error: Models.HomeError?) {
        if isSuccessful {
            // do something on success
            let goodExample = exampleVariable ?? ""
            self.exampleVariable = goodExample
        }

        let response = Models.PerformHome.Response(error: error)
        presenter?.presentPerformHome(with: response)
    }
}
