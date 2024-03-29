//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Андрей Парамонов on 22.04.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    private let viewModel: TrackersViewModelProtocol
    private let analyticsService: AnalyticsService?
    private let filtersButtonHeight: CGFloat = 50
    private let filtersButtonVerticalOffset: CGFloat = 16

    private lazy var plusImageButton: UIButton = {
        let plusImage = UIButton()
        plusImage.translatesAutoresizingMaskIntoConstraints = false
        plusImage.setImage(UIImage(named: "AddTracker")?.withTintColor(.ypBlack), for: .normal)
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
        trackerLabel.text = L10n.Localizable.Trackers.title
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
        trackersView.alwaysBounceVertical = true
        trackersView.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: filtersButtonHeight + filtersButtonVerticalOffset,
                                                 right: 0)
        return trackersView
    }()

    private lazy var emptyTrackersPlaceholderView: EmptyResultPlaceholderView = {
        let emptyTrackersPlaceholderView = EmptyResultPlaceholderView(emptyStateText: "Что будем отслеживать?")
        emptyTrackersPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        return emptyTrackersPlaceholderView
    }()

    private lazy var filtersButton: UIButton = {
        let filtersButton = UIButton()
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        filtersButton.setTitle(L10n.Localizable.Trackers.filters, for: .normal)
        filtersButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        filtersButton.backgroundColor = .ypBlue
        filtersButton.layer.cornerRadius = 16
        filtersButton.layer.masksToBounds = true
        filtersButton.addTarget(self, action: #selector(filtersTapped), for: .touchUpInside)
        return filtersButton
    }()

    init(viewModel: TrackersViewModelProtocol, analyticsService: AnalyticsService? = nil) {
        self.viewModel = viewModel
        self.analyticsService = analyticsService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        analyticsService?.report(name: "viewDidLoad", event: .open, screen: .main, item: nil)
        viewModel.currentDateObservable.bind { [weak self] dateOnly in
            self?.datePicker.date = dateOnly.date
        }
        viewModel.trackersDidChange = { [weak self] in
            self?.trackersView.reloadData()
        }
        viewModel.placeholderStateObservable.bind { [weak self] state in
            self?.placeholderDidChange(state: state)
        }
        setupView()
        viewModel.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService?.report(name: "viewDidDisappear", event: .close, screen: .main, item: nil)
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
        trackersView.addSubview(filtersButton)
        view.addSubview(emptyTrackersPlaceholderView)
    }

    private func setupConstraints() {
        let safeG = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate(
                [
                    plusImageButton.widthAnchor.constraint(equalToConstant: 42),
                    plusImageButton.heightAnchor.constraint(equalToConstant: 42),

                    trackerLabel.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 1),
                    trackerLabel.leadingAnchor
                            .constraint(equalTo: view.leadingAnchor, constant: Constants.defaultLeadingOffset),

                    searchTextField.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 7),
                    searchTextField.leadingAnchor
                            .constraint(equalTo: view.leadingAnchor, constant: Constants.defaultLeadingOffset),
                    searchTextField.trailingAnchor
                            .constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultLeadingOffset),
                    searchTextField.heightAnchor.constraint(equalToConstant: 36),

                    trackersView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
                    trackersView.leadingAnchor
                            .constraint(equalTo: view.leadingAnchor, constant: Constants.trackersViewSideOffset),
                    trackersView.trailingAnchor
                            .constraint(equalTo: view.trailingAnchor, constant: -Constants.trackersViewSideOffset),
                    trackersView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor),

                    emptyTrackersPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    emptyTrackersPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

                    filtersButton.widthAnchor.constraint(equalToConstant: 114),
                    filtersButton.heightAnchor.constraint(equalToConstant: filtersButtonHeight),
                    filtersButton.centerXAnchor.constraint(equalTo: trackersView.safeAreaLayoutGuide.centerXAnchor),
                    filtersButton.bottomAnchor.constraint(equalTo: trackersView.safeAreaLayoutGuide.bottomAnchor,
                                                          constant: -filtersButtonVerticalOffset),
                ]
        )
    }

    @objc private func addTracker() {
        analyticsService?.report(name: "addTracker", event: .click, screen: .main, item: .addTrack)
        let addTrackerViewController = AddTrackerViewController()
        addTrackerViewController.delegate = viewModel
        present(addTrackerViewController, animated: true)
    }

    @objc private func dateChanged() {
        viewModel.setCurrentDate(to: datePicker.date)
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

    @objc private func filtersTapped() {
        analyticsService?.report(name: "filtersTapped", event: .click, screen: .main, item: .filter)
        let vc = FiltersViewController(selectedFilter: viewModel.currentFilter, delegate: viewModel)
        present(vc, animated: true)
    }
}

