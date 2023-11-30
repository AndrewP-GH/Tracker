//
// Created by Андрей Парамонов on 26.11.2023.
//

import Foundation

protocol FiltersViewControllerDelegate: AnyObject {
    func didSelect(filter: Filter)
}
