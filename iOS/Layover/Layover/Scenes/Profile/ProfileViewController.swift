//
//  ProfileViewController.swift
//  Layover
//
//  Created by kong on 2023/11/21.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol ProfileDisplayLogic: AnyObject {

}

final class ProfileViewController: BaseViewController, ProfileDisplayLogic {

    // MARK: - UI Components

    private lazy var thumbnailCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(ThumbnailCollectionViewCell.self,
                                forCellWithReuseIdentifier: ThumbnailCollectionViewCell.identifier)
        collectionView.register(ProfileHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ProfileHeaderView.identifier)
        return collectionView
    }()

    private lazy var videoDatasource = UICollectionViewDiffableDataSource<UUID, Int>(collectionView: thumbnailCollectionView) { collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.identifier,
                                                            for: indexPath) as? ThumbnailCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }

    // MARK: - Properties

    typealias Models = ProfileModels
    var router: (NSObjectProtocol & ProfileRoutingLogic & ProfileDataPassing)?
    var interactor: ProfileBusinessLogic?

    // MARK: - Object Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
        ProfileConfigurator.shared.configure(self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        ProfileConfigurator.shared.configure(self)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setVideoCollectionView()
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth((1/3) * (178/117)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(198))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func setVideoCollectionView() {
        thumbnailCollectionView.dataSource = videoDatasource
        var snapshot = NSDiffableDataSourceSnapshot<UUID, Int>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        videoDatasource.apply(snapshot)
        videoDatasource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderView.identifier, for: indexPath) as? ProfileHeaderView
            return header
        }
    }

}

#Preview {
    ProfileViewController()
}
