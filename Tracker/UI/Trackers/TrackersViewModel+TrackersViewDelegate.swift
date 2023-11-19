//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Андрей Парамонов on 22.04.2023.
//

import Foundation

extension TrackersViewModel: TrackersViewDelegate {
    func didCompleteTracker(id: UUID) {
        let trackerRecord = TrackerRecord(trackerId: id, date: currentDate.dateOnly())
        do {
            try trackerRecordStore.add(trackerRecord)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func didUncompleteTracker(id: UUID) {
        let trackerRecord = TrackerRecord(trackerId: id, date: currentDate.dateOnly())
        do {
            try trackerRecordStore.remove(trackerRecord)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func addTrackerToCategory(category: TrackerCategory, tracker: Tracker) {
        do {
            try categoryStore.createOrUpdate(category: category, tracker: tracker)
            trackerStore.performFetch()
        } catch {
            fatalError(error.localizedDescription)
        }
        updateContent()
    }

    func reloadData() {
        reloadDataDelegate?()
    }
}
