//
// Created by Андрей Парамонов on 23.09.2023.
//

import Foundation

struct TrackerCategory: Equatable {
    let id: UUID
    let header: String

    static func ==(lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.id == rhs.id
    }
}
