//
//  ProfileViewController.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ProfileDisplayLogic: AnyObject {
    func fetchProfile(viewModel: ProfileModels.FetchProfile.ViewModel)
}

final class ProfileViewController: BaseViewController {

    // MARK: - Type

    enum ProfileType {
        case own
        case other
    }

    // MARK: - CollectionView Section

    enum Section: Int {
        case profileInfo
        case thumnail
    }

    // MARK: - UI Components

    private lazy var thumbnailCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(ProfileCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        collectionView.register(ThumbnailCollectionViewCell.self,
                                forCellWithReuseIdentifier: ThumbnailCollectionViewCell.identifier)
        return collectionView
    }()

    private var videoDatasource: UICollectionViewDiffableDataSource<Section, AnyHashable>?

    // MARK: - Properties

    typealias Models = ProfileModels
    var router: (NSObjectProtocol & ProfileRoutingLogic & ProfileDataPassing)?
    var interactor: ProfileBusinessLogic?
    private let profileType: ProfileType

    // MARK: - Object Lifecycle

    init(profileType: ProfileType) {
        self.profileType = profileType
        super.init(nibName: nil, bundle: nil)
        ProfileConfigurator.shared.configure(self)
    }

    required init?(coder: NSCoder) {
        self.profileType = .other
        super.init(coder: coder)
        ProfileConfigurator.shared.configure(self)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setDataSource()
        interactor?.fetchProfile()
    }

    override func setConstraints() {
        view.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            thumbnailCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            thumbnailCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            thumbnailCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Methods

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            guard let section: Section = Section(rawValue: section) else { return nil }
            switch section {
            case .profileInfo:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .estimated(196))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(196))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section

            case .thumnail:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalWidth((1/3) * (178/117)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
        return layout
    }

    private func setNavigationBar() {
        switch profileType {
        case .own:
            let barButtonItem: UIBarButtonItem = UIBarButtonItem(title: nil,
                                                                 image: UIImage(resource: .setting),
                                                                 target: self,
                                                                 action: #selector(settingButtonDidTap))
            barButtonItem.tintColor = .layoverWhite
            self.navigationItem.rightBarButtonItem = barButtonItem
        case .other:
            return
        }
    }

    private func setDataSource() {
        let profileCellRegistration = UICollectionView.CellRegistration<ProfileCollectionViewCell, Models.Member> { cell, _, itemIdentifier in
            let item = itemIdentifier as Models.Member
            cell.configure(profileImage: nil,
                           nickname: item.username,
                           introduce: item.introduce)
            cell.editButton.addTarget(self, action: #selector(self.editbuttonDidTap), for: .touchUpInside)
        }

        let thumnailCellRegistration = UICollectionView.CellRegistration<ThumbnailCollectionViewCell, Int> { _, _, itemIdentifier in
            let item = itemIdentifier as Int
            // TODO: Board Reponse 확정시 configure
        }

        videoDatasource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: thumbnailCollectionView) { collectionView, indexPath, itemIdentifier in
            let section: Section = Section(rawValue: indexPath.section)!
            switch section {
            case .profileInfo:
                return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier as? Models.Member)
            case .thumnail:
                return collectionView.dequeueConfiguredReusableCell(using: thumnailCellRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier as? Int)
            }
        }
    }

    @objc private func editbuttonDidTap() {
        router?.routeToEditProfileViewController()
    }

    @objc private func settingButtonDidTap() {
        router?.routeToSettingSceneViewController()
    }

}

extension ProfileViewController: ProfileDisplayLogic {

    func fetchProfile(viewModel: ProfileModels.FetchProfile.ViewModel) {
        thumbnailCollectionView.dataSource = videoDatasource
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.profileInfo, .thumnail])
        snapshot.appendItems([Models.Member(identifier: 0,
                                     username: viewModel.nickname,
                                     introduce: viewModel.introduce,
                                     profileImageURL: viewModel.profileImageURL)],
                             toSection: .profileInfo)
        snapshot.appendItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], toSection: .thumnail)
        videoDatasource?.apply(snapshot)
    }

}
