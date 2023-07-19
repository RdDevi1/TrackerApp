//
//  TabBarViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 28.03.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
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
