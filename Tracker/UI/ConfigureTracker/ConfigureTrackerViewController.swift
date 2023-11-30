//
// Created by Андрей Парамонов on 25.09.2023.
//

import UIKit

final class ConfigureTrackerViewController: UIViewController {
    weak var addTrackerDelegate: AddTrackerDelegate?
    weak var editTrackerDelegate: EditTrackerDelegate?

    private let tableCellHeight: CGFloat = 75
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
    private let emojiSectionIndex = 0
    private let colorSectionIndex = 1

    private var trackerType: TrackerType
    private var mode: ConfigurationMode

    private var titleText: String {
        switch mode {
        case .create:
            switch trackerType {
            case .habit:
                return "Новая привычка"
            case .irregularEvent:
                return "Новое нерегулярное событие"
            }
        case .edit:
            switch trackerType {
            case .habit:
                return "Редактирование привычки"
            case .irregularEvent:
                return "Редактирование нерегулярного события"
            }
        }
    }

    private var tableRows: Int {
        switch trackerType {
        case .habit:
            return 2
        case .irregularEvent:
            return 1
        }
    }

    private var saveButtonTitle: String {
        switch mode {
        case .create:
            return "Создать"
        case .edit:
            return "Сохранить"
        }
    }

    private var selectedCategory: TrackerCategory?
    private var selectedDays: [WeekDay] = []
    private var selectedEmojiPath: IndexPath?
    private var selectedColorPath: IndexPath?

    private var initTracker: Tracker?
    private var initCategory: TrackerCategory? {
        didSet {
            selectedCategory = initCategory
        }
    }
    private var initCompletedDays: Int = 0

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

    private lazy var completedDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.Localizable.numberOfDays(initCompletedDays)
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.isHidden = mode == .create
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

    private lazy var configurationTable: UITableView = {
        let configureTable = UITableView()
        configureTable.translatesAutoresizingMaskIntoConstraints = false
        configureTable.backgroundColor = .ypBackground
        configureTable.separatorStyle = .none
        configureTable.showsVerticalScrollIndicator = false
        configureTable.showsHorizontalScrollIndicator = false
        configureTable.register(ConfigureTrackerTableViewCell.self,
                                forCellReuseIdentifier: ConfigureTrackerTableViewCell.identifier)
        configureTable.delegate = self
        configureTable.dataSource = self
        configureTable.layer.cornerRadius = 16
        configureTable.layer.masksToBounds = true
        configureTable.isScrollEnabled = false
        configureTable.rowHeight = tableCellHeight
        return configureTable
    }()

    private lazy var configurationCollectionView: DynamicCollectionView = {
        let collectionView = DynamicCollectionView(frame: .zero,
                                                   collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ConfigurationHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ConfigurationHeaderReusableView.identifier)
        collectionView.register(EmojiCollectionViewCell.self,
                                forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        collectionView.register(ColorCollectionViewCell.self,
                                forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        return collectionView
    }()

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
        button.setTitle(saveButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel!.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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

    init(trackerType: TrackerType, mode: ConfigurationMode) {
        self.trackerType = trackerType
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        restoreFromState()
        updateSaveButtonState()
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
        contentView.addSubview(completedDaysLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(configurationTable)
        contentView.addSubview(configurationCollectionView)
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

                    contentView.topAnchor.constraint(equalTo: svContentG.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor),
                    contentView.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

                    svContentG.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

                    titleLabel.topAnchor.constraint(equalTo: svContentG.topAnchor, constant: 26),
                    titleLabel.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: sideInset),
                    titleLabel.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor, constant: -sideInset),

                    completedDaysLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
                    completedDaysLabel.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: sideInset),
                    completedDaysLabel.trailingAnchor
                            .constraint(equalTo: svContentG.trailingAnchor, constant: -sideInset),

                    nameTextFieldTopAnchor,
                    nameTextField.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: sideInset),
                    nameTextField.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor, constant: -sideInset),
                    nameTextField.heightAnchor.constraint(equalToConstant: 75),

