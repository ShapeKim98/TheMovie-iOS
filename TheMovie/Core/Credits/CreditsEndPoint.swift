//
//  CreditsEndPoint.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import Foundation

import Alamofire

enum CreditsEndPoint: EndPoint {
    case fetchCredits(_ model: CreditsRequest)
    
    var path: String {
        switch self {
        case .fetchCredits(let model):
            return "/movie/\(model.id)/credits"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchCredits: return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchCredits(model):
            let mirror = Mirror(reflecting: model)
            var queryItems: Parameters = [:]
            for child in mirror.children {
                guard child.label != "id" else { continue }
                queryItems.updateValue(
                    child.value,
                    forKey: child.label ?? ""
                )
            }
            return queryItems
        }
    }
    
    var headers: HTTPHeaders? {
        return .authorization
    }
}
