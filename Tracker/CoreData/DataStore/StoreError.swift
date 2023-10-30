//
// Created by Андрей Парамонов on 28.10.2023.
//

import Foundation

struct StoreError {
    static let decodeError = NSError(domain: "Decode error", code: 0, userInfo: nil)
    static let encodeError = NSError(domain: "Encode error", code: 0, userInfo: nil)
}
