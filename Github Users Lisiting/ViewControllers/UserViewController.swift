//
//  UserViewController.swift
//  Github Users Lisiting
//
//  Created by Kua Jun Hong on 03/08/2024.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = UsersViewModel()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        viewModel.loadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserCell.nib(), forCellReuseIdentifier: UserCell.identifier)
        refreshControl.addTarget(self, action: #selector(refreshUsers), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupBindings() {
        viewModel.onUsersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showError(error)
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func refreshUsers() {
        viewModel.refreshUsers()
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell else {
            fatalError("Unable to dequeue UserCell")
        }
        let user = viewModel.users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.users[indexPath.row]
        performSegue(withIdentifier: "ShowUserDetails", sender: user)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.users.count - 1 {
            viewModel.loadUsers()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserDetails",
            let userDetailsVC = segue.destination as? UserDetailsViewController,
           let user = sender as? User {
            userDetailsVC.username = user.login
            userDetailsVC.userUrl = user.url
            userDetailsVC.reposUrl = user.reposUrl
        }
    }

}
