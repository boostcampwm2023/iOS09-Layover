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
    func presentThumbnailImage(with response: UploadPostModels.FetchThumbnail.Response)
    func presentCurrentAddress(with response: UploadPostModels.FetchCurrentAddress.Response)
    func presentUploadButton(with response: UploadPostModels.CanUploadPost.Response)
    func presentUnsupportedFormatAlert()
}

final class UploadPostPresenter: UploadPostPresentationLogic {

    // MARK: - Properties

    typealias Models = UploadPostModels
    weak var viewController: UploadPostDisplayLogic?

    func presentTags(with response: UploadPostModels.FetchTags.Response) {
        viewController?.displayTags(viewModel: Models.FetchTags.ViewModel(tags: response.tags))
    }

    func presentThumbnailImage(with response: UploadPostModels.FetchThumbnail.Response) {
        let image = UIImage(cgImage: response.thumbnailImage)
        viewController?.displayThumbnail(viewModel: Models.FetchThumbnail.ViewModel(thumbnailImage: image))
    }

    func presentCurrentAddress(with response: UploadPostModels.FetchCurrentAddress.Response) {
        let addresses: [String] = [
            response.addressInfo.first?.administrativeArea,
            response.addressInfo.first?.locality,
            response.addressInfo.first?.subLocality]
            .compactMap { $0 }
        
        var fullAddress: [String] = []

        for address in addresses {
            if !fullAddress.contains(address) {
                fullAddress.append(address)
            }
        }
        let viewModel = Models.FetchCurrentAddress.ViewModel(fullAddress: fullAddress.joined(separator: " "))
        viewController?.displayCurrentAddress(viewModel: viewModel)
    }

    func presentUploadButton(with response: UploadPostModels.CanUploadPost.Response) {
        let viewModel = Models.CanUploadPost.ViewModel(canUpload: !response.isEmpty)
        viewController?.displayUploadButton(viewModel: viewModel)
    }

    func presentUnsupportedFormatAlert() {
        viewController?.displayUnsupportedFormatAlert()
    }
}
