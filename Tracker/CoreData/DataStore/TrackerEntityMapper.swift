//
// Created by Андрей Парамонов on 11.10.2023.
//

import Foundation
import CoreData

final class TrackerEntityMapper {
    private let colorMarshalling = UIColorMarshalling()
    private let scheduleMarshalling = ScheduleMarshalling()

    func map(from tracker: Tracker, context: NSManagedObjectContext) -> TrackerEntity {
        let trackerEntity = TrackerEntity(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.hexColor = colorMarshalling.hexString(from: tracker.color)
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = scheduleMarshalling.toString(from: tracker.schedule)
        trackerEntity.createdAt = tracker.createdAt
        return trackerEntity
    }

    func map(from trackerEntity: TrackerEntity) throws -> Tracker {
        let color = colorMarshalling.color(from: trackerEntity.hexColor!)
        let schedule = scheduleMarshalling.toSchedule(from: trackerEntity.schedule)
        guard
                let id = trackerEntity.id,
                let name = trackerEntity.name,
                let emoji = trackerEntity.emoji,
                let createdAt = trackerEntity.createdAt
        else { throw StoreError.decodeError }
        return Tracker(id: id,
                       name: name,
                       color: color,
                       emoji: emoji,
                       schedule: schedule,
                       createdAt: createdAt)
    }

    func map(from dayOfWeak: WeekDay) -> String {
        let days: Set<WeekDay> = [dayOfWeak]
        return scheduleMarshalling.toString(from: days)
    }
}
