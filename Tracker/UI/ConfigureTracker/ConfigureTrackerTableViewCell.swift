//
// Created by Андрей Парамонов on 25.09.2023.
//

import Foundation
import UIKit

final class ConfigureTrackerTableViewCell: GreyTableViewCell {
    static let identifier = "ConfigureTrackerTableViewCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.backgroundColor = .clear
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypGray
        label.backgroundColor = .clear
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "CellArrow")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(title: String) {
        titleLabel.text = title
        subtitleLabel.isHidden = true
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = false
    }

    private func setupView() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(stackView)
        stackView.addSubview(titleLabel)
        stackView.addSubview(subtitleLabel)
        contentView.addSubview(arrowImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
                    arrowImageView.widthAnchor.constraint(equalToConstant: 24),
                    arrowImageView.heightAnchor.constraint(equalToConstant: 24),

                    stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                    stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -16),
                    stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                    stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

                    titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                    titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

                    subtitleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                    subtitleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
                ]
        )
    }
}

