//
//  ImageView + LOImageCacherWrapper.swift
//
//
//  Created by kong on 2024/01/17.
//

import UIKit

// MARK: - Extensions

extension UIImageView: LOImageCacherCompatible { }

extension LOImageCacherWrapper where Base: UIImageView {

    public func setImage(with url: URL) {
        Task {
            if let data = await LOImageFetcher.shared.fetchImage(from: url) {
                await updateImage(data)
            }
        }
    }

    @MainActor
    private func updateImage(_ data: Data) {
        self.base.image = UIImage(data: data)
    }

}
