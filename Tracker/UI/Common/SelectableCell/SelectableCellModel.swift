//
// Created by Андрей Парамонов on 19.11.2023.
//

import Foundation

struct SelectableCellModel<T> {
    let value: T
    let isSelected: Bool
    let title: String
    let valueSelectedDelegate: (T) -> Void
}
