//
//  UserListViewModelDelegateMocked.swift
//  UsersFromGithubAppTests
//
//  Created by Camila Luísa Farias on 24/07/22.
//

import XCTest
@testable import UsersFromGithubApp

class GithubAPIManagerProtocolMocked: GithubAPIManagerProtocol {
    var mockedUsers: [User] = []
    var mockedError: NetworkError?
    
    func getUsers(perPage: Int, sinceId: Int?, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        
        if let mockedError = mockedError {
            completion(.failure(mockedError))
            
            return
        }
        
        completion(.success(mockedUsers))
    }
}
