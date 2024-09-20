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
    func fetchProfile(with request: ProfileModels.FetchProfile.Request) async -> Bool
    @discardableResult
    func fetchMorePosts(with request: ProfileModels.FetchMorePosts.Request) async -> Bool
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

    private var postsPageCursor: Int?
    private var canFetchMorePosts = true
    private var isMyProfile: Bool {
        profileId == nil
    }

    // MARK: - DataStore

    var nickname: String?
    var introduce: String?
    var profileImageData: Data?
    var profileId: Int?

    var playbackStartIndex: Int?
    var posts: [Post] = []

    // MARK: - Methods

    @discardableResult
    func fetchProfile(with request: ProfileModels.FetchProfile.Request) async -> Bool {
        canFetchMorePosts = true
        posts = []
        guard let userProfile = await userWorker?.fetchProfile(by: profileId) else {
            return false
        }
        nickname = userProfile.username
        introduce = userProfile.introduce

        let posts = await fetchPosts()
        canFetchMorePosts = !posts.isEmpty

        let response = Models.FetchProfile.Response(userProfile: ProfileModels.Profile(username: userProfile.username,
                                                                                       introduce: userProfile.introduce,
                                                                                       profileImageURL: userProfile.profileImageURL),
                                                    displayedPosts: posts)
        await MainActor.run {
            presenter?.presentProfile(with: response)
        }
        return true
    }

    @discardableResult
    func fetchMorePosts(with request: ProfileModels.FetchMorePosts.Request) async -> Bool {
        guard canFetchMorePosts else { return false }
        let fetchedPosts = await fetchPosts(at: postsPageCursor)
        if fetchedPosts.isEmpty {
            canFetchMorePosts = false
            return false
        }
        let response = Models.FetchMorePosts.Response(displayedPosts: fetchedPosts)

        await MainActor.run {
            presenter?.presentMorePosts(with: response)
        }
        return true
    }

    private func fetchPosts(at cursor: Int? = nil) async -> [Models.DisplayedPost] {
        guard let fetchedPostsPage = await userWorker?.fetchPosts(at: cursor, of: profileId),
              fetchedPostsPage.posts.count > 0 else {
            return []
        }
        let fetchedPosts = fetchedPostsPage.posts
        posts += fetchedPosts
        postsPageCursor = fetchedPostsPage.cursor

        return fetchedPosts.map { post in
            Models.DisplayedPost(id: post.board.identifier,
                                 thumbnailImageData: post.board.thumbnailImageURL,
                                 status: post.board.status)
        }
    }

    func showPostDetail(with request: ProfileModels.ShowPostDetail.Request) {
        playbackStartIndex = request.startIndex
        presenter?.presentPostDetail(with: Models.ShowPostDetail.Response())
    }
}