                    configurationTable.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
                    configurationTable.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: sideInset),
                    configurationTable.trailingAnchor
                            .constraint(equalTo: svContentG.trailingAnchor, constant: -sideInset),
                    configurationTable.heightAnchor.constraint(equalToConstant: tableCellHeight * CGFloat(tableRows)),

                    configurationCollectionView.topAnchor.constraint(equalTo: configurationTable.bottomAnchor),
                    configurationCollectionView.leadingAnchor
                            .constraint(equalTo: svContentG.leadingAnchor, constant: 18),
                    configurationCollectionView.trailingAnchor
                            .constraint(equalTo: svContentG.trailingAnchor, constant: -18),

                    buttonsStackView.topAnchor
                            .constraint(equalTo: configurationCollectionView.bottomAnchor, constant: 40),
                    buttonsStackView.leadingAnchor.constraint(equalTo: svContentG.leadingAnchor, constant: 20),
                    buttonsStackView.trailingAnchor.constraint(equalTo: svContentG.trailingAnchor, constant: -20),
                    buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
                ]
        )
    }

    private var nameTextFieldTopAnchor: NSLayoutConstraint {
        switch mode {
        case .create:
            return nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38)
        case .edit:
            return nameTextField.topAnchor.constraint(equalTo: completedDaysLabel.bottomAnchor, constant: 40)
        }
    }

    private func restoreFromState() {
        guard let initTracker else { return }
        nameTextField.text = initTracker.name
        if let index = emojis.firstIndex(of: initTracker.emoji) {
            selectedEmojiPath = IndexPath(row: index, section: emojiSectionIndex)
        }
        if let index = colors.firstIndex(of: initTracker.color) {
            selectedColorPath = IndexPath(row: index, section: colorSectionIndex)
        }
        if let schedule = initTracker.schedule {
            selectedDays = schedule.days.sorted()
        }
        selectedCategory = initCategory
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text,
              let selectedCategory,
              let selectedEmojiPath,
              let selectedColorPath else { return }
        let schedule = selectedDays.isEmpty
                ? nil
                : Schedule(days: Set(selectedDays))
        switch mode {
        case .create:
            addTrackerDelegate?.addTracker(
                    tracker: Tracker(
                            id: UUID(),
                            name: name,
                            color: colors[selectedColorPath.row],
                            emoji: emojis[selectedEmojiPath.row],
                            schedule: schedule,
                            createdAt: DateOnly.today,
                            isPinned: false),
                    to: selectedCategory
            )
        case .edit:
            guard let initTracker,
                  let initCategory else { return }
            let tracker = Tracker(
                    id: initTracker.id,
                    name: name,
                    color: colors[selectedColorPath.row],
                    emoji: emojis[selectedEmojiPath.row],
                    schedule: schedule,
                    createdAt: initTracker.createdAt,
                    isPinned: initTracker.isPinned)
            let result = initCategory == selectedCategory
                    ? EditTrackerResult.edit(tracker: tracker)
                    : EditTrackerResult.editAndMove(tracker: tracker, to: selectedCategory, from: initCategory)
            editTrackerDelegate?.editTracker(result: result)
        }
    }

    private func updateSaveButtonState() {
        let isNameFilled = !(nameTextField.text?.isEmpty ?? true)
        let isDesignConfigured = selectedEmojiPath != nil && selectedColorPath != nil
        let isCategorySelected = selectedCategory != nil
        let fullConfigured: Bool
        switch trackerType {
        case .habit:
            fullConfigured = isNameFilled && isDesignConfigured && isCategorySelected && !selectedDays.isEmpty
        case .irregularEvent:
            fullConfigured = isNameFilled && isDesignConfigured && isCategorySelected
        }
        if fullConfigured {
            enableButton(saveButton)
        } else {
            disableButton(saveButton)
        }
    }

    func setState(_ state: EditState) {
        initTracker = state.cell.tracker
        initCategory = state.category
        initCompletedDays = state.cell.completedDays
    }
}

extension ConfigureTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateSaveButtonState()
    }
}

extension ConfigureTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConfigureTrackerTableViewCell.identifier,
                                                 for: indexPath) as? ConfigureTrackerTableViewCell
                ?? ConfigureTrackerTableViewCell()
        switch indexPath.row {
        case 0:
            let categoryTitle = "Категория"
            if let selectedCategory {
                cell.configure(title: categoryTitle, subtitle: selectedCategory.header)
            } else {
                cell.configure(title: categoryTitle)
            }
        case 1:
            let scheduleTitle = "Расписание"
            if selectedDays.isEmpty {
                cell.configure(title: scheduleTitle)
            } else {
                let schedule = selectedDays.count == WeekDay.allCases.count
                        ? "Каждый день"
                        : selectedDays.map { $0.shortDescription }.joined(separator: ", ")
                cell.configure(title: scheduleTitle, subtitle: schedule)
            }
        default:
            break
        }
        return cell
    }
}

