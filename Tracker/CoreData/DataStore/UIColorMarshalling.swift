//
// Created by Андрей Парамонов on 10.10.2023.
//

import Foundation
import UIKit

// TODO: rewrite this implementation
final class UIColorMarshalling {
    func hexString(from color: UIColor) -> String {
        color.hexString!
    }

    func color(from hexString: String) -> UIColor {
        UIColor(hex: hexString)!
    }
}
