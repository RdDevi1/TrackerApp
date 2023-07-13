//
//  StatisticsViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 28.03.2023.
//

import UIKit

enum StatisticsCases: CaseIterable {
    case bestPeriod
    case perfectDays
    case complitedTrackers
    case mediumValue
    
    var name: String {
        switch self {
        case .bestPeriod:
            return NSLocalizedString("bestPeriod", comment: "")
        case .perfectDays:
            return NSLocalizedString("perfectDays", comment: "")
        case .complitedTrackers:
            return NSLocalizedString("complitedTrackers", comment: "")
        case .mediumValue:
            return NSLocalizedString("mediumValue", comment: "")
        }
    }
}


final class StatisticsViewController: UIViewController {
    
    //    MARK: - Layout
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistics", comment: "")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .toggleBlackWhiteColor
        return label
    }()
    
    private lazy var emptyStatisticsImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "crySmile")!
        return image
    }()
    
    private lazy var emptyStatisticsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("emptyStatistics.text", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            StatisticCell.self,
            forCellReuseIdentifier: StatisticCell.identifier
        )
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let trackerRecordStore = TrackerRecordStore.shared
    private var records: [TrackerRecordCoreData] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkRecords()
        setLayout()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            records = try trackerRecordStore.fetchAllRecords()
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
        checkRecords()
    }
    
    //   MARK: - Methods
    private func checkRecords() {
        if records.count == 0 {
            emptyStatisticsImageView.isHidden = false
            emptyStatisticsLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyStatisticsImageView.isHidden = true
            emptyStatisticsLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        
        [titleLabel, emptyStatisticsLabel, emptyStatisticsImageView, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            
            emptyStatisticsImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStatisticsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptyStatisticsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatisticsLabel.topAnchor.constraint(equalTo: emptyStatisticsImageView.bottomAnchor, constant: 8),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 408)
        ])
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StatisticsCases.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        102
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCell.identifier, for: indexPath) as? StatisticCell else { return UITableViewCell() }
        
        var title = ""
        let subtitle = StatisticsCases.allCases[indexPath.row].name
        
        switch indexPath.row {
        case 0:
            title = String(0)
            // TO DO
        case 1:
            title = String(0)
            // TO DO
        case 2:
            title = "\(records.count)"
        case 3:
            title = String(0)
            // TO DO
        default:
            break
        }
        
        cell.configureCell(title, subtitle)
        return cell
    }
}
