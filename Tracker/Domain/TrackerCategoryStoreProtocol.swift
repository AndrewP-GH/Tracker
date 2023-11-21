//
// Created by Андрей Парамонов on 27.10.2023.
//

import Foundation

protocol TrackerCategoryStoreProtocol {
    func addTracker(to: TrackerCategory, tracker: Tracker) throws
    func getAll() throws -> [TrackerCategory]
    func create(category: TrackerCategory) throws
    func moveTracker(from: TrackerCategory, to: TrackerCategory, tracker: Tracker) throws
}
