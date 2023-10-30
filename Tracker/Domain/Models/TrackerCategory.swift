//
// Created by Андрей Парамонов on 23.09.2023.
//

import Foundation

struct TrackerCategory {
    let id: UUID
    let header: String
    let items: [Tracker]

    init(id: UUID,
         header: String,
         items: [Tracker]) {
        self.id = id
        self.header = header
        self.items = items
    }
}
