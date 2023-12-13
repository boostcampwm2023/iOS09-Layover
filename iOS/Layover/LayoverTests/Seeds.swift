//
//  Seeds.swift
//  LayoverTests
//
//  Created by 김인환 on 12/12/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//
@testable import Layover
import Foundation

// JSON 데이터와 비교하기 위한 모델
class Seeds {
    static let sampleImageData = try! Data(contentsOf: Bundle(for: Seeds.self).url(forResource: "sample", withExtension: "jpeg")!)

    struct Posts {
        // PostList.json에 정의된 데이터
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
                                             longitude: 37.0532156213,
                                             status: .complete
                                            ),
                                tag: ["아이브", "yujin"])

        // PostListMore.json에 정의된 데이터
        static let post2 = Post(member: Member(identifier: 2,
                                               username: "장원영",
                                               introduce: "안녕하세요, 아이브의 장원영입니다.",
                                               profileImageURL: URL(string: "https://www.fnnews.com/resource/media/image/2023/10/17/202310171126334525_l.jpg")!),
                                board: Board(identifier: 2,
                                             title: "아이브의 멤버",
                                             description: "게시글 설명설명설명",
                                             thumbnailImageURL: URL(string: "https://img.etoday.co.kr/pto_db/2022/11/600/20221108175829_1816470_1200_1800.jpg")!,
                                             videoURL: URL(string: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8")!,
                                             latitude: 100.060123123,
                                             longitude: 35.001828282,
                                             status: .complete
                                            ),
                                tag: ["Ive", "wonyoung"])
        
        static let thumbnailImageNilPost = Post(member: Member(identifier: 1,
                                        username: "안유진",
                                        introduce: "안녕하세요, 아이브의 안유진입니다.",
                                        profileImageURL: URL(string: "https://cdn.footballist.co.kr/news/photo/202307/170226_100422_1733.jpg")!),
                         board: Board(identifier: 1,
                                      title: "최강 아이돌",
                                      description: "게시글 설명",
                                      thumbnailImageURL: nil,
                                      videoURL: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")!,
                                      latitude: 127.060123123,
                                      longitude: 37.0532156213,
                                      status: .complete
                                     ),
                         tag: ["아이브", "yujin"])

        static let videoURLNilPost = Post(member: Member(identifier: 1,
                                        username: "안유진",
                                        introduce: "안녕하세요, 아이브의 안유진입니다.",
                                        profileImageURL: URL(string: "https://cdn.footballist.co.kr/news/photo/202307/170226_100422_1733.jpg")!),
                         board: Board(identifier: 1,
                                      title: "최강 아이돌",
                                      description: "게시글 설명",
                                      thumbnailImageURL: nil,
                                      videoURL: nil,
                                      latitude: 127.060123123,
                                      longitude: 37.0532156213,
                                      status: .complete
                                     ),
                         tag: ["아이브", "yujin"])

    }

    struct Members {
        static let getMember1 = Member(identifier: 221,
                                       username: "안유진",
                                       introduce: "안녕하세요, 아이브의 안유진입니다.",
                                       profileImageURL: URL(string: "https://cdn.footballist.co.kr/news/photo/202307/170226_100422_1733.jpg")!)
    }
}
