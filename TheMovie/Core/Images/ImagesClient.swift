//
//  ImagesClient.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import Foundation

final class ImagesClient {
    static let shared = ImagesClient()
    
    private let provider = NetworkProvider<ImagesEndPoint>()
    
    private init() {}
    
    func fetchImages(
        _ id: Int,
        completion: @escaping (Result<Images, Error>) -> Void
    ) {
        provider.request(.fetchImages(id), completion: completion)
    }
}

