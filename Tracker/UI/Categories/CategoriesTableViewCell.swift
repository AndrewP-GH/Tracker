//
// Created by Андрей Парамонов on 28.09.2023.
//

import Foundation
import UIKit

final class CategoriesTableViewCell: GreyTableViewCell {
    static let identifier = "CategoriesTableViewCell"

    var category: TrackerCategory?
    var delegate: ((TrackerCategory) -> Void)?

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
        selectButton.setImage(UIImage(named: "CategorySelected"), for: .normal)
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

    func configure(model: CategoryCellModel) {
        category = model.category
        titleLabel.text = model.category.header
        selectButton.isHidden = !model.isSelected
        delegate = model.categorySelectedDelegate
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
        guard let category,
              let delegate else { return }
        delegate(category)
    }
}
