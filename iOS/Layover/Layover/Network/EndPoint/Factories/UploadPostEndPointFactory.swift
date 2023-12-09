//
//  UploadPostEndPointFactory.swift
//  Layover
//
//  Created by kong on 2023/12/05.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol UploadPostEndPointFactory {
    func makeUploadPostEndPoint(title: String,
                                content: String?,
                                latitude: Double,
                                longitude: Double,
                                tag: [String]) -> EndPoint<Response<UploadPostDTO>>
    func makeUploadVideoEndPoint(boardID: Int, fileType: String) -> EndPoint<Response<PresignedURLDTO>>
}

final class DefaultUploadPostEndPointFactory: UploadPostEndPointFactory {

    func makeUploadPostEndPoint(title: String,
                                content: String?,
                                latitude: Double,
                                longitude: Double,
                                tag: [String]) -> EndPoint<Response<UploadPostDTO>> {
        return EndPoint(path: "/board",
                        method: .POST,
                        bodyParameters: UploadPostRequestDTO(title: title,
                                                             content: content,
                                                             latitude: latitude,
                                                             longitude: longitude,
                                                             tag: tag))
    }

    func makeUploadVideoEndPoint(boardID: Int, fileType: String) -> EndPoint<Response<PresignedURLDTO>> {
        return EndPoint(path: "/board/presigned-url",
                        method: .POST,
                        bodyParameters: UploadVideoRequestDTO(boardID: boardID,
                                                              filetype: fileType))
    }
}
