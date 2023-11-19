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

    func createOrUpdate(header: String, tracker: Tracker) throws {
        let findRequest = TrackerCategoryEntity.fetchRequest()
        findRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryEntity.header), header)
        let findResult = try? context.fetch(findRequest)
        if let findResult, findResult.count > 0 {
            guard let trackerCategoryEntity = findResult.first else { return }
            try addTacker(tracker, to: trackerCategoryEntity)
        } else {
            let trackerCategoryEntity = TrackerCategoryEntity(context: context)
            trackerCategoryEntity.id = UUID()
            trackerCategoryEntity.header = header
            try addTacker(tracker, to: trackerCategoryEntity)
        }
        try context.save()
    }

    func getAll() throws -> [TrackerCategory] {
        let request = TrackerCategoryEntity.fetchRequest()
        let result = try context.fetch(request)
        return try result.map { trackerCategoryEntity in
            guard let id = trackerCategoryEntity.id,
                  let header = trackerCategoryEntity.header,
                  let items = trackerCategoryEntity.items as? Set<TrackerEntity>
            else { throw StoreError.decodeError }
            return TrackerCategory(
                    id: id,
                    header: header,
                    items: try items.map { try trackerMapper.map(from: $0) }
            )
        }
    }

    private func addTacker(_ tracker: Tracker, to category: TrackerCategoryEntity) throws {
        let trackerEntity = try trackerMapper.map(from: tracker, context: context)
        category.addToItems(trackerEntity)
    }
}
