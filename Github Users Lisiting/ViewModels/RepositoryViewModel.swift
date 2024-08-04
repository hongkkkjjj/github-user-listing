//
//  RepositoryViewModel.swift
//  Github Users Lisiting
//
//  Created by Kua Jun Hong on 04/08/2024.
//

import Foundation

struct RepositoryViewModel {
    let name: String
    let description: String
    let stargazersCount: String
    let language: String
    let url: String
    
    init(repository: Repository) {
        self.name = repository.name
        self.description = repository.description ?? "No description"
        self.stargazersCount = "★ \(repository.stargazersCount)"
        self.language = repository.language ?? "Unknown"
        self.url = repository.url ?? ""
    }
}
