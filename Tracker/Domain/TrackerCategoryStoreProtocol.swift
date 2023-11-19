//
// Created by Андрей Парамонов on 27.10.2023.
//

import Foundation

protocol TrackerCategoryStoreProtocol {
    func createOrUpdate(category: TrackerCategory, tracker: Tracker) throws
    func getAll() throws -> [TrackerCategory]
}
