//
// Created by Андрей Парамонов on 18.11.2023.
//

import Foundation

final class CellModel {
    let tracker: Tracker
    let completedDays: Int
    let isDone: Bool
    let canBeDone: Bool

    init(tracker: Tracker, completedDays: Int, isDone: Bool, canBeDone: Bool) {
        self.tracker = tracker
        self.completedDays = completedDays
        self.isDone = isDone
        self.canBeDone = canBeDone
    }
}
