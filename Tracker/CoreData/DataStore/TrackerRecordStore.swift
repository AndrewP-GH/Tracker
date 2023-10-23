//
// Created by Андрей Парамонов on 11.10.2023.
//

import Foundation
import UIKit
import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func add(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordEntity = TrackerRecordEntity(context: context)
        trackerRecordEntity.date = trackerRecord.date
        trackerRecordEntity.trackerId = trackerRecord.trackerId
        try context.save()
    }
}
