//
//  SelectTypeEventViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 18.04.2023.
//

import UIKit

protocol SelectTypeEventViewControllerDelegate: AnyObject {
    func didTapSelectTypeEventButton(isRegular: Bool)
}

final class SelectTypeEventViewController: UIViewController {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var addRegularEventButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .black
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapRegularEventButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var addIrregularEventButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .black
        button.setTitle("Нерегулярные событие", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapIrregularEventButton), for: .touchUpInside)
        return button
    }()
    
    //    MARK: - Properties
    weak var delegate: CreateEventViewControllerDelegate?
    
    
    //    MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setConstraints()
    }
    
    // MARK: - Actions
    @objc
    private func didTapRegularEventButton() {
        let createEventViewController = CreateEventViewController()
        createEventViewController.isRegular = true
        createEventViewController.delegate = delegate
        createEventViewController.modalPresentationStyle = .pageSheet
        present(createEventViewController, animated: true)
    }
    
    @objc
    private func didTapIrregularEventButton() {
        let createEventViewController = CreateEventViewController()
        createEventViewController.isRegular = false
        createEventViewController.delegate = delegate
        createEventViewController.modalPresentationStyle = .pageSheet
        present(createEventViewController, animated: true)
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        [titleLabel, addRegularEventButton, addIrregularEventButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            addRegularEventButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 295),
            addRegularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addRegularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addRegularEventButton.heightAnchor.constraint(equalToConstant: 60),
            
            addIrregularEventButton.topAnchor.constraint(equalTo: addRegularEventButton.bottomAnchor, constant: 16),
            addIrregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addIrregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addIrregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
