//
//  ViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit
import Network

import SnapKit

final class ViewController: UITabBarController {
    private let toastMessageView = UIView()
    
    private let networkMonitor = NetworkMonitor()
    
    private var networkIsConnected = true {
        didSet { didSetNetworkIsConnected() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        networkMonitor.monitoringStart()
        
        networkMonitor.monitoringHandler { [weak self] path in
            guard let `self` else { return }
            networkIsConnected = path.status == .satisfied
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
    }
}

// MARK: Configure Views
private extension ViewController {
    func configureUI() {
        configureTabBarController()
        
        configureTabBarAppearance()
        
        configureToastMessageView()
    }
    
    func configureLayout() {
        toastMessageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    func configureTabBarController() {
        let dayViewController = DayViewController()
        dayViewController.tabBarItem = UITabBarItem(
            title: "CINEMA",
            image: UIImage(systemName: "popcorn"),
            tag: 0
        )
        
        let upcomingViewController = UIViewController()
        upcomingViewController.tabBarItem = UITabBarItem(
            title: "UPCOMING",
            image: UIImage(systemName: "film.stack"),
            tag: 1
        )
        
        let settingViewController = SettingViewController()
        settingViewController.tabBarItem = UITabBarItem(
            title: "PROFILE",
            image: UIImage(systemName: "person.crop.circle"),
            tag: 2
        )
        
        let viewControllers = [
            UINavigationController(rootViewController: dayViewController),
            UINavigationController(rootViewController: upcomingViewController),
            UINavigationController(rootViewController: settingViewController)
        ]
        
        for viewController in viewControllers {
            viewController.navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.tm(.semantic(.text(.primary)))
            ]
            viewController.navigationBar.tintColor = .tm(.primitive(.blue))
            viewController.navigationBar.barTintColor = .tm(.primitive(.black))
        }
        
        setViewControllers(viewControllers, animated: true)
    }
    
    func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tm(.semantic(.background(.primary)))
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .tm(.primitive(.blue))
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func configureToastMessageView() {
        let label = UILabel()
        label.text = "네트워크 연결을 확인해 주세요."
        label.textColor = .tm(.semantic(.text(.brand)))
        label.font = .tm(.headline)
        toastMessageView.addSubview(label)
        label.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }
        
        toastMessageView.backgroundColor = .tm(.semantic(.background(.tertiary)))
        toastMessageView.layer.cornerRadius = (UIFont.tm(.headline).lineHeight + 16) / 2
        toastMessageView.clipsToBounds = true
        view.addSubview(toastMessageView)
        toastMessageView.alpha = 0
        toastMessageView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
}

// MARK: Data Bindings
private extension ViewController {
    func didSetNetworkIsConnected() {
        UIView.springAnimate { [weak self] in
            guard let `self` else { return }
            if networkIsConnected {
                toastMessageView.alpha = 0
                toastMessageView.transform = CGAffineTransform(translationX: 0, y: 0)
            } else {
                toastMessageView.alpha = 1
                toastMessageView.transform = CGAffineTransform(translationX: 0, y: 50)
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    ViewController()
}
