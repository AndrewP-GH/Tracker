//
// Created by Андрей Парамонов on 19.11.2023.
//

import Foundation

protocol CategoriesViewModelProtocol {
    var categoriesChangedDelegate: (() -> Void)? { get set }
    var selectedCategory: TrackerCategory? { get set }

    var placeholderStateObservable: Observable<PlaceholderState> { get }

    func numberOfItems() -> Int
    func categoryCellModel(at index: Int) -> CategoryCellModel
    func viewDidLoad()

    func addCategory(category: TrackerCategory)
}
