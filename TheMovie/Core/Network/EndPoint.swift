//
//  EndPoint.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

import Alamofire

protocol EndPoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
}
