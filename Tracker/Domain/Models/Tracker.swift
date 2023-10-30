//
// Created by Андрей Парамонов on 23.09.2023.
//

import Foundation
import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule?
    let createdAt: Date

    init(id: UUID,
         name: String,
         color: UIColor,
         emoji: String,
         schedule: Schedule?,
         createdAt: Date) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.createdAt = createdAt
    }
}
