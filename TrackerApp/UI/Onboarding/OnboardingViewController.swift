//
//  OnboardingViewController.swift
//  TrackerApp
//
//  Created by Vitaly Anpilov on 05.05.2023.
//

import UIKit


enum Pages: CaseIterable {
    case pageZero
    case pageOne
    
    var name: String {
        switch self {
        case .pageZero:
            return NSLocalizedString("backgroundImage.blue.text", comment: "")
        case .pageOne:
            return NSLocalizedString("Even if it's not liters of water or yoga", comment: "")
        }
    }
    
    var background: UIImageView {
        switch self {
        case .pageZero:
            return UIImageView(image: UIImage(named: "background1")!)
        case .pageOne:
            return UIImageView(image: UIImage(named: "background2")!)
        }
    }
    
    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        }
    }
}

final class OnboardingViewController: UIPageViewController {
    
    //    MARK: - Layout
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("onboardingPageViewController.Button", comment: ""), for: .normal)
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
        pageControl.numberOfPages = Pages.allCases.count
        pageControl.currentPage = currentIndex
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .ypGray
        return pageControl
    }()
    
    private var pageController: UIPageViewController?
    private var pages: [Pages] = Pages.allCases
    private var currentIndex: Int = 0
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
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
    private func setupPageController() {
        
        pageController = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal,
                                              options: nil)
        pageController?.dataSource = self
        pageController?.delegate = self
        pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        pageController?.view.backgroundColor = .gray
        addChild(pageController!)
        self.view.addSubview(self.pageController!.view)
        
        let initialVC = OnboardingPageViewController(page: pages[0])
        
        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        
        self.pageController?.didMove(toParent: self)
    }
    
    private func setLayout() {
        
        [button, pageControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24)
        ])
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


extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? OnboardingPageViewController else { return nil }
        
        var index = currentVC.page.index
        if index == 0 {
            return nil
        }
        index -= 1
        pageControl.currentPage = index
        
        return OnboardingPageViewController(page: pages[index])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? OnboardingPageViewController else { return nil }
        
        var index = currentVC.page.index
        if index >= self.pages.count - 1 {
            return nil
        }
    
        index += 1
        pageControl.currentPage = index
       
        return OnboardingPageViewController(page: pages[index])
    }
    
}
