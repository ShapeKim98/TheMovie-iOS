//
//  UIViewController+Extension.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit

extension UIViewController {
    func push(_ viewController: UIViewController, source: UIView? = nil) {
        if #available(iOS 18.0, *) {
            viewController.preferredTransition = .zoom { _ in
                return source
            }
        } else {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func switchRoot(_ viewController: UIViewController) {
        let scene = UIApplication.shared.connectedScenes.first
        guard
            let windowScene = scene as? UIWindowScene,
            let window = windowScene.windows.first
        else { return }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
