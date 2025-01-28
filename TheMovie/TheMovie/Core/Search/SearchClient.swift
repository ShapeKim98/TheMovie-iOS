//
//  SearchClient.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import Foundation

final class SearchClient {
    static let shared = SearchClient()
    
    private let provider = NetworkProvider<SearchEndPoint>()
    
    private init() {}
    
    func fetchSearch(
        _ model: SearchRequest,
        completion: @escaping (Result<Search, Error>) -> Void
    ) {
        provider.request(.fetchSearch(model), completion: completion)
    }
}
