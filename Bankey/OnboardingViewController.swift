//
//  OnboardingViewController.swift
//  Bankey
//
//  Created by Abdusamad Mamasoliyev on 25/02/24.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {
    
    let stactView = UIStackView()
    let imageView = UIImageView()
    let label = UILabel()
    
    let heroImageName: String
    let titleText: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    init(heroImageName: String, titleText: String) {
        self.heroImageName = heroImageName
        self.titleText = titleText
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OnboardingViewController {
    func style() {
        view.backgroundColor = .systemBackground
        
        stactView.translatesAutoresizingMaskIntoConstraints = false
        stactView.axis = .vertical
        stactView.spacing = 0
        // image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: heroImageName)
        // label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        label.text = titleText
        
    }
    
    func layout() {
        
        stactView.addArrangedSubview(imageView)
        stactView.addArrangedSubview(label)
        view.addSubview(stactView)
        
        NSLayoutConstraint.activate([
            stactView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stactView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stactView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stactView.trailingAnchor, multiplier: 1)
        ])
    }
}
