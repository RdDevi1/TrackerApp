//
//  OnboardingPageViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 24.05.2023.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    
    //    MARK: - Layout
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: - Properties
    
    var page: Pages
    
    init(page: Pages) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = page.background
        label.text = page.name
        setLayout()
    }
    
    private func setLayout() {
        [imageView, label].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 26),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
