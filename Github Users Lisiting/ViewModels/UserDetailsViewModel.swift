//
//  UserDetailsViewModel.swift
//  Github Users Lisiting
//
//  Created by Kua Jun Hong on 03/08/2024.
//

import Foundation

class UserDetailsViewModel {
    private(set) var userDetails: UserDetails?
    private(set) var repositories: [Repository] = []
    
    var onUserDetailsUpdated: (() -> Void)?
    var onRepositoriesUpdated: (() -> Void)?
    var onErrorOccurred: ((Error) -> Void)?
    
    var repositoryViewModels: [RepositoryViewModel] {
        return repositories.map { RepositoryViewModel(repository: $0) }
    }
    
    func loadUserDetails(url: String) {
        GitHubAPI.getUserDetails(url: url) { [weak self] result in
            switch result {
            case .success(let details):
                self?.userDetails = details
                self?.onUserDetailsUpdated?()
            case .failure(let error):
                self?.onErrorOccurred?(error)
            }
        }
    }
    
    func loadRepositories(url: String) {
        GitHubAPI.getRepositories(url: url) { [weak self] result in
            switch result {
            case .success(let repos):
                self?.repositories = self?.findTopRepositories(repos) ?? []
                self?.onRepositoriesUpdated?()
            case .failure(let error):
                self?.onErrorOccurred?(error)
            }
        }
    }
    
    private func findTopRepositories(_ repositories: [Repository], limit: Int = 6) -> [Repository] {
        var minHeap: [Repository] = []
        
        func insertIntoHeap(_ repo: Repository) {
            if minHeap.count < limit {
                minHeap.append(repo)
                minHeap.sort(by: { $0.stargazersCount < $1.stargazersCount })
            } else if let minRepo = minHeap.first, repo.stargazersCount > minRepo.stargazersCount {
                minHeap[0] = repo
                minHeap.sort(by: { $0.stargazersCount < $1.stargazersCount })
            }
        }
        
        for repo in repositories {
            insertIntoHeap(repo)
        }
        
        return minHeap.sorted(by: {$0.stargazersCount > $1.stargazersCount })
    }

}
