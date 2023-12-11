//
//  Seeds.swift
//  LayoverTests
//
//  Created by 김인환 on 12/12/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//
@testable import Layover
import Foundation

class Seeds {
    static let sampleImageData = try! Data(contentsOf: Bundle(for: Seeds.self).url(forResource: "sample", withExtension: "jpeg")!)

    struct Posts {
        static let post1 = Post(member: Member(identifier: 1,
                                        username: "안유진",
                                        introduce: "안녕하세요, 아이브의 안유진입니다.",
                                        profileImageURL: URL(string: "https://cdn.footballist.co.kr/news/photo/202307/170226_100422_1733.jpg")!),
                         board: Board(identifier: 1,
                                      title: "최강 아이돌",
                                      description: "게시글 설명",
                                      thumbnailImageURL: URL(string: "https://think-note.com/wp-content/uploads/2023/07/eta_3.jpg")!,
                                      videoURL: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")!,
                                      latitude: 127.060123123,
                                      longitude: 37.0532156213),
                         tag: ["아이브", "yujin"])
    }
}
