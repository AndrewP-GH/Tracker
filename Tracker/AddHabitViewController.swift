//
// Created by Андрей Парамонов on 25.09.2023.
//

import Foundation
import UIKit

final class AddHabitViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .ypBlack
        textField.textAlignment = .left
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        return textField
    }()

    private lazy var configureTable: UITableView = {
        let configureTable = UITableView()
        configureTable.translatesAutoresizingMaskIntoConstraints = false
        configureTable.backgroundColor = .ypBackground
        configureTable.separatorStyle = .none
        configureTable.showsVerticalScrollIndicator = false
        configureTable.showsHorizontalScrollIndicator = false
//        configureTable.register(AddHabitTableViewCell.self, forCellReuseIdentifier: AddHabitTableViewCell.identifier)
//        configureTable.delegate = self
        configureTable.dataSource = self
        return configureTable
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
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(configureTable)
    }

    private func setupConstraints() {
        let sideInset: CGFloat = 16
        NSLayoutConstraint.activate(
                [
                    titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
                    titleLabel.leadingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sideInset),
                    titleLabel.trailingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sideInset),

                    nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
                    nameTextField.leadingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sideInset),
                    nameTextField.trailingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sideInset),
                    nameTextField.heightAnchor.constraint(equalToConstant: 75),

                    configureTable.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
                    configureTable.leadingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sideInset),
                    configureTable.trailingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sideInset),
                ]
        )
    }
}

extension AddHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddHabitTableViewCell.identifier,
                                                 for: indexPath) as! AddHabitTableViewCell
        return cell
    }


}
