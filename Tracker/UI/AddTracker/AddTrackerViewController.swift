//
// Created by Андрей Парамонов on 24.09.2023.
//

import Foundation
import UIKit

final class AddTrackerViewController: UIViewController {
    weak var delegate: TrackersViewControllerDelegate?

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
        let sideInset: CGFloat = 20
        NSLayoutConstraint.activate(
                [
                    header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
                    header.leadingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sideInset),
                    header.trailingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sideInset),

                    habit.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 295),
                    habit.leadingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sideInset),
                    habit.trailingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sideInset),
                    habit.heightAnchor.constraint(equalToConstant: 60),

                    event.topAnchor.constraint(equalTo: habit.bottomAnchor, constant: 16),
                    event.leadingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sideInset),
                    event.trailingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sideInset),
                    event.heightAnchor.constraint(equalToConstant: 60),
                ]
        )
    }

    @objc private func addHabit() {
        let vc = CreateTrackerViewController(mode: .habit)
        vc.delegate = self
        present(vc, animated: true)
    }

    @objc private func addEvent() {
        let vc = CreateTrackerViewController(mode: .event)
        vc.delegate = self
        present(vc, animated: true)
    }

    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}

extension AddTrackerViewController: AddTrackerViewControllerDelegate {
    func addTracker(tracker: Tracker) {
        let min = Calendar.current.component(.minute, from: Date())
        delegate?.addTrackerToCategory(category: "Новые \(min)" , tracker: tracker)
        presentingViewController?.dismiss(
                animated: true,
                completion: { [weak self] in
                    self?.dismiss(animated: false)
                }
        )
    }
}
