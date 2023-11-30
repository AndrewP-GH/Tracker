//
// Created by Андрей Парамонов on 29.11.2023.
//

import UIKit

public extension UIView {
    // https://stackoverflow.com/a/62091073
    // I was inspired by this answer but it had several bugs so the final implementation is a bit different
    private static let GradientBorderLayerName = "GradientBorderLayer"

    func gradientBorder(
            width: CGFloat,
            colors: [UIColor],
            startPoint: CGPoint = .init(x: 0.0, y: 0.0),
            endPoint: CGPoint = .init(x: 1.0, y: 1.0),
            cornerRadius: CGFloat = 0
    ) {
        if gradientBorderLayer() != nil {
            return
        }
        let border = CAGradientLayer()
        border.frame = self.bounds
        border.colors = colors.map(\.cgColor)
        border.startPoint = startPoint
        border.endPoint = endPoint

        let mask = CAShapeLayer()
        let maskRect = CGRect(
                x: bounds.origin.x + width / 2, // cause width/2 is applied on both sides of the mask rect
                y: bounds.origin.y + width / 2,
                width: bounds.size.width - width,
                height: bounds.size.height - width
        )
        mask.path = UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.black.cgColor
        mask.lineWidth = width

        border.mask = mask
        layer.addSublayer(border)
    }

    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter {
            $0.name == UIView.GradientBorderLayerName
        }
        if borderLayers?.count ?? 0 > 1 {
            assertionFailure("There should be at most 1 gradient border layer")
            return nil
        }
        return borderLayers?.first as? CAGradientLayer
    }
}
