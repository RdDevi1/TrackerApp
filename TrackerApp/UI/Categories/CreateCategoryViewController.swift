//
//  CreateCategoriesViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 10.05.2023.
//

import UIKit

protocol CreateCategoryViewControllerDelegate: AnyObject {
    func addCategory(newCategoryLabel: String)
}

final class CreateCategoryViewController: UIViewController {
    
    // MARK: - Layout
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Новая категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
   
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.layer.masksToBounds = true
        field.placeholder = "Введите название категории"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = .always
        field.layer.cornerRadius = 16
        field.backgroundColor = .ypBackground
        field.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return field
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .ypGray
        button.isEnabled = false
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapСonfirmButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Propertie
    
    weak var delegate: CreateCategoryViewControllerDelegate?
    private var newTrackerCategory: TrackerCategory?
    
    //    MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = newTrackerCategory?.label
        textField.delegate = self
        
        setLayout()
        hideKeyboardWhenTappedAround()
    }
    
    //   MARK: - Methods
    private func setLayout() {
        
        view.backgroundColor = .white
        
        [titleLabel,
         confirmButton,
         textField].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    
    // MARK: - Actions
    @objc
    private func didTapСonfirmButton() {
        if textField.hasText {
            if let category = textField.text {
                if newTrackerCategory == nil {
                    delegate?.addCategory(newCategoryLabel: category)
                } else {
                    //                   
                    newTrackerCategory = nil
                }
                dismiss(animated: true)
            }
        }
    }
}

    // MARK: - UITextFieldDelegate
extension CreateCategoryViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.hasText {
            confirmButton.backgroundColor = .black
            confirmButton.isEnabled = true
        } else {
            confirmButton.backgroundColor = .ypGray
            confirmButton.isEnabled = false
        }
    }
}




