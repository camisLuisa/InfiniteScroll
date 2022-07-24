//
//  UserListViewModelTests.swift
//  UsersFromGithubAppTests
//
//  Created by Camila Luísa Farias on 24/07/22.
//

import XCTest
@testable import UsersFromGithubApp

class UserListViewModelTests: XCTestCase {
    var mockedGithubAPIManager: GithubAPIManagerProtocolMocked!
    var mockedDelegate: UserListViewModelDelegateMocked!
    var sut: UserListViewModel!
    
    override func setUp() {
        super.setUp()
        mockedGithubAPIManager = GithubAPIManagerProtocolMocked()
        mockedDelegate = UserListViewModelDelegateMocked()
        sut = UserListViewModel(githubAPIManager: mockedGithubAPIManager)
        sut.delegate = mockedDelegate
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func test_viewDidLoad_withSuccess_shouldCallDelegateShowItemsMethod() {
        //given
        mockedGithubAPIManager.mockedUsers = [User(id: 19, name: "Test", avatarUrl: "tests.com")]
        //when
        sut.loadItems()
        //them
        XCTAssertTrue(mockedDelegate.invokedShowloading)
        XCTAssertTrue(mockedDelegate.invokedReloadData)
    }
    
    func test_viewDidLoad_withError_shouldCallDelegateShowErrorMethod() {
        //given
        mockedGithubAPIManager.mockedError = .unknownError
        //when
        sut.loadItems()
        //them
        XCTAssertTrue(mockedDelegate.invokedShowloading)
        XCTAssertTrue(mockedDelegate.invokedShowError)
    }
}
