//
//  ProfileInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol ProfileBusinessLogic {
    @discardableResult
    func fetchProfile(with request: ProfileModels.FetchProfile.Request) -> Task<Bool, Never>

    @discardableResult
    func fetchMorePosts(with request: ProfileModels.FetchMorePosts.Request) -> Task<Bool, Never>

    func showPostDetail(with request: ProfileModels.ShowPostDetail.Request)
}

protocol ProfileDataStore {
    var nickname: String? { get set }
    var introduce: String? { get set }
    var profileImageData: Data? { get set }

    var profileId: Int? { get set }

    var playbackStartIndex: Int? { get set }
    var posts: [Post] { get set }
}

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {

    // MARK: - Properties

    typealias Models = ProfileModels
    var presenter: ProfilePresentationLogic?
    var userWorker: UserWorkerProtocol?

    private var fetchPostsPage = 1
    private var canFetchMorePosts = true

    // MARK: - DataStore

    var nickname: String?
    var introduce: String?
    var profileImageData: Data?
    var profileId: Int?

    var playbackStartIndex: Int?
    var posts: [Post] = []

    // MARK: - Methods

    @discardableResult
    func fetchProfile(with request: ProfileModels.FetchProfile.Request) -> Task<Bool, Never> {
        fetchPostsPage = 1
        canFetchMorePosts = true
        return Task {
            guard let userProfile = await userWorker?.fetchProfile(by: profileId) else {
                return false
            }
            posts = []
            nickname = userProfile.username
            introduce = userProfile.introduce

            let posts = await fetchPosts()
            canFetchMorePosts = !posts.isEmpty
            fetchPostsPage += 1

            var imageData: Data? = nil
            if let profileImageURL = userProfile.profileImageURL {
                imageData = await userWorker?.fetchImageData(with: profileImageURL)
            }
            profileImageData = imageData
            let response = Models.FetchProfile.Response(userProfile: ProfileModels.Profile(username: userProfile.username,
                                                                                           introduce: userProfile.introduce,
                                                                                           profileImageData: imageData),
                                                        posts: posts)
            await MainActor.run {
                presenter?.presentProfile(with: response)
            }
            return true
        }
    }

    @discardableResult
    func fetchMorePosts(with request: ProfileModels.FetchMorePosts.Request) -> Task<Bool, Never> {
        Task {
            guard canFetchMorePosts else { return false }
            let fetchedPosts = await fetchPosts()
            fetchPostsPage += 1

            if fetchedPosts.isEmpty {
                canFetchMorePosts = false
                return false
            }

            let response = Models.FetchMorePosts.Response(posts: fetchedPosts)

            await MainActor.run {
                presenter?.presentMorePosts(with: response)
            }

            return true
        }
    }

    private func fetchPosts() async -> [Models.Post] {
        guard let fetchedPosts = await userWorker?.fetchPosts(at: fetchPostsPage, of: profileId),
              fetchedPosts.count > 0 else {
            return []
        }
        posts += fetchedPosts

        var responsePosts = [Models.Post]()
        for post in fetchedPosts {
            guard let thumbnailURL = post.board.thumbnailImageURL,
                  let profileImageData = await userWorker?.fetchImageData(with: thumbnailURL) else {
                responsePosts.append(.init(id: post.board.identifier, thumbnailImageData: nil))
                continue
            }

            responsePosts.append(Models.Post(id: post.board.identifier, thumbnailImageData: profileImageData))
        }

        return responsePosts
    }

    func showPostDetail(with request: ProfileModels.ShowPostDetail.Request) {
        playbackStartIndex = request.startIndex
        presenter?.presentPostDetail(with: Models.ShowPostDetail.Response())
    }

}
