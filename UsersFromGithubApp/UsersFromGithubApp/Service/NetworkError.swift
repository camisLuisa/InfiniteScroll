//
//  NetworkError.swift
//  UsersFromGithubApp
//
//  Created by Camila Luísa Farias on 24/07/22.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case errorDecode
    case failed(error: Error)
    case unknownError
}
