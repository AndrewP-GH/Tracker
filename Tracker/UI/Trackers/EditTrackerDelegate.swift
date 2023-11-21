//
// Created by Андрей Парамонов on 21.11.2023.
//

import Foundation

protocol EditTrackerDelegate: AnyObject {
    func invoke(tracker: Tracker, category: TrackerCategory, previousCategory: TrackerCategory)
}
