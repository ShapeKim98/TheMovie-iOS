//
//  TMImage.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit

enum TMImage {
    case onboarding
    case profile(id: Int)
    
    var uiImage: UIImage? {
        switch self {
        case .onboarding:
            return UIImage(named: "onboarding")
        case .profile(id: let id):
            return UIImage(named: "profile_\(id)")
        }
    }
}
