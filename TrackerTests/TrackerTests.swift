//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Андрей Парамонов on 22.04.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmptyTrackersList() throws {
        let trackersViewModel = FakeTrackersViewModel()
        let trackersViewController = TrackersViewController(viewModel: trackersViewModel)

        assertSnapshot(matching: trackersViewController, as: .image)
    }

    final class FakeTrackersViewModel: TrackersViewModelProtocol {
        var trackersDidChange: (() -> Void)?

        private(set) var currentDateObservable: Observable<Date> = .init(wrappedValue: Date())
        private(set) var currentFilter: Filter = .all

        var placeholderStateObservable: Observable<PlaceholderState> = .init(wrappedValue: .noResults)
        
        init(){
        }

        func dateChanged(to date: Date) {
        }

        func searchTextChanged(to text: String?) {
        }

        func viewDidLoad() {
        }

        func numberOfSections() -> Int {
           0
        }

        func numberOfItems(in section: Int) -> Int {
           0
        }

        func categoryName(at: Int) -> String {
           "TestCategory"
        }

        func cellModel(at indexPath: IndexPath) -> CellModel {
            CellModel(tracker: Tracker(id: UUID(),
                                       name: "TestTracker",
                                       color: .red,
                                       emoji: "e",
                                       schedule: nil,
                                       createdAt: Date(),
                                       isPinned: false), completedDays: 0, isDone: false, canBeDone: true)
        }

        func getPinAction(at: IndexPath) -> PinAction {
            .pin
        }

        func pinTracker(at indexPath: IndexPath) {
        }

        func unpinTracker(at: IndexPath) {
        }

        func trackerType(at: IndexPath) -> TrackerType {
            .irregularEvent
        }

        func getEditState(at: IndexPath) -> EditState {
            let tracker = Tracker(id: UUID(),
                                  name: "TestTracker",
                                  color: .red,
                                  emoji: "e",
                                  schedule: nil,
                                  createdAt: Date(),
                                  isPinned: false)
            return EditState(cell: CellModel(tracker: tracker, completedDays: 0, isDone: false, canBeDone: true),
                      category: TrackerCategory(id: UUID(), header: "TestCategory"))
        }

        func editTracker(result: EditTrackerResult) {
        }

        func deleteTracker(at indexPath: IndexPath) {
        }

        func didCompleteTracker(id: UUID) {
        }

        func didUncompleteTracker(id: UUID) {
        }

        func addTrackerToCategory(category: TrackerCategory, tracker: Tracker) {
        }

        func fetchedObjects(trackersByCategory: [String: [Tracker]]) {
        }

        func didSelect(filter: Filter) {
        }
    }
}
