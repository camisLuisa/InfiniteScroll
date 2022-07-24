//
//  User.swift
//  UsersFromGithubApp
//
//  Created by Camila Luísa Farias on 24/07/22.
//

import Foundation

struct User: Codable, Equatable {
    let id: Int
    let name: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarUrl = "avatar_url"
    }
}
