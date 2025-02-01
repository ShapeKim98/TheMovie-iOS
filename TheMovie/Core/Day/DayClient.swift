//
//  DayClient.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

final class DayClient {
    static let shared = DayClient()
    
    private let provider = NetworkProvider<DayEndPoint>()
    
    private init() {}
    
    func fetchDay(
        _ model: DayRequest,
        completion: @escaping (Result<Day, Error>) -> Void
    ) {
        provider.request(.fetchDay(model), completion: completion)
    }
}
