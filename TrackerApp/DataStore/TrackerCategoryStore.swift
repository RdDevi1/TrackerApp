//
//  TrackerCategoryStore.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 19.04.2023.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdate()
}

final class TrackerCategoryStore: NSObject {
    // MARK: - Properties
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var categoriesCoreData: [TrackerCategoryCoreData] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    var categories = [TrackerCategory]()
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt",
                                                         ascending: true)]
        
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchResultController.delegate = self
        try? fetchResultController.performFetch()
        return fetchResultController
    }()
    
    
    // MARK: - Lifecycle
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
    
    
    // MARK: - Methods
    func categoryCoreData(with id: UUID) throws -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.categoryId), id.uuidString
        )
        let category = try context.fetch(request)
        return category[0]
    }
    
    func makeCategory(from coreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard
            let idString = coreData.categoryId,
            let id = UUID(uuidString: idString),
            let label = coreData.label
        else { throw StoreError.decodeCategoryStoreError }
        return TrackerCategory(id: id,label: label)
    }
    
    func makeCategory(with label: String) throws -> TrackerCategory {
        let category = TrackerCategory(label: label)
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.label = category.label
        categoryCoreData.categoryId = category.id.uuidString
        categoryCoreData.createdAt = Date()
        try context.save()
        return category
    }
    
    func deleteCategory(category: TrackerCategory) throws {
        let categoryForDelete = try getCategoryCoreData(id: category.id)
        context.delete(categoryForDelete)
        try context.save()
    }
    
    
    private func getCategoryCoreData(id: UUID) throws -> TrackerCategoryCoreData {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath (TrackerCategoryCoreData.categoryId), id.uuidString
        )
        try fetchedResultsController.performFetch()
        guard let category = fetchedResultsController.fetchedObjects?.first
        else { throw StoreError.decodeCategoryStoreError }
        fetchedResultsController.fetchRequest.predicate = nil
        try fetchedResultsController.performFetch()
        return category
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}
