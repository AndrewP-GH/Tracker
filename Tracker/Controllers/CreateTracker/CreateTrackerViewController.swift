//
// Created by Андрей Парамонов on 25.09.2023.
//

import Foundation
import UIKit

final class CreateTrackerViewController: UIViewController {
    weak var delegate: AddTrackerViewControllerDelegate?

    private let tableCellHeight: CGFloat = 75
    private let tableRows: Int = 2
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
    private let colors = [
        UIColor.init(hex: "#FD4C49")!, UIColor.init(hex: "#FF881E")!, UIColor.init(hex: "#007BFA")!,
        UIColor.init(hex: "#6E44FE")!, UIColor.init(hex: "#33CF69")!, UIColor.init(hex: "#E66DD4")!,
        UIColor.init(hex: "#F9D4D4")!, UIColor.init(hex: "#34A7FE")!, UIColor.init(hex: "#46E69D")!,
        UIColor.init(hex: "#35347C")!, UIColor.init(hex: "#FF674D")!, UIColor.init(hex: "#FF99CC")!,
        UIColor.init(hex: "#F6C48B")!, UIColor.init(hex: "#7994F5")!, UIColor.init(hex: "#832CF1")!,
        UIColor.init(hex: "#AD56DA")!, UIColor.init(hex: "#8D72E6")!, UIColor.init(hex: "#2FD058")!,
    ]
    private let collectionItemsPerRow: CGFloat = 6
    private let collectionCellSize = CGSize(width: 52, height: 52)

    private var titleText: String?

    private var selectedDays: [WeekDay] = []
    private var selectedEmojiPath: IndexPath?
    private var selectedColorPath: IndexPath?

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
        label.text = titleText
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
        configureTable.register(CreateTrackerTableViewCell.self,
                                forCellReuseIdentifier: CreateTrackerTableViewCell.identifier)
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
        label.textColor = .ypBlack
        return label
    }

    private lazy var emojiCollectionView: UICollectionView = {
        let collectionView = createCollectionView()
        collectionView.register(EmojiCollectionViewCell.self,
                                forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        return collectionView
    }()

    private lazy var colorCollectionView: UICollectionView = {
        let collectionView = createCollectionView()
        collectionView.register(ColorCollectionViewCell.self,
                                forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        return collectionView
    }()

    private func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
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

    convenience init(mode: CreateTrackerMode) {
        self.init()
        switch mode {
        case .habit:
            titleText = "Новая привычка"
        case .event:
            titleText = "Новое нерегулярное событие"
        }
    }


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
        let svContentG = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate(
                [
                    scrollView.topAnchor.constraint(equalTo: safeG.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor),
                    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                    svContentG.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),

                    contentView.topAnchor.constraint(equalTo: svContentG.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                    contentView.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),

                    titleLabel.topAnchor.constraint(equalTo: svContentG.topAnchor, constant: 26),
                    titleLabel.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: sideInset),
                    titleLabel.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor, constant: -sideInset),

                    nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
                    nameTextField.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: sideInset),
                    nameTextField.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor, constant: -sideInset),
                    nameTextField.heightAnchor.constraint(equalToConstant: 75),

                    configureTable.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
                    configureTable.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: sideInset),
                    configureTable.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor, constant: -sideInset),
                    configureTable.heightAnchor.constraint(equalToConstant: tableCellHeight * CGFloat(tableRows)),


                    emojiLabel.topAnchor.constraint(equalTo: configureTable.bottomAnchor, constant: 32),
                    emojiLabel.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: 28),
                    emojiLabel.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor, constant: -28),

                    emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24),
                    emojiCollectionView.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: 18),
                    emojiCollectionView.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor, constant: -18),
                    emojiCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),

                    colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40),
                    colorLabel.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: 28),
                    colorLabel.trailingAnchor
                            .constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -28),

                    colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 24),
                    colorCollectionView.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: 18),
                    colorCollectionView.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor, constant: -18),
                    colorCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),

                    buttonsStackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 40),
                    buttonsStackView.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: 20),
                    buttonsStackView.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor, constant: -20),
                    buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
                ]
        )
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func saveButtonTapped() {
        guard let delegate,
              let selectedEmojiPath,
              let selectedColorPath else { return }
        delegate.addTracker(tracker: Tracker(
                id: UUID(),
                name: nameTextField.text!,
                color: colors[selectedColorPath.row],
                emoji: emojis[selectedEmojiPath.row],
                schedule: Schedule(days: Set(selectedDays)))
        )
    }
}

