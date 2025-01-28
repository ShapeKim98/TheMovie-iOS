//
//  Credit.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import Foundation

struct Credits: Decodable {
    let id: Int
    let cast: [Cast]
}

extension Credits {
    struct Cast: Decodable {
        let name: String
        let character: String
        let profilePath: String
        
        enum CodingKeys: String, CodingKey {
            case name, character
            case profilePath = "profile_path"
        }
    }
}

extension Credits {
    static let mock = Credits(
        id: 610251,
        cast: [
            Cast(name: "현빈", character: "Ahn Jung-geun", profilePath: "/JQFzhO9j8HRiyr7leGPj6cqhvM.jpg"),
            Cast(name: "박정민", character: "Woo Duk-soon", profilePath: "/4ulrJOpIwgCjYjEsq8zdBoRnDDy.jpg"),
            Cast(name: "조우진", character: "Kim Sang-hyun", profilePath: "/7yoOqi1yV4q9MBLOLMfQDFqbYc7.jpg"),
            Cast(name: "전여빈", character: "Ms. Gong", profilePath: "/l28uxiGDMyZjQMRvhfNCtkydmpK.jpg"),
            Cast(name: "이동욱", character: "Lee Chang-sup", profilePath: "/f27YNf7JAznkzq7N0h6hnWF1HGQ.jpg"),
            Cast(name: "박훈", character: "Mori Tatsuo", profilePath: "/1fVcI5O31gu3SlQKyocZ5fGPSdg.jpg"),
            Cast(name: "유재명", character: "Choi Jae-hyung", profilePath: "/27OwsiC3j37mTpBZ6AjiNfHdNC.jpg"),
            Cast(name: "릴리 프랭키", character: "Itō Hirobumi", profilePath: "/8T3I7KQX0SH6twXsuqe12Sc7Hxr.jpg"),
            Cast(name: "정우성", character: "Park Jum-chool", profilePath: "/tI0ANQSwcOBfQUeHgfcwn7VmHRO.jpg"),
            Cast(name: "김지오", character: "Ohtani", profilePath: "/ccZBYHOOXYSdymO5y52LjGOuZrb.jpg"),
            Cast(name: "이태형", character: "Cho Do-sun", profilePath: "/o0lPnov7YoOz1piY3A6VSPInMqK.jpg"),
            Cast(name: "안세호", character: "Lee Kang", profilePath: "/64bKEsAaJmmihelcHEN6cGdqtNT.jpg"),
            Cast(name: "윤여원", character: "Shin Jae-shik", profilePath: ""),
            Cast(name: "윤상호", character: "Kawakami Toshihiko", profilePath: "/xBCO2J5AvKIyftvSGQ86I6LfsQ9.jpg"),
            Cast(name: "박동하", character: "Yamada", profilePath: "/zP4BgIccUJfEUgIgB3BWaryGoAg.jpg"),
            Cast(name: "허승", character: "Ohtani's man", profilePath: ""),
            Cast(name: "Son In-yong", character: "Kim Sung-baik", profilePath: "/6XKVnoL9Jm4kfkCopTBvlJbIpDQ.jpg"),
            Cast(name: "Son Seung-hoon", character: "Suzuki", profilePath: "/e5ZMC61w1Z5nU0DHylbjzQEDHFW.jpg"),
            Cast(name: "에고 미키타스", character: "Vladimir Kokovtsov", profilePath: "/6bpMVYgZVbrpWiEFn2jNwaYQWv4.jpg"),
            Cast(name: "Hooper, Lewis", character: "Background Extra (Train Passanger)", profilePath: "/wdl3Yl1g8bes80RNtQWumV3ekhj.jpg"),
            Cast(name: "윤여원", character: "Shin Jae-shik", profilePath: ""),
            Cast(name: "Son In-yong", character: "Kim Sung-baik", profilePath: "/6XKVnoL9Jm4kfkCopTBvlJbIpDQ.jpg"),
            Cast(name: "Son Seung-hoon", character: "Suzuki", profilePath: "/e5ZMC61w1Z5nU0DHylbjzQEDHFW.jpg"),
            Cast(name: "에고 미키타스", character: "Vladimir Kokovtsov", profilePath: "/6bpMVYgZVbrpWiEFn2jNwaYQWv4.jpg"),
            Cast(name: "Hooper, Lewis", character: "Background Extra (Train Passanger)", profilePath: "/wdl3Yl1g8bes80RNtQWumV3ekhj.jpg")
        ]
    )
}

