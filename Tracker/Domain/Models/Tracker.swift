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
    let createdAt: DateOnly
    var isPinned: Bool
}
