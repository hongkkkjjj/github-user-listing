//
//  UserDetails.swift
//  Github Users Lisiting
//
//  Created by Kua Jun Hong on 03/08/2024.
//

import Foundation

struct UserDetails: Codable {
    let login: String
    let avatarUrl: String
    let name: String?
    let email: String?
    let bio: String?
    let publicRepos: Int
    let location: String?
    let company: String?
    let blog: String?
    let followers: Int
    let following: Int
    let createdAt: String
    let reposUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case name, email, bio
        case publicRepos = "public_repos"
        case location, company, blog
        case followers, following
        case createdAt = "created_at"
        case reposUrl = "repos_url"
    }
}
