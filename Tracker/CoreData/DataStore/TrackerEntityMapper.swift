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
        trackerEntity.schedule = scheduleMarshalling.toByte(from: tracker.schedule)
        trackerEntity.createdAt = tracker.createdAt
        return trackerEntity
    }

    func map(from trackerEntity: TrackerEntity) -> Tracker {
        let color = colorMarshalling.color(from: trackerEntity.hexColor!)
        let schedule = scheduleMarshalling.toSchedule(from: trackerEntity.schedule)
        return Tracker(id: trackerEntity.id!,
                       name: trackerEntity.name!,
                       color: color,
                       emoji: trackerEntity.emoji!,
                       schedule: schedule,
                       createdAt: trackerEntity.createdAt!)
    }

    func map(from dayOfWeak: WeekDay) -> Data? {
        let days: Set<WeekDay> = [dayOfWeak]
        return scheduleMarshalling.toByte(from: days)
    }
}
