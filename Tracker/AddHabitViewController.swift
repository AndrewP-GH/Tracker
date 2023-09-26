//
// Created by Андрей Парамонов on 25.09.2023.
//

import Foundation
import UIKit

final class AddHabitViewController: UIViewController {
    private let tableCellHeight: CGFloat = 75
    private let tableRows: Int = 2
    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓",
            "🥇", "🎸", "🏝", "😪"]

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
        configureTable.register(AddHabitTableViewCell.self, forCellReuseIdentifier: AddHabitTableViewCell.identifier)
        configureTable.delegate = self
        configureTable.dataSource = self
        configureTable.layer.cornerRadius = 16
        return configureTable
    }()

    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.text = "Emoji"
        emojiLabel.font = .systemFont(ofSize: 19, weight: .bold)
        emojiLabel.textAlignment = .left
        emojiLabel.textColor = .ypBlack
        return emojiLabel
    }()

    private lazy var emojiCollectionView: UICollectionView = {
        let emojiCollectionView = UICollectionView(frame: .zero,
                                                   collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollectionView.backgroundColor = .clear
        emojiCollectionView.showsVerticalScrollIndicator = false
        emojiCollectionView.showsHorizontalScrollIndicator = false
        emojiCollectionView.register(TrackerCustomizationViewCell.self,
                                     forCellWithReuseIdentifier: TrackerCustomizationViewCell.identifier)
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        return emojiCollectionView
    }()

    private lazy var rowsSeparator: UIView = {
        let rowsSeparator = UIView()
        rowsSeparator.translatesAutoresizingMaskIntoConstraints = false
        rowsSeparator.backgroundColor = .ypGray
        return rowsSeparator
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
        view.addSubview(rowsSeparator)
        view.addSubview(emojiLabel)
        view.addSubview(emojiCollectionView)
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
                    configureTable.heightAnchor.constraint(equalToConstant: tableCellHeight * CGFloat(tableRows)),

                    rowsSeparator.topAnchor
                            .constraint(equalTo: configureTable.topAnchor, constant: tableCellHeight - 0.5),
                    rowsSeparator.leadingAnchor
                            .constraint(equalTo: configureTable.leadingAnchor, constant: sideInset),
                    rowsSeparator.trailingAnchor
                            .constraint(equalTo: configureTable.trailingAnchor, constant: -sideInset),
                    rowsSeparator.heightAnchor.constraint(equalToConstant: 0.5),

                    emojiLabel.topAnchor.constraint(equalTo: configureTable.bottomAnchor, constant: 32),
                    emojiLabel.leadingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
                    emojiLabel.trailingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
                    emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24),
                    emojiCollectionView.leadingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
                    emojiCollectionView.trailingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
                    emojiCollectionView.bottomAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
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
        tableRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
                withIdentifier: AddHabitTableViewCell.identifier,
                for: indexPath) as? AddHabitTableViewCell ?? AddHabitTableViewCell()
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Категория"
        case 1:
            cell.titleLabel.text = "Расписание"
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableCellHeight
    }
}

extension AddHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
//            let vc = CategoriesViewController()
//            navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
//            let vc = ScheduleViewController()
//            navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
}


extension AddHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojis.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCustomizationViewCell.identifier,
                                                      for: indexPath) as! TrackerCustomizationViewCell
        cell.titleLabel.text = emojis[indexPath.row]
        return cell
    }
}

extension AddHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension AddHabitViewController: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
        .zero
    }

    fileprivate var itemsPerRow: CGFloat {
        6
    }

    fileprivate var interitemSpace: CGFloat {
        5.0
    }

    func collectionView(_ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
        let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }

    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        interitemSpace
    }
}