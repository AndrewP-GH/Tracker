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

    public convenience init?(hex: String) {
        var hexColor: String
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexColor = String(hex[start...])
        } else {
            hexColor = hex
        }
        let r, g, b, a: CGFloat
        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber >> 16) & 0xFF) / 255
                g = CGFloat((hexNumber >> 8) & 0xFF) / 255
                b = CGFloat(hexNumber & 0xFF) / 255
                a = 1
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber >> 24) & 0xFF) / 255
                g = CGFloat((hexNumber >> 16) & 0xFF) / 255
                b = CGFloat((hexNumber >> 8) & 0xFF) / 255
                a = CGFloat(hexNumber & 0xFF) / 255
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        return nil
    }

}
