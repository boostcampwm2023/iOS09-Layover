//
//  VideoPickerManager.swift
//  Layover
//
//  Created by kong on 2023/12/06.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import PhotosUI

protocol VideoPickerDelegate: AnyObject {
    func didFinishPickingVideo(_ url: URL)
}

final class VideoPickerManager: NSObject, PHPickerViewControllerDelegate {

    // MARK: - Properties

    weak var videoPickerDelegate: VideoPickerDelegate?

    let phPickerViewController: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.preferredAssetRepresentationMode = .current
        configuration.filter = .videos
        configuration.selectionLimit = 1
        let phPickerViewController = PHPickerViewController(configuration: configuration)
        return phPickerViewController
    }()

    // MARK: - Object LifeCycle

    override init() {
        super.init()
        phPickerViewController.delegate = self
    }

    // MARK: - Methods

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let result = results.first else {
            self.phPickerViewController.dismiss(animated: true)
            return
        }

        _ = result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
            if error != nil {
                Task {
                    await MainActor.run {
                        Toast.shared.showToast(message: "지원하지 않는 동영상 형식입니다 T.T")
                    }
                }
            }

            if let url {
                self.videoPickerDelegate?.didFinishPickingVideo(url)
            }
        }
    }

}
