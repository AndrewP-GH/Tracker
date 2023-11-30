//
// Created by Андрей Парамонов on 03.10.2023.
//

import UIKit

final class CategoryHeaderReusableView: UICollectionReusableView {
    static let identifier = "CategoryHeaderReusableView"

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(with title: String) {
        label.text = title
    }

    private func setupView() {
        backgroundColor = .clear
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        addSubview(label)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                    label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                    label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                    label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
                ]
        )
    }
}
