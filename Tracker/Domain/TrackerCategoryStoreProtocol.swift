//
// Created by Андрей Парамонов on 27.10.2023.
//

import Foundation

protocol TrackerCategoryStoreProtocol {
    func createOrUpdate(header: String, tracker: Tracker) throws
}
