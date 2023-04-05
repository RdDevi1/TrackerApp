//
//  ViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 23.03.2023.
//

import UIKit

class TrackersViewController: UIViewController {
    
    //    MARK: - Layout
    
    private lazy var trakersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(systemName: "plus")!, target: self, action: #selector(didTapAddButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.addTarget(self, action: #selector(didChangePickerValue), for: .touchUpInside)
        return picker
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let field = UISearchTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Поиск"
        field.delegate = self
    
        return field
    }()
    
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: "trackerCell")
        collection.register(TrackerCategoryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        return collection
    }()
    
    private lazy var emptyTrackersImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "star")
        return image
    }()
    
    private lazy var emptyTrackersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    //    MARK: - Properties
    var eventTypeSelectionVC = EventTypeSelectionViewController()
    
    
    private var params = UICollectionView.GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    private var categories: [TrackerCategory] = []
   
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    private var visibleCategories: [TrackerCategory] = []
//        TrackerCategory(
//            label: "Домашний уют",
//            trackers: [
//                Tracker(color: UIColor(named: "Color selection 5")!,
//                        label: "Поливать растения",
//                        emoji: "❤️",
//                        schedule: [.saturday]
//                       )
//            ]
//        ),
//
//        TrackerCategory(
//            label: "Радостные мелочи",
//            trackers: [
//                Tracker(color: UIColor(named: "Color selection 2")!,
//                        label: "Кошка заслонила камеру на созвоне",
//                        emoji: "😻",
//                        schedule: nil
//                       ),
//
//                Tracker(color: UIColor(named: "Color selection 1")!,
//                        label: "Бабушка прислала открытку в вотсапе",
//                        emoji: "🌺",
//                        schedule: nil
//                       ),
//
//                Tracker(color: UIColor(named: "Color selection 14")!,
//                        label: "Свидания в апреле",
//                        emoji: "❤️",
//                        schedule: nil
//                       ),
//            ]
//        )
//    ]

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        checkVisibleCategories()
        
        eventTypeSelectionVC.callback = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        view.addSubview(addButton)
        view.addSubview(trakersLabel)
        view.addSubview(datePicker)
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        view.addSubview(emptyTrackersImageView)
        view.addSubview(emptyTrackersLabel)
        setConstraints()
    }
    
    
//    MARK: - Methods
    private func setConstraints() {
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            
            trakersLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 13),
            trakersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            datePicker.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            
            searchTextField.topAnchor.constraint(equalTo: trakersLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 34),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyTrackersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTrackersImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 402),
            
            emptyTrackersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTrackersLabel.topAnchor.constraint(equalTo: emptyTrackersImageView.bottomAnchor, constant: 8)
            
        ])
    }
    
    private func checkVisibleCategories() {
        if visibleCategories.isEmpty {
            emptyTrackersLabel.isHidden = false
            emptyTrackersImageView.isHidden = false
        } else {
            emptyTrackersLabel.isHidden = true
            emptyTrackersImageView.isHidden = true
        }
    }

    
    @objc
    private func didTapAddButton() {
        eventTypeSelectionVC.modalPresentationStyle = .pageSheet
        present(eventTypeSelectionVC, animated: true)
    }
    
    @objc
    private func didChangePickerValue(_ sender: UIDatePicker) {
        currentDate = sender.date
        collectionView.reloadData()
    }
    
}

//MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        trackerCell.configCell(with: tracker, days: 0, isDone: false)
        return trackerCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? TrackerCategoryView
        else { return UICollectionReusableView() }
        
        let label = visibleCategories[indexPath.section].label
        view.configure(with: label)
        return view
    }
    
}


//MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableSize = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableSize / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height
                                                        ),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: params.leftInset, bottom: 16, right: params.rightInset)
    }
}


// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchTextFieldDelegate {
    
    
}
