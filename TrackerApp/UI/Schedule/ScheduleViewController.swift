//
//  ScheduleViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 03.04.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
    //  MARK: - Layout
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.text = "Расписание"
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.layer.masksToBounds = true
        table.isScrollEnabled = false
        table.layer.cornerRadius = 16
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.separatorColor = .ypGray
        return table
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .black
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    //    MARK: - Properties
    
    private var selectedDays: [String] = []
    var provideSelectedDays: (([String]) -> Void)?
    
    
    //    MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        setLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let sortedSelectedDays = sortSelectedDays(selectedDays)
        provideSelectedDays?(sortedSelectedDays)
    }
    
    //   MARK: - Methods
    private func setLayout() {
        view.backgroundColor = .white
        [titleLabel, tableView, confirmButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        setConstraints()
    }
    
    private func sortSelectedDays(_ days: [String]) -> [String] {
        let preferredOrder = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        return days.sorted { preferredOrder.firstIndex(of: $0)! < preferredOrder.firstIndex(of: $1)! }
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 524),
            
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc
    private func didTapConfirmButton() {
        dismiss(animated: true)
    }
    
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}


extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let switcher = UISwitch()
        switcher.onTintColor = .ypBlue
        switcher.tag = indexPath.row
        switcher.addTarget(self, action: #selector(didTapSwitcher(_:)), for: .valueChanged)
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let weekday = WeekDay.allCases[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .ypBackground
        cell.textLabel?.text = weekday.rawValue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.accessoryView = switcher
        
        return cell
    }
    
    
    @objc
    private func didTapSwitcher(_ sender: UISwitch) {
        if sender.isOn {
            switch sender.tag {
            case 0: selectedDays.append(WeekDay.monday.shortForm)
            case 1: selectedDays.append(WeekDay.tuesday.shortForm)
            case 2: selectedDays.append(WeekDay.wednesday.shortForm)
            case 3: selectedDays.append(WeekDay.thursday.shortForm)
            case 4: selectedDays.append(WeekDay.friday.shortForm)
            case 5: selectedDays.append(WeekDay.saturday.shortForm)
            case 6: selectedDays.append(WeekDay.sunday.shortForm)
            default: break
            }
        } else {
            switch sender.tag {
            case 0: selectedDays.removeAll { $0 == WeekDay.monday.shortForm }
            case 1: selectedDays.removeAll { $0 == WeekDay.tuesday.shortForm }
            case 2: selectedDays.removeAll { $0 == WeekDay.wednesday.shortForm }
            case 3: selectedDays.removeAll { $0 == WeekDay.thursday.shortForm }
            case 4: selectedDays.removeAll { $0 == WeekDay.friday.shortForm }
            case 5: selectedDays.removeAll { $0 == WeekDay.saturday.shortForm }
            case 6: selectedDays.removeAll { $0 == WeekDay.sunday.shortForm }
            default: break
            }
        }
    }
}
