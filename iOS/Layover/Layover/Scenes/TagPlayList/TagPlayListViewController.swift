//
//  TagPlayListViewController.swift
//  Layover
//
//  Created by 김인환 on 11/29/23.
//  Copyright (c) 2023 CodeBomber. All rights reserved.

import UIKit

protocol TagPlayListDisplayLogic: AnyObject {
    func displayPlayList(viewModel: TagPlayListModels.FetchPosts.ViewModel)
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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionView
    }()

    // MARK: - Properties

    typealias Model = TagPlayListModels
    var interactor: TagPlayListBusinessLogic?
    var router: (TagPlayListRoutingLogic & TagPlayListDataPassing)?

    private var displayedPosts: [Model.FetchPosts.ViewModel.DisplayedPost] = []

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
        setNavigationBar()
    }

    // MARK: - Methods

    private func setNavigationBar() {
        guard let titleTag = router?.dataStore?.titleTag else { return }

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

    private func fetchPlayList() {
        guard let titleTag = router?.dataStore?.titleTag else { return }
        interactor?.fetchPlayList(request: TagPlayListModels.FetchPosts.Request(tag: titleTag))
    }
}

extension TagPlayListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedPosts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagPlayListCollectionViewCell.identifier,
                                                            for: indexPath) as? TagPlayListCollectionViewCell
        else { return UICollectionViewCell() }

        let data = displayedPosts[indexPath.item]
        guard let imageData = data.thumbnailImage,
              let image = UIImage(data: imageData)
        else { return UICollectionViewCell() }

        cell.configure(thumbnailImage: image, title: data.title)
        return cell
    }
}

// MARK: - TagPlayListDisplayLogic

extension TagPlayListViewController: TagPlayListDisplayLogic {
    func displayPlayList(viewModel: TagPlayListModels.FetchPosts.ViewModel) {
        displayedPosts = viewModel.displayedPost
        collectionView.reloadData()
    }
}

#Preview {
    let navi = UINavigationController(rootViewController: UIViewController())
    navi.pushViewController(TagPlayListViewController(), animated: false)
    return navi
}
