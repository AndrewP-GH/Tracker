//
// Created by Андрей Парамонов on 11.10.2023.
//

import Foundation
import UIKit
import CoreData

final class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    private let context: NSManagedObjectContext

    private let trackerMapper = TrackerEntityMapper()

    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("appDelegate is nil")
        }
        context = appDelegate.persistentContainer.viewContext
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addTracker(to category: TrackerCategory, tracker: Tracker) throws {
        let fetchRequest = TrackerCategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             (\TrackerCategoryEntity.id)._kvcKeyPathString!,
                                             category.id as CVarArg)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(TrackerCategoryEntity.header),
                                                         ascending: true)]
        let findResult = try? context.fetch(fetchRequest)
        if let findResult, findResult.count > 0 {
            guard let trackerCategoryEntity = findResult.first else { return }
            try addTacker(to: trackerCategoryEntity, tracker)
            try context.save()
        } else {
            throw StoreError.notFound
        }
    }

    func create(category: TrackerCategory) throws {
        let trackerCategoryEntity = TrackerCategoryEntity(context: context)
        trackerCategoryEntity.id = category.id
        trackerCategoryEntity.header = category.header
        trackerCategoryEntity.items = []
        try context.save()
    }

    func getAll() throws -> [TrackerCategory] {
        let request = TrackerCategoryEntity.fetchRequest()
        let result = try context.fetch(request)
        return try result.map { trackerCategoryEntity in
            guard let id = trackerCategoryEntity.id,
                  let header = trackerCategoryEntity.header else { throw StoreError.decodeError }
            return TrackerCategory(id: id, header: header)
        }
    }

    private func addTacker(to category: TrackerCategoryEntity, _ tracker: Tracker?) throws {
        guard let tracker = tracker else { return }
        let trackerEntity = try trackerMapper.map(from: tracker, context: context)
        category.addToItems(trackerEntity)
    }
}
