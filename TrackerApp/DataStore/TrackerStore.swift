//
//  TrackerStore.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 19.04.2023.
//

import UIKit
import CoreData

final class TrackerStore {
    // MARK: - Properties
    let context: NSManagedObjectContext
    let uiColorMarshalling = UIColorMarshalling()
    private let trackerCategoryStore = TrackerCategoryStore()
    
    
    
    // MARK: - Lifecycle
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    // MARK: - Methods
    
    func makeTracker() {
        
    }
    
    
    
    
    
}

