//
//  UserListViewModel.swift
//  UsersFromGithubApp
//
//  Created by Camila Luísa Farias on 24/07/22.
//

import Foundation

protocol UserListViewModelDelegate: AnyObject {
    func reloadData(_ items: [User])
    func showError()
    func showLoading()
}

protocol UserListViewModelProtocol {
    var delegate: UserListViewModelDelegate? { get set }
    var pageLimit: Int { get }
    
    func loadItems()
}

class UserListViewModel: UserListViewModelProtocol {
    let githubAPIManager: GithubAPIManagerProtocol
    weak var delegate: UserListViewModelDelegate?
    
    var pageLimit = 25
    private var currentLastId: Int? = nil
    private var savedLastId: Int? = nil
    
    private var users = [User]() {
        didSet {
            self.delegate?.reloadData(users)
        }
    }
    
    init(githubAPIManager: GithubAPIManagerProtocol = GithubAPIManager()) {
        self.githubAPIManager = githubAPIManager
    }

    func loadItems() {
        if (savedLastId != nil) && (savedLastId == currentLastId) {
            return
        }
        
        savedLastId = currentLastId
        
        delegate?.showLoading()
        
        githubAPIManager.getUsers(perPage: pageLimit, sinceId: currentLastId) { [weak self] result in
            
            switch result {
            case .success(let users):
                self?.users.append(contentsOf: users)
                self?.currentLastId = users.last?.id
            case .failure:
                self?.delegate?.showError()
            }
        }
    }
}
