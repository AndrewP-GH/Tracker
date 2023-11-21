//
// Created by Андрей Парамонов on 16.11.2023.
//

import Foundation

enum PlaceholderState {
    case hide
    case empty
    case noResults
}

final class TrackersViewModel: TrackersViewModelProtocol {
    private let categoryStore: TrackerCategoryStoreProtocol
    private let trackerRecordStore: TrackerRecordStoreProtocol

    private var trackersByCategory: [(category: String, trackers: [Tracker])] = []

    private lazy var trackerStore: TrackersStoreProtocol = {
        let trackerStore = TrackerStore()
        trackerStore.delegate = self
        return trackerStore
    }()

    var reloadDataDelegate: (() -> Void)?

    private(set) var currentDate: Date = Date() {
        didSet {
            updateContent()
        }
    }
    private(set) var searchQuery: String? {
        didSet {
            updateContent()
        }
    }

    @Observable
    private(set) var placeholderState: PlaceholderState = .hide
    var placeholderStateObservable: Observable<PlaceholderState> {
        $placeholderState
    }

    init(categoryStore: TrackerCategoryStoreProtocol, trackerRecordStore: TrackerRecordStoreProtocol) {
        self.categoryStore = categoryStore
        self.trackerRecordStore = trackerRecordStore
    }

    func dateChanged(to date: Date) {
        currentDate = date
    }

    func searchTextChanged(to text: String?) {
        searchQuery = text
    }

    func viewDidLoad() {
        updateContent()
    }

    private func updateContent() {
        let dayOfWeek = currentDate.dayOfWeek()
        let searchText = searchQuery?.trimmingCharacters(in: .whitespacesAndNewlines)
        trackerStore.filter(prefix: searchText, weekDay: dayOfWeek)
        placeholderState = getPlaceholderState()
    }

    private func getPlaceholderState() -> PlaceholderState {
        if trackersByCategory.count != 0 {
            return .hide
        }
        if searchQuery?.isEmpty != false {
            return .empty
        }
        return .noResults
    }

    func numberOfSections() -> Int {
        trackersByCategory.count
    }

    func numberOfItems(in section: Int) -> Int {
        trackersByCategory[section].trackers.count
    }

    func categoryName(at section: Int) -> String {
        trackersByCategory[section].category
    }

    func cellModel(at indexPath: IndexPath) -> CellModel {
        let tracker = trackersByCategory[indexPath.section].trackers[indexPath.row]
        let completedDays = trackerRecordStore.count(for: tracker.id)
        let isDone = trackerRecordStore.exists(TrackerRecord(trackerId: tracker.id, date: currentDate.dateOnly()))
        let isButtonEnabled = currentDate <= Date()
        return CellModel(tracker: tracker,
                         completedDays: completedDays,
                         isDone: isDone,
                         canBeDone: isButtonEnabled)
    }

    func getPinAction(at indexPath: IndexPath) -> PinAction {
        trackersByCategory[indexPath.section].trackers[indexPath.row].isPinned
                ? .unpin
                : .pin
    }

    func pinTracker(at indexPath: IndexPath) {
        var tracker = trackersByCategory[indexPath.section].trackers[indexPath.row]
        tracker.isPinned = true
        updateTracker(tracker)
    }

    func unpinTracker(at indexPath: IndexPath) {
        var tracker = trackersByCategory[indexPath.section].trackers[indexPath.row]
        tracker.isPinned = false
        updateTracker(tracker)
    }

    private func updateTracker(_ tracker: Tracker) {
        do {
            try trackerStore.update(tracker: tracker)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

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
            try categoryStore.addTracker(to: category, tracker: tracker)
            trackerStore.performFetch()
        } catch {
            fatalError(error.localizedDescription)
        }
        updateContent()
    }

    func fetchedObjects(trackersByCategory: [String: [Tracker]]) {
        self.trackersByCategory = aggregateResult(trackersByCategory)
        reloadDataDelegate?()
    }

    private func aggregateResult(_ trackersByCategory: [String: [Tracker]]) -> [(category: String, trackers: [Tracker])] {
        var filteredResult = [(category: String, trackers: [Tracker])]()
        var pinned = [Tracker]()
        for (category, trackers) in trackersByCategory {
            if category.isEmpty || trackers.isEmpty {
                continue
            }
            let inCategory = trackers.reduce(into: [Tracker]()) { (result, tracker) in
                tracker.isPinned
                        ? pinned.append(tracker)
                        : result.append(tracker)
            }
            if !inCategory.isEmpty {
                filteredResult.append((category: category, trackers: inCategory.sorted(by: trackersSortRule)))
            }
        }
        filteredResult = filteredResult.sorted(by: { $0.category < $1.category })
        if pinned.isEmpty {
            return filteredResult
        }
        return [(category: "Закрепленные", trackers: pinned.sorted(by: trackersSortRule))]
                + filteredResult
    }

    private func trackersSortRule(_ lhs: Tracker, _ rhs: Tracker) -> Bool {
        lhs.name < rhs.name
    }
}