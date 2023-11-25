//
// Created by Андрей Парамонов on 28.09.2023.
//

import Foundation
import UIKit

final class SelectableTableViewCell<T>: GreyTableViewCell {
    static var identifier: String { "SelectableTableViewCell_\(T.self)" }

    var value: T?
    var delegate: ((T) -> Void)?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.backgroundColor = .clear
        return label
    }()

    private lazy var selectButton: UIButton = {
        let selectButton = UIButton()
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.backgroundColor = .clear
        selectButton.setImage(UIImage(named: "CellSelected"), for: .normal)
        selectButton.addTarget(self, action: #selector(cellTapped), for: .touchUpInside)
        return selectButton
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

    func configure(model: SelectableCellModel<T>) {
        value = model.value
        titleLabel.text = model.title
        selectButton.isHidden = !model.isSelected
        delegate = model.valueSelectedDelegate
    }

    private func setupView() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(allCellButton)
        allCellButton.addSubview(titleLabel)
        allCellButton.addSubview(selectButton)
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

                    selectButton.centerYAnchor.constraint(equalTo: allCellButton.centerYAnchor),
                    selectButton.trailingAnchor.constraint(equalTo: allCellButton.trailingAnchor, constant: -16),
                    selectButton.widthAnchor.constraint(equalToConstant: 24),
                    selectButton.heightAnchor.constraint(equalToConstant: 24),
                ]
        )
    }

    @objc private func cellTapped() {
        guard let value, let delegate else { return }
        delegate(value)
    }
}
