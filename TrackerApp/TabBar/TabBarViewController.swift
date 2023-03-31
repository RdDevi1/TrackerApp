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
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .ypBlue
        
        let trackersViewController = TrackersViewController()
        let statisticsViewController = StatisticsViewController()
        
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры",
                                                         image: UIImage(systemName: "record.circle.fill"),
                                                         selectedImage: nil)
        statisticsViewController.tabBarItem = UITabBarItem(title: "Cтатистика",
                                                           image: UIImage(systemName: "hare.fill"),
                                                           selectedImage: nil)
    
        let controllers = [trackersViewController, statisticsViewController]
        
        viewControllers = controllers
    }
    
}
