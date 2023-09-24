//
// Created by Андрей Парамонов on 24.09.2023.
//

import Foundation
import UIKit

class AddTrackerViewController: UIViewController {
    private lazy var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        return label
    }()

    private lazy var habit: UIButton = {
        createButton(title: "Привычка", action: #selector(addHabit))
    }()

    private lazy var event: UIButton = {
        createButton(title: "Нерегулярное событие", action: #selector(addEvent))
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
        view.addSubview(header)
        view.addSubview(habit)
        view.addSubview(event)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
                    header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                    header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

                    habit.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 180),
                    habit.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                    habit.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                    habit.heightAnchor.constraint(equalToConstant: 60),

                    event.topAnchor.constraint(equalTo: habit.bottomAnchor, constant: 16),
                    event.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                    event.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                    event.heightAnchor.constraint(equalToConstant: 60),
                ]
        )
    }

    @objc private func addHabit() {
    }

    @objc private func addEvent() {
    }

    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}