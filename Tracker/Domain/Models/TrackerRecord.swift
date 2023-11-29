//
// Created by Андрей Парамонов on 23.09.2023.
//

import Foundation

struct TrackerRecord: Hashable {
    let trackerId: UUID
    let date: Date

    init(trackerId: UUID, date: Date) {
        self.trackerId = trackerId
        self.date = date.stripTime()
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(trackerId)
        hasher.combine(date)
    }
}
