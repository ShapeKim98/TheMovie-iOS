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
    
    var baseURL: String {
        return infoDictionary?["BASE_URL"] as? String ?? ""
    }
    
    var imageBaseURL: String {
        return infoDictionary?["IMAGE_BASE_URL"] as? String ?? ""
    }
}
