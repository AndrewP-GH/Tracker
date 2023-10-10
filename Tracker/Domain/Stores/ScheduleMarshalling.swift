//
// Created by Андрей Парамонов on 10.10.2023.
//

import Foundation

final class ScheduleMarshalling {
    func toByte(from schedule: Schedule?) -> Data? {
        guard let schedule else {
            return nil
        }
        var byte: UInt8 = 0
        schedule.days.forEach { day in
            byte |= 1 << day.rawValue
        }
        return Data([byte])
    }

    func toSchedule(from data: Data?) -> Schedule? {
        guard let data else {
            return nil
        }
        let byte = data[0]
        var days = Set<WeekDay>()
        for day in WeekDay.allCases {
            if byte & (1 << day.rawValue) != 0 {
                days.insert(WeekDay(rawValue: day.rawValue)!)
            }
        }
        return Schedule(days: days)
    }
}
