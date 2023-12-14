//
//  HLSResourceLoader.swift
//  Layover
//
//  Created by 김인환 on 12/14/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation
import OSLog

protocol ResourceLoader {
    func loadResource(from url: URL) async -> Data?
}

// 앞부분부터 원하는 duration만큼 잘라서 load시켜주는 Resource Loader
final class HLSSliceResourceLoader: ResourceLoader {

    enum M3U8Tag: String {
        case extm3u = "#EXTM3U" // m3u8 파일의 시작
        case extend = "#EXT-X-ENDLIST" // 마지막 태그
        case extinf = "#EXTINF:" // 재생시간 -> 미디어 m3u8 파일에 포함
        case extxstreaminf = "#EXT-X-STREAM-INF" // 마스터 m3u8 파일
    }

    // MARK: - Properties

    private let session: URLSession

    // MARK: - Initializer

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    // MARK: - ResourceLoader

    func loadResource(from url: URL) async -> Data? {
        let urlRequest = URLRequest(url: url.originHLS_URL) // 원래 url scheme 으로 변경

        guard let (data, response) = try? await session.data(for: urlRequest),
              let httpResponse = response as? HTTPURLResponse,
              (200...399) ~= httpResponse.statusCode else {
            os_log(.error, log: .data, "Failed to load resource from %{public}@", url.absoluteString)
            return nil
        }

        guard let m3u8Playlist = String(data: data, encoding: .utf8) else {
            os_log(.error, log: .data, "Failed to decode data to String")
            return nil
        }

        guard isMediaM3U8(m3u8Playlist) else { return data }
        return sliceM3U8Playlist(m3u8Playlist, duration: 4).data(using: .utf8) ?? data // 3초보다는 약간 여유있게 잡는다.
    }

    // MARK: - Methods

    private func isMediaM3U8(_ m3u8Playlist: String) -> Bool {
        m3u8Playlist.contains(M3U8Tag.extinf.rawValue)
    }

    // m3u8 미디어 플레이리스트를 받아서 duration만큼 잘라서 반환
    private func sliceM3U8Playlist(_ m3u8Playlist: String, duration: TimeInterval) -> String {
        var duration = duration
        var playlist = m3u8Playlist.components(separatedBy: M3U8Tag.extinf.rawValue)
            .compactMap {
                if $0.contains(M3U8Tag.extm3u.rawValue) { return $0 } // 시작부분
                else if let tsDuration = $0.components(separatedBy: ",").compactMap({ Double($0) }).first,
                        duration > .zero {
                    duration -= tsDuration
                    return $0
                } else {
                    return nil
                }
            }.joined(separator: M3U8Tag.extinf.rawValue)

        if !playlist.contains(M3U8Tag.extend.rawValue) {
            playlist.append("\n\(M3U8Tag.extend.rawValue)")
        }

        return playlist
    }
}
