//
// Created by Андрей Парамонов on 25.09.2023.
//

import Foundation
import UIKit

final class AddHabitTableViewCell: UITableViewCell {
    static let identifier = "AddHabitTableViewCell"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypGray
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()

    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "CellArrow")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .ypBackground
        selectionStyle = .none
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(arrowImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
                    arrowImageView.widthAnchor.constraint(equalToConstant: 24),
                    arrowImageView.heightAnchor.constraint(equalToConstant: 24),

//                    titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
                    titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -16),
                    titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

                    subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
                    subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                    subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                ]
        )
    }

}