//
// Created by Андрей Парамонов on 19.11.2023.
//

import Foundation

final class CategoryViewModel: CategoryViewModelProtocol {
    let categoryStore: TrackerCategoryStoreProtocol
    weak var delegate: CreateTrackerViewControllerDelegate?

    init(trackerCategoryStore: TrackerCategoryStoreProtocol, delegate: CreateTrackerViewControllerDelegate) {
        categoryStore = trackerCategoryStore
        self.delegate = delegate
    }

    var selectedCategory: TrackerCategory?
    var categoryChangedDelegate: (() -> Void)?

    func numberOfItems() -> Int {
        do {
            return try categoryStore.getAll().count
        } catch {
            return 0
        }
    }

    func category(at index: Int) -> CategoryModel {
        let categories = try! categoryStore.getAll()
        let category = categories[index]
        return CategoryModel(category: category, isSelected: category == selectedCategory) { [weak self] category in
            self?.categorySelected(category)
        }
    }

    private func categorySelected(_ category: TrackerCategory) {
        selectedCategory = selectedCategory == category
                ? nil
                : category
        delegate?.setCategory(category: selectedCategory)
        categoryChangedDelegate?()
    }
}
