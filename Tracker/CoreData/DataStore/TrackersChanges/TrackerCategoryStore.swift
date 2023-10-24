//
// Created by Андрей Парамонов on 11.10.2023.
//

import Foundation
import UIKit
import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    private let trackerMapper = TrackerEntityMapper()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func add(_ trackerCategory: TrackerCategory) throws {
        let trackerCategoryEntity = TrackerCategoryEntity(context: context)
        trackerCategoryEntity.header = trackerCategory.header
        trackerCategoryEntity.addToItems(
                NSSet(array: trackerCategory.items.map { trackerMapper.map(from: $0, context: context) })
        )
        try context.save()
    }
}
