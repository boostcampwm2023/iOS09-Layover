//
//  UploadPostInteractor.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol UploadPostBusinessLogic {
    func fetchFromLocalDataStore(with request: UploadPostModels.FetchFromLocalDataStore.Request)
    func fetchFromRemoteDataStore(with request: UploadPostModels.FetchFromRemoteDataStore.Request)
    func trackAnalytics(with request: UploadPostModels.TrackAnalytics.Request)
    func performUploadPost(with request: UploadPostModels.PerformUploadPost.Request)
}

protocol UploadPostDataStore {
    var exampleVariable: String? { get set }
}

class UploadPostInteractor: UploadPostBusinessLogic, UploadPostDataStore {

    // MARK: - Properties

    typealias Models = UploadPostModels

    lazy var worker = UploadPostWorker()
    var presenter: UploadPostPresentationLogic?

    var exampleVariable: String?

    // MARK: - Use Case - Fetch From Local DataStore

    func fetchFromLocalDataStore(with request: UploadPostModels.FetchFromLocalDataStore.Request) {
        let response = Models.FetchFromLocalDataStore.Response()
        presenter?.presentFetchFromLocalDataStore(with: response)
    }

    // MARK: - Use Case - Fetch From Remote DataStore

    func fetchFromRemoteDataStore(with request: UploadPostModels.FetchFromRemoteDataStore.Request) {
        // fetch something from backend and return the values here
        // <#Network Worker Instance#>.fetchFromRemoteDataStore(completion: { [weak self] code in
        //     let response = Models.FetchFromRemoteDataStore.Response(exampleVariable: code)
        //     self?.presenter?.presentFetchFromRemoteDataStore(with: response)
        // })
    }

    // MARK: - Use Case - Track Analytics

    func trackAnalytics(with request: UploadPostModels.TrackAnalytics.Request) {
        // call analytics library/wrapper here to track analytics
        // <#Analytics Worker Instance#>.trackAnalytics(event: request.event)

        let response = Models.TrackAnalytics.Response()
        presenter?.presentTrackAnalytics(with: response)
    }

    // MARK: - Use Case - UploadPost

    func performUploadPost(with request: UploadPostModels.PerformUploadPost.Request) {
        let error = worker.validate(exampleVariable: request.exampleVariable)

        if let error = error {
            let response = Models.PerformUploadPost.Response(error: error)
            presenter?.presentPerformUploadPost(with: response)
            return
        }

        // <#Network Worker Instance#>.performUploadPost(completion: { [weak self, weak request] isSuccessful, error in
        //     self?.completion(request?.exampleVariable, isSuccessful, error)
        // })
    }

    private func completion(_ exampleVariable: String?, _ isSuccessful: Bool, _ error: Models.UploadPostError?) {
        if isSuccessful {
            // do something on success
            let goodExample = exampleVariable ?? ""
            self.exampleVariable = goodExample
        }

        let response = Models.PerformUploadPost.Response(error: error)
        presenter?.presentPerformUploadPost(with: response)
    }
}
