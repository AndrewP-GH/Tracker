//
// Created by Андрей Парамонов on 29.11.2023.
//

import Foundation

public extension CGPoint {
    enum CoordinateSide {
        case topLeft, top, topRight, right, bottomRight, bottom, bottomLeft, left
    }

    static func unitCoordinate(_ side: CoordinateSide) -> CGPoint {
        let x: CGFloat
        let y: CGFloat

        switch side {
        case .topLeft:      x = 0; y = 0
        case .top:          x = 0.5; y = 0
        case .topRight:     x = 1; y = 0
        case .left:         x = 0; y = 0.5
        case .right:        x = 1; y = 0.5
        case .bottomLeft:   x = 0; y = 1
        case .bottom:       x = 0.5; y = 1
        case .bottomRight:  x = 1; y = 1
        }
        return .init(x: x, y: y)
    }
}
