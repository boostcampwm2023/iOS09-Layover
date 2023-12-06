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

    // MARK: - Properties

    typealias Models = SettingModels
    var router: (SettingRoutingLogic & SettingDataPassing)?
    var interactor: SettingBusinessLogic?

    private var tableViewSections = [Models.ConfigureTableView.ViewModel.TableSection]()

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
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func setUI() {
        super.setUI()
        self.title = "설정"
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

}


// MARK: - SettingDisplayLogic

extension SettingViewController: SettingDisplayLogic {
    func displayTableView(viewModel: SettingModels.ConfigureTableView.ViewModel) {
        tableViewSections = viewModel.tableViewSections
        tableView.reloadData()
    }
}

#Preview {
    let navi = UINavigationController(rootViewController: UIViewController())
    navi.pushViewController(SettingViewController(), animated: false)
    return navi
}
