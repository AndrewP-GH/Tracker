//
// Created by Андрей Парамонов on 26.09.2023.
//

import Foundation
import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    static let identifier = "ColorCollectionViewCell"

    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    var value: UIColor = .clear {
        didSet {
            colorView.backgroundColor = value
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(colorView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
                    colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
                    colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
                    colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
                    colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                ]
        )
    }
}


