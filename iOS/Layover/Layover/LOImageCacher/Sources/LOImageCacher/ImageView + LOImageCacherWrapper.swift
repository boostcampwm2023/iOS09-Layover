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

    @MainActor
    @available(iOS 13.0, *)
    public func setImage(with url: URL) {
        Task {
            if let data = await LOImageFetcher.shared.fetchImage(from: url) {
                self.base.image = UIImage(data: data)
            }
        }
    }

}
