//
// Created by Андрей Парамонов on 11.10.2023.
//

import Foundation
import CoreData

final class TrackerEntityMapper {
    private let colorMarshalling = UIColorMarshalling()
    private let scheduleMarshalling = ScheduleMarshalling()

    func toEntity(from tracker: Tracker, context: NSManagedObjectContext) -> TrackerEntity {
        let trackerEntity = TrackerEntity(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.hexColor = colorMarshalling.hexString(from: tracker.color)
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = scheduleMarshalling.toByte(from: tracker.schedule)
        return trackerEntity
    }
}
