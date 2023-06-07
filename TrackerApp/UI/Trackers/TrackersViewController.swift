//
//  ViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 23.03.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    //    MARK: - Layout
    private lazy var trakersLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("trackers", comment: "")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "plus")!, target: self, action: #selector(didTapAddButton))
        button.tintColor = .toggleBlackWhiteColor
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.addTarget(self, action: #selector(didChangePickerValue), for: .valueChanged)
        return picker
    }()
    
    private lazy var searchTextField: UISearchBar = {
        let field = UISearchBar()
        field.placeholder = NSLocalizedString("search", comment: "")
        field.searchBarStyle = .minimal
        return field
    }()
    
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .white
        collection.register(TrackerCell.self,
                            forCellWithReuseIdentifier: "trackerCell")
        collection.register(TrackerCategoryView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: "header")
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    private lazy var emptyTrackersImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "star")
        return image
    }()
    
    private lazy var emptyTrackersLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("emptyTrackers.text", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("filters", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .ypBlue
        button.layer.cornerRadius = 16
        return button
    }()
    
    //    MARK: - Properties
    private let analyticsService = AnalyticsService()
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var params = UICollectionView.GeometricParams(cellCount: 2,
                                                          leftInset: 16,
                                                          rightInset: 16,
                                                          cellSpacing: 9
    )
    private var searchText = "" {
        didSet {
            try? trackerStore.loadFilteredTrackers(date: currentDate, searchString: searchText)
        }
    }
    private var currentDate: Date = Date()
    private var categories = [TrackerCategory]()
    private var completedTrackers: Set<TrackerRecord> = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        trackerRecordStore.delegate = self
        trackerStore.delegate = self
        
        try? trackerStore.loadFilteredTrackers(date: currentDate, searchString: searchText)
        try? trackerRecordStore.loadCompletedTrackers(by: currentDate)
        
        checkTrackers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.reportScreen(event: .open, onScreen: .main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.reportScreen(event: .close, onScreen: .main)
    }
    
    //    MARK: - Methods
    private func checkTrackers() {
        if trackerStore.numberOfTrackers == 0 {
            emptyTrackersLabel.isHidden = false
            emptyTrackersImageView.isHidden = false
            collectionView.isHidden = true
            filterButton.isHidden = true
        } else {
            emptyTrackersLabel.isHidden = true
            emptyTrackersImageView.isHidden = true
            collectionView.isHidden = false
            filterButton.isHidden = false
        }
    }
    
    private func deleteTracker(forIndexPath: IndexPath) {
        
        guard let tracker = trackerStore.tracker(at: forIndexPath) else { return }
        let alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("alertTracker.text", comment: ""),
                                      preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
        let deleteAction = UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .destructive) { [weak self] _ in
            guard let self else { return }
            try? self.trackerStore.deleteTracker(tracker)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
    private func setLayout() {
        [
            trakersLabel,
            addButton,
            datePicker,
            searchTextField,
            collectionView,
            emptyTrackersLabel,
            emptyTrackersImageView,
            filterButton
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.backgroundColor = .systemBackground
        setConstraints()
    }
    
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
            emptyTrackersLabel.topAnchor.constraint(equalTo: emptyTrackersImageView.bottomAnchor, constant: 8),
            
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //    MARK: - Actions
    @objc
    private func didTapAddButton() {
        analyticsService.reportEvent(event: .click, screen: .main, item: .add_track)
        let selectTypeEventViewController = SelectTypeEventViewController()
        selectTypeEventViewController.delegate = self
        selectTypeEventViewController.modalPresentationStyle = .pageSheet
        present(selectTypeEventViewController, animated: true)
    }
    
    @objc
    private func didChangePickerValue(_ sender: UIDatePicker) {
        currentDate = sender.date.onlyDate()
        do {
            try trackerStore.loadFilteredTrackers(date: currentDate, searchString: searchText)
            try trackerRecordStore.loadCompletedTrackers(by: currentDate)
        } catch {}
        collectionView.reloadData()
    }
    
    @objc
    private func didTapFilterButton() {
        analyticsService.reportEvent(event: .click, screen: .main, item: .filter)
//        TO DO
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerStore.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        trackerStore.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let trackerCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerCell.identifier,
                for: indexPath
            ) as? TrackerCell,
            let tracker = trackerStore.tracker(at: indexPath)
        else {
            return UICollectionViewCell()
        }
        
        let isCompleted = completedTrackers.contains { $0.date == currentDate && $0.trackerId == tracker.id }
        trackerCell.configCell(with: tracker, days: tracker.completedDaysCount, isDone: isCompleted)
        trackerCell.delegate = self
        
        return trackerCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? TrackerCategoryView
        else { return UICollectionReusableView() }
        
        guard let label = trackerStore.headerLabelInSection(indexPath.section) else { return UICollectionReusableView() }
        view.configure(with: label)
        return view
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableSize = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableSize / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: params.leftInset, bottom: 16, right: params.rightInset)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
                        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        let indexPath = indexPaths[0]
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: NSLocalizedString("pin", comment: "")) { [weak self] _ in
                    /* TO DO */
                },
                UIAction(title: NSLocalizedString("edit", comment: "")) { [weak self] _ in
                    /* TO DO */
                    self?.analyticsService.reportEvent(event: .click, screen: .main, item: .edit)
                },
                UIAction(title: NSLocalizedString("delete", comment: ""), attributes: .destructive) { [weak self] _ in
                    self?.analyticsService.reportEvent(event: .click, screen: .main, item: .delete)
                    self?.deleteTracker(forIndexPath: indexPath)
                }
            ])
        })
    }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchTextFieldDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        searchText = ""
        collectionView.reloadData()
    }
}

// MARK: - TrackerCellDelegate
extension TrackersViewController: TrackerCellDelegate {
    func didTapDoneButton(of cell: TrackerCell, with tracker: Tracker) {
        analyticsService.reportEvent(event: .click, screen: .main, item: .track)
        if let recordToRemove = completedTrackers.first(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            try? trackerRecordStore.remove(recordToRemove)
            cell.toggleDoneButton(false)
            cell.decreaseCount()
        } else {
            let trackerRecord = TrackerRecord(trackerId: tracker.id, date: currentDate)
            try? trackerRecordStore.add(trackerRecord)
            cell.toggleDoneButton(true)
            cell.increaseCount()
        }
    }
}

// MARK: - SelectTypeEventViewControllerDelegate
extension TrackersViewController: SelectTypeEventViewControllerDelegate {
    func didTapSelectTypeEventButton(isRegular: Bool) {
        let createEventViewController = CreateEventViewController()
        createEventViewController.isRegular = isRegular
        createEventViewController.delegate = self
        present(createEventViewController, animated: true, completion: nil)
    }
}

// MARK: - CreateEventViewControllerDelegate
extension TrackersViewController: CreateEventViewControllerDelegate {
    func didTapCreateButton(_ tracker: Tracker, toCategory category: TrackerCategory) {
        try? trackerStore.addTracker(tracker, with: category)
    }
}


// MARK: - TrackerStoreDelegate

extension TrackersViewController: TrackerStoreDelegate {
    func didUpdate() {
        checkTrackers()
        collectionView.reloadData()
    }
}

// MARK: - TrackerRecordStoreDelegate

extension TrackersViewController: TrackerRecordStoreDelegate {
    func didUpdateRecords(_ records: Set<TrackerRecord>) {
        completedTrackers = records
    }
}

