//
// Created by Андрей Парамонов on 28.09.2023.
//

import Foundation

protocol AddTrackerDelegate: AnyObject {
    func addTracker(tracker: Tracker, to category: TrackerCategory)
}
