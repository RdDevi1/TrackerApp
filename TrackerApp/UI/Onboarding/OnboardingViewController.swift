//
//  OnboardingViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 05.05.2023.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    //    MARK: - Layout
    private lazy var pages: [UIViewController] = {
        let vc1 = createPage(withBackground: UIImage(named: "background1")!, text: "Отслеживайте только то, что хотите")
        let vc2 = createPage(withBackground: UIImage(named: "background2")!, text: "Даже если это не литры воды и йога")
        return [vc1, vc2]
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вот это технолгии!", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.backgroundColor = .black
        button.tintColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .ypGray
        return pageControl
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        setLayout()
    }
    
    override init(transitionStyle: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]?) {
        super.init(transitionStyle: .pageCurl,
                   navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Methods
    private func setLayout() {
        view.addSubview(button)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24)
            
        ])
    }
    
    private func createPage(withBackground backgroundImage: UIImage, text: String) -> UIViewController {
        let vc = UIViewController()
        let background = UIImageView(image: backgroundImage)
        background.frame = vc.view.bounds
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        vc.view.addSubview(background)
        vc.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: 432)
        ])
        vc.view.backgroundColor = .blue
        return vc
    }

    //    MARK: - Actions
    @objc
    private func didTapButton() {
        let tabBarVC = TabBarController()
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.modalTransitionStyle = .flipHorizontal
        present(tabBarVC, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        //возвращаем предыдущий (относительно переданного viewController) дочерний контроллер
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        //возвращаем следующий (относительно переданного viewController) дочерний контроллер
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
