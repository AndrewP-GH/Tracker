//
// Created by Андрей Парамонов on 04.10.2023.
//

import Foundation

extension Date {
    private final class Formatters {
        static let eeeeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter
        }()
    }

    func dayOfWeek() -> WeekDay {
        let weekDay = Formatters.eeeeFormatter.string(from: self)
        switch weekDay {
        case "Monday":
            return .monday
        case "Tuesday":
            return .tuesday
        case "Wednesday":
            return .wednesday
        case "Thursday":
            return .thursday
        case "Friday":
            return .friday
        case "Saturday":
            return .saturday
        case "Sunday":
            return .sunday
        default:
            return .monday
        }
    }
}
