//
// Created by Андрей Парамонов on 11.10.2023.
//

import UIKit
import CoreData

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    private let mapper = TrackerRecordEntityMapper()
    private let context: NSManagedObjectContext

    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("appDelegate is nil")
        }
        context = appDelegate.persistentContainer.viewContext
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func add(_ record: TrackerRecord) throws {
        let _ = mapper.map(from: record, context: context)
        try context.save()
    }

    func delete(_ record: TrackerRecord) throws {
        let fetchRequest = TrackerRecordEntity.fetchRequest() as NSFetchRequest<TrackerRecordEntity>
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                             #keyPath(TrackerRecordEntity.trackerId),
                                             record.trackerId as CVarArg,
                                             #keyPath(TrackerRecordEntity.date),
                                             mapper.map(from: record.date))
        let trackerRecordEntities = try context.fetch(fetchRequest)
        guard let trackerRecordEntity = trackerRecordEntities.first else { return }
        context.delete(trackerRecordEntity)
        try context.save()
    }

    func count(for trackerId: UUID) -> Int {
        let fetchRequest = TrackerRecordEntity.fetchRequest() as NSFetchRequest<TrackerRecordEntity>
        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             #keyPath(TrackerRecordEntity.trackerId),
                                             trackerId as CVarArg)
        let trackerRecordEntities = try? context.fetch(fetchRequest)
        return trackerRecordEntities?.count ?? 0
    }

    func exists(_ record: TrackerRecord) -> Bool {
        let fetchRequest = TrackerRecordEntity.fetchRequest() as NSFetchRequest<TrackerRecordEntity>
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                             #keyPath(TrackerRecordEntity.trackerId),
                                             record.trackerId as CVarArg,
                                             #keyPath(TrackerRecordEntity.date),
                                             mapper.map(from: record.date))
        let trackerRecordEntities = try? context.fetch(fetchRequest)
        return trackerRecordEntities?.count ?? 0 > 0
    }

    func get(for date: Date) throws -> [TrackerRecord] {
        let fetchRequest = TrackerRecordEntity.fetchRequest() as NSFetchRequest<TrackerRecordEntity>
        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             #keyPath(TrackerRecordEntity.date),
                                             mapper.map(from: date))
        let trackerRecordEntities = try context.fetch(fetchRequest)
        return try trackerRecordEntities.map { try mapper.map(from: $0) }
    }

    func getAll() throws -> [TrackerRecord] {
        let fetchRequest = TrackerRecordEntity.fetchRequest() as NSFetchRequest<TrackerRecordEntity>
        let trackerRecordEntities = try context.fetch(fetchRequest)
        return try trackerRecordEntities.map { try mapper.map(from: $0) }
    }
}
