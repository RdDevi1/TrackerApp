//
//  RootCoordinator.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 23.11.2023.
//

import Foundation
import UIKit

final class RootCoordinator: NSObject, Coordinator, ParentCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var enterVC: EnterViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
        enterVC = EnterViewController()
        enterVC!.coordinator = self
//        tabBarController!.coordinator = self
        navigationController.pushViewController(enterVC!, animated: animated)
    }
    
    
    
    
}
