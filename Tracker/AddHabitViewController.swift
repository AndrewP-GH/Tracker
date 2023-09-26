//
// Created by Андрей Парамонов on 25.09.2023.
//

import Foundation
import UIKit

final class AddHabitViewController: UIViewController {
    private let tableCellHeight: CGFloat = 75
    private let tableRows: Int = 2
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
    private let colors = [
        UIColor.init(hex: "#FD4C49"), UIColor.init(hex: "#FF881E"), UIColor.init(hex: "#007BFA"),
        UIColor.init(hex: "#6E44FE"), UIColor.init(hex: "#33CF69"), UIColor.init(hex: "#E66DD4"),
        UIColor.init(hex: "#F9D4D4"), UIColor.init(hex: "#34A7FE"), UIColor.init(hex: "#46E69D"),
        UIColor.init(hex: "#35347C"), UIColor.init(hex: "#FF674D"), UIColor.init(hex: "#FF99CC"),
        UIColor.init(hex: "#F6C48B"), UIColor.init(hex: "#7994F5"), UIColor.init(hex: "#832CF1"),
        UIColor.init(hex: "#AD56DA"), UIColor.init(hex: "#8D72E6"), UIColor.init(hex: "#2FD058"),

    ]
    private let collectionItemsPerRow: CGFloat = 6
    private let collectionCellSize = CGSize(width: 52, height: 52)

    private var collectionViewHeight: CGFloat {
        collectionCellSize.height * (CGFloat(emojis.count) / collectionItemsPerRow).rounded(.up)
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        scrollView.contentMode = .scaleAspectFit
        return scrollView
    }()

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
        configureTable.clipsToBounds = true
        configureTable.isScrollEnabled = false
        return configureTable
    }()

    private lazy var configureTableRowsSeparator: UIView = {
        let rowsSeparator = UIView()
        rowsSeparator.translatesAutoresizingMaskIntoConstraints = false
        rowsSeparator.backgroundColor = .ypGray
        return rowsSeparator
    }()

    private lazy var emojiLabel: UILabel = {
        createCollectionLabel(title: "Emoji")
    }()

    private lazy var colorLabel: UILabel = {
        createCollectionLabel(title: "Color")
    }()

    private func createCollectionLabel(title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textAlignment = .left
        label.textColor = .ypBlack
        return label
    }

    private lazy var emojiCollectionView: UICollectionView = {
        createCollectionView()
    }()

    private lazy var colorCollectionView: UICollectionView = {
        createCollectionView()
    }()

    private func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TrackerCustomizationViewCell.self,
                                forCellWithReuseIdentifier: TrackerCustomizationViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.size.width,
                                        height: view.frame.size.height + 1200)
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(configureTable)
        scrollView.addSubview(configureTableRowsSeparator)
        scrollView.addSubview(emojiLabel)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorLabel)
        scrollView.addSubview(colorCollectionView)
    }

    private func setupConstraints() {
        let sideInset: CGFloat = 16
        let layout = scrollView.safeAreaLayoutGuide
        NSLayoutConstraint.activate(
                [
                    scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                    titleLabel.topAnchor.constraint(equalTo: layout.topAnchor, constant: 26),
                    titleLabel.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: sideInset),
                    titleLabel.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: -sideInset),

                    nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
                    nameTextField.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: sideInset),
                    nameTextField.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: -sideInset),
                    nameTextField.heightAnchor.constraint(equalToConstant: 75),

                    configureTable.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
                    configureTable.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: sideInset),
                    configureTable.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: -sideInset),
                    configureTable.heightAnchor.constraint(equalToConstant: tableCellHeight * CGFloat(tableRows)),

                    configureTableRowsSeparator.topAnchor
                            .constraint(equalTo: configureTable.topAnchor, constant: tableCellHeight - 0.5),
                    configureTableRowsSeparator.leadingAnchor
                            .constraint(equalTo: configureTable.leadingAnchor, constant: sideInset),
                    configureTableRowsSeparator.trailingAnchor
                            .constraint(equalTo: configureTable.trailingAnchor, constant: -sideInset),
                    configureTableRowsSeparator.heightAnchor.constraint(equalToConstant: 0.5),

                    emojiLabel.topAnchor.constraint(equalTo: configureTable.bottomAnchor, constant: 32),
                    emojiLabel.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: 28),
                    emojiLabel.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: -28),

                    emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24),
                    emojiCollectionView.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: 18),
                    emojiCollectionView.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: -18),
                    emojiCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),

                    colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40),
                    colorLabel.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: 28),
                    colorLabel.trailingAnchor
                            .constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -28),

                    colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 24),
                    colorCollectionView.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: 18),
                    colorCollectionView.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: -18),
                    colorCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
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
        switch collectionView {
        case emojiCollectionView:
            return emojis.count
        case colorCollectionView:
            return colors.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCustomizationViewCell.identifier,
                                                      for: indexPath) as! TrackerCustomizationViewCell
        switch collectionView {
        case emojiCollectionView:
            cell.titleLabel.text = emojis[indexPath.row]
        case colorCollectionView:
            cell.colorView.backgroundColor = colors[indexPath.row]
        default:
            break
        }
        return cell
    }
}

extension AddHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension AddHabitViewController: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets { .zero }

    func collectionView(_ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionCellSize
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
        let paddingsCount = collectionItemsPerRow - 1
        if paddingsCount <= 0 {
            return 0.0
        }
        let sectionPadding = (sectionInsets.left + sectionInsets.right) * collectionItemsPerRow
        let itemsWidth = collectionCellSize.width * collectionItemsPerRow
        let paddingsWidth = collectionView.bounds.width - sectionPadding - itemsWidth
        if paddingsWidth <= 0 {
            return 0.0
        }
        let padding = paddingsWidth / paddingsCount
        return padding.rounded(.towardZero)
    }
}
