//
// Created by Андрей Парамонов on 25.09.2023.
//

import Foundation
import UIKit

final class AddHabitViewController: UIViewController {
    weak var delegate: AddTrackerViewControllerDelegate?

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

    private var selectedDays: [WeekDay] = []

    private var collectionViewHeight: CGFloat {
        collectionCellSize.height * (CGFloat(emojis.count) / collectionItemsPerRow).rounded(.up)
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        return contentView
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
        configureTable.layer.masksToBounds = true
        configureTable.isScrollEnabled = false
        return configureTable
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
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }

    private lazy var cancelButton: UIButton = {
        let red = UIColor.ypRed
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(red, for: .normal)
        button.titleLabel!.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = red.cgColor
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel!.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        disableButton(button)
        return button
    }()

    private func disableButton(_ button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = .ypGray
    }

    private func enableButton(_ button: UIButton) {
        button.isEnabled = true
        button.backgroundColor = .ypBlack
    }

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
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
        contentView.addSubview(nameTextField)
        contentView.addSubview(configureTable)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(colorLabel)
        contentView.addSubview(colorCollectionView)
        contentView.addSubview(buttonsStackView)
    }

    private func setupConstraints() {
        let sideInset: CGFloat = 16
        let safeG = view.safeAreaLayoutGuide
        let contentG = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate(
                [
                    scrollView.topAnchor.constraint(equalTo: safeG.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor),
                    scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor),

                    contentView.topAnchor.constraint(equalTo: contentG.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
                    contentView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                    contentView.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),

                    titleLabel.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 26),
                    titleLabel.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: sideInset),
                    titleLabel.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -sideInset),

                    nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
                    nameTextField.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: sideInset),
                    nameTextField.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -sideInset),
                    nameTextField.heightAnchor.constraint(equalToConstant: 75),

                    configureTable.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
                    configureTable.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: sideInset),
                    configureTable.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -sideInset),
                    configureTable.heightAnchor.constraint(equalToConstant: tableCellHeight * CGFloat(tableRows)),


                    emojiLabel.topAnchor.constraint(equalTo: configureTable.bottomAnchor, constant: 32),
                    emojiLabel.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 28),
                    emojiLabel.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -28),

                    emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24),
                    emojiCollectionView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 18),
                    emojiCollectionView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -18),
                    emojiCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),

                    colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40),
                    colorLabel.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 28),
                    colorLabel.trailingAnchor
                            .constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -28),

                    colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 24),
                    colorCollectionView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 18),
                    colorCollectionView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -18),
                    colorCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),

                    buttonsStackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 40),
                    buttonsStackView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 20),
                    buttonsStackView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -20),
                    buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
                ]
        )
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func saveButtonTapped() {
        delegate?.addTracker(tracker: Tracker(
                id: UUID(),
                name: nameTextField.text!,
                color: colors[0],
                emoji: emojis[0],
                schedule: Schedule(days: selectedDays))
        )
    }
}

extension AddHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        UpdateSaveButtonState(textField: textField)
    }

    private func UpdateSaveButtonState(textField: UITextField) {
        if (textField.text?.isEmpty ?? true) || selectedDays.isEmpty {
            disableButton(saveButton)
        } else {
            enableButton(saveButton)
        }
    }
}

extension AddHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
                withIdentifier: AddHabitTableViewCell.identifier,
                for: indexPath) as! AddHabitTableViewCell
        switch indexPath.row {
        case 0:
            cell.set(title: "Категория", withSeparator: true)
        case 1:
            cell.set(title: "Расписание", withSeparator: false)
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
            let vc = ScheduleViewController()
            vc.delegate = self
            present(vc, animated: true)
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
            cell.value = .emoji(emojis[indexPath.row])
        case colorCollectionView:
            cell.value = .color(colors[indexPath.row])
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

extension AddHabitViewController: AddHabitViewControllerDelegate {
    func setSchedule(schedule: [WeekDay]) {
        selectedDays = schedule
        UpdateSaveButtonState(textField: nameTextField)
    }
}
