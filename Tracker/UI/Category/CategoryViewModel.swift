//
// Created by Андрей Парамонов on 19.11.2023.
//

import Foundation

final class CategoryViewModel: CategoryViewModelProtocol {
    let categoryStore: TrackerCategoryStoreProtocol
    weak var delegate: CreateTrackerViewControllerDelegate?

    private var selectedCategory: TrackerCategory?

    var categoryChangedDelegate: (() -> Void)?

    init(trackerCategoryStore: TrackerCategoryStoreProtocol, delegate: CreateTrackerViewControllerDelegate) {
        categoryStore = trackerCategoryStore
        self.delegate = delegate
    }

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
            guard let self else { return }
            self.selectedCategory = self.selectedCategory == category
                    ? nil
                    : category
            self.categoryChangedDelegate?()
        }
    }

    func applyTapped() {
        guard let selectedCategory = selectedCategory else { return }
        delegate?.setCategory(category: selectedCategory)
    }
}
