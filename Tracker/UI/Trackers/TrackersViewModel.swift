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

    private lazy var trackerStore: TrackerStore = {
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

    func pinTracker(at indexPath: IndexPath) {

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
        self.trackersByCategory = trackersByCategory
                .sorted(by: { $0.key < $1.key })
                .map({ (category: $0.key, trackers: $0.value.sorted(by: { $0.name < $1.name })) })
        reloadDataDelegate?()
    }
}