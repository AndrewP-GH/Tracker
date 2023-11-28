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
    }

    func configure(with model: StatisticsCellModel) {
        titleLabel.text = model.title
        valueLabel.text = String(model.value)
    }

    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = 16
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
    }
}
