//
//  NetworkProvider.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

import Alamofire

struct NetworkProvider<E: EndPoint>: Sendable {
    func request<T: Decodable & Sendable>(
        _ endPoint: E,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard
            let url = try? (String.baseURL + endPoint.path).asURL()
        else {
            let error = AFError.parameterEncodingFailed(reason: .missingURL)
            completion(.failure(error))
            return
        }
        
        AF.request(
            url,
            method: endPoint.method,
            parameters: endPoint.parameters,
            encoding: URLEncoding.queryString,
            headers: endPoint.headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if let data = response.data {
                    do {
                        let baseError = try JSONDecoder().decode(BaseError.self, from: data)
                        completion(.failure(baseError))
                        return
                    } catch { completion(.failure(error)) }
                }
                
                completion(.failure(error))
            }
        }
    }
}

extension String {
    static let baseURL = Bundle.main.baseURL
    
    static let imageBaseURL = Bundle.main.imageBaseURL
}

extension HTTPHeaders {
    static let authorization: HTTPHeaders = [
        "Authorization": "Bearer " + Bundle.main.accessToken
    ]
}
