//
// Created by Андрей Парамонов on 22.11.2023.
//

import Foundation

enum EditTrackerResult {
    case edit(tracker: Tracker)
    case editAndMove(tracker: Tracker, to: TrackerCategory, from: TrackerCategory)
}