extension CreateTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateSaveButtonState()
    }

    private func updateSaveButtonState() {
        if (nameTextField.text?.isEmpty ?? true)
           || selectedDays.isEmpty
           || selectedEmojiPath == nil
           || selectedColorPath == nil {
            disableButton(saveButton)
        } else {
            enableButton(saveButton)
        }
    }
}

extension CreateTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
                withIdentifier: CreateTrackerTableViewCell.identifier,
                for: indexPath) as! CreateTrackerTableViewCell
        switch indexPath.row {
        case 0:
            cell.configure(title: "Категория")
        case 1:
            cell.configure(title: "Расписание")
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableCellHeight
    }
}

extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
//            let vc = CategoriesViewController()
//            navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = ScheduleViewController()
            vc.delegate = self
            vc.selectedDays = selectedDays
            present(vc, animated: true)
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CreateTrackerTableViewCell {
            cell.isLast = tableView.isLastCellInSection(at: indexPath)
        }
    }
}


extension CreateTrackerViewController: UICollectionViewDataSource {
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
        switch collectionView {
        case emojiCollectionView:
            return dequeueCellWithValue(collectionView,
                                        cellForItemAt: indexPath,
                                        cellType: EmojiCollectionViewCell.self,
                                        value: emojis[indexPath.row])
        case colorCollectionView:
            return dequeueCellWithValue(collectionView,
                                        cellForItemAt: indexPath,
                                        cellType: ColorCollectionViewCell.self,
                                        value: colors[indexPath.row])
        default:
            return UICollectionViewCell()
        }

        func dequeueCellWithValue<T: CellWithValueProtocol>(
                _ collectionView: UICollectionView,
                cellForItemAt indexPath: IndexPath,
                cellType: T.Type,
                value: T.TValue) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
            cell.value = value
            return cell
        }
    }
}

extension CreateTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case emojiCollectionView:
            if selectedEmojiPath == indexPath { return };
            selectCell(collectionView,
                       selectedPath: indexPath,
                       cellType: EmojiCollectionViewCell.self,
                       prevSelectedPath: selectedEmojiPath)
            selectedEmojiPath = indexPath
        case colorCollectionView:
            if selectedColorPath == indexPath { return }
            selectCell(collectionView,
                       selectedPath: indexPath,
                       cellType: ColorCollectionViewCell.self,
                       prevSelectedPath: selectedColorPath)
            selectedColorPath = indexPath
        default:
            break
        }
        updateSaveButtonState()
    }

    private func selectCell<T: SelectableCellProtocol>(
            _ collectionView: UICollectionView,
            selectedPath: IndexPath,
            cellType: T.Type,
            prevSelectedPath: IndexPath?) {
        if let prevSelectedPath {
            setSelectedState(collectionView, cellForItemAt: prevSelectedPath, cellType: cellType, state: false)
        }
        setSelectedState(collectionView, cellForItemAt: selectedPath, cellType: cellType, state: true)

        func setSelectedState(_ collectionView: UICollectionView, cellForItemAt: IndexPath, cellType: T.Type, state: Bool) {
            let cell = collectionView.cellForItem(at: cellForItemAt) as! T
            cell.isSelected = state
        }
    }
}

extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionCellSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let paddingsCount = collectionItemsPerRow - 1
        if paddingsCount <= 0 {
            return 0.0
        }
        let itemsWidth = collectionCellSize.width * collectionItemsPerRow
        let paddingsWidth = collectionView.bounds.width - itemsWidth
        if paddingsWidth <= 0 {
            return 5.0
        }
        let padding = paddingsWidth / paddingsCount
        return padding.rounded(.towardZero)
    }
}

extension CreateTrackerViewController: AddHabitViewControllerDelegate {
    func setSchedule(schedule: [WeekDay]) {
        selectedDays = schedule
        updateSaveButtonState()
    }
}
