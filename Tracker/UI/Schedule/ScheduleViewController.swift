//
// Created by Андрей Парамонов on 28.09.2023.
//

import Foundation
import UIKit

final class ScheduleViewController: UIViewController {
    private let cellHeight: CGFloat = 75
    private let weekDaysCount = WeekDay.allCases.count

    weak var delegate: AddHabitViewControllerDelegate?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
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
        scrollView.layer.cornerRadius = 16
        scrollView.layer.masksToBounds = true
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        return contentView
    }()

    private lazy var configureTable: UITableView = {
        let configureTable = UITableView()
        configureTable.translatesAutoresizingMaskIntoConstraints = false
        configureTable.backgroundColor = .ypBackground
        configureTable.separatorStyle = .none
        configureTable.showsVerticalScrollIndicator = false
        configureTable.showsHorizontalScrollIndicator = false
        configureTable.register(WeekDayTableViewCell.self, forCellReuseIdentifier: WeekDayTableViewCell.identifier)
        configureTable.delegate = self
        configureTable.dataSource = self
        configureTable.layer.cornerRadius = 16
        configureTable.layer.masksToBounds = true
        configureTable.isScrollEnabled = false
        return configureTable
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(configureTable)
        view.addSubview(button)
    }

    private func setupConstraints() {
        let sideInset: CGFloat = 16
        let safeG = view.safeAreaLayoutGuide
        let contentG = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate(
                [
                    scrollView.topAnchor.constraint(equalTo: safeG.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: sideInset),
                    scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -sideInset),
                    scrollView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16),

                    contentG.bottomAnchor.constraint(equalTo: configureTable.bottomAnchor),

                    contentView.topAnchor.constraint(equalTo: contentG.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

                    titleLabel.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 26),
                    titleLabel.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
                    titleLabel.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),

                    configureTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
                    configureTable.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
                    configureTable.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
                    configureTable.heightAnchor.constraint(equalToConstant: cellHeight * 7),

                    button.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -16),
                    button.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 20),
                    button.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -20),
                    button.heightAnchor.constraint(equalToConstant: 60),
                ]
        )
    }

    @objc private func save() {
        defer {
            dismiss(animated: true)
        }
        var selected: [WeekDay] = []
        configureTable.visibleCells.forEach { cell in
            guard let cell = cell as? WeekDayTableViewCell else {
                return
            }
            if cell.isEnabled, let weekDay = cell.weekDay {
                selected.append(weekDay)
            }
        }
        delegate?.setSchedule(schedule: selected)
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekDaysCount
    }

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeekDayTableViewCell.identifier,
                                                 for: indexPath) as! WeekDayTableViewCell
        let weekDay = WeekDay.allCases[indexPath.row]
        cell.set(weekDay: weekDay, title: weekDay.rawValue)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? WeekDayTableViewCell {
            cell.withSeparator = !tableView.isLastCellInSection(at: indexPath)
        }
    }
}
