//
//  ViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit

final class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarController()
        
        configureTabBarAppearance()
    }

}

private extension ViewController {
    func configureTabBarController() {
        let dayViewController = UINavigationController(rootViewController: DayViewController())
        dayViewController.tabBarItem.title = "CINEMA"
        dayViewController.tabBarItem.image = UIImage(systemName: "popcorn")
        
        let upcomingViewController = UINavigationController(rootViewController: UIViewController())
        upcomingViewController.tabBarItem.title = "UPCOMING"
        upcomingViewController.tabBarItem.image = UIImage(systemName: "film.stack")
        
        let settingViewController = UINavigationController(rootViewController: SettingViewController())
        settingViewController.tabBarItem.title = "PROFILE"
        settingViewController.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        setViewControllers(
            [dayViewController, upcomingViewController, settingViewController],
            animated: true
        )
        
        for viewController in viewControllers ?? [] {
            guard let viewController = viewController as? UINavigationController else {
                continue
            }
            
            viewController.navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.tm(.semantic(.text(.primary)))
            ]
            viewController.navigationBar.tintColor = .tm(.primitive(.blue))
            viewController.navigationBar.barTintColor = .tm(.primitive(.black))
        }
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
}
