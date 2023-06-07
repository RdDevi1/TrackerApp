//
//  StatisticsViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 28.03.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    //    MARK: - Layout
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistics", comment: "")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .toggleBlackWhiteColor
        return label
    }()
    
    private lazy var emptyStatisticsImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "crySmile")!
        return image
    }()
    
    private lazy var emptyStatisticsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("emptyStatistics.text", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setLayout()
    }
    
    private func setLayout() {
        [titleLabel, emptyStatisticsImageView, emptyStatisticsLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            
            emptyStatisticsImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStatisticsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptyStatisticsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatisticsLabel.topAnchor.constraint(equalTo: emptyStatisticsImageView.bottomAnchor, constant: 8)
        
        ])
        
    }
}
