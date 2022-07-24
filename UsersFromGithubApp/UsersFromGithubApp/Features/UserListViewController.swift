//
//  UserListViewController.swift
//  UsersFromGithubApp
//
//  Created by Camila Luísa Farias on 24/07/22.
//

import UIKit

class UserListViewController: UIViewController {
    
    enum TableSection: Int {
        case userList
        case loader
    }
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 64
        
        return tableView
    }()
    
    private var users = [User]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var viewModel: UserListViewModelProtocol
    
    init(viewModel: UserListViewModelProtocol = UserListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        viewModel.delegate = self
        viewModel.loadItems()
    }
    
    private func setupView() {
        title = "Github Users"
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listSection = TableSection(rawValue: section) else { return 0 }
        
        switch listSection {
        case .userList:
            return users.count
        case .loader:
            return users.count >= viewModel.pageLimit ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        switch section {
        case .userList:
            let repo = users[indexPath.row]
            cell.textLabel?.text = repo.name
            cell.textLabel?.textColor = .label
            cell.detailTextLabel?.text = "\(indexPath.row + 1)"
        case .loader:
            cell.textLabel?.text = "Loading..."
            cell.textLabel?.textColor = .systemBlue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = TableSection(rawValue: indexPath.section) else { return }
        guard !users.isEmpty else { return }
        
        if section == .loader {
            print("load new data..")
            viewModel.loadItems()
        }
    }
    
    private func hideBottomLoader() {
        DispatchQueue.main.async {
            let lastListIndexPath = IndexPath(row: self.users.count - 1, section: TableSection.userList.rawValue)
            self.tableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
        }
    }
}

extension UserListViewController: UserListViewModelDelegate {
    func reloadData(_ items: [User]) {
        users = items
    }
    
    func showError() {
        self.hideBottomLoader()
    }
    
    func showLoading() {
        // TO DO
    }
}
