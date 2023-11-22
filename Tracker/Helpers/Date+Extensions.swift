//
// Created by Андрей Парамонов on 04.10.2023.
//

import Foundation

extension Date {
    private final class Formatters {
        static let timeTruncatedFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }

    func dayOfWeek() -> WeekDay {
        let current = Calendar.current.component(.weekday, from: self)
        let first = Calendar.current.firstWeekday
        let wd = WeekDay(rawValue: (current + 7 - first) % 7 + 1)
        guard let wd else {
            fatalError("WeekDay is nil")
        }
        return wd
    }

    func dateOnly() -> String {
        Formatters.timeTruncatedFormatter.string(from: self)
    }
}
