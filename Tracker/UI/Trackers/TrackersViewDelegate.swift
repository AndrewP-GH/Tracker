//
// Created by Андрей Парамонов on 04.10.2023.
//

import Foundation

protocol TrackersViewDelegate: AnyObject {
    func didCompleteTracker(id: UUID)
    func didUncompleteTracker(id: UUID)
    func addTrackerToCategory(category: TrackerCategory, tracker: Tracker)
    func fetchedObjects(trackersByCategory: [String: [Tracker]])
}
