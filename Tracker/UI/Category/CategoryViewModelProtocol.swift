//
// Created by Андрей Парамонов on 19.11.2023.
//

import Foundation

protocol CategoryViewModelProtocol {
    var categoryChangedDelegate: (() -> Void)? { get set }
    var selectedCategory: TrackerCategory? { get set }

    func numberOfItems() -> Int
    func category(at index: Int) -> CategoryModel
}
