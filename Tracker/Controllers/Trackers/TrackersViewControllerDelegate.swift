//
// Created by Андрей Парамонов on 04.10.2023.
//

import Foundation

protocol TrackersViewControllerDelegate: AnyObject {
    func didCompleteTracker(id: UUID)
    func didUncompleteTracker(id: UUID)
    func addTrackerToCategory(category: String, tracker: Tracker)
    func updateTrackers(changes: TrackersChanges)
}
