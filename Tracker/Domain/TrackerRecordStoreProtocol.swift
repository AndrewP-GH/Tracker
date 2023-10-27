//
// Created by Андрей Парамонов on 27.10.2023.
//

import Foundation

protocol TrackerRecordStoreProtocol {
    func add(_ trackerRecord: TrackerRecord) throws
    func remove(_ trackerRecord: TrackerRecord) throws
    func count(for trackerId: UUID) -> Int
    func isDone(_ trackerRecord: TrackerRecord) -> Bool
}
