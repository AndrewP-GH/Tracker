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
                           UIColor.init(r: 0, g: 123, b: 250),
                           UIColor.init(r: 70, g: 230, b: 157),
                           UIColor.init(r: 253, g: 76, b: 73),
                       ],
                       startPoint: .unitCoordinate(.right),
                       endPoint: .unitCoordinate(.left),
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
