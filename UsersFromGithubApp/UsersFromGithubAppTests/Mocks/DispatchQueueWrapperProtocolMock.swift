//
//  DispatchQueueWrapperProtocolMock.swift
//  UsersFromGithubAppTests
//
//  Created by Camila Luísa Farias on 24/07/22.
//

import XCTest
@testable import UsersFromGithubApp

struct DispatchQueueWrapperProtocolMock: DispatchQueueWrapperProtocol {
    func mainAsync(completion: @escaping () -> Void) {
        completion()
    }
}
