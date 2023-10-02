//
// Created by Андрей Парамонов on 29.09.2023.
//

import Foundation
import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrackerCollectionViewCell"

    var tracker: Tracker?
    private var isDone = false

    private lazy var coloredView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = UIColor.init(white: 1.0, alpha: 0.3)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()

    private lazy var controlView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.textColor = .ypBlack
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "PlusButton"), for: .normal)
        button.backgroundColor = .ypWhite
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(with tracker: Tracker) {
        self.tracker = tracker
        updateContent()
    }

    private func setupView() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .clear

        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(coloredView)
        coloredView.addSubview(emojiLabel)
        coloredView.addSubview(textStackView)
        textStackView.addSubview(nameLabel)
        contentView.addSubview(controlView)
        controlView.addSubview(daysLabel)
        controlView.addSubview(button)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    coloredView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    coloredView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    coloredView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    coloredView.heightAnchor.constraint(equalToConstant: 90),

                    emojiLabel.topAnchor.constraint(equalTo: coloredView.topAnchor, constant: 12),
                    emojiLabel.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor, constant: 12),
                    emojiLabel.widthAnchor.constraint(equalToConstant: 24),
                    emojiLabel.heightAnchor.constraint(equalToConstant: 24),

                    textStackView.topAnchor.constraint(equalTo: emojiLabel.topAnchor, constant: 8),
                    textStackView.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor, constant: 12),
                    textStackView.trailingAnchor.constraint(equalTo: coloredView.trailingAnchor, constant: -12),
                    textStackView.bottomAnchor.constraint(equalTo: coloredView.bottomAnchor, constant: -12),

                    nameLabel.leadingAnchor.constraint(equalTo: textStackView.leadingAnchor),
                    nameLabel.trailingAnchor.constraint(equalTo: textStackView.trailingAnchor),
                    nameLabel.bottomAnchor.constraint(equalTo: textStackView.bottomAnchor),

                    controlView.topAnchor.constraint(equalTo: coloredView.bottomAnchor),
                    controlView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    controlView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    controlView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

                    daysLabel.topAnchor.constraint(equalTo: controlView.topAnchor, constant: 16),
                    daysLabel.leadingAnchor.constraint(equalTo: controlView.leadingAnchor, constant: 12),
                    daysLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),

                    button.topAnchor.constraint(equalTo: controlView.topAnchor, constant: 8),
                    button.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: -12),
                    button.widthAnchor.constraint(equalToConstant: 34),
                    button.heightAnchor.constraint(equalToConstant: 34),
                ]
        )
    }

    private func updateContent() {
        guard let tracker else {
            return
        }
        coloredView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        button.tintColor = tracker.color
        daysLabel.text = "0 дней"
        updateButton()
    }

    @objc private func buttonTapped() {
        isDone.toggle()
        updateButton()
    }

    private func updateButton() {
        if isDone {
            button.setImage(UIImage(named: "DoneButton"), for: .normal)
        } else {
            button.setImage(UIImage(named: "PlusButton"), for: .normal)
        }
    }
}
