//
//  TrackerRecordStore.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 19.04.2023.
//

import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateRecords(_ records: Set<TrackerRecord>)
}


final class TrackerRecordStore: NSObject {
    // MARK: - Properties
    enum StoreError: Error {
        case decodeError
    }
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    private var completedTrackers: Set<TrackerRecord> = []
    
    // MARK: - Lifecycle
    
    convenience override init() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }

    // MARK: - Methods
    
    func add(_ newRecord: TrackerRecord) throws {
        let trackerCoreData = try trackerStore.getTrackerCoreData(by: newRecord.trackerId)
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.recordId = newRecord.id.uuidString
        trackerRecordCoreData.date = newRecord.date
        trackerRecordCoreData.tracker = trackerCoreData
        try context.save()
        completedTrackers.insert(newRecord)
        delegate?.didUpdateRecords(completedTrackers)
    }
    
    func remove(_ record: TrackerRecord) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCoreData.recordId), record.id.uuidString
        )
        let records = try context.fetch(request)
        guard let recordToRemove = records.first else { return }
        context.delete(recordToRemove)
        try context.save()
        completedTrackers.remove(record)
        delegate?.didUpdateRecords(completedTrackers)
    }
    
    func loadCompletedTrackers(by date: Date) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date as NSDate)
        let recordsCoreData = try context.fetch(request)
        let records = try recordsCoreData.map { try makeTrackerRecord(from: $0) }
        completedTrackers = Set(records)
        delegate?.didUpdateRecords(completedTrackers)
    }
    
    private func makeTrackerRecord(from coreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let idString = coreData.recordId,
            let id = UUID(uuidString: idString),
            let date = coreData.date,
            let trackerCoreData = coreData.tracker,
            let tracker = try? trackerStore.getTracker(from: trackerCoreData)
        else { throw StoreError.decodeError }
        return TrackerRecord(id: id, trackerId: tracker.id, date: date)
    }
}
