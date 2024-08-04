//
//  UserCell.swift
//  Github Users Lisiting
//
//  Created by Kua Jun Hong on 03/08/2024.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    
    static let identifier = "UserCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "UserCell", bundle: nil)
    }
    
    func configure(with user: User) {
        loginLabel.text = user.login
        avatarImageView.sd_setImage(with: URL(string: user.avatarUrl))
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }
}
