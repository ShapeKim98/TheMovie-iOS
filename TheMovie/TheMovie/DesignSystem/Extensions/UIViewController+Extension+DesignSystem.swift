//
//  UIViewController+Extension.swift
//  TheMovie
//
//  Created by 김도형 on 1/26/25.
//

import UIKit

extension UIViewController {
    func setTMBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
