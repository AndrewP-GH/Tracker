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
        set {
            switchView.isOn = newValue
        }
    }

    var weekDay: WeekDay?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()

    private lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.backgroundColor = .ypBackground
        return switchView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func set(weekDay: WeekDay, title: String) {
        self.weekDay = weekDay
        titleLabel.text = title
    }

    private func setupView() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

                    switchView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    switchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                ]
        )
    }
}
