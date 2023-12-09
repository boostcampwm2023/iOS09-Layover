//
//  TagPlayListViewController.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.

import UIKit

protocol TagPlayListDisplayLogic: AnyObject {
    func displayPlayList(viewModel: TagPlayListModels.FetchPosts.ViewModel)
    func displayMorePlayList(viewModel: TagPlayListModels.FetchMorePosts.ViewModel)
    func displayTitle(viewModel: TagPlayListModels.FetchTitleTag.ViewModel)
}

final class TagPlayListViewController: BaseViewController {

    // MARK: - UI Components

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 9
        layout.minimumInteritemSpacing = 9
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.bounds.width - 29) / 2, height: ((view.bounds.width - 29) / 2) * 289/173)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        collectionView.delegate = self
        collectionView.register(TagPlayListCollectionViewCell.self,
                                forCellWithReuseIdentifier: TagPlayListCollectionViewCell.identifier)
        return collectionView
    }()

    private lazy var dataSource = UICollectionViewDiffableDataSource<UUID, Models.DisplayedPost>(collectionView: collectionView) { collectionView, indexPath, displayedPost in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagPlayListCollectionViewCell.identifier,
                                                            for: indexPath) as? TagPlayListCollectionViewCell
        else { return UICollectionViewCell() }

        cell.configure(thumbnailImageData: displayedPost.thumbnailImageData,
                       title: displayedPost.title)
        return cell
    }

    // MARK: - Properties

    typealias Models = TagPlayListModels
    var interactor: TagPlayListBusinessLogic?
    var router: (TagPlayListRoutingLogic & TagPlayListDataPassing)?

    // MARK: - Intializer

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        TagPlayListConfigurator.shared.configure(self)
    }

    // MARK: - View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPlayList()
    }

    // MARK: - Layout

    override func setConstraints() {
        super.setConstraints()
        view.addSubviews(collectionView)
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    override func setUI() {
        super.setUI()
        collectionView.dataSource = dataSource
        setTitleTag()
    }

    // MARK: - Methods

    private func setNavigationBar(with title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor.primaryPurple
        configuration.title = title
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.loFont(ofSize: 13, weight: .bold)
            outgoing.foregroundColor = UIColor.layoverWhite
            return outgoing
        }

        let button = UIButton(configuration: configuration)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        navigationItem.titleView = button
    }

    private func setTitleTag() {
        interactor?.setTitleTag(request: Models.FetchTitleTag.Request())
    }

    private func fetchPlayList() {
        interactor?.fetchPlayList(request: Models.FetchPosts.Request())
    }
}

// MARK: - UICollectionViewDataSource

extension TagPlayListViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        let height = scrollView.bounds.height

        if scrollOffset > contentHeight - height {
            interactor?.fetchMorePlayList(request: Models.FetchMorePosts.Request())
        }
    }
}

// MARK: - TagPlayListDisplayLogic

extension TagPlayListViewController: TagPlayListDisplayLogic {
    func displayPlayList(viewModel: Models.FetchPosts.ViewModel) {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, Models.DisplayedPost>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems(viewModel.displayedPost)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func displayMorePlayList(viewModel: TagPlayListModels.FetchMorePosts.ViewModel) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(viewModel.displayedPost)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func displayTitle(viewModel: TagPlayListModels.FetchTitleTag.ViewModel) {
        setNavigationBar(with: viewModel.title)
    }
}

#Preview {
    let navi = UINavigationController(rootViewController: UIViewController())
    navi.pushViewController(TagPlayListViewController(), animated: false)
    return navi
}
