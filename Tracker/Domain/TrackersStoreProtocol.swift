//
// Created by Андрей Парамонов on 24.10.2023.
//

import Foundation

protocol TrackersStoreProtocol {
    func filter(prefix: String?, weekDay: WeekDay)
    func performFetch()
    func update(tracker: Tracker) throws
    func category(for tracker: Tracker) throws -> TrackerCategory
    func delete(tracker: Tracker) throws
    func countBy(date: Date) throws -> Int

    var delegate: TrackersViewDelegate? { get set }
}
