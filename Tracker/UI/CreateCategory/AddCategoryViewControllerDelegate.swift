//
// Created by Андрей Парамонов on 20.11.2023.
//

import Foundation

protocol AddCategoryViewControllerDelegate: AnyObject {
    func addCategory(category: TrackerCategory)
}
