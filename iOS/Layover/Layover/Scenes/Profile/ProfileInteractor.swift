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

    private let provider: ProviderType

    init(provider: ProviderType = Provider()) {
        self.provider = provider
    }

    // MARK: - Properties

    typealias Models = ProfileModels

    var presenter: ProfilePresentationLogic?

    func fetchProfile() {
        if let data = try? Data(contentsOf: URL(string: "https://i.ibb.co/qML8vdN/2023-11-25-9-08-01.png")!) {
            profileImage = UIImage(data: data)
        }
        nickname = "kong"
        introduce = "콩이라고해"
        let response = ProfileModels.FetchProfile.Response(nickname: nickname,
                                                           introduce: introduce,
                                                           profileImage: profileImage)
        presenter?.present(with: response)
    }

}
