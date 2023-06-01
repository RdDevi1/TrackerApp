//
//  StatisticsViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 28.03.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    //    MARK: - Layout
    private lazy var Label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistics", comment: "")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
