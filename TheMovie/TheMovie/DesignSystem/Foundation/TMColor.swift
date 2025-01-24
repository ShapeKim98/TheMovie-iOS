//
//  TMColor.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit

enum TMColor {
    case brand
    case gray
    case graySecondary
    case black
    case white
    
    var uiColor: UIColor {
        switch self {
        case .brand: return UIColor(resource: .brand)
        case .gray: return UIColor(resource: .gray)
        case .graySecondary: return UIColor(resource: .graySecondary)
        case .black: return UIColor(resource: .black)
        case .white: return UIColor(resource: .white)
        }
    }
    
    var cgColor: CGColor {
        self.uiColor.cgColor
    }
}
