//
// Created by Андрей Парамонов on 04.10.2023.
//

import Foundation

extension String {
    func startsWith(string: String) -> Bool {
        guard let range = range(of: string, options: [.anchored, .caseInsensitive]) else {
            return false
        }
        return range.lowerBound == startIndex
    }
}
