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
            if source != nil {
                viewController.preferredTransition = .zoom { _ in
                    return source
                }
            }
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleFailure(_ failure: Error) {
        UINotificationFeedbackGenerator()
            .notificationOccurred(.error)
        if let baseError = failure as? BaseError {
            let message =  baseError.statusMessage
            presentAlert(title: "오류", message: message)
        } else {
            presentAlert(title: "오류", message: "알 수 없는 오류입니다.")
            print(failure)
        }
    }
    
    func presentAlert(title: String?, message: String? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        alert.overrideUserInterfaceStyle = .dark
        present(alert, animated: true)
    }
    
    func navigation(_ viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.tm(.semantic(.text(.primary)))
        ]
        navigation.navigationBar.tintColor = .tm(.primitive(.blue))
        navigation.navigationBar.barTintColor = .tm(.primitive(.black))
        return navigation
    }
}
