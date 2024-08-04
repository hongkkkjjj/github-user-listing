//
//  UserDetailsViewController.swift
//  Github Users Lisiting
//
//  Created by Kua Jun Hong on 03/08/2024.
//

import UIKit
import SDWebImage
import SafariServices

class UserDetailsViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var blogView: UIView!
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var blogLabel: UILabel!
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var repoStackView: UIStackView!
    
    var username: String = ""
    var userUrl: String = ""
    var reposUrl: String = ""
    private let viewModel = UserDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = username
        setupBindings()
        viewModel.loadUserDetails(url: userUrl)
        viewModel.loadRepositories(url: reposUrl)
    }
    
    private func setupBindings() {
        viewModel.onUserDetailsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.onRepositoriesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateRepositoriesUI()
            }
        }
        
        viewModel.onErrorOccurred = { [weak self] error in
            DispatchQueue.main.async {
                self?.showErrorAlert(error: error)
            }
        }
    }
    
    private func updateUI() {
        guard let userDetails = viewModel.userDetails else { return }
        // Update UI with user details
        avatarImageView.sd_setImage(with: URL(string: userDetails.avatarUrl))
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        nameLabel.text = userDetails.name
        followersLabel.text = "Followers: \(userDetails.followers)"
        followingLabel.text = "Following: \(userDetails.following)"
        bioLabel.text = userDetails.bio ?? "-"
        
        hideIfDetailIsNull(emailView, emailLabel, detail: userDetails.email)
        hideIfDetailIsNull(locationView, locationLabel, detail: userDetails.location)
        hideIfDetailIsNull(companyView, companyLabel, detail: userDetails.company)
        hideIfDetailIsNull(blogView, blogLabel, detail: userDetails.blog)
        emailImageView.image = UIImage(systemName: "envelope.fill")
        locationImageView.image = UIImage(systemName: "location.fill")
        companyImageView.image = UIImage(systemName: "building.fill")
        blogImageView.image = UIImage(systemName: "link")
        
        initTapGesture()
    }
    
    private func updateRepositoriesUI() {
        let viewModels = viewModel.repositoryViewModels
        
        // Clear existing views
        repoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, viewModel) in viewModels.enumerated() {
            let repositoryView = RepositoryView()
            repositoryView.configure(with: viewModel)
            repoStackView.addArrangedSubview(repositoryView)
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            repositoryView.addGestureRecognizer(tapRecognizer)
            repositoryView.tag = index
        }
    }
    
    private func showErrorAlert(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func hideIfDetailIsNull(_ view: UIView, _ label: UILabel, detail: String?) {
        if let validDetail = detail, !validDetail.isEmpty {
            view.isHidden = false
            label.text = validDetail
        } else {
            view.isHidden = true
        }
    }
    
    private func initTapGesture() {
        let emailTapRecognizer = UITapGestureRecognizer()
        emailTapRecognizer.addTarget(self, action: #selector(emailViewTap))
        emailView.addGestureRecognizer(emailTapRecognizer)
        
        let blogTapRecognizer = UITapGestureRecognizer()
        blogTapRecognizer.addTarget(self, action: #selector(blogViewTap))
        blogView.addGestureRecognizer(blogTapRecognizer)
    }
    
    // MARK: - Tap Gesture
    
    @objc func emailViewTap() {
        guard let email = viewModel.userDetails?.email else { return }
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func blogViewTap() {
        guard let blog = viewModel.userDetails?.blog else { return }
        guard let url = URL(string: blog) else { return }
        let webVC = SFSafariViewController(url: url)
        present(webVC, animated: true)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        let index = tappedView.tag
        
        let repositoryViewModel = viewModel.repositoryViewModels[index]
        guard let url = URL(string: repositoryViewModel.url) else { return }
        let webVC = SFSafariViewController(url: url)
        present(webVC, animated: true)
    }
}
