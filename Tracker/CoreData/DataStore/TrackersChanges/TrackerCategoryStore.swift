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
        let findResult = try? findById(id: category.id)
        if let findResult, findResult.count > 0 {
            guard let trackerCategoryEntity = findResult.first else { return }
            try addTacker(to: trackerCategoryEntity, tracker)
            try context.save()
        } else {
            throw StoreError.notFound
        }
    }

    private func findById(id: UUID) throws -> [TrackerCategoryEntity] {
        let request = TrackerCategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@",
                                        (\TrackerCategoryEntity.id)._kvcKeyPathString!,
                                        id as CVarArg)
        let result = try context.fetch(request)
        return result
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

    func moveTracker(from: TrackerCategory, to: TrackerCategory, tracker: Tracker) throws {
        try removeTracker(from: from, tracker: tracker)
        try addTracker(to: to, tracker: tracker)
    }

    private func removeTracker(from category: TrackerCategory, tracker: Tracker) throws {
        let findResult = try? findById(id: category.id)
        if let findResult, findResult.count > 0 {
            guard let trackerCategoryEntity = findResult.first else { return }
            let trackerEntity = try trackerMapper.map(from: tracker, context: context)
            trackerCategoryEntity.removeFromItems(trackerEntity)
            try context.save()
        } else {
            throw StoreError.notFound
        }
    }

    func get(by name: String) throws -> TrackerCategory {
        let request = TrackerCategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@",
                                        (\TrackerCategoryEntity.header)._kvcKeyPathString!,
                                        name as CVarArg)
        let result = try context.fetch(request)
        guard let trackerCategoryEntity = result.first else { throw StoreError.notFound }
        guard let id = trackerCategoryEntity.id,
              let header = trackerCategoryEntity.header else { throw StoreError.decodeError }
        return TrackerCategory(id: id, header: header)
    }
}
