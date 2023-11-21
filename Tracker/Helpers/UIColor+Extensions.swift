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

    private static let hexRgbMultiplier = CGFloat(255.999999)

    //https://stackoverflow.com/a/39358741
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        if alpha == 1.0 {
            return String(
                    format: "#%02lX%02lX%02lX",
                    Int(red * UIColor.hexRgbMultiplier),
                    Int(green * UIColor.hexRgbMultiplier),
                    Int(blue * UIColor.hexRgbMultiplier)
            )
        } else {
            return String(format: "#%02lX%02lX%02lX%02lX",
                          Int(red * UIColor.hexRgbMultiplier),
                          Int(green * UIColor.hexRgbMultiplier),
                          Int(blue * UIColor.hexRgbMultiplier),
                          Int(alpha * UIColor.hexRgbMultiplier)
            )
        }
    }

    public convenience init?(hex: String) {
        var hexColor: String
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexColor = String(hex[start...])
        } else {
            hexColor = hex
        }
        let r, g, b: UInt64
        let a: CGFloat
        switch hexColor.count {
        case 6: // RGB
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            if scanner.scanHexInt64(&hexNumber) {
                r = (hexNumber >> 16) & 0xFF
                g = (hexNumber >> 8) & 0xFF
                b = hexNumber & 0xFF
                a = 1
                self.init(r: r, g: g, b: b, alpha: a)
                return
            }
        case 8: // ARGB
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            if scanner.scanHexInt64(&hexNumber) {
                r = (hexNumber >> 24) & 0xFF
                g = (hexNumber >> 16) & 0xFF
                b = (hexNumber >> 8) & 0xFF
                a = CGFloat(hexNumber & 0xFF) / 255
                self.init(r: r, g: g, b: b, alpha: a)
                return
            }
        default:
            break
        }
        return nil
    }

    public convenience init(r: UInt64, g: UInt64, b: UInt64, alpha: CGFloat = 1.0) {
        self.init(
                red: CGFloat(r) / 255,
                green: CGFloat(g) / 255,
                blue: CGFloat(b) / 255,
                alpha: alpha
        )
    }
}
