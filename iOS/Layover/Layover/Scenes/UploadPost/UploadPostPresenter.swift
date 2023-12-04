//
//  UploadPostPresenter.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol UploadPostPresentationLogic {
    func presentTags(with response: UploadPostModels.FetchTags.Response)
    func presentThumnailImage(with response: UploadPostModels.FetchThumbnail.Response)
    func presentCurrentAddress(with response: UploadPostModels.FetchCurrentAddress.Response)
    func presentUploadButton(with response: UploadPostModels.CanUploadPost.Response)
}

final class UploadPostPresenter: UploadPostPresentationLogic {

    // MARK: - Properties

    typealias Models = UploadPostModels
    weak var viewController: UploadPostDisplayLogic?

    func presentTags(with response: UploadPostModels.FetchTags.Response) {
        viewController?.displayTags(viewModel: UploadPostModels.FetchTags.ViewModel(tags: response.tags))
    }

    func presentThumnailImage(with response: UploadPostModels.FetchThumbnail.Response) {
        let image = UIImage(cgImage: response.thumnailImage)
        viewController?.displayThumbnail(viewModel: UploadPostModels.FetchThumbnail.ViewModel(thumnailImage: image))
    }

    func presentCurrentAddress(with response: UploadPostModels.FetchCurrentAddress.Response) {
        let addressSet = Set([response.administrativeArea, response.locality, response.subLocality])
        let fullAddress: String = Array(addressSet)
            .compactMap { $0 }
            .joined(separator: " ")
        let viewModel = UploadPostModels.FetchCurrentAddress.ViewModel(fullAddress: fullAddress)
        viewController?.displayCurrentAddress(viewModel: viewModel)
    }

    func presentUploadButton(with response: UploadPostModels.CanUploadPost.Response) {
        let viewModel = UploadPostModels.CanUploadPost.ViewModel(canUpload: !response.isEmpty)
        viewController?.displayUploadButton(viewModel: viewModel)
    }

}
