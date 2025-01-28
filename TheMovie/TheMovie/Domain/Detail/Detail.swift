//
//  Detail.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import Foundation

struct Detail {
    let movie: Movie
    var images: Images?
    var credits: Credits?
    
    init(movie: Movie, images: Images? = nil, credits: Credits? = nil) {
        self.movie = movie
        self.images = images
        self.credits = credits
    }
}

extension Detail {
    static let mock = Detail(
        movie: .mock,
        images: .mock,
        credits: .mock
    )
}
