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

    convenience init() {
//        self.init(context: CoreDataStack.shared.context)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    func add(_ tracker: Tracker) throws {
        _ = mapper.toEntity(from: tracker, context: context)
        try context.save()
    }
}
