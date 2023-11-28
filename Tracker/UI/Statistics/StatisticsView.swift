//
// Created by Андрей Парамонов on 28.11.2023.
//

import UIKit

final class StatisticsView: UIView {
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientBorder(width: 1,
                       colors: [
                           UIColor.init(r: 253, g: 76, b: 73),
                           UIColor.init(r: 70, g: 230, b: 157),
                           UIColor.init(r: 0, g: 123, b: 250),
                       ],
                       startPoint: CGPoint(x: 0, y: 0.5),
                       endPoint: CGPoint(x: 1, y: 0.5),
                       cornerRadius: Constants.cornerRadius)
    }

    func configure(with model: StatisticsCellModel) {
        titleLabel.text = model.title
        valueLabel.text = String(model.value)
    }

    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true

        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(valueLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.defaultOffset),
                    valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultOffset),
                    valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultOffset),
                    valueLabel.heightAnchor.constraint(equalToConstant: 41),

                    titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 7),
                    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultOffset),
                    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultOffset),
                    titleLabel.heightAnchor.constraint(equalToConstant: 18),
                ]
        )
    }
}

extension StatisticsView {
    private enum Constants {
        static let defaultOffset: CGFloat = 12
        static let cornerRadius: CGFloat = 16
    }
}

public extension UIView {
    private static let kGradientBorderLayerName = "GradientBorderLayer"

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
                x: bounds.origin.x + width / 2, // cause half of the border applied to each side
                y: bounds.origin.y + width / 2,
                width: bounds.size.width - width,
                height: bounds.size.height - width
        )
        mask.path = UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.ypBackground.cgColor
        mask.lineWidth = width

        border.mask = mask
        layer.addSublayer(border)
    }

    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter {
            $0.name == UIView.kGradientBorderLayerName
        }
        if borderLayers?.count ?? 0 > 1 {
            assertionFailure("There should be at most 1 gradient border layer")
            return nil
        }
        return borderLayers?.first as? CAGradientLayer
    }
}
