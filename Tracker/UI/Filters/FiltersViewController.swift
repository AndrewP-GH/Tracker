//
// Created by Андрей Парамонов on 25.11.2023.
//

import Foundation
import UIKit

final class FiltersViewController: UIViewController {
    private let cellHeight: CGFloat = 75
    private let cornerRadius: CGFloat = 16

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Фильтры"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        return label
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.cornerRadius = cornerRadius
        scrollView.layer.masksToBounds = true
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        return contentView
    }()

    private lazy var filtersTable: UITableView = {
        let filtersTable = UITableView()
        filtersTable.translatesAutoresizingMaskIntoConstraints = false
        filtersTable.backgroundColor = .ypBackground
        filtersTable.separatorStyle = .none
        filtersTable.showsVerticalScrollIndicator = false
        filtersTable.showsHorizontalScrollIndicator = false
//        filtersTable.register(SelectableTableViewCell.self,
//                                forCellReuseIdentifier: SelectableTableViewCell.identifier)
//        filtersTable.delegate = self
//        filtersTable.dataSource = self
        filtersTable.layer.cornerRadius = cornerRadius
        filtersTable.layer.masksToBounds = true
        filtersTable.isScrollEnabled = false
        filtersTable.rowHeight = cellHeight
        return filtersTable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        view.backgroundColor = .ypWhite
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(filtersTable)
    }

    private func setupConstraints() {
        let sideInset: CGFloat = 16
        let safeG = view.safeAreaLayoutGuide
        let svContentG = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate(
                [
                    scrollView.topAnchor.constraint(equalTo: safeG.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: sideInset),
                    scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -sideInset),
                    scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor),

                    contentView.topAnchor.constraint(equalTo: svContentG.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

                    titleLabel.topAnchor.constraint(equalTo: svContentG.topAnchor, constant: 26),
                    titleLabel.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor),
                    titleLabel.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor),

                    filtersTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
                    filtersTable.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor),
                    filtersTable.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor),
                    filtersTable.bottomAnchor.constraint(equalTo: svContentG.bottomAnchor),
                ]
        )
    }
}

//extension
