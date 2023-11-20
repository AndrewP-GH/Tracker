//
// Created by Андрей Парамонов on 18.11.2023.
//

import Foundation

protocol TrackersViewModelProtocol: TrackersViewDelegate {
    var reloadDataDelegate: (() -> Void)? { get set }

    var currentDate: Date { get }
    var placeholderStateObservable: Observable<PlaceholderState> { get }

    func dateChanged(to date: Date)
    func searchTextChanged(to text: String?)
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func categoryName(at: Int) -> String
    func cellModel(at indexPath: IndexPath) -> CellModel
}
