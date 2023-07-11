//
//  StatisticsViewModel.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 11.07.2023.
//

import UIKit

final class StatisticCell: UITableViewCell {
    
    //MARK: - Properties
    private let gradientBorderView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 7
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    private var gradientBorder: CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientBorderView.bounds
        gradientLayer.colors = [
            uiColorMarshalling.color(from: "#FD4C49").cgColor,
            uiColorMarshalling.color(from: "#46E69D").cgColor,
            uiColorMarshalling.color(from: "#007BFA").cgColor
        ]

        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        return gradientLayer
    }
    
    private let uiColorMarshalling = UIColorMarshalling.shared
    static let identifier = "statisticCell"
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        gradientBorder.removeFromSuperlayer()

        DispatchQueue.main.async {
            self.gradientBorderView.layer.insertSublayer(self.gradientBorder, at: 0)
        }
    }
    
    //MARK: - Helpers
    func configureCell( _ title: String, _ subtitle: String) {
        backgroundColor = .clear
                        
        setElements()
        setupConstraints()
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    private func setElements() {
        contentView.addSubview(gradientBorderView)
        gradientBorderView.addSubview(mainView)
        mainView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gradientBorderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientBorderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientBorderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientBorderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            mainView.leadingAnchor.constraint(equalTo: gradientBorderView.leadingAnchor, constant: 1),
            mainView.topAnchor.constraint(equalTo: gradientBorderView.topAnchor, constant: 1),
            mainView.trailingAnchor.constraint(equalTo: gradientBorderView.trailingAnchor, constant: -1),
            mainView.bottomAnchor.constraint(equalTo: gradientBorderView.bottomAnchor, constant: -1),
            
            stackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 11),
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 11),
            stackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -11),
            stackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -11)
        ])
    }
}

