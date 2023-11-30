//
// Created by Андрей Парамонов on 10.10.2023.
//

import UIKit

final class UIColorMarshalling {
    func hexString(from color: UIColor) throws -> String {
        guard let hex = color.hexString else { throw StoreError.encodeError }
        return hex
    }

    func color(from hexString: String) throws -> UIColor {
        guard let color = UIColor(hex: hexString) else { throw StoreError.decodeError }
        return color
    }
}
