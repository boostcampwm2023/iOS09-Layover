//
//  SettingSceneViewController.swift
//  Layover
//
//  Created by 황지웅 on 11/30/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol SettingSceneDisplayLogic: AnyObject {
}

final class SettingSceneViewController: BaseViewController {

    // MARK: - Properties

    typealias Models = SettingSceneModels
    var router: (NSObjectProtocol & SettingSceneRoutingLogic & SettingSceneDataPassing)?
    var interactor: SettingSceneBusinessLogic?

    private let settingSceneTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let policy: [String] = ["이용약관", "개인정보 처리 방침", "위치정보 이용 약관"]
    let versionInfo: [String] = ["버전정보"]
    let userInfo: [String] = ["로그아웃", "탈퇴"]
    // MARK: - Object lifecycle

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
        let viewController = self
        let interactor = SettingSceneInteractor()
        let presenter = SettingScenePresenter()
        let router = SettingSceneRouter()

        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        settingSceneTableView.delegate = self
        settingSceneTableView.dataSource = self
        settingSceneTableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
    }

    override func setConstraints() {
        super.setConstraints()
        view.addSubview(settingSceneTableView)
        NSLayoutConstraint.activate([
            settingSceneTableView.topAnchor.constraint(equalTo: view.topAnchor),
            settingSceneTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingSceneTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingSceneTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func setUI() {
        super.setUI()
        setNavigationBar()
    }

    private func setNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .layoverWhite
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.title = "설정"
    }

    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingSceneViewController: SettingSceneDisplayLogic {

}

extension SettingSceneViewController: UITableViewDelegate {

}

extension SettingSceneViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "약관 및 정책"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        switch indexPath.section {
        case 0:
            content.text = policy[indexPath.row]
            cell.contentConfiguration = content
        case 1:
            content.text = versionInfo[indexPath.row]
            content.secondaryText = "1.0.0"
            content.prefersSideBySideTextAndSecondaryText = true
            cell.contentConfiguration = content
        case 2:
            content.text = userInfo[indexPath.row]
            cell.contentConfiguration = content
        default:
            break
        }
        return cell
    }
}

#Preview {
    let navi = UINavigationController(rootViewController: UIViewController())
    navi.pushViewController(SettingSceneViewController(), animated: false)
    return navi
}
