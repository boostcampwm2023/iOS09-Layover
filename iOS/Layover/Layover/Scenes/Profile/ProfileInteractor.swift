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
    func fetchProfile() -> Task<Bool, Never>

    @discardableResult
    func fetchMorePosts() -> Task<Bool, Never>
}

protocol ProfileDataStore {
    var nickname: String? { get set }
    var introduce: String? { get set }
    var profileImageData: Data? { get set }

    var profileId: Int? { get set }
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

    // MARK: - Methods

    @discardableResult
    func fetchProfile() -> Task<Bool, Never> {
        Task {
            guard let userProfile = await userWorker?.fetchProfile(by: profileId) else {
                return false
            }

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
    func fetchMorePosts() -> Task<Bool, Never> {
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
        guard let posts = await userWorker?.fetchPosts(at: fetchPostsPage, of: profileId),
              posts.count > 0 else {
            return []
        }

        var responsePosts = [Models.Post]()
        for post in posts {
            guard let thumbnailURL = post.board.thumbnailImageURL,
                  let profileImageData = await userWorker?.fetchImageData(with: thumbnailURL) else {
                responsePosts.append(.init(id: post.board.identifier, thumbnailImageData: nil))
                continue
            }

            responsePosts.append(Models.Post(id: post.board.identifier, thumbnailImageData: profileImageData))
        }

        return responsePosts
    }

}
