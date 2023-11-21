//
// Created by Андрей Парамонов on 18.11.2023.
//

import Foundation

protocol TrackersViewModelProtocol: TrackersViewDelegate, EditTrackerDelegate {
    var trackersDidChange: (() -> Void)? { get set }

    var currentDate: Date { get }
    var placeholderStateObservable: Observable<PlaceholderState> { get }

    func dateChanged(to date: Date)
    func searchTextChanged(to text: String?)
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func categoryName(at: Int) -> String
    func cellModel(at indexPath: IndexPath) -> CellModel
    func getPinAction(at: IndexPath) -> PinAction
    func pinTracker(at indexPath: IndexPath)
    func unpinTracker(at: IndexPath)
    func getTrackerType(at: IndexPath) -> TrackerType
    func category(for tracker: Tracker) -> TrackerCategory
}
