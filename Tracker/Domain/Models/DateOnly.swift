//
// Created by Андрей Парамонов on 30.11.2023.
//

import Foundation

struct DateOnly: Hashable, Equatable, Comparable {
    let year: Int
    let month: Int
    let day: Int

    public static var today: DateOnly {
        DateOnly(Date())
    }

    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    init(_ date: Date) {
        let calendar = Calendar.current
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
    }

    var date: Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }

    var dayOfWeek: WeekDay? {
        date.dayOfWeek()
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(year)
        hasher.combine(month)
        hasher.combine(day)
    }

    func addingDays(_ days: Int) -> DateOnly {
        let date = Calendar.current.date(byAdding: .day, value: days, to: date)!
        return DateOnly(date)
    }

    static func ==(lhs: DateOnly, rhs: DateOnly) -> Bool {
        lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }

    static func <(lhs: DateOnly, rhs: DateOnly) -> Bool {
        lhs.date < rhs.date
    }
}
