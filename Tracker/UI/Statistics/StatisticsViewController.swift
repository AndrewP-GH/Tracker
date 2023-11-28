//
// Created by Андрей Парамонов on 12.08.2023.
//


import UIKit

final class StatisticsViewController: UIViewController {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Статистика"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()

    private lazy var noStatisticsView: EmptyResultPlaceholderView = {
        let emptyView = EmptyResultPlaceholderView(emptyStateText: "")
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.configure(state: .noStatistics)
        return emptyView
    }()

    private lazy var statistics: [StatisticsView] = {
        let statistics = [createView(), createView(), createView(), createView()]
        return statistics

        func createView() -> StatisticsView {
            let view = StatisticsView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: update state
    }

    private func setupView() {
        view.backgroundColor = .ypBackground
        addSubviews()
        setupConstraints()

        statistics[0].configure(with: StatisticsCellModel(title: "Среднее время сна", value: "8 часов"))
        statistics[1].configure(with: StatisticsCellModel(title: "Среднее время сна", value: "8 часов"))
        statistics[2].configure(with: StatisticsCellModel(title: "Среднее время сна", value: "8 часов"))
        statistics[3].configure(with: StatisticsCellModel(title: "Среднее время сна", value: "8 часов"))
    }

    private func addSubviews() {
        view.addSubview(label)
        view.addSubview(noStatisticsView)
        statistics.forEach(view.addSubview(_:))
    }

    private func setupConstraints() {
        let sideInset: CGFloat = 16
        NSLayoutConstraint.activate(
                [
                    label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
                    label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInset),
                    label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInset),
                    label.heightAnchor.constraint(equalToConstant: 41),

                    noStatisticsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    noStatisticsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

                    statistics[0].topAnchor.constraint(equalTo: label.bottomAnchor, constant: 77),
                    statistics[1].topAnchor.constraint(equalTo: statistics[0].bottomAnchor, constant: Constants.spaceBetweenCells),
                    statistics[2].topAnchor.constraint(equalTo: statistics[1].bottomAnchor, constant: Constants.spaceBetweenCells),
                    statistics[3].topAnchor.constraint(equalTo: statistics[2].bottomAnchor, constant: Constants.spaceBetweenCells),
                ] + statistics.map {
                                  [
                                      $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                                  constant: sideInset),
                                      $0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                                   constant: -sideInset),
                                      $0.heightAnchor.constraint(equalToConstant: Constants.cellHeight)
                                  ]
                              }
                              .flatMap({ $0 })
        )
    }
}

extension StatisticsViewController {
    private enum Constants {
        static let cellHeight: CGFloat = 90
        static let sideInset: CGFloat = 16
        static let spaceBetweenCells: CGFloat = 12
    }
}
