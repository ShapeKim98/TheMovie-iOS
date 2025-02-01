//
//  BaseError.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

struct BaseError: Error, Decodable {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
