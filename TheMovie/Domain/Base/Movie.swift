//
//  Movie.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

struct Movie: Decodable, Equatable {
    let id: Int
    let backdropPath: String?
    let title: String?
    let overview: String
    let posterPath: String?
    let genreIds: [Genre]?
    let releaseDate: String?
    let voteAverage: Double?
}

extension Movie {
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

extension Movie {
    enum Genre: Int, Decodable, Equatable {
        case 액션 = 28
        case 애니메이션 = 16
        case 범죄 = 80
        case 드라마 = 18
        case 판타지 = 14
        case 공포 = 27
        case 미스터리 = 9648
        case sf = 878
        case 스릴러 = 53
        case 서부 = 37
        case 모험 = 12
        case 코미디 = 35
        case 다큐멘터리 = 99
        case 가족 = 10751
        case 역사 = 36
        case 음악 = 10402
        case 로맨스 = 10749
        case tv_영화 = 10770
        case 전쟁 = 10752
        
        var title: String {
            switch self {
            case .액션: return "액션"
            case .애니메이션: return "애니메이션"
            case .범죄: return "범죄"
            case .드라마: return "드라마"
            case .판타지: return "판타지"
            case .공포: return "공포"
            case .미스터리: return "미스터리"
            case .sf: return "SF"
            case .스릴러: return "스릴러"
            case .서부: return "서부"
            case .모험: return "모험"
            case .코미디: return "코미디"
            case .다큐멘터리: return "다큐멘터리"
            case .가족: return "가족"
            case .역사: return "역사"
            case .음악: return "음악"
            case .로맨스: return "로맨스"
            case .tv_영화: return "TV 영화"
            case .전쟁: return "전쟁"
            }
        }
    }
}

extension Movie {
    static let mock = Movie(
        id: 610251,
        backdropPath: "/biJctq3zk4Km3hYkRQWN91yt0rY.jpg",
        title: "하얼빈",
        overview: "1908년 함경북도 신아산에서 안중근이 이끄는 독립군들은 일본군과의 전투에서 큰 승리를 거둔다. 대한의군 참모중장 안중근은 만국공법에 따라 전쟁포로인 일본인들을 풀어주게 되고, 이 사건으로 인해 독립군 사이에서는 안중근에 대한 의심과 함께 균열이 일기 시작한다. 1년 후, 블라디보스토크에는 안중근을 비롯해 우덕순, 김상현, 공부인, 최재형, 이창섭 등 빼앗긴 나라를 되찾기 위해 마음을 함께하는 이들이 모이게 된다. 이토 히로부미가 러시아와 협상을 위해 하얼빈으로 향한다는 소식을 접한 안중근과 독립군들은 하얼빈으로 향하고, 내부에서 새어 나간 이들의 작전 내용을 입수한 일본군들의 추격이 시작되는데…",
        posterPath: "/68D8dptiLWxUqwM9Iop1pNedSZL.jpg",
        genreIds: [.액션, .스릴러, .역사, .전쟁],
        releaseDate: "2024-12-24",
        voteAverage: 8.2
    )
}
