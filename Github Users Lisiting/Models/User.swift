//
//  User.swift
//  Github Users Lisiting
//
//  Created by Kua Jun Hong on 03/08/2024.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    let url: String
    let reposUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case url
        case reposUrl = "repos_url"
    }
}
