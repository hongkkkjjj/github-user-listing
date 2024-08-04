//
//  RepositoryView.swift
//  Github Users Lisiting
//
//  Created by Kua Jun Hong on 04/08/2024.
//

import UIKit
import SafariServices

class RepositoryView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var stargazersLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "RepositoryView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func configure(with viewModel: RepositoryViewModel) {
        contentView.layer.cornerRadius = 8.0
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        stargazersLabel.text = viewModel.stargazersCount
        languageLabel.text = viewModel.language
    }
}

