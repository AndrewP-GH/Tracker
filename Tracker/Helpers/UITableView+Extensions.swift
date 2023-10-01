//
// Created by Андрей Парамонов on 01.10.2023.
//

import Foundation
import UIKit

extension UITableView {
    func isLastCellInSection(at indexPath: IndexPath) -> Bool {
        indexPath.row == numberOfRows(inSection: indexPath.section) - 1
    }
}