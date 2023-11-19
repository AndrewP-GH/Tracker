//
// Created by Андрей Парамонов on 20.11.2023.
//

import Foundation
import UIKit

final class CreateCategoryViewController: UIViewController {
    weak var delegate: AddCategoryViewControllerDelegate?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая категория"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название категории"
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .ypBlack
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        return textField
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel!.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        disableButton(button)
        return button
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
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(button)
    }

    private func setupConstraints() {
        let safeG = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate(
                [
                    titleLabel.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 26),
                    titleLabel.leadingAnchor.constraint(equalTo: safeG.leadingAnchor),
                    titleLabel.trailingAnchor.constraint(equalTo: safeG.trailingAnchor),

                    nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
                    nameTextField.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 16),
                    nameTextField.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -16),
                    nameTextField.heightAnchor.constraint(equalToConstant: 75),

                    button.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -16),
                    button.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 20),
                    button.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -20),
                    button.heightAnchor.constraint(equalToConstant: 60),
                ]
        )
    }

    private func updateSaveButtonState() {
        if nameTextField.text?.isEmpty ?? true {
            disableButton(button)
        } else {
            enableButton(button)
        }
    }

    private func disableButton(_ button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = .ypGray
    }

    private func enableButton(_ button: UIButton) {
        button.isEnabled = true
        button.backgroundColor = .ypBlack
    }

    @objc private func saveButtonTapped() {
        guard let delegate,
              let name = nameTextField.text else { return }
        delegate.addCategory(
                category: TrackerCategory(
                        id: UUID(),
                        header: name,
                        items: []
                )
        )
    }
}

extension CreateCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateSaveButtonState()
    }
}