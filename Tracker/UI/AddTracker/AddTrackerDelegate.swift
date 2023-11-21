//
// Created by Андрей Парамонов on 28.09.2023.
//

import Foundation

protocol AddTrackerDelegate: AnyObject {
    func invoke(tracker: Tracker, category: TrackerCategory)
}
