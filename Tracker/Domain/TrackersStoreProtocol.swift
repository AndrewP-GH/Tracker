//
// Created by Андрей Парамонов on 24.10.2023.
//

import Foundation

protocol TrackersStoreProtocol {
    func categoriesCount() -> Int
    func trackersCount(for category: Int) -> Int
    func categoryName(at index: Int) -> String
    func tracker(at indexPath: IndexPath) throws -> Tracker
    func filter(prefix: String?, weekDay: WeekDay)
    func performFetch()

    var delegate: TrackersViewDelegate? { get set }
}
