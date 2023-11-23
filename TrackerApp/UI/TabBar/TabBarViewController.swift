//
//  TabBarViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 28.03.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    weak var coordinator: RootCoordinator?
    
    init(coordinator: RootCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: "TabBarController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .ypBackgroundScreen
        tabBar.tintColor = .ypBlue
        
        let trackersViewController = TrackersViewController(trackerStore: TrackerStore())
        let statisticsViewController = StatisticsViewController(viewModel: StatisticsViewModel())
        
        trackersViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("trackers", comment: ""),
                                                         image: UIImage(systemName: "record.circle.fill"),
                                                         selectedImage: nil)
        statisticsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("statistics", comment: ""),
                                                           image: UIImage(systemName: "hare.fill"),
                                                           selectedImage: nil)
    
        let controllers = [trackersViewController, statisticsViewController]
        
        viewControllers = controllers
    }
    
}
