//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Андрей Парамонов on 22.04.2023.
//

import UIKit

extension TrackersViewController: TrackersViewControllerDelegate {
    func didCompleteTracker(id: UUID) {
        let trackerRecord = TrackerRecord(trackerId: id, date: currentDate.dateOnly())
        completedTrackers.insert(trackerRecord)
    }

    func didUncompleteTracker(id: UUID) {
        let trackerRecord = TrackerRecord(trackerId: id, date: currentDate.dateOnly())
        completedTrackers.remove(trackerRecord)
    }

    func addTrackerToCategory(category: String, tracker: Tracker) {
        let categoryIndex = categories.firstIndex(where: { $0.header == category })
        if let categoryIndex {
            categories[categoryIndex] = TrackerCategory(
                    header: category,
                    items: categories[categoryIndex].items + [tracker]
            )
        } else {
            categories.append(TrackerCategory(header: category, items: [tracker]))
        }
        updateContent()
    }
}
