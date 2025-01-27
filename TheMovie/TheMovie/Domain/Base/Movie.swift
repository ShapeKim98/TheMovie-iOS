//
//  Movie.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let backdropPath: String
    let title: String
    let overview: String
    let posterPath: String
    let genreIds: [Genre]
    let releaseDate: String
    let voteAverage: Double
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
    enum Genre: Int, Decodable {
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
