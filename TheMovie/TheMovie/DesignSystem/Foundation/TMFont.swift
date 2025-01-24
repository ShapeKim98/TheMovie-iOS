//
//  TMFont.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit

enum TMFont {
    case caption
    case body
    case title
    case headline
    case subheadline
    
    var uiFont: UIFont {
        switch self {
        case .caption:
            return .systemFont(ofSize: 12, weight: .regular)
        case .body:
            return .systemFont(ofSize: 13, weight: .regular)
        case .title:
            return .systemFont(ofSize: 16, weight: .bold)
        case .headline:
            return .systemFont(ofSize: 15, weight: .bold)
        case .subheadline:
            return .systemFont(ofSize: 15, weight: .regular)
        }
    }
}
