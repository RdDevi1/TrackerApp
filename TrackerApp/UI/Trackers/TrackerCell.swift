//
//  TrackerCell.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 28.03.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapDoneButton(of cell: TrackerCell, with tracker: Tracker)
}

final class TrackerCell: UICollectionViewCell {
    
    //  MARK: - Layout
    
    private lazy var trackerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let trackerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let emojiView: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private let daysCounterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var  doneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = trackerView.backgroundColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
    
    
    //  MARK: - Properties
    
    static let identifier = "trackerCell"
    private var days = 0 {
        didSet {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = Locale.current
            daysCounterLabel.text = String.localizedStringWithFormat(
                NSLocalizedString("numberOfDays", comment: "Number of checked days"),
                days
            )
        }
    }
    
    private var tracker: Tracker?
    weak var delegate: TrackerCellDelegate?
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configCell(with tracker: Tracker, days: Int, isDone: Bool) {
        self.tracker = tracker
        self.days = days
        trackerView.backgroundColor = tracker.color
        doneButton.backgroundColor = tracker.color
        trackerLabel.text = tracker.label
        emojiView.text = tracker.emoji
        toggleDoneButton(isDone)
    }
    
    func toggleDoneButton(_ isDone: Bool) {
        if isDone {
            doneButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            doneButton.layer.opacity = 0.3
        } else {
            doneButton.setImage(UIImage(systemName: "plus"), for: .normal)
            doneButton.layer.opacity = 1
        }
    }
    
    func increaseCount() {
        days += 1
    }
    
    func decreaseCount() {
        days -= 1
    }
    
    private func formatDayString(for days: Int) -> String {
        let mod10 = days % 10
        let mod100 = days % 100
        
        if mod100 >= 11 && mod100 <= 19 {
            return "\(days) дней"
        } else if mod10 == 1 {
            return "\(days) день"
        } else if mod10 >= 2 && mod10 <= 4 {
            return "\(days) дня"
        } else {
            return "\(days) дней"
        }
    }
    
    
    private func setCellLayout() {
        [trackerView, trackerLabel, emojiView, doneButton, daysCounterLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            trackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerView.heightAnchor.constraint(equalToConstant: 90),
            
            trackerLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            trackerLabel.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            trackerLabel.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12),
            
            emojiView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            
            doneButton.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 8),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            doneButton.widthAnchor.constraint(equalToConstant: 34),
            
            daysCounterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysCounterLabel.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor)
            
        ])
        
    }
    // MARK: - Actions
    @objc
    private func didTapDoneButton() {
        guard let tracker else { return }
        delegate?.didTapDoneButton(of: self, with: tracker)
    }
    
}
