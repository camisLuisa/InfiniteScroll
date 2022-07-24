//
//  DispatchQueueWrapper.swift
//  UsersFromGithubApp
//
//  Created by Camila Luísa Farias on 24/07/22.
//

import Foundation

protocol DispatchQueueWrapperProtocol {
    func mainAsync(completion: @escaping () -> Void)
}

struct DispatchQueueWrapper: DispatchQueueWrapperProtocol {
    func mainAsync(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            completion()
        }
    }
}
