//
// Created by Андрей Парамонов on 10.10.2023.
//

import Foundation
import UIKit
import CoreData

final class TrackerStore {
    private let context: NSManagedObjectContext
    private let colorMarshalling = UIColorMarshalling()
    private let scheduleMarshalling = ScheduleMarshalling()

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    convenience init() {
//        self.init(context: CoreDataStack.shared.context)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    func addTracker(_ tracker: Tracker) throws {
        let trackerEntity = TrackerEntity(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.hexColor = colorMarshalling.hexString(from: tracker.color)
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = scheduleMarshalling.toByte(from: tracker.schedule)
        try context.save()
    }
}
