//
//  UIImage+Extension.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit

extension UIImage {
    static func tm(_ tmImage: TMImage) -> UIImage? {
        return tmImage.uiImage
    }
}
