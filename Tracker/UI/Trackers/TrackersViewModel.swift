//
// Created by Андрей Парамонов on 16.11.2023.
//

import Foundation

enum PlaceholderState {
    case hide
    case empty
    case noResults
}

typealias Category = (category: String, trackers: [Tracker])

final class TrackersViewModel: TrackersViewModelProtocol {
    private let categoryStore: TrackerCategoryStoreProtocol
    private let trackerRecordStore: TrackerRecordStoreProtocol
    private let trackerStore: TrackersStoreProtocol
    private let analyticsService = AnalyticsService()
    private let filterStore = FilterStore.shared

    private var visibleTrackers: [Category] = []

    var trackersDidChange: (() -> Void)?

    @Observable
    private(set) var currentDate: Date = Date() {
        didSet {
            let today = Date()
            if currentFilter == .today && currentDate != today {
                currentFilter = .all
            } else {
                updateContent()
            }
        }
    }
    var currentDateObservable: Observable<Date> {
        $currentDate
    }

    private(set) var searchQuery: String? {
        didSet {
            updateContent()
        }
    }

    var currentFilter: Filter = .all {
        didSet {
            filterStore.setSelectedFilter(currentFilter)
            let today = Date()
            if currentFilter == .today && currentDate != today {
                currentDate = today
            } else {
                updateContent()
            }
        }
    }

    @Observable
    private(set) var placeholderState: PlaceholderState = .hide
    var placeholderStateObservable: Observable<PlaceholderState> {
        $placeholderState
    }

    init(trackerStore: TrackersStoreProtocol,
         categoryStore: TrackerCategoryStoreProtocol,
         trackerRecordStore: TrackerRecordStoreProtocol) {
        self.trackerStore = trackerStore
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
        currentFilter = filterStore.getSelectedFilter()
    }

    private func updateContent() {
        let dayOfWeek = currentDate.dayOfWeek()
        let searchText = searchQuery?.trimmingCharacters(in: .whitespacesAndNewlines)
        trackerStore.filter(prefix: searchText, weekDay: dayOfWeek)
        placeholderState = getPlaceholderState()
    }

    private func getPlaceholderState() -> PlaceholderState {
        if visibleTrackers.count != 0 {
            return .hide
        }
        if searchQuery?.isEmpty != false {
            return .empty
        }
        return .noResults
    }

    func numberOfSections() -> Int {
        visibleTrackers.count
    }

    func numberOfItems(in section: Int) -> Int {
        visibleTrackers[section].trackers.count
    }

    func categoryName(at section: Int) -> String {
        visibleTrackers[section].category
    }

    func cellModel(at indexPath: IndexPath) -> CellModel {
        let tracker = visibleTrackers[indexPath.section].trackers[indexPath.row]
        let completedDays = trackerRecordStore.count(for: tracker.id)
        let isDone = trackerRecordStore.exists(TrackerRecord(trackerId: tracker.id, date: currentDate))
        let isButtonEnabled = currentDate <= Date()
        return CellModel(tracker: tracker,
                         completedDays: completedDays,
                         isDone: isDone,
                         canBeDone: isButtonEnabled)
    }

    func getPinAction(at indexPath: IndexPath) -> PinAction {
        visibleTrackers[indexPath.section].trackers[indexPath.row].isPinned
                ? .unpin
                : .pin
    }

    func pinTracker(at indexPath: IndexPath) {
        var tracker = visibleTrackers[indexPath.section].trackers[indexPath.row]
        tracker.isPinned = true
        updateTracker(tracker)
    }

    func unpinTracker(at indexPath: IndexPath) {
        var tracker = visibleTrackers[indexPath.section].trackers[indexPath.row]
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

    func trackerType(at indexPath: IndexPath) -> TrackerType {
        visibleTrackers[indexPath.section].trackers[indexPath.row].schedule != nil
                ? .habit
                : .irregularEvent
    }
}

extension TrackersViewModel: TrackersViewDelegate {
    func didCompleteTracker(id: UUID) {
        let trackerRecord = TrackerRecord(trackerId: id, date: currentDate)
        do {
            try trackerRecordStore.add(trackerRecord)
        } catch {
            fatalError(error.localizedDescription)
        }
        updateContent()
    }

    func didUncompleteTracker(id: UUID) {
        let trackerRecord = TrackerRecord(trackerId: id, date: currentDate)
        do {
            try trackerRecordStore.delete(trackerRecord)
        } catch {
            fatalError(error.localizedDescription)
        }
        updateContent()
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
        visibleTrackers = aggregateResult(trackersByCategory)
        trackersDidChange?()
    }

    private func aggregateResult(_ trackersByCategory: [String: [Tracker]]) -> [Category] {
        var filteredResult = [Category]()
        var pinned = [Tracker]()
        let finished: [UUID]
        switch currentFilter {
        case .finished, .unfinished:
            finished = getFinished(for: currentDate)
        default:
            finished = []
        }
        for (category, var trackers) in trackersByCategory {
            if category.isEmpty || trackers.isEmpty {
                continue
            }
            switch currentFilter {
            case .finished:
                trackers = trackers.filter({ finished.contains($0.id) })
            case .unfinished:
                trackers = trackers.filter({ !finished.contains($0.id) })
            default:
                break
            }
            let inCategory = trackers.reduce(into: [Tracker]()) { (result, tracker) in
                tracker.isPinned
                        ? pinned.append(tracker)
                        : result.append(tracker)
            }
            if !inCategory.isEmpty {
                filteredResult.append((category: category, trackers: inCategory.sorted(by: trackersSortOrder)))
            }
        }
        filteredResult = filteredResult.sorted(by: { $0.category < $1.category })
        if pinned.isEmpty {
            return filteredResult
        }
        return [(category: L10n.Localizable.Trackers.pinned, trackers: pinned.sorted(by: trackersSortOrder))]
                + filteredResult
    }


    private func getFinished(for date: Date) -> [UUID] {
        do {
            return try trackerRecordStore.get(for: date)
                    .map({ $0.trackerId })
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func trackersSortOrder(_ lhs: Tracker, _ rhs: Tracker) -> Bool {
        lhs.name < rhs.name
    }

    func category(for tracker: Tracker) -> TrackerCategory {
        do {
            return try trackerStore.category(for: tracker)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func getEditState(at: IndexPath) -> EditState {
        let cellModel = cellModel(at: at)
        let category = category(for: cellModel.tracker)
        return EditState(cell: cellModel, category: category)
    }

    func editTracker(result: EditTrackerResult) {
        do {
            switch result {
            case .edit(let tracker):
                try trackerStore.update(tracker: tracker)
            case .editAndMove(let tracker, let to, let from):
                try trackerStore.update(tracker: tracker)
                try categoryStore.moveTracker(from: from, to: to, tracker: tracker)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        updateContent()
    }

    func deleteTracker(at indexPath: IndexPath) {
        let tracker = visibleTrackers[indexPath.section].trackers[indexPath.row]
        do {
            try trackerStore.delete(tracker: tracker)
        } catch {
            fatalError(error.localizedDescription)
        }
        updateContent()
    }
}

extension TrackersViewModel: FiltersViewControllerDelegate {
    func didSelect(filter: Filter) {
        currentFilter = filter
    }
}