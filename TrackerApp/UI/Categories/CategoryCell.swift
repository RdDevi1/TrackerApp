//
//  CategoryCell.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 10.05.2023.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    static let identifier = "CategoryCell"
    
    private let checkmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.isHidden = true
        return imageView
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            checkmarkImage.isHidden = false
        } else {
            checkmarkImage.isHidden = true
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent() {
        selectionStyle = .none
        contentView.backgroundColor = .ypBackground
        
        [label, checkmarkImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -83),
            
            checkmarkImage.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            checkmarkImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configCell(with label: String, isSelected: Bool) {
        self.label.text = label
    }
}