extension TrackersViewController {
    private enum Constants {
        static let defaultLeadingOffset: CGFloat = 16
        static let trackersViewSideOffset: CGFloat = 10
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
        cell.configure(with: viewModel.cellModel(at: indexPath),
                       delegate: viewModel,
                       analyticsService: analyticsService);
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(
            _ collectionView: UICollectionView,
            contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
            point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let firstAction = getFirstAction(for: indexPath)
        return UIContextMenuConfiguration(actionProvider: { actions in
            UIMenu(children: [
                firstAction,
                UIAction(title: L10n.Localizable.Trackers.edit) { [weak self] _ in
                    self?.editTracker(at: indexPath)
                },
                UIAction(title: L10n.Localizable.Trackers.delete,
                         attributes: .destructive) { [weak self] _ in
                    self?.deleteTracker(at: indexPath)
                }
            ])
        })
    }

    func collectionView(
            _ collectionView: UICollectionView,
            contextMenuConfigurationForItemAt indexPath: IndexPath,
            point: CGPoint) -> UIContextMenuConfiguration? {
        self.collectionView(collectionView, contextMenuConfigurationForItemsAt: [indexPath], point: point)
    }

    private func getFirstAction(for indexPath: IndexPath) -> UIAction {
        let pinAction = viewModel.getPinAction(at: indexPath)
        switch pinAction {
        case .pin:
            return UIAction(title: L10n.Localizable.Trackers.pin) { [weak self] _ in
                self?.pinTracker(at: indexPath)
            }
        case .unpin:
            return UIAction(title: L10n.Localizable.Trackers.unpin) { [weak self] _ in
                self?.unpinTracker(at: indexPath)
            }
        }
    }

    private func editTracker(at indexPath: IndexPath) {
        analyticsService?.report(name: "editTracker", event: .click, screen: .main, item: .edit)
        let trackerType = viewModel.trackerType(at: indexPath)
        let vc = ConfigureTrackerViewController(trackerType: trackerType, mode: .edit)
        vc.editTrackerDelegate = self
        guard let editState = viewModel.getEditState(at: indexPath) else { return }
        vc.setState(editState)
        present(vc, animated: true)
    }

    private func deleteTracker(at indexPath: IndexPath) {
        analyticsService?.report(name: "deleteTracker", event: .click, screen: .main, item: .delete)
        let actionSheet = UIAlertController(title: nil,
                                            message: L10n.Localizable.Trackers.deleteConfirm,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: L10n.Localizable.Trackers.delete,
                                            style: .default) { [weak self] action in
            self?.viewModel.deleteTracker(at: indexPath)
        })
        actionSheet.addAction(UIAlertAction(title: L10n.Localizable.Trackers.deleteCancel, style: .cancel))
        present(actionSheet, animated: true, completion: nil)
    }

    func collectionView(
            _ collectionView: UICollectionView,
            contextMenuConfiguration configuration: UIContextMenuConfiguration,
            highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        getCellPreview(for: indexPath)
    }

    func collectionView(
            _ collectionView: UICollectionView,
            contextMenuConfiguration configuration: UIContextMenuConfiguration,
            dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        getCellPreview(for: indexPath)
    }

    private func getCellPreview(for indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = trackersView.cellForItem(at: indexPath) as? TrackerCollectionViewCell,
              let cellPreview = cell.previewView else { return nil }
        let targetedPreview = UITargetedPreview(view: cellPreview)
        targetedPreview.parameters.backgroundColor = .clear
        return targetedPreview
    }

    private func pinTracker(at indexPath: IndexPath) {
        viewModel.pinTracker(at: indexPath)
    }

    private func unpinTracker(at indexPath: IndexPath) {
        viewModel.unpinTracker(at: indexPath)
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
        1
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

extension TrackersViewController: EditTrackerDelegate {
    func editTracker(result: EditTrackerResult) {
        viewModel.editTracker(result: result)
        dismiss(animated: true)
    }
}
