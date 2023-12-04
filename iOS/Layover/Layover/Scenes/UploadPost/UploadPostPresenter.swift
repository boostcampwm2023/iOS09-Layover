//
//  UploadPostPresenter.swift
//  Layover
//
//  Created by kong on 2023/12/01.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol UploadPostPresentationLogic {
    func presentThumnailImage(with response: UploadPostModels.FetchThumbnail.Response)
}

final class UploadPostPresenter: UploadPostPresentationLogic {

    // MARK: - Properties

    typealias Models = UploadPostModels
    weak var viewController: UploadPostDisplayLogic?

    func presentThumnailImage(with response: UploadPostModels.FetchThumbnail.Response) {
        let image = UIImage(cgImage: response.thumnailImage)
        viewController?.displayThumbnail(viewModel: UploadPostModels.FetchThumbnail.ViewModel(thumnailImage: image))
    }

}
