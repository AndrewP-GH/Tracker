//
// Created by Андрей Парамонов on 26.11.2023.
//

import Foundation

struct DateMarshalling {
    private final class Formatter {
        static let timeTruncatedFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }

    func toString(from date: Date) -> String {
        Formatter.timeTruncatedFormatter.string(from: date)
    }

    func toDate(from string: String) -> Date? {
        Formatter.timeTruncatedFormatter.date(from: string)
    }
}
