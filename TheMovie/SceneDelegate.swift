//
//  SceneDelegate.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    @UserDefault(
        forKey: .userDefaults(.profileCompleted),
        defaultValue: false
    )
    private var isProfileCompleted: Bool?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window?.windowScene = scene
        
        var viewController: UIViewController
        
        if let isProfileCompleted, isProfileCompleted {
            viewController = configureViewController()
        } else {
            viewController = configureOnboardViewController()
        }
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func configureViewController() -> UIViewController {
        let viewController = ViewController()
        
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
        settingViewController.delegate = self
        
        let viewControllers = [
            UINavigationController(rootViewController: dayViewController),
            UINavigationController(rootViewController: upcomingViewController),
            UINavigationController(rootViewController: settingViewController)
        ]
        
        for child in viewControllers {
            child.navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.tm(.semantic(.text(.primary)))
            ]
            child.navigationBar.tintColor = .tm(.primitive(.blue))
            child.navigationBar.barTintColor = .tm(.primitive(.black))
        }
        
        viewController.setViewControllers(viewControllers, animated: true)
        return viewController
    }
    
    func configureOnboardViewController() -> UIViewController {
        let onboardViewController = OnboardViewController()
        onboardViewController.delegate = self
        onboardViewController.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.tm(.semantic(.text(.primary)))
        ]
        onboardViewController.navigationController?.navigationBar.tintColor = .tm(.primitive(.blue))
        onboardViewController.navigationController?.navigationBar.barTintColor = .tm(.primitive(.black))
        
        return UINavigationController(
            rootViewController: onboardViewController
        )
    }
}

extension SceneDelegate: SettingViewControllerDelegate {
    func withdrawButtonTouchUpInside() {
        window?.rootViewController = configureOnboardViewController()
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate: OnboardViewControllerDelegate {
    func completeButtonTouchUpInside() {
        window?.rootViewController = configureViewController()
        window?.makeKeyAndVisible()
    }
}
