//
// Created by Андрей Парамонов on 26.09.2023.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell, CellWithValueProtocol {
    static let identifier = "EmojiCollectionViewCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()

    var value: String = "" {
        didSet {
            titleLabel.text = value
        }
    }

    var wasSelected: Bool = false {
        didSet {
            if wasSelected {
                contentView.backgroundColor = .ypLightGrey
            } else {
                contentView.backgroundColor = .clear
            }
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
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
                    titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
                    titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
                    titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
                    titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                ]
        )
    }
}
