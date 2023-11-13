//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Андрей Парамонов on 22.04.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    let categoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()
    let trackerRecordStore: TrackerRecordStoreProtocol = TrackerRecordStore()

    private var currentDate: Date {
        datePicker.date
    }

    private lazy var plusImageButton: UIButton = {
        let plusImage = UIButton()
        plusImage.translatesAutoresizingMaskIntoConstraints = false
        plusImage.setImage(UIImage(named: "AddTracker"), for: .normal)
        plusImage.tintColor = .ypBlack
        plusImage.contentMode = .scaleAspectFit
        plusImage.backgroundColor = .clear
        plusImage.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        return plusImage
    }()

    private lazy var plusButton: UIBarButtonItem = {
        let plusButton = UIBarButtonItem(customView: plusImageButton)
        return plusButton
    }()

    private lazy var trackerLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackerLabel.textColor = .ypBlack
        trackerLabel.text = "Трекеры"
        return trackerLabel
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.backgroundColor = .ypBackground
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.init(identifier: "ru_RU")
        datePicker.date = Date()
        return datePicker
    }()

    private lazy var datePickerButton: UIBarButtonItem = {
        let datePickerButton = UIBarButtonItem(customView: datePicker)
        return datePickerButton
    }()

    private lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 16))
        let imageView = UIImageView(frame: CGRect(x: 8, y: 0, width: 16, height: 16))
        imageView.image = UIImage(systemName: "magnifyingglass",
                                  withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?
                .withTintColor(.ypGray, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(imageView)
        searchTextField.leftViewMode = .always
        searchTextField.leftView = iconContainer
        searchTextField.placeholder = "Поиск"
        searchTextField.backgroundColor = .ypBackground
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.masksToBounds = true
        searchTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        searchTextField.textColor = .ypBlack
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        searchTextField.delegate = self
        return searchTextField
    }()

    private lazy var trackersView: UICollectionView = {
        let trackersView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        trackersView.translatesAutoresizingMaskIntoConstraints = false
        trackersView.backgroundColor = .clear
        trackersView.register(TrackerCollectionViewCell.self,
                              forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        trackersView.register(CategoryHeaderReusableView.self,
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: CategoryHeaderReusableView.identifier)
        trackersView.dataSource = self
        trackersView.delegate = self
        trackersView.showsVerticalScrollIndicator = false
        trackersView.showsHorizontalScrollIndicator = false
        return trackersView
    }()

    private lazy var emptyTrackersPlaceholderView: EmptyTrackersPlaceholderView = {
        let emptyTrackersPlaceholderView = EmptyTrackersPlaceholderView()
        emptyTrackersPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        return emptyTrackersPlaceholderView
    }()

    private lazy var trackerStore: TrackerStore = {
        let trackerStore = TrackerStore()
        trackerStore.delegate = self
        return trackerStore
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        addSubviews()
        setupConstraints()
        updateContent()
    }

    private func setupNavigationBar() {
        guard let navBar = navigationController?.navigationBar,
              let topItem = navBar.topItem else {
            return
        }
        topItem.setLeftBarButton(plusButton, animated: false)
        topItem.setRightBarButton(datePickerButton, animated: false)
    }

    private func addSubviews() {
        view.addSubview(trackerLabel)
        view.addSubview(searchTextField)
        view.addSubview(trackersView)
        view.addSubview(emptyTrackersPlaceholderView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    plusImageButton.widthAnchor.constraint(equalToConstant: 42),
                    plusImageButton.heightAnchor.constraint(equalToConstant: 42),

                    trackerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
                    trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

                    searchTextField.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 7),
                    searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    searchTextField.heightAnchor.constraint(equalToConstant: 36),

                    trackersView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
                    trackersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    trackersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    trackersView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

                    emptyTrackersPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    emptyTrackersPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ]
        )
    }

    private func updateContent() {
        let dayOfWeek = currentDate.dayOfWeek()
        let searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        trackerStore.filter(prefix: searchText, weekDay: dayOfWeek)
        emptyTrackersPlaceholderView.isHidden = trackerStore.categoriesCount() != 0
    }

    @objc private func addTracker() {
        let addTrackerViewController = AddTrackerViewController()
        addTrackerViewController.delegate = self
        present(addTrackerViewController, animated: true)
    }

    @objc private func dateChanged() {
        updateContent()
        presentedViewController?.dismiss(animated: false, completion: nil)
    }

    @objc private func searchTextChanged() {
        updateContent()
    }
}

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerStore.categoriesCount()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStore.trackersCount(for: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier,
                                                      for: indexPath) as? TrackerCollectionViewCell
                ?? TrackerCollectionViewCell()
        do {
            let tracker = try trackerStore.tracker(at: indexPath)
            let days = trackerRecordStore.count(for: tracker.id)
            let isDone = trackerRecordStore.exists(TrackerRecord(trackerId: tracker.id, date: currentDate.dateOnly()))
            let isButtonEnable = currentDate <= Date()
            cell.configure(with: tracker,
                           completedDays: days,
                           isDone: isDone,
                           isButtonEnable: isButtonEnable,
                           delegate: self);
            return cell
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
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
                    withReuseIdentifier: CategoryHeaderReusableView.identifier,
                    for: indexPath) as? CategoryHeaderReusableView ?? CategoryHeaderReusableView()
            sectionHeader.configure(with: trackerStore.categoryName(at: indexPath.section))
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }

    fileprivate var itemsPerRow: CGFloat {
        2
    }

    fileprivate var spacing: CGFloat {
        9
    }

    fileprivate var cellHeight: CGFloat {
        148
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = spacing * (itemsPerRow - 1)
        let widthPerItem = (collectionView.bounds.width - spacing) / itemsPerRow
        return CGSize(width: widthPerItem.rounded(.towardZero), height: cellHeight)
    }

    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}

extension TrackersViewController: TrackersViewControllerDelegate {
    func didCompleteTracker(id: UUID) {
        let trackerRecord = TrackerRecord(trackerId: id, date: currentDate.dateOnly())
        do {
            try trackerRecordStore.add(trackerRecord)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func didUncompleteTracker(id: UUID) {
        let trackerRecord = TrackerRecord(trackerId: id, date: currentDate.dateOnly())
        do {
            try trackerRecordStore.remove(trackerRecord)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func addTrackerToCategory(category: String, tracker: Tracker) {
        do {
            try categoryStore.createOrUpdate(header: category, tracker: tracker)
            trackerStore.performFetch()
        } catch {
            fatalError(error.localizedDescription)
        }
        updateContent()
    }

    func updateTrackers(changes: TrackersChanges) {
        reloadData()
    }

    func reloadData() {
        trackersView.reloadData()
    }
}
