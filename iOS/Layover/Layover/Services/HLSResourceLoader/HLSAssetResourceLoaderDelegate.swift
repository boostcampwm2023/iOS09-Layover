//
//  HLSAssetResourceLoaderDelegate.swift
//  Layover
//
//  Created by 김인환 on 12/14/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import AVFoundation

class HLSAssetResourceLoaderDelegate: NSObject, AVAssetResourceLoaderDelegate {

    // MARK: - Properties

    let resourceLoader: ResourceLoader

    // MARK: - Initializer

    init(resourceLoader: ResourceLoader) {
        self.resourceLoader = resourceLoader
    }

    // MARK: - Delegate Methods

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader,
                        shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        loadRequestedResource(loadingRequest)
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader,
                        shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool {
        loadRequestedResource(renewalRequest)
    }

    // MARK: - Methods

    // 공통으로 처리
    func loadRequestedResource(_ loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard let url = loadingRequest.request.url?.originHLS_URL else { return false }

        if url.pathExtension.contains("ts") { // ts 파일은 리디렉션 시킨다.
            loadingRequest.redirect = URLRequest(url: url)
            loadingRequest.response = HTTPURLResponse(url: url,
                                                      statusCode: 302,
                                                      httpVersion: nil,
                                                      headerFields: nil)
            loadingRequest.finishLoading()
        } else {
            Task {
                guard let data = await resourceLoader.loadResource(from: url) else {
                    loadingRequest.finishLoading(with: NSError(domain: "Failed to load resource from \(url.absoluteString)",
                                                              code: 0,
                                                              userInfo: nil))
                    return
                }

                loadingRequest.dataRequest?.respond(with: data)
                loadingRequest.finishLoading()
            }
        }

        return true
    }
}
