//
// Created by Андрей Парамонов on 10.10.2023.
//

import Foundation
import UIKit
import CoreData

final class TrackerStore {
    private let context: NSManagedObjectContext
    private let mapper = TrackerEntityMapper()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func add(_ tracker: Tracker) throws {
        _ = mapper.createEntity(from: tracker, context: context)
        try context.save()
    }
}
