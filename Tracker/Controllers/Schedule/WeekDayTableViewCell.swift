//
// Created by Андрей Парамонов on 28.09.2023.
//

import Foundation
import UIKit

final class WeekDayTableViewCell: GreyTableViewCell {
    static let identifier = "WeekDayTableViewCell"

    var isEnabled: Bool {
        get {
            switchView.isOn
        }
    }

    var weekDay: WeekDay?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.backgroundColor = .clear
        return label
    }()

    private lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.backgroundColor = .clear
        switchView.onTintColor = .ypBlue
        return switchView
    }()

    private lazy var allCellButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(cellTapped), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(weekDay: WeekDay, title: String, isEnabled: Bool) {
        self.weekDay = weekDay
        titleLabel.text = title
        switchView.isOn = isEnabled
    }

    private func setupView() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(allCellButton)
        allCellButton.addSubview(titleLabel)
        allCellButton.addSubview(switchView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    allCellButton.topAnchor.constraint(equalTo: contentView.topAnchor),
                    allCellButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    allCellButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    allCellButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

                    titleLabel.centerYAnchor.constraint(equalTo: allCellButton.centerYAnchor),
                    titleLabel.leadingAnchor.constraint(equalTo: allCellButton.leadingAnchor, constant: 16),

                    switchView.centerYAnchor.constraint(equalTo: allCellButton.centerYAnchor),
                    switchView.trailingAnchor.constraint(equalTo: allCellButton.trailingAnchor, constant: -16),
                ]
        )
    }

    @objc private func cellTapped() {
        switchView.setOn(!switchView.isOn, animated: true)
    }
}
