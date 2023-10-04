//
// Created by Андрей Парамонов on 04.10.2023.
//

import Foundation

extension TrackerCategory {
    func hasTrackers() -> Bool {
        !items.isEmpty
    }

    func hasTrackers(for day: WeekDay, withoutSchedule: Bool = true) -> Bool {
        items.contains(where: { $0.schedule?.days.contains(day) ?? withoutSchedule })
    }

    func hasTrackers(startsWith prefix: String) -> Bool {
        items.contains(where: { $0.name.startsWith(string: prefix) })
    }
}