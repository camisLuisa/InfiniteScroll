//
//  UserListViewModelDelegateMocked.swift
//  UsersFromGithubAppTests
//
//  Created by Camila Luísa Farias on 24/07/22.
//

import XCTest
@testable import UsersFromGithubApp

class UserListViewModelDelegateMocked: UserListViewModelDelegate {
    var invokedReloadData = false
    var invokedShowError = false
    var invokedShowloading = false
    
    func reloadData(_ items: [User]) {
        invokedReloadData = true
    }
    
    func showError() {
        invokedShowError = true
    }
    
    func showLoading() {
        invokedShowloading = true
    }
    
    
}
