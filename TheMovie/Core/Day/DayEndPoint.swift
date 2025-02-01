//
//  DayEndPoint.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

import Alamofire

enum DayEndPoint: EndPoint {
    case fetchDay(_ model: DayRequest)
    
    var path: String {
        switch self {
        case .fetchDay: return "/trending/movie/day"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchDay: return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchDay(model):
            let mirror = Mirror(reflecting: model)
            var queryItems: Parameters = [:]
            for child in mirror.children {
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
