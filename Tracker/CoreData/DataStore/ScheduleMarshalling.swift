//
// Created by Андрей Парамонов on 10.10.2023.
//

import Foundation

final class ScheduleMarshalling {
    func toString(from schedule: Schedule?) -> String? {
        guard let schedule else {
            return nil
        }
        return toString(from: schedule.days)
    }

    func toSchedule(from data: String?) -> Schedule? {
        guard let data else {
            return nil
        }
        let days = Set(data.map { WeekDay(rawValue: Int.init(String($0))!)! })
        return Schedule(days: days)
    }

    func toString(from days: Set<WeekDay>) -> String {
        days.sorted().map { String($0.rawValue) }.joined()
    }
}
