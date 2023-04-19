import UIKit


protocol CreateEventViewControllerDelegate: AnyObject {
    func didTapCreateButton(_ tracker: Tracker, toCategory categoryLabel: String)
}


final class CreateEventViewController: UIViewController {
    
    //  MARK: - Layout
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .white
        scroll.frame = view.bounds
        return scroll
    }()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.masksToBounds = true
        field.placeholder = "Введите название трекера"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = .always
        field.layer.cornerRadius = 16
        field.backgroundColor = .ypBackground
        field.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return field
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .ypGray
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        return collection
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
        button.isEnabled = false
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
        return button
    }()
    
    // MARK: - Properties
    weak var delegate: CreateEventViewControllerDelegate?
    private var scheduleVC = ScheduleViewController()

    private var trackerCategory: String? = "qwerty"
    private var trackerSchedule: [String]?
    private var trackerColor: UIColor?
    private var trackerEmoji: String?
    private var trackerLabel: String?
    
    var isRegular: Bool?
    
    private var isCreateButtonEnable: Bool = false {
        willSet {
            if newValue {
                createButton.backgroundColor = .ypBlack
                createButton.isEnabled = true
            } else {
                createButton.backgroundColor = .ypGray
                createButton.isEnabled = false
            }
        }
    }
    
    private var params = UICollectionView.GeometricParams(cellCount: 6,
                                                          leftInset: 25,
                                                          rightInset: 25,
                                                          cellSpacing: 5)
    
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
        tableView.dataSource = self
        tableView.delegate = self
        textField.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CreateEventHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header"
        )
        collectionView.register(CreateEventCell.self,
                                forCellWithReuseIdentifier: CreateEventCell.identifier
        )
        setLayout()
        setConstraints()
        
        isTreckerReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scheduleVC.provideSelectedDays = { [weak self] Array in
            self?.trackerSchedule = Array
            self?.tableView.reloadData()
        }
        tableView.reloadData()
    }
    
//    MARK: - Methods
    private func isTreckerReady() {
        if isRegular! {
            if (trackerColor == nil) || (trackerEmoji == nil) || (trackerLabel == nil) || (trackerCategory == nil) || (trackerSchedule == nil) {
                isCreateButtonEnable = false
                return
            }
        } else {
            if (trackerColor == nil) || (trackerEmoji == nil) || (trackerLabel == nil) || (trackerCategory == nil) {
                isCreateButtonEnable = false
                return
            }
        }
        isCreateButtonEnable = true
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(textField)
        scrollView.addSubview(tableView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(createButton)
        scrollView.addSubview(cancelButton)
        
        if isRegular! {
            titleLabel.text = "Новая привычка"
        } else {
            titleLabel.text = "Новое нерегулярное событие"
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: (isRegular! ? 149 : 74)),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 484),
            
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: -4),
            cancelButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -34),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            createButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            createButton.leadingAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 4),
            createButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -34),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapCreateButton() {
        guard
            let category = trackerCategory,
            let color = trackerColor,
            let emoji = trackerEmoji,
            let text = trackerLabel
        else { return }
        let schedule = trackerSchedule?.compactMap { dayString -> WeekDay? in
            WeekDay.allCases.first(where: { $0.shortForm == dayString })
        }
        
        let newTracker = Tracker(color: color,
                                 label: text,
                                 emoji: emoji,
                                 schedule: schedule
        )
        
        delegate?.didTapCreateButton(newTracker, toCategory: category)

        self.presentingViewController?.dismiss(animated: false, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTapCancelButon() {
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension CreateEventViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let categoriesViewController = CategoriesViewController()
            present(categoriesViewController, animated: true)
        case 1:
            present(scheduleVC, animated: true)
        default: break
        }
    }
}

// MARK: - UITableViewDataSource
extension CreateEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isRegular! ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = .ypBackground
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = .ypGray
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = trackerCategory
        case 1:
            cell.textLabel?.text = "Расписание"
            if trackerSchedule?.isEmpty == false {
                if trackerSchedule?.count == 7 {
                    cell.detailTextLabel?.text = "Каждый день"
                } else {
                    cell.detailTextLabel?.text = trackerSchedule?.joined(separator: ", ")
                }
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

// MARK: - UITextFieldDelegate
extension CreateEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if newString.count <= 38 {
            trackerLabel = newString
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        isTreckerReady()
    }
}

// MARK: - UICollectionViewDataSource
extension CreateEventViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateEventCell.identifier,
                                                      for: indexPath)
        
        guard let collectionCell = cell as? CreateEventCell else { return UICollectionViewCell() }
        
        collectionCell.layer.cornerRadius = 16
        collectionCell.layer.masksToBounds = true
        
        switch indexPath.section {
        case 0:
            collectionCell.layer.cornerRadius = 16
            collectionCell.label.text = emojis[indexPath.row]
            collectionCell.label.font = UIFont.systemFont(ofSize: 32)
        case 1:
            collectionCell.layer.cornerRadius = 13
            collectionCell.label.text = ""
            collectionCell.contentView.backgroundColor = colors[indexPath.row]
        default:
            break
        }
        collectionCell.prepareForReuse()
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "header",
                                                                   for: indexPath) as? CreateEventHeaderView
        guard let view = view else { return UICollectionReusableView() }
        
        switch indexPath.section {
        case 0:
            view.headerLabel.text = "Emoji"
        case 1:
            view.headerLabel.text = "Цвет"
        default:
            break
        }
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CreateEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView,
                                             viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                             at: indexPath)

        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
    -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 25,
                            left: params.leftInset,
                            bottom: 25,
                            right: params.rightInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return params.cellSpacing
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath)  as? CreateEventCell  {
            
            switch indexPath.section {
                
            case 0:
                for item in 0..<collectionView.numberOfItems(inSection: 0) {
                    guard let cell = collectionView.cellForItem(at: IndexPath(row: item, section: 0)) else { return }
                    cell.backgroundColor = .clear
                }
                cell.backgroundColor = .ypLightGray
                trackerEmoji = cell.label.text
                isTreckerReady()
                
            case 1:
                for item in 0..<collectionView.numberOfItems(inSection: 1) {
                    guard let cell = collectionView.cellForItem(at: IndexPath(row: item, section: 1)) else { return }
                    cell.backgroundColor = .clear
                    cell.layer.borderWidth = 0
                }
                
                cell.layer.borderColor = cell.contentView.backgroundColor?.withAlphaComponent(0.3).cgColor
                cell.layer.borderWidth = 3
                trackerColor = cell.contentView.backgroundColor
                isTreckerReady()
                
            default:
                break
            }
        }
    }
}


