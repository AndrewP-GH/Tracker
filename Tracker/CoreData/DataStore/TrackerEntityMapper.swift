//
// Created by Андрей Парамонов on 11.10.2023.
//

import Foundation
import CoreData

final class TrackerEntityMapper {
    private let colorMarshalling = UIColorMarshalling()
    private let scheduleMarshalling = ScheduleMarshalling()

    func map(from tracker: Tracker, context: NSManagedObjectContext) throws -> TrackerEntity {
        let trackerEntity = TrackerEntity(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.hexColor = try colorMarshalling.hexString(from: tracker.color)
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = scheduleMarshalling.toString(from: tracker.schedule)
        trackerEntity.createdAt = tracker.createdAt
        trackerEntity.isPinned = tracker.isPinned
        return trackerEntity
    }

    func map(from tracker: Tracker, to trackerEntity: TrackerEntity) throws {
        trackerEntity.name = tracker.name
        trackerEntity.hexColor = try colorMarshalling.hexString(from: tracker.color)
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = scheduleMarshalling.toString(from: tracker.schedule)
        trackerEntity.createdAt = tracker.createdAt
        trackerEntity.isPinned = tracker.isPinned
    }

    func map(from trackerEntity: TrackerEntity) throws -> Tracker {
        guard let id = trackerEntity.id,
              let name = trackerEntity.name,
              let hexColor = trackerEntity.hexColor,
              let emoji = trackerEntity.emoji,
              let createdAt = trackerEntity.createdAt
        else { throw StoreError.decodeError }
        let color = try colorMarshalling.color(from: hexColor)
        let schedule = scheduleMarshalling.toSchedule(from: trackerEntity.schedule)
        let isPinned = trackerEntity.isPinned
        return Tracker(id: id,
                       name: name,
                       color: color,
                       emoji: emoji,
                       schedule: schedule,
                       createdAt: createdAt,
                       isPinned: isPinned)
    }

    func map(from dayOfWeak: WeekDay) -> String {
        let days: Set<WeekDay> = [dayOfWeak]
        return scheduleMarshalling.toString(from: days)
    }
}
