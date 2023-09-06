//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Андрей Парамонов on 09.05.2023.
//

import UIKit

extension UIColor {
    static var ypBackground: UIColor { UIColor(named: "YP Background")! }
    static var ypBlack: UIColor { UIColor(named: "YP Black")! }
    static var ypBlue: UIColor { UIColor(named: "YP Blue")! }
    static var ypGray: UIColor { UIColor(named: "YP Gray")! }
    static var ypLightGrey: UIColor { UIColor(named: "YP Light Gray")! }
    static var ypRed: UIColor { UIColor(named: "YP Red")! }
    static var ypWhite: UIColor { UIColor(named: "YP White")! }

    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
                red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
                green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
                blue: CGFloat(rgb & 0xFF) / 255.0,
                alpha: alpha
        )
    }
}
