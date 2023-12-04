//
//  ProfileInteractor.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ProfileBusinessLogic {
    func fetchProfile()
}

protocol ProfileDataStore {
    var nickname: String? { get set }
    var introduce: String? { get set }
    var profileImage: UIImage? { get set }
}

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {

    var nickname: String?
    var introduce: String?
    var profileImage: UIImage?

    // MARK: - Properties

    typealias Models = ProfileModels

    var presenter: ProfilePresentationLogic?
    var userWorker: UserWorker?

    func fetchProfile() {
        nickname = "kong"
        introduce = "콩이라고해"
        let response = ProfileModels.FetchProfile.Response(nickname: "kong",
                                                           introduce: "콩이라고해",
                                                           profileImageURL: nil)
        presenter?.present(with: response)
    }

}
