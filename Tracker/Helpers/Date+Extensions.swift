//
// Created by Андрей Парамонов on 04.10.2023.
//

import Foundation

extension Date {
    func dayOfWeek() -> WeekDay? {
        let current = Calendar.current.component(.weekday, from: self)
        let first = Calendar.current.firstWeekday
        let wd = WeekDay(rawValue: (current + 7 - first) % 7 + 1)
        guard let wd else {
            assertionFailure("WeekDay is nil")
            return nil
        }
        return wd
    }

    func isDateEqual(to date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }

    func dateOnly() -> DateOnly {
        DateOnly(self)
    }
}
