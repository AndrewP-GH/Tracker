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

    func testEmptyTrackersVCLight() throws {
        let trackersViewModel = FakeTrackersViewModel(isEmpty: true)
        let vc = TrackersViewController(viewModel: trackersViewModel)

        let traits = UITraitCollection.init(userInterfaceStyle: .light)
        assertSnapshot(matching: vc, as: .image(traits: traits))
    }

    func testOneItemTrackersVCLight() throws {
        let trackersViewModel = FakeTrackersViewModel(isEmpty: false)
        let vc = TrackersViewController(viewModel: trackersViewModel)

        let traits = UITraitCollection.init(userInterfaceStyle: .light)
        assertSnapshot(matching: vc, as: .image(traits: traits))
    }
    
    func testEmptyTrackersVCDark() throws {
        let trackersViewModel = FakeTrackersViewModel(isEmpty: true)
        let vc = TrackersViewController(viewModel: trackersViewModel)

        let traits = UITraitCollection.init(userInterfaceStyle: .dark)
        assertSnapshot(matching: vc, as: .image(traits: traits))
    }

    func testOneItemTrackersVCDark() throws {
        let trackersViewModel = FakeTrackersViewModel(isEmpty: false)
        let vc = TrackersViewController(viewModel: trackersViewModel)

        let traits = UITraitCollection.init(userInterfaceStyle: .dark)
        assertSnapshot(matching: vc, as: .image(traits: traits))
    }

    final class FakeTrackersViewModel: TrackersViewModelProtocol {
        var trackersDidChange: (() -> Void)?

        private(set) var currentDateObservable: Observable<Date> = .init(wrappedValue: Date())
        private(set) var currentFilter: Filter = .all

        var placeholderStateObservable: Observable<PlaceholderState> = .init(wrappedValue: .empty)
        private let isEmpty: Bool

        init(isEmpty: Bool){
            self.isEmpty = isEmpty
        }

        func setCurrentDate(to date: Date) {
        }

        func searchTextChanged(to text: String?) {
        }

        func viewDidLoad() {
        }

        func numberOfSections() -> Int {
            isEmpty ? 0 : 1
        }

        func numberOfItems(in section: Int) -> Int {
           isEmpty ? 0 : 1
        }

        func categoryName(at: Int) -> String {
           "TestCategory"
        }

        func cellModel(at indexPath: IndexPath) -> CellModel {
            CellModel(tracker: Tracker(id: UUID(),
                                       name: "TestTracker",
                                       color: .red,
                                       emoji: "🍔",
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

        func getEditState(at: IndexPath) -> EditState? {
            let tracker = Tracker(id: UUID(),
                                  name: "TestTracker",
                                  color: .red,
                                  emoji: "🍔",
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
