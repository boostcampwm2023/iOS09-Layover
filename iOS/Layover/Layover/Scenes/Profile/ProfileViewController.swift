//
//  ProfileViewController.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ProfileDisplayLogic: AnyObject {
    func displayProfile(viewModel: ProfileModels.FetchProfile.ViewModel)
    func displayMorePosts(viewModel: ProfileModels.FetchMorePosts.ViewModel)
}

final class ProfileViewController: BaseViewController {

    // MARK: - Type

    enum ProfileType {
        case own
        case other
    }

    // MARK: - CollectionView Section

    enum Section: Int {
        case profile
        case posts
    }

    // MARK: - UI Components

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(ProfileCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        collectionView.register(ThumbnailCollectionViewCell.self,
                                forCellWithReuseIdentifier: ThumbnailCollectionViewCell.identifier)
        collectionView.delegate = self
        return collectionView
    }()

    private var collectionViewDatasource: UICollectionViewDiffableDataSource<Section, AnyHashable>?

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
        fetchProfile()
    }

    override func setConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Methods

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            guard let section: Section = Section(rawValue: section) else { return nil }
            switch section {
            case .profile:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .estimated(196))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(196))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section

            case .posts:
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
        let profileCellRegistration = UICollectionView.CellRegistration<ProfileCollectionViewCell, Models.Profile> { [weak self] cell, _, itemIdentifier in
            guard let self else { return }

            var profileImage = UIImage.profile
            if let profileImageData = itemIdentifier.profileImageData,
               let image = UIImage(data: profileImageData) {
                profileImage = image
            }

            cell.configure(profileImage: profileImage,
                           nickname: itemIdentifier.username,
                           introduce: itemIdentifier.introduce)
            cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
            cell.editButton.addTarget(self, action: #selector(self.editbuttonDidTap), for: .touchUpInside)
        }

        let postCellRegistration = UICollectionView.CellRegistration<ThumbnailCollectionViewCell, Models.Post> { cell, indexPath, itemIdentifier in

            if let imageData = itemIdentifier.thumbnailImageData,
               let image = UIImage(data: imageData) {
                cell.configure(image: image)
            }
        }

        collectionViewDatasource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in

            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .profile:
                return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier as? Models.Profile)
            case .posts:
                return collectionView.dequeueConfiguredReusableCell(using: postCellRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier as? Models.Post)
            }
        }
        collectionView.dataSource = collectionViewDatasource
    }

    // MARK: - Use Case

    private func fetchProfile() {
        interactor?.fetchProfile()
    }

    private func fetchPosts() {
        interactor?.fetchMorePosts()
    }

    // MARK: - Actions

    @objc private func editbuttonDidTap() {
        router?.routeToEditProfileViewController()
    }

    @objc private func settingButtonDidTap() {
        router?.routeToSettingSceneViewController()
    }

}

// MARK: - ProfileDisplayLogic

extension ProfileViewController: ProfileDisplayLogic {

    func displayProfile(viewModel: ProfileModels.FetchProfile.ViewModel) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.profile, .posts])
        snapshot.appendItems([viewModel.userProfile], toSection: .profile)
        snapshot.appendItems(viewModel.posts, toSection: .posts)
        collectionViewDatasource?.apply(snapshot)
    }

    func displayMorePosts(viewModel: ProfileModels.FetchMorePosts.ViewModel) {
        guard var snapshot = collectionViewDatasource?.snapshot(for: .posts) else { return }
        snapshot.append(viewModel.posts)
        collectionViewDatasource?.apply(snapshot, to: .posts)
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        let height = scrollView.bounds.height

        if scrollOffset > contentHeight - height {
            fetchPosts()
        }
    }
}
