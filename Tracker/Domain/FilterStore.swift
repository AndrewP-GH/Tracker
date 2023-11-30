//
// Created by Андрей Парамонов on 26.11.2023.
//

import Foundation

final class FilterStore {
    private let userDefaults = UserDefaults.standard
    private let selectedFilter = "selectedFilter"

    static let shared = FilterStore()

    private init() {}

    func getSelectedFilter() -> Filter {
        let value = userDefaults.integer(forKey: selectedFilter)
        return Filter(rawValue: value) ?? .all
    }

    func setSelectedFilter(_ filter: Filter) {
        userDefaults.set(filter.rawValue, forKey: selectedFilter)
    }
}
