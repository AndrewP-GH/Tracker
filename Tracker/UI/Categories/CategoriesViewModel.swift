//
// Created by Андрей Парамонов on 19.11.2023.
//

import Foundation

final class CategoriesViewModel: CategoriesViewModelProtocol {
    let categoryStore: TrackerCategoryStoreProtocol
    weak var delegate: ConfigureTrackerViewControllerDelegate?

    init(trackerCategoryStore: TrackerCategoryStoreProtocol, delegate: ConfigureTrackerViewControllerDelegate) {
        categoryStore = trackerCategoryStore
        self.delegate = delegate
    }

    var selectedCategory: TrackerCategory?
    var categoriesChangedDelegate: (() -> Void)?
    var categorySelectedDelegate: (() -> Void)?

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
            print(error.localizedDescription)
        }
    }

    func categoryCellModel(at index: Int) -> SelectableCellModel<TrackerCategory> {
        let categories = try! categoryStore.getAll()
        let category = categories[index]
        return SelectableCellModel(
                value: category,
                isSelected: category == selectedCategory,
                title: category.header) { [weak self] category in
            self?.categorySelected(category)
        }
    }

    private func categorySelected(_ category: TrackerCategory) {
        selectedCategory = selectedCategory == category
                ? nil
                : category
        delegate?.setCategory(category: selectedCategory)
        categorySelectedDelegate?()
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
