//
// Created by Андрей Парамонов on 19.11.2023.
//

import Foundation

struct CategoriesCellModel {
    let category: TrackerCategory
    let isSelected: Bool
    let categorySelectedDelegate: (TrackerCategory) -> Void
}
