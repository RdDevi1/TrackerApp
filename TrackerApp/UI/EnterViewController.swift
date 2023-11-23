//
//  EnterViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 22.05.2023.
//

import UIKit

final class EnterViewController: UIViewController {

    weak var coordinator: RootCoordinator?
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case onboardingShown
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let onboardingShown = userDefaults.bool(forKey: Keys.onboardingShown.rawValue)
        
        if !onboardingShown {
            let onboardingVC = OnboardingViewController()
            onboardingVC.modalPresentationStyle = .fullScreen
            present(onboardingVC, animated: false)
        
            userDefaults.set(true, forKey: Keys.onboardingShown.rawValue)
        } else {
            let tabBarVC = TabBarController(coordinator: coordinator!)
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: false)
        }
    }
}
