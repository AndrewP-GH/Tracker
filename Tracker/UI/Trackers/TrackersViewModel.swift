//
// Created by Андрей Парамонов on 16.11.2023.
//

import Foundation

final class TrackersViewModel {
    let categoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()
    let trackerRecordStore: TrackerRecordStoreProtocol = TrackerRecordStore()

    lazy var trackerStore: TrackerStore = {
        let trackerStore = TrackerStore()
        trackerStore.delegate = self
        return trackerStore
    }()

    var reloadDataDelegate: (() -> Void)?

    var currentDate: Date = Date() {
        didSet {
            updateContent()
        }
    }
    var searchQuery: String? {
        didSet {
            updateContent()
        }
    }

    @Observable
    private(set) var showPlaceholder: Bool = false

    init() {
    }

    func dateChanged(to date: Date) {
        currentDate = date
    }

    func searchTextChanged(to text: String?) {
        searchQuery = text
    }

    func updateContent() {
        let dayOfWeek = currentDate.dayOfWeek()
        let searchText = searchQuery?.trimmingCharacters(in: .whitespacesAndNewlines)
        trackerStore.filter(prefix: searchText, weekDay: dayOfWeek)
        showPlaceholder = trackerStore.categoriesCount() == 0
    }

    func numberOfSections() -> Int {
        trackerStore.categoriesCount()
    }

    func numberOfItems(in section: Int) -> Int {
        trackerStore.trackersCount(for: section)
    }

    func tracker(at indexPath: IndexPath) throws -> Tracker {
        try trackerStore.tracker(at: indexPath)
    }

    func days(for tracker: Tracker) -> Int {
        trackerRecordStore.count(for: tracker.id)
    }

    func isDone(for tracker: Tracker) -> Bool {
        trackerRecordStore.exists(TrackerRecord(trackerId: tracker.id, date: currentDate.dateOnly()))
    }

    func categoryName(at section: Int) -> String {
        trackerStore.categoryName(at: section)
    }

    func isCompleteEnabled() -> Bool {
        currentDate <= Date()
    }
}
