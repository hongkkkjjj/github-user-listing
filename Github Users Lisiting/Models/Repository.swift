//
//  Repository.swift
//  Github Users Lisiting
//
//  Created by Kua Jun Hong on 03/08/2024.
//

import Foundation

struct Repository: Codable {
    let name: String
    let description: String?
    let stargazersCount: Int
    let language: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case name, description, language
        case stargazersCount = "stargazers_count"
        case url = "html_url"
    }
}