extension ConfigureTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let viewModel = CategoriesViewModel(trackerCategoryStore: TrackerCategoryStore(), delegate: self)
            viewModel.selectedCategory = selectedCategory
            let vc = CategoriesViewController(viewModel: viewModel)
            present(vc, animated: true)
            break
        case 1:
            let vc = ScheduleViewController()
            vc.delegate = self
            vc.selectedDays = Set(selectedDays)
            present(vc, animated: true)
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ConfigureTrackerTableViewCell {
            cell.isLast = tableView.isLastCellInSection(at: indexPath)
        }
    }
}


extension ConfigureTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case emojiSectionIndex:
            return emojis.count
        case colorSectionIndex:
            return colors.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case emojiSectionIndex:
            return dequeueCellWithValue(collectionView,
                                        cellForItemAt: indexPath,
                                        cellType: EmojiCollectionViewCell.self,
                                        value: emojis[indexPath.row],
                                        isSelected: selectedEmojiPath == indexPath)
        case colorSectionIndex:
            return dequeueCellWithValue(collectionView,
                                        cellForItemAt: indexPath,
                                        cellType: ColorCollectionViewCell.self,
                                        value: colors[indexPath.row],
                                        isSelected: selectedColorPath == indexPath)
        default:
            return UICollectionViewCell()
        }

        func dequeueCellWithValue<T: CellWithValueProtocol>(
                _ collectionView: UICollectionView,
                cellForItemAt indexPath: IndexPath,
                cellType: T.Type,
                value: T.TValue,
                isSelected: Bool) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.identifier,
                                                          for: indexPath) as? T ?? T()
            cell.value = value
            cell.wasSelected = isSelected
            return cell
        }
    }
}

extension ConfigureTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case emojiSectionIndex:
            if selectedEmojiPath == indexPath { return };
            selectCell(collectionView,
                       selectedPath: indexPath,
                       cellType: EmojiCollectionViewCell.self,
                       previousSelectedPath: selectedEmojiPath)
            selectedEmojiPath = indexPath
        case colorSectionIndex:
            if selectedColorPath == indexPath { return }
            selectCell(collectionView,
                       selectedPath: indexPath,
                       cellType: ColorCollectionViewCell.self,
                       previousSelectedPath: selectedColorPath)
            selectedColorPath = indexPath
        default:
            break
        }
        updateSaveButtonState()
    }

    private func selectCell<T: CellWithValueProtocol>(
            _ collectionView: UICollectionView,
            selectedPath: IndexPath,
            cellType: T.Type,
            previousSelectedPath: IndexPath?) {
        if let previousSelectedPath {
            setSelectedState(collectionView, cellForItemAt: previousSelectedPath, cellType: cellType, state: false)
        }
        setSelectedState(collectionView, cellForItemAt: selectedPath, cellType: cellType, state: true)

        func setSelectedState(_ collectionView: UICollectionView, cellForItemAt: IndexPath, cellType: T.Type, state: Bool) {
            if let cell = collectionView.cellForItem(at: cellForItemAt) as? T {
                cell.wasSelected = state
            }
        }
    }
}

extension ConfigureTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
                collectionView,
                viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                at: sectionPath)
        return headerView.systemLayoutSizeFitting(
                CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel)
    }

    func collectionView(
            _ collectionView: UICollectionView,
            viewForSupplementaryElementOfKind kind: String,
            at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ConfigurationHeaderReusableView.identifier,
                    for: indexPath) as? ConfigurationHeaderReusableView ?? ConfigurationHeaderReusableView()
            var title = ""
            switch indexPath.section {
            case emojiSectionIndex:
                title = "Emoji"
            case colorSectionIndex:
                title = "Color"
            default:
                break
            }
            sectionHeader.configure(with: title)
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionCellSize
    }

    func collectionView(
            _ collectionView: UICollectionView,
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
        let itemsWidth = collectionCellSize.width * collectionItemsPerRow
        let paddingsWidth = collectionView.bounds.width - itemsWidth
        if paddingsWidth <= 0 {
            return 5.0
        }
        let padding = paddingsWidth / paddingsCount
        return padding.rounded(.towardZero)
    }

    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        } else {
            return UIEdgeInsets.zero
        }
    }
}

extension ConfigureTrackerViewController: ConfigureTrackerViewControllerDelegate {
    func setSchedule(schedule: [WeekDay]) {
        selectedDays = schedule.sorted()
        configurationTable.reloadData()
        updateSaveButtonState()
    }

    func setCategory(category: TrackerCategory?) {
        selectedCategory = category
        configurationTable.reloadData()
        updateSaveButtonState()
    }
}
