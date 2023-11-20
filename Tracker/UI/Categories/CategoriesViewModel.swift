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
    var categoriesChangedDelegate: (() -> Void)?

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
            setPlaceholderState()
            categoriesChangedDelegate?()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func categoryCellModel(at index: Int) -> CategoryCellModel {
        let categories = try! categoryStore.getAll()
        let category = categories[index]
        return CategoryCellModel(category: category, isSelected: category == selectedCategory) { [weak self] category in
            self?.categorySelected(category)
        }
    }

    private func categorySelected(_ category: TrackerCategory) {
        selectedCategory = selectedCategory == category
                ? nil
                : category
        delegate?.setCategory(category: selectedCategory)
        categoriesChangedDelegate?()
    }

    func viewDidLoad() {
        setPlaceholderState()
    }

    private func setPlaceholderState() {
        placeholderState = numberOfItems() == 0
                ? .empty
                : .hide
    }
}
