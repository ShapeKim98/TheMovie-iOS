//
//  Bundle+Extension.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

extension Bundle {
    var accessToken: String {
        return infoDictionary?["ACCESS_TOKEN"] as? String ?? ""
    }
}
