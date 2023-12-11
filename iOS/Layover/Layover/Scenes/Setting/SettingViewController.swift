//
//  SettingSceneViewController.swift
//  Layover
//
//  Created by 황지웅 on 11/30/23.
//  Copyright © 2023 CodeBomber. All rights reserved.
//

import UIKit

protocol SettingDisplayLogic: AnyObject {
    func displayTableView(viewModel: SettingModels.ConfigureTableView.ViewModel)
    func displayUserLogoutConfirmed(viewModel: SettingModels.Logout.ViewModel)
    func displayUserWithdrawConfirmed(viewModel: SettingModels.Withdraw.ViewModel)
}

final class SettingViewController: BaseViewController {

    // MARK: - UI Components

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        return tableView
    }()

    private lazy var logoutAlertController: UIAlertController = {
        let alertController = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { [weak self] _ in
            self?.interactor?.performUserLogout(request: Models.Logout.Request())
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        return alertController
    }()

    private lazy var withdrawAlertController: UIAlertController = {
        let alertController = UIAlertController(title: "회원탈퇴", message: "7일내로 재로그인시 계정이 복구됩니다.\n정말 탈퇴하시겠어요?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "탈퇴", style: .destructive, handler: { [weak self] _ in
            self?.interactor?.performUserWithdraw(request: Models.Withdraw.Request())
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        return alertController
    }()

    // MARK: - Properties

    typealias Models = SettingModels
    var router: (SettingRoutingLogic & SettingDataPassing)?
    var interactor: SettingBusinessLogic?

    private var tableViewSections = [Models.TableSection]()

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
        SettingConfigurator.shared.configure(self)
    }

    // MARK: - UI Layout

    override func setConstraints() {
        super.setConstraints()
        view.addSubview(tableView)
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    override func setUI() {
        super.setUI()
        title = "설정"
        setNavigationBar()
        interactor?.performTableViewConfigure(request: Models.ConfigureTableView.Request())
    }

    // MARK: - View Life Cycle

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreNavigationBar()
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func restoreNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        tableViewSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)

        let primaryText = tableViewSections[indexPath.section].items[indexPath.row].title.rawValue
        let secondaryText = tableViewSections[indexPath.section].items[indexPath.row].secondaryText ?? ""
        
        var contentConfiguration = UIListContentConfiguration.valueCell()
        contentConfiguration.text = primaryText
        contentConfiguration.secondaryText = secondaryText
        cell.contentConfiguration = contentConfiguration
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableViewSections[section].sectionTitle.rawValue
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSection = tableViewSections[indexPath.section]
        let selectedItem = selectedSection.items[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)

        switch selectedSection.sectionTitle {
        case .policy:
            guard let policyURL = selectedItem.title.policyURL else { return }
            router?.showSafariViewController(url: policyURL)
        case .signOut:
            switch selectedItem.title {
            case .signOut:
                showDetailViewController(logoutAlertController, sender: nil)
            case .withdraw:
                showDetailViewController(withdrawAlertController, sender: nil)
            default:
                break
            }
        default:
            break
        }
    }
}


// MARK: - SettingDisplayLogic

extension SettingViewController: SettingDisplayLogic {
    func displayTableView(viewModel: Models.ConfigureTableView.ViewModel) {
        tableViewSections = viewModel.tableViewSections
        tableView.reloadData()
    }

    func displayUserLogoutConfirmed(viewModel: Models.Logout.ViewModel) {
        Toast.shared.showToast(message: "로그아웃 되었습니다.")
        router?.routeToLogin()
    }

    func displayUserWithdrawConfirmed(viewModel: Models.Withdraw.ViewModel) {
        Toast.shared.showToast(message: "회원탈퇴 되었습니다.")
        router?.routeToLogin()
    }
}

#Preview {
    let navi = UINavigationController(rootViewController: UIViewController())
    navi.pushViewController(SettingViewController(), animated: false)
    return navi
}
