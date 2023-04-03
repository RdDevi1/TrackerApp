

import UIKit

final class CreateEventViewController: UIViewController, UITextFieldDelegate {
    
//  MARK: - Layout
    private lazy var titleLabel: UILabel = {
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
    
    private lazy var trackerTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.masksToBounds = true
        field.placeholder = "Введите название трекера"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = .always
        field.layer.cornerRadius = 16
        field.backgroundColor = .lightGray.withAlphaComponent(0.3)
        field.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        field.isHidden = true
        return field
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .ypGray
        tableView.isHidden = true
        
        return tableView
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Cоздать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .ypGray
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed?.cgColor
        button.addTarget(self, action: #selector(didTapCancelButon), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
    
    // MARK: - Properties
    
    private var isRegular = true
    private var params = UICollectionView.GeometricParams(cellCount: 6,
                                                          leftInset: 25,
                                                          rightInset: 25,
                                                          cellSpacing: 17)
    
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
    
    private let colors = [
        #colorLiteral(red: 0.9921568627, green: 0.2980392157, blue: 0.2862745098, alpha: 1), #colorLiteral(red: 1, green: 0.5333333333, blue: 0.1176470588, alpha: 1), #colorLiteral(red: 0, green: 0.4823529412, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0.431372549, green: 0.2666666667, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.2, green: 0.8117647059, blue: 0.4117647059, alpha: 1), #colorLiteral(red: 0.9019607843, green: 0.4274509804, blue: 0.831372549, alpha: 1),
        #colorLiteral(red: 0.9764705882, green: 0.831372549, blue: 0.831372549, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.6549019608, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.2745098039, green: 0.9019607843, blue: 0.6156862745, alpha: 1), #colorLiteral(red: 0.2078431373, green: 0.2039215686, blue: 0.4862745098, alpha: 1), #colorLiteral(red: 1, green: 0.4039215686, blue: 0.3019607843, alpha: 1), #colorLiteral(red: 1, green: 0.6, blue: 0.8, alpha: 1),
        #colorLiteral(red: 0.9647058824, green: 0.768627451, blue: 0.5450980392, alpha: 1), #colorLiteral(red: 0.4745098039, green: 0.5803921569, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.5137254902, green: 0.1725490196, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.6784313725, green: 0.337254902, blue: 0.8549019608, alpha: 1), #colorLiteral(red: 0.5529411765, green: 0.4470588235, blue: 0.9019607843, alpha: 1), #colorLiteral(red: 0.1843137255, green: 0.8156862745, blue: 0.3450980392, alpha: 1)
    ]
    
    //    MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        
        
    }
    //    MARK: - Methods
    private func setLayout() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(addRegularEventButton)
        view.addSubview(addIrregularEventButton)
        view.addSubview(createButton)
        view.addSubview(cancelButton)
        view.addSubview(trackerTextField)
        view.addSubview(tableView)
        
        setConstraints()
    }
    
    private func goToEventCreator() {
        addRegularEventButton.isHidden = true
        addIrregularEventButton.isHidden = true
        createButton.isHidden = false
        cancelButton.isHidden = false
        trackerTextField.isHidden = false
        setConstraints()
        tableView.isHidden = false
//        tableView.reloadData()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            titleLabel.heightAnchor.constraint(equalToConstant: 49),
            
            addRegularEventButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 295),
            addRegularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addRegularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addRegularEventButton.heightAnchor.constraint(equalToConstant: 60),
            
            addIrregularEventButton.topAnchor.constraint(equalTo: addRegularEventButton.bottomAnchor, constant: 16),
            addIrregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addIrregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addIrregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            
            trackerTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            trackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: trackerTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: (isRegular ? 150 : 75)),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -37),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 161),
            
            cancelButton.centerYAnchor.constraint(equalTo: createButton.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 161)
            
        ])
    }
    
    //    MARK: - Actions
    @objc
    private func didTapRegularEventButton() {
        isRegular = true
        titleLabel.text = "Новая привычка"
        goToEventCreator()
    }
    
    @objc
    private func didTapIrregularEventButton() {
        isRegular = false
        titleLabel.text = "Новое нерегулярное событие"
        goToEventCreator()
    }
    
    @objc
    private func didTapCreateButton() {
    
    }
    
    @objc
    private func didTapCancelButon() {
        dismiss(animated: true)
    }
    
}


extension CreateEventViewController: UITableViewDelegate {
    
}


extension CreateEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isRegular ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = .systemBackground
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
        } else {
            cell.textLabel?.text = "Расписание"
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
}

