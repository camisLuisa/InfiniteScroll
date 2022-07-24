//
//  GithubAPIManagerTests.swift
//  UsersFromGithubAppTests
//
//  Created by Camila Luísa Farias on 22/07/22.
//

import XCTest
@testable import UsersFromGithubApp

class GithubAPIManagerTests: XCTestCase {
    var dispatchQueueMock: DispatchQueueWrapperProtocolMock!
    var urlSessionMock: UrlSessionMock!
    var sut: GithubAPIManager!
    
    override func setUp() {
        super.setUp()
        dispatchQueueMock = DispatchQueueWrapperProtocolMock()
        urlSessionMock = UrlSessionMock()
        sut = GithubAPIManager(session: urlSessionMock, dispatchQueueWrapper: dispatchQueueMock)
    }
    
    override func tearDown() {
        super.tearDown()
        dispatchQueueMock = nil
        urlSessionMock = nil
        sut = nil
    }
    
    func test_getUsers_withSuccess_shouldReturnUsers() {
        //given
        let usersResponse = [User(id: 12, name: "", avatarUrl: "www.test.com")]
        
        urlSessionMock.mockResponse = getMockResponseData(users: usersResponse)
        
        var checkGetUsersResponse: [User]?
        
        //When
        sut.getUsers { result in
            switch result {
            case .success(let reponse):
                checkGetUsersResponse = reponse
            case .failure:
                break
            }
        }
        
        //Then
        XCTAssertNotNil(checkGetUsersResponse)
        XCTAssertEqual(usersResponse, checkGetUsersResponse)
    }
    
    private func getMockResponseData(users: [User]) -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? encoder.encode(users)

        return data
    }
}
