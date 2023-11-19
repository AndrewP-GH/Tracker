//
// Created by Андрей Парамонов on 19.11.2023.
//

import Foundation

final class CategoriesViewModel: CategoriesViewModelProtocol {
    let categoryStore: TrackerCategoryStoreProtocol
    weak var delegate: CreateTrackerViewControllerDelegate?

    init(trackerCategoryStore: TrackerCategoryStoreProtocol, delegate: CreateTrackerViewControllerDelegate) {
        categoryStore = trackerCategoryStore
        self.delegate = delegate
    }

    var selectedCategory: TrackerCategory?
    var categoryChangedDelegate: (() -> Void)?

    @Observable
    private(set) var placeholderState: PlaceholderState = .hide
    var placeholderStateObservable: Observable<PlaceholderState> {
        $placeholderState
    }

    func numberOfItems() -> Int {
        do {
            return try categoryStore.getAll().count
        } catch {
            return 0
        }
    }

    func addCategory(category: TrackerCategory) {
        do {
            try categoryStore.create(category: category)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func category(at index: Int) -> CategoriesCellModel {
        let categories = try! categoryStore.getAll()
        let category = categories[index]
        return CategoriesCellModel(category: category, isSelected: category == selectedCategory) { [weak self] category in
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

    func viewDidLoad() {
        if numberOfItems() == 0 {
            placeholderState = .empty
        } else {
            placeholderState = .hide
        }
    }
}
