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
    let categoryStore: TrackerCategoryStoreProtocol
    let trackerRecordStore: TrackerRecordStoreProtocol

    lazy var trackerStore: TrackerStore = {
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
    private(set) var placeholderState: PlaceholderState = .empty
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

    func updateContent() {
        let dayOfWeek = currentDate.dayOfWeek()
        let searchText = searchQuery?.trimmingCharacters(in: .whitespacesAndNewlines)
        trackerStore.filter(prefix: searchText, weekDay: dayOfWeek)
        placeholderState = getPlaceholderState()
    }

    private func getPlaceholderState() -> PlaceholderState {
        if trackerStore.categoriesCount() != 0 {
            return .hide
        }
        if searchQuery?.isEmpty != false {
            return .empty
        }
        return .noResults
    }

    func numberOfSections() -> Int {
        trackerStore.categoriesCount()
    }

    func numberOfItems(in section: Int) -> Int {
        trackerStore.trackersCount(for: section)
    }

    func categoryName(at section: Int) -> String {
        trackerStore.categoryName(at: section)
    }

    func cellModel(at indexPath: IndexPath) -> CellModel {
        let tracker = try! trackerStore.tracker(at: indexPath)
        let completedDays = trackerRecordStore.count(for: tracker.id)
        let isDone = trackerRecordStore.exists(TrackerRecord(trackerId: tracker.id, date: currentDate.dateOnly()))
        let isButtonEnabled = currentDate <= Date()
        return CellModel(tracker: tracker,
                         completedDays: completedDays,
                         isDone: isDone,
                         canBeDone: isButtonEnabled)
    }
}
