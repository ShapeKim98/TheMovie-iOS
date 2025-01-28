//
//  SearchEndPoint.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import Foundation

import Alamofire

enum SearchEndPoint: EndPoint {
    case fetchSearch(_ model: SearchRequest)
    
    var path: String {
        switch self {
        case .fetchSearch: return "/search/movie"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchSearch: return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchSearch(model):
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
