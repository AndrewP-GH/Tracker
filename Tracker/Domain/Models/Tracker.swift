//
// Created by Андрей Парамонов on 23.09.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule?
    let createdAt: Date
    var isPinned: Bool

    init(id: UUID, name: String, color: UIColor, emoji: String, schedule: Schedule?, createdAt: Date, isPinned: Bool) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.createdAt = createdAt.stripTime()
        self.isPinned = isPinned
    }
}
