//
//  ProfileInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ProfileBusinessLogic {
    @discardableResult
    func fetchProfile() -> Task<Bool, Never>

    @discardableResult
    func fetchMorePosts() -> Task<Bool, Never>
}

protocol ProfileDataStore {
    var nickname: String? { get set }
    var introduce: String? { get set }
    var profileImage: UIImage? { get set }

    var profileId: Int? { get set }
}

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {

    // MARK: - Properties

    typealias Models = ProfileModels
    var presenter: ProfilePresentationLogic?
    var profileWorker: ProfileWorker?

    private var fetchPostsPage = 1
    private var canFetchMorePosts = true

    // MARK: - DataStore

    var nickname: String?
    var introduce: String?
    var profileImage: UIImage?
    var profileId: Int?

    // MARK: - Methods

    @discardableResult
    func fetchProfile() -> Task<Bool, Never> {
        Task {
            guard let userProfile = await profileWorker?.fetchProfile(by: profileId) else {
                return false
            }

            let posts = await fetchPosts()
            canFetchMorePosts = !posts.isEmpty
            fetchPostsPage += 1

            var profileImageData: Data? = nil
            if let profileImageURL = userProfile.profileImageURL {
                profileImageData = await profileWorker?.fetchImageData(with: profileImageURL)
            }
            let response = Models.FetchProfile.Response(userProfile: ProfileModels.Profile(username: userProfile.username,
                                                                                           introduce: userProfile.introduce,
                                                                                           profileImageData: profileImageData),
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
        guard let posts = await profileWorker?.fetchPosts(at: fetchPostsPage, of: profileId),
              posts.count > 0 else {
            return []
        }

        var responsePosts = [Models.Post]()
        for post in posts {
            guard let thumbnailURL = post.board.thumbnailImageURL,
                  let profileImageData = await profileWorker?.fetchImageData(with: thumbnailURL) else {
                responsePosts.append(.init(thumbnailImageData: nil))
                continue
            }

            responsePosts.append(Models.Post(thumbnailImageData: profileImageData))
        }

        return responsePosts
    }

}
