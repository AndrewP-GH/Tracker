//
// Created by Андрей Парамонов on 12.08.2023.
//


import Foundation
import UIKit

final class StatisticsViewController: UIViewController {
    private let cellHeight: CGFloat = 90
    private let cornerRadius: CGFloat = 16

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Статистика"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()

    private lazy var statisticsTable: UITableView = {
        let statisticsTable = UITableView()
        statisticsTable.translatesAutoresizingMaskIntoConstraints = false
        statisticsTable.backgroundColor = .ypBackground
        statisticsTable.separatorStyle = .none
        statisticsTable.showsVerticalScrollIndicator = false
        statisticsTable.showsHorizontalScrollIndicator = false
        statisticsTable.dataSource = self
        statisticsTable.layer.cornerRadius = cornerRadius
        statisticsTable.layer.masksToBounds = true
        statisticsTable.isScrollEnabled = false
        return statisticsTable
    }()

    private lazy var noStatisticsView: EmptyResultPlaceholderView = {
        let emptyView = EmptyResultPlaceholderView(emptyStateText: "")
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.configure(state: .noStatistics)
        return emptyView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // я работаю над сколь-нибудь адектваным алгоритмом подсчета статистики, но пока вообще хз.
        // считаю, что она должна возвращаться с бекенда, поскольку там можно легко делать аналитические звапросы
        // поэтому пока что я просто скрываю таблицу и показываю плейсхолдер :)
        statisticsTable.isHidden = true
    }

    private func setupView() {
        view.backgroundColor = .ypBackground
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(label)
        view.addSubview(statisticsTable)
        view.addSubview(noStatisticsView)
    }

    private func setupConstraints() {
        let sideInset: CGFloat = 16
        NSLayoutConstraint.activate(
                [
                    label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
                    label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInset),
                    label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInset),

                    statisticsTable.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 77),
                    statisticsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInset),
                    statisticsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInset),
                    statisticsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

                    noStatisticsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    noStatisticsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ]
        )
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}