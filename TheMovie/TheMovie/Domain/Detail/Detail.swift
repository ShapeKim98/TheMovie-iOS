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
        movie: Movie(
            id: 610251,
            backdropPath: "/biJctq3zk4Km3hYkRQWN91yt0rY.jpg",
            title: "하얼빈",
            overview: "1908년 함경북도 신아산에서 안중근이 이끄는 독립군들은 일본군과의 전투에서 큰 승리를 거둔다. 대한의군 참모중장 안중근은 만국공법에 따라 전쟁포로인 일본인들을 풀어주게 되고, 이 사건으로 인해 독립군 사이에서는 안중근에 대한 의심과 함께 균열이 일기 시작한다. 1년 후, 블라디보스토크에는 안중근을 비롯해 우덕순, 김상현, 공부인, 최재형, 이창섭 등 빼앗긴 나라를 되찾기 위해 마음을 함께하는 이들이 모이게 된다. 이토 히로부미가 러시아와 협상을 위해 하얼빈으로 향한다는 소식을 접한 안중근과 독립군들은 하얼빈으로 향하고, 내부에서 새어 나간 이들의 작전 내용을 입수한 일본군들의 추격이 시작되는데…",
            posterPath: "/68D8dptiLWxUqwM9Iop1pNedSZL.jpg",
            genreIds: [.액션, .스릴러, .역사, .전쟁],
            releaseDate: "2024-12-24",
            voteAverage: 8.2
        ),
        images: .mock,
        credits: .mock
    )
}
