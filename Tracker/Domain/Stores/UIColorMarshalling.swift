//
// Created by Андрей Парамонов on 10.10.2023.
//

import Foundation
import UIKit

// TODO: rewrite this implementation
final class UIColorMarshalling {
    func hexString(from color: UIColor) -> String {
        let components = color.cgColor.components!
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let a = Float(components[3])
        if a == 1.0 {
            let rgb = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
            return String(format: "#%06x", rgb)
        } else {
            let rgba = (Int)(r * 255) << 24 | (Int)(g * 255) << 16 | (Int)(b * 255) << 8 | (Int)(a * 255) << 0
            return String(format: "#%08x", rgba)
        }
    }

    func color(from hexString: String) -> UIColor {
        UIColor(hex: hexString)
    }
}
