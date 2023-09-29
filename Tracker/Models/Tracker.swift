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

    init(id: UUID, name: String, color: UIColor, emoji: String, schedule: Schedule?) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
}
