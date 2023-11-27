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
    var profileImageURL: URL? { get set }
    var introduce: String? { get set }
}

final class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore {

    var nickname: String?
    var profileImageURL: URL?
    var introduce: String?

    // MARK: - Properties

    typealias Models = ProfileModels

    var presenter: ProfilePresentationLogic?

    func fetchProfile() {
        nickname = "kong"
        profileImageURL = URL(string: "https://i.ibb.co/qML8vdN/2023-11-25-9-08-01.png")
        introduce = "콩이라고해"
        let response = ProfileModels.FetchProfile.Response(nickname: nickname, 
                                                           introduce: introduce,
                                                           profileImageURL: profileImageURL)
        presenter?.present(with: response)
    }

}
