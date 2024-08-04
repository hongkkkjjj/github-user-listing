//
//  UserViewModel.swift
//  Github Users Lisiting
//
//  Created by Kua Jun Hong on 03/08/2024.
//

import Foundation

class UsersViewModel {
    private(set) var users: [User] = []
    private var currentPage = 1
    
    var onUsersUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func loadUsers() {
        GitHubAPI.getUsers(page: currentPage) { [weak self] result in
            switch result {
            case .success(let newUsers):
                self?.users.append(contentsOf: newUsers)
                self?.currentPage += 1
                self?.onUsersUpdated?()
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    func refreshUsers() {
        currentPage = 1
        users.removeAll()
        loadUsers()
    }
}
