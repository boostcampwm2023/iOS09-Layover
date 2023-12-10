//
//  PlaybackRouter.swift
//  Layover
//
//  Created by 황지웅 on 11/17/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import Foundation

protocol PlaybackRoutingLogic {
    func routeToBack()
    func routeToReport()
    func routeToProfile()
    func routeToTagPlay()
}

protocol PlaybackDataPassing {
    var dataStore: PlaybackDataStore? { get }
}

final class PlaybackRouter: NSObject, PlaybackRoutingLogic, PlaybackDataPassing {

    // MARK: - Properties

    weak var viewController: PlaybackViewController?
    var dataStore: PlaybackDataStore?

    // MARK: - Routing

    func routeToBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func routeToReport() {
        let reportViewController: ReportViewController = ReportViewController()
        guard let source = dataStore,
              var destination = reportViewController.router?.dataStore
        else { return }
        destination.boardID = source.previousCell?.boardID
        reportViewController.modalPresentationStyle = .fullScreen
        viewController?.present(reportViewController, animated: false)
    }

    func routeToProfile() {
        let profileViewController: ProfileViewController = ProfileViewController(profileType: .other)
        guard let source = dataStore,
              var destination = profileViewController.router?.dataStore
        else { return }
        passDataToProfile(source: source, destination: &destination)
        viewController?.navigationController?.pushViewController(profileViewController, animated: true)
    }

    func routeToTagPlay() {
        let tagPlayListViewController: TagPlayListViewController = TagPlayListViewController()
        guard let source = dataStore,
              var destination = tagPlayListViewController.router?.dataStore
        else { return }
        passDataToTagPlay(source: source, destination: &destination)
        viewController?.navigationController?.pushViewController(tagPlayListViewController, animated: true)
    }

    // MARK: - Data Passing

    private func passDataToProfile(source: PlaybackDataStore, destination: inout ProfileDataStore) {
        destination.profileId = source.memberID
    }

    private func passDataToTagPlay(source: PlaybackDataStore, destination: inout TagPlayListDataStore) {
        destination.titleTag = source.selectedTag
    }
}
