//
//  EnterViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 22.05.2023.
//

import UIKit

class EnterViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let onboardingShown = UserDefaults.standard.bool(forKey: "OnboardingShown")
        
        if !onboardingShown {
            let OnboardingVC = OnboardingViewController()
            OnboardingVC.modalPresentationStyle = .fullScreen
            present(OnboardingVC, animated: false)
        
            UserDefaults.standard.set(true, forKey: "OnboardingShown")
        } else {
            let tabBarVC = TabBarController()
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: false)
        }
    }
}
