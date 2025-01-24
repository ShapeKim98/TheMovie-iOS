//
//  UIFont+Extension.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit

extension UIFont {
    static func tm(_ tmFont: TMFont) -> UIFont {
        return tmFont.uiFont
    }
    
    static func italicBoldSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        let font: UIFont = .italicSystemFont(ofSize: fontSize)
        let descriptor = font.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic])
        guard let descriptor else { return font }
        return UIFont(descriptor: descriptor, size: fontSize)
    }
}
