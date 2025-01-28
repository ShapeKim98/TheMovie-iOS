//
//  ImagesEndPoint.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import Foundation

import Alamofire

enum ImagesEndPoint: EndPoint {
    case fetchImages(_ id: Int)
    
    var path: String {
        switch self {
        case let .fetchImages(id):
            return "/movie/\(id)/images"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchImages: return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchImages:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        return .authorization
    }
}
