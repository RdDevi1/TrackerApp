

import UIKit


final class EventTypeSelectionViewController: UIViewController {
    
    
    //  MARK: - Layout
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Создание трекера"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var addRegularEventButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Нерегулярные событие", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapIrregularEventButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    

    
    //    MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setConstraints()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismiss(animated: false)
    }
    
    
    private func setLayout() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(addRegularEventButton)
        view.addSubview(addIrregularEventButton)
        
        
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
            addIrregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    
    // MARK: - Actions
    @objc
    private func didTapRegularEventButton() {
        let createEventViewController = CreateEventViewController(isRegular: true)
        createEventViewController.modalPresentationStyle = .pageSheet
        present(createEventViewController, animated: true)
        
    }
    
    @objc
    private func didTapIrregularEventButton() {
        let createEventViewController = CreateEventViewController(isRegular: false)
        createEventViewController.modalPresentationStyle = .pageSheet
        present(createEventViewController, animated: true)
    }
    
}
