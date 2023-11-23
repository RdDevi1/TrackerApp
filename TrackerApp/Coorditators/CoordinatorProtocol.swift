//
//  CoordinatorProtocol.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 23.11.2023.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    /// The navigation controller for the coordinator
    var navigationController: UINavigationController { get set }
    
    /**
     The Coordinator takes control and activates itself.
     - Parameters:
        - animated: Set the value to true to animate the transition. Pass false if you are setting up a navigation controller before its view is displayed.
     
    */
    func start(animated: Bool)
    
    /**
        Pops out the active View Controller from the navigation stack.
        - Parameters:
            - animated: Set this value to true to animate the transition.
     */
    func popViewController(animated: Bool, useCustomAnimation: Bool, transitionType: CATransitionType)
}

extension Coordinator {
    /**
     Pops the top view controller from the navigation stack and updates the display.
     
     - Parameters:
     - animated: Set this value to true to animate the transition.
     - useCustomAnimation: Set to true if you want a transition from top to bottom.
     */
    func popViewController(animated: Bool, useCustomAnimation: Bool = false, transitionType: CATransitionType = .push) {
        if useCustomAnimation {
            navigationController.customPopViewController(transitionType: transitionType)
        } else {
            navigationController.popViewController(animated: animated)
        }
    }
    
