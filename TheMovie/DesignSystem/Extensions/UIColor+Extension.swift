//
//  UIColor+Extension.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit

extension UIColor {
    static func tm(_ tmColor: TMColor, alpha: CGFloat = 1.0) -> UIColor {
        return tmColor.uiColor.withAlphaComponent(alpha)
    }
}
