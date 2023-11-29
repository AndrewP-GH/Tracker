//
// Created by Андрей Парамонов on 12.08.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    private let recordsStore: TrackerRecordStoreProtocol
    private let trackersStore: TrackersStoreProtocol

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

    private var bestPeriodView: StatisticsView {
        statistics[0]
    }

    private var idealDaysView: StatisticsView {
        statistics[1]
    }

    private var trackersFinishedView: StatisticsView {
        statistics[2]
    }
    private var averagePerDayView: StatisticsView {
        statistics[3]
    }

    init(recordsStore: TrackerRecordStoreProtocol, trackersStore: TrackersStoreProtocol) {
        self.recordsStore = recordsStore
        self.trackersStore = trackersStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateContent()
    }

    private func updateContent() {
        let statisticsService = StatisticsService(recordsStore: recordsStore, trackersStore: trackersStore)
        let model = statisticsService.getStatistics()
        if model.trackersFinished > 0 {
            noStatisticsView.isHidden = true
            statistics.forEach { $0.isHidden = false }
            bestPeriodView.configure(with: StatisticsCellModel(title: "Лучший период", value: model.bestPeriod))
            idealDaysView.configure(with: StatisticsCellModel(title: "Идеальные дни", value: model.idealDays))
            trackersFinishedView.configure(with: StatisticsCellModel(title: "Трекеров завершено",
                                                                     value: model.trackersFinished))
            averagePerDayView.configure(with: StatisticsCellModel(title: "Среднее значение",
                                                                  value: model.averagePerDay))
        } else {
            noStatisticsView.isHidden = false
            statistics.forEach { $0.isHidden = true }
        }
    }

    private func setupView() {
        view.backgroundColor = .ypBackground
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(label)
        view.addSubview(noStatisticsView)
        statistics.forEach(view.addSubview(_:))
    }

    private func setupConstraints() {
        let sideInset: CGFloat = 16
        let views = [
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInset),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInset),
            label.heightAnchor.constraint(equalToConstant: 41),

            noStatisticsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noStatisticsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ]
        let statisticsTop = [statistics[0].topAnchor.constraint(equalTo: label.bottomAnchor, constant: 77)]
                + statistics.enumerated()
                            .dropFirst()
                            .map { index, view in
                                view.topAnchor.constraint(equalTo: statistics[index - 1].bottomAnchor,
                                                          constant: Constants.spaceBetweenCells)
                            }
        let statisticsOther = statistics
                .map {
                    [
                        $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInset),
                        $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInset),
                        $0.heightAnchor.constraint(equalToConstant: Constants.cellHeight)
                    ]
                }
                .flatMap({ $0 })
        NSLayoutConstraint.activate(views + statisticsTop + statisticsOther)
    }
}

extension StatisticsViewController {
    private enum Constants {
        static let cellHeight: CGFloat = 90
        static let sideInset: CGFloat = 16
        static let spaceBetweenCells: CGFloat = 12
    }
}
