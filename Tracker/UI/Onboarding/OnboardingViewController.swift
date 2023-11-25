//
// Created by Андрей Парамонов on 13.11.2023.
//

import Foundation
import UIKit

final class OnboardingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private lazy var pages: [UIViewController] = [
        OnboardingPageViewController(
                title: "Отслеживайте только то, что хотите",
                imageName: "Onboarding_1"
        ),
        OnboardingPageViewController(
                title: "Даже если это не литры воды и йога",
                imageName: "Onboarding_2"
        )
    ]

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .ypBlack.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = .ypBlack
        return pageControl
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        dataSource = self
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .ypBlack
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(pageControl)
        view.addSubview(button)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),

                    button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
                    button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    button.heightAnchor.constraint(equalToConstant: 60)
                ]
        )
    }

    func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = index - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }

    func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = index + 1
        guard nextIndex < pages.count else {
            return nil
        }
        return pages[nextIndex]
    }

    func pageViewController(
            _ pageViewController: UIPageViewController,
            willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers.first,
           let index = pages.firstIndex(of: vc) {
            pageControl.currentPage = index
        }
    }

    func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool) {
        if let vc = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: vc) {
            pageControl.currentPage = index
        }
    }

    @objc
    private func buttonTapped() {
        OnboardingDataStore.shared.setOnboardingWasShown()
        let viewController = HomePageViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
