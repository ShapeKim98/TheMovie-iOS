//
//  CreditsClient.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import Foundation

final class CreditsClient {
    static let shared = CreditsClient()
    
    private let provider = NetworkProvider<CreditsEndPoint>()
    
    private init() {}
    
    func fetchCredits(
        _ model: CreditsRequest,
        completion: @escaping (Result<Credits, Error>) -> Void
    ) {
        provider.request(.fetchCredits(model), completion: completion)
    }
}
