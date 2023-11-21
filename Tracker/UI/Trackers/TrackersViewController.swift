//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Андрей Парамонов on 22.04.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    private let viewModel: TrackersViewModelProtocol

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
        datePicker.date = viewModel.currentDate
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

    lazy var trackersView: UICollectionView = {
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
        let emptyTrackersPlaceholderView = EmptyTrackersPlaceholderView(emptyStateText: "Что будем отслеживать?")
        emptyTrackersPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        return emptyTrackersPlaceholderView
    }()

    init(viewModel: TrackersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reloadDataDelegate = { [weak self] in
            self?.trackersView.reloadData()
        }
        viewModel.placeholderStateObservable.bind { [weak self] state in
            self?.placeholderDidChange(state: state)
        }
        setupView()
        viewModel.viewDidLoad()
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        addSubviews()
        setupConstraints()
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
                    trackersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                    trackersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                    trackersView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

                    emptyTrackersPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    emptyTrackersPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ]
        )
    }

    @objc private func addTracker() {
        let addTrackerViewController = AddTrackerViewController()
        addTrackerViewController.delegate = viewModel
        present(addTrackerViewController, animated: true)
    }

    @objc private func dateChanged() {
        viewModel.dateChanged(to: datePicker.date)
        presentedViewController?.dismiss(animated: false, completion: nil)
    }

    @objc private func searchTextChanged() {
        viewModel.searchTextChanged(to: searchTextField.text)
    }

    private func placeholderDidChange(state: PlaceholderState) {
        switch state {
        case .hide:
            trackersView.isHidden = false
            emptyTrackersPlaceholderView.isHidden = true
        default:
            emptyTrackersPlaceholderView.configure(state: state)
            trackersView.isHidden = true
            emptyTrackersPlaceholderView.isHidden = false
        }
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
        viewModel.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier,
                                                      for: indexPath) as? TrackerCollectionViewCell
                ?? TrackerCollectionViewCell()
        cell.configure(with: viewModel.cellModel(at: indexPath), delegate: viewModel);
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(
            _ collectionView: UICollectionView,
            contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
            point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(actionProvider: { actions in
            UIMenu(children: [
                UIAction(title: "Закрепить") { [weak self] _ in
//                    self?.pinTracker(at: indexPaths)
                },
                UIAction(title: "Редактировать") { [weak self] _ in
//                    self?.editTracker(at: indexPaths)
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
//                    self?.deleteTracker(at: indexPaths)
                }
            ])
        })
    }

    func collectionView(
            _ collectionView: UICollectionView,
            contextMenuConfigurationForItemsAt indexPaths: IndexPath,
            point: CGPoint) -> UIContextMenuConfiguration? {
        self.collectionView(collectionView, contextMenuConfigurationForItemsAt: [indexPaths], point: point)
    }

    func collectionView(
            _ collectionView: UICollectionView,
            contextMenuConfiguration configuration: UIContextMenuConfiguration,
            highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        getPreviewView(for: indexPath)
    }

    func collectionView(
            _ collectionView: UICollectionView,
            contextMenuConfiguration configuration: UIContextMenuConfiguration,
            dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        getPreviewView(for: indexPath)
    }

    private func getPreviewView(for indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = trackersView.cellForItem(at: indexPath) as? TrackerCollectionViewCell,
              let preview = cell.previewView else { return nil }
        let targetedPreview = UITargetedPreview(view: preview)
        targetedPreview.parameters.backgroundColor = .clear
        return targetedPreview
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
            sectionHeader.configure(with: viewModel.categoryName(at: indexPath.section))
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }

    fileprivate var itemsPerRow: CGFloat {
        2
    }

    fileprivate var spacing: CGFloat {
        0
    }

    fileprivate var cellHeight: CGFloat {
        148
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = spacing * (itemsPerRow - 1)
        let widthPerItem = (collectionView.bounds.width - spacing) / itemsPerRow
        return CGSize(width: widthPerItem.rounded(.up), height: cellHeight)
    }

    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}
