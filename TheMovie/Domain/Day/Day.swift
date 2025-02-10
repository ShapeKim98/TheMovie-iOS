//
//  Day.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

struct Day: Decodable, Equatable {
    let page: Int
    let results: [Movie]
}

extension Day {
    static let mock = Day(
        page: 1,
        results: [
            Movie(
                id: 939243,
                backdropPath: "/b85bJfrTOSJ7M5Ox0yp4lxIxdG1.jpg",
                title: "수퍼 소닉 3",
                overview: "너클즈, 테일즈와 함께 평화로운 일상을 보내던 초특급 히어로 소닉. 연구 시설에 50년간 잠들어 있던 사상 최강의 비밀 병기 \"섀도우\"가 탈주하자, 세계 수호 통합 부대(약칭 세.수.통)에 의해 극비 소집된다. 소중한 것을 잃은 분노와 복수심에 불타는 섀도우는 소닉의 초고속 스피드와 너클즈의 최강 펀치를 단 단숨에 제압해버린다. 세상을 지배하려는 닥터 로보트닉과 그의 할아버지 제럴드 박사는 섀도우의 엄청난 힘 카오스 에너지를 이용해 인류를 정복하려고 하는데…",
                posterPath: "/5ZoI48Puf5i5FwI6HOpunDuJOw0.jpg",
                genreIds: [.액션, .sf, .코미디, .가족],
                releaseDate: "2024-12-19",
                voteAverage: 7.831
            ),
            Movie(
                id: 1114894,
                backdropPath: "/3SOunz2Z0qcOVlrkYFj20HquziB.jpg",
                title: "스타 트렉: 섹션 31",
                overview: "",
                posterPath: "/sqiCinCzUGlzQiFytS30N1nO3Pt.jpg",
                genreIds: [.sf, .모험, .액션, .드라마],
                releaseDate: "2025-01-15",
                voteAverage: 4.73
            ),
            Movie(
                id: 426063,
                backdropPath: "/fYnEbgoNCxW9kL0IgOgtJb9JTBU.jpg",
                title: "노스페라투",
                overview: "오랜 시간 통제할 수 없는 강력한 힘에 이끌려 악몽과 괴로움에 시달려 온 엘렌. 남편 토마스가 거액의 부동산 계약을 위해 머나먼 올록성으로 떠난 후부터 엘렌은 불안 증세가 심해지고 알 수 없는 말을 되뇌인다. 기이한 현상들이 일어나며 마을로 점점 짙게 번져오는 그림자. 영원한 어둠 속에서 깨어난 올록 백작이 찾아오는데…",
                posterPath: "/xeiARSpxGdVCw5KkCDgj31MO45o.jpg",
                genreIds: [.공포, .판타지],
                releaseDate: "2024-12-25",
                voteAverage: 6.6
            ),
            Movie(
                id: 402431,
                backdropPath: "/uKb22E0nlzr914bA9KyA5CVCOlV.jpg",
                title: "위키드",
                overview: "자신의 진정한 힘을 아직 발견하지 못한 엘파바와 자신의 진정한 본성을 발견하지 못한 글린다, 전혀 다른 두 인물이 우정을 쌓아가며 맞닥뜨리는 예상치 못한 위기와 모험을 그린 이야기",
                posterPath: "/mHozMgx7w29qC9gLzUQDQEP7AEM.jpg",
                genreIds: [.드라마, .로맨스, .판타지],
                releaseDate: "2024-11-20",
                voteAverage: 6.898
            ),
            Movie(
                id: 1064213,
                backdropPath: "/4cp40IyTpFfsT2IKpl0YlUkMBIR.jpg",
                title: "아노라",
                overview: "뉴욕의 스트리퍼 아노라는 자신의 바를 찾은 철부지 러시아 재벌2세 이반을 만나게 되고 충동적인 사랑을 믿고 허황된 신분 상승을 꿈꾸며 결혼식을 올리게 된다. 그러나 신데렐라 스토리를 꿈꿨던 것도 잠시, 한 번도 본 적 없는 이반의 부모님이 아들의 결혼 사실을 알게 되자 길길이 날뛰며 미국에 있는 하수인 3인방에게 둘을 잡아 혼인무효소송을 진행할 것을 지시한다. 하수인 3인이 들이닥치자 부모님이 무서워 겁에 질린 남편 이반은 아노라를 버린채 홀로 도망친다. 이반을 찾아 결혼 생활을 유지하고 싶은 아노라와 어떻게든 이반을 찾아 혼인무효소송을 시켜야만 하는 하수인 3인방의 대환장 발악이 시작된다.",
                posterPath: "/mwguqSMRCA3NgpPoRsXdFhid25m.jpg",
                genreIds: [.로맨스, .코미디, .드라마],
                releaseDate: "2024-10-14",
                voteAverage: 7.0
            ),
            Movie(
                id: 933260,
                backdropPath: "/7h6TqPB3ESmjuVbxCxAeB1c9OB1.jpg",
                title: "서브스턴스",
                overview: "더 나은 버전의 당신을 꿈꿔본 적 있나요? 당신의 인생을 바꿔줄 신제품 ‘서브스턴스’. ‘서브스턴스’는 또 다른 당신을 만들어냅니다. 새롭고, 젊고, 더 아름답고, 더 완벽한 당신을. 단 한가지 규칙, 당신의 시간을 공유하면 됩니다. 당신을 위한 일주일, 새로운 당신을 위한 일주일, 각각 7일간의 완벽한 밸런스. 쉽죠? 균형을 존중한다면… 무엇이 잘못될 수 있을까요?",
                posterPath: "/5TPPefBI1OzWnSQfBkOrv1OFGq5.jpg",
                genreIds: [.공포, .sf],
                releaseDate: "2024-09-07",
                voteAverage: 7.1
            ),
            Movie(
                id: 993710,
                backdropPath: "/xZm5YUNY3PlYD1Q4k7X8zd2V4AK.jpg",
                title: "백 인 액션",
                overview: "평범한 가정을 꾸리기 위해 CIA를 떠났던 두 엘리트 첩보 요원 맷과 에밀리. 그런데 15년 만에 신분이 들통나면서 다시 스파이의 세계로 뛰어들게 된다.",
                posterPath: "/7FlD5tJbYVtyJkRnhvGYqsMQVou.jpg",
                genreIds: [.액션, .코미디],
                releaseDate: "2025-01-15",
                voteAverage: 6.721
            ),
            Movie(
                id: 728949,
                backdropPath: "/2ICMZZVcwboF8Z9V7aaJY3CVh9w.jpg",
                title: "나이트비치",
                overview: "한 여성이 전업주부가 되면서 경력을 중단하는데, 곧 그녀의 새로운 가정생활에 뜻밖의 변화가 찾아온다.",
                posterPath: "/dDB71usg620D9RhgL3Rk8LhKc5j.jpg",
                genreIds: [.코미디, .공포],
                releaseDate: "2024-12-06",
                voteAverage: 6.013
            ),
            Movie(
                id: 507241,
                backdropPath: "/zGLQmrmIB56kMZPnzqReIOBay1B.jpg",
                title: "킬러의 게임",
                overview: "최고의 암살자 조 플러드(데이브 바티스타)는 불치병 진단을 받고 직접 문제를 해결하기로 결심한다. 바로 자기 자신을 암살하는 것이다. 하지만 그가 고용한 암살자들이 그의 전 여자친구(소피아 부텔라)도 노리게 되자, 그는 다른 암살자 무리를 물리치고 너무 늦기 전에 자신의 천생연분을 되찾아야 한다.",
                posterPath: "/4bKlTeOUr5AKrLky8mwWvlQqyVd.jpg",
                genreIds: [.액션, .코미디, .범죄],
                releaseDate: "2024-09-12",
                voteAverage: 6.527
            ),
            Movie(
                id: 1185719,
                backdropPath: "/jyiS3eQFQzSNlY4TRIIkTSyI1ce.jpg",
                title: "모래성",
                overview: "외딴 무인도에 고립된 채 먹을 것을 찾아다니며 살아가는 네 명의 가족. 묻혀 있던 그들의 과거가 서서히 드러나면서, 고통스러운 사건의 소용돌이에 빠져든다.",
                posterPath: "/eeIPRiPHWg87Ac9SjJwmdwaxNLx.jpg",
                genreIds: [.스릴러, .미스터리, .드라마, .판타지],
                releaseDate: "2024-12-07",
                voteAverage: 5.1
            ),
            Movie(
                id: 974950,
                backdropPath: "/u2eA9pqi1q3DvevT7RuDuJHxxBT.jpg",
                title: "에밀리아 페레즈",
                overview: "능력 있는 변호사 '리타'는 '큰돈을 벌게 해주겠다'는 비밀 의뢰를 받고 멕시코 카르텔의 수장 '델 몬테'를 만나러 간다. 그의 요청은 놀랍게도 \"자신을 여자로 다시 태어나게 해달라는 것. 아내도 모르게 새로운 삶을 살 수 있게 세팅하라는 것.\" 얼마 뒤, 새로운 그녀 ‘에밀리아 페레즈’가 나타나면서 모두의 인생에 2막이 오른다.",
                posterPath: "/t1XuL5308zcEGjeeN2wzsqlwSDR.jpg",
                genreIds: [.드라마, .스릴러],
                releaseDate: "2024-08-21",
                voteAverage: 7.571
            ),
            Movie(
                id: 454626,
                backdropPath: "/stmYfCUGd8Iy6kAMBr6AmWqx8Bq.jpg",
                title: "수퍼 소닉",
                overview: "소리보다 빠른 초고속 고슴도치 히어로 '소닉'은 지구에 불시착한다. 그의 특별한 능력을 감지한 과학자 ‘닥터 로보트닉’은 세계 정복의 야욕을 채우려 하고, 경찰관 ‘톰’은 위험에 빠진 ‘소닉’을 돕기 위해 나서는데…! 과연, ‘소닉'은 천재 악당에 맞서 지구를 지킬 수 있을까?",
                posterPath: "/bhGOIk6lVNVDx082NDB2OlrjjWO.jpg",
                genreIds: [.액션, .sf, .코미디, .가족],
                releaseDate: "2020-02-12",
                voteAverage: 7.3
            ),
            Movie(
                id: 710295,
                backdropPath: "/wwARk7hRIfHfh2n2ubN6N7lvTne.jpg",
                title: "울프맨",
                overview: "오리건 주 시골에 있는 집을 물려받게 된 블레이크(크리스토퍼 애봇)는 아내인 샬럿(줄리아 가너)과 어린 딸 진저와 함께 도시에서 내려가게 되는데, 한밤 중에 정체모를 동물에게 공격을 받고 상처입은 블레이크가 무언가로 변하기 시작한다. 샬럿은 집 밖과 집 안에서 정체모를 위협적인 존재로부터 딸을 지켜야 하게 되는 상황을 맞닥뜨리게 되는데...",
                posterPath: "/tUtuMtC6oaRXr4x2B5Xi6ABdMCv.jpg",
                genreIds: [.공포, .스릴러],
                releaseDate: "2025-01-15",
                voteAverage: 6.5
            ),
            Movie(
                id: 912649,
                backdropPath: "/vZG7PrX9HmdgL5qfZRjhJsFYEIA.jpg",
                title: "베놈: 라스트 댄스",
                overview: "환상의 케미스트리의 에디 브록과 그의 심비오트 베놈은 그들을 노리는 정체불명 존재의 추격을 피해 같이 도망을 다니게 된다. 한편 베놈의 창조자 널은 고향 행성에서부터 그들을 찾아내기 위해 지구를 침략하고 에디와 베놈은 그동안 겪어보지 못한 최악의 위기를 맞이하게 되는데…",
                posterPath: "/ptfoRD0MmL8Ry0iBVccYbqoN9Xc.jpg",
                genreIds: [.액션, .sf, .모험],
                releaseDate: "2024-10-22",
                voteAverage: 6.8
            ),
            Movie(
                id: 675353,
                backdropPath: "/8wwXPG22aNMpPGuXnfm3galoxbI.jpg",
                title: "수퍼 소닉 2",
                overview: "강력한 파워의 ‘너클즈’와 함께 돌아온 천재 과학자 ‘닥터 로보트닉’에 맞서 지구를 구하기 위해 ‘소닉’과 새로운 파트너 ‘테일즈’가 전 세계를 누비는 스피드 액션 블록버스터.",
                posterPath: "/tjFVUV06bzGSaG5YiU7NdpK1Qzp.jpg",
                genreIds: [.액션, .모험, .가족, .코미디],
                releaseDate: "2022-03-30",
                voteAverage: 7.488
            ),
            Movie(
                id: 823219,
                backdropPath: "/b3mdmjYTEL70j7nuXATUAD9qgu4.jpg",
                title: "플로우",
                overview: "한때 인간이 존재했던 흔적만이 가득한 세상은 점점 종말에 가까워지고 있다. '까만 고양이'는 혼자 있기를 좋아하는 동물이지만 대홍수로 인해 고향이 완전히 파괴되자 다양한 동물들이 가득한 배 한 척을 피난처로 삼게 되고, 그곳에서 서로가 가진 차이점에도 불구하고 팀을 이루게 된다. 신비롭게 범람하는 풍경 속을 항해하기 시작한 외딴 배 안에서 그들은 새로운 세계에 적응하는데 따르는 어려움과 위험을 함께 헤쳐나가게 된다",
                posterPath: "/kX9gzHyfwXCkTszBcPekQZxPnzP.jpg",
                genreIds: [.애니메이션, .판타지, .모험],
                releaseDate: "2024-08-29",
                voteAverage: 8.4
            ),
            Movie(
                id: 974576,
                backdropPath: "/66nlC5LDZmDUWONGkUZT2BrOszG.jpg",
                title: "콘클라베",
                overview: "교황의 예기치 못한 죽음 이후 새로운 교황을 선출하는 ‘콘클라베’가 시작되고, 로렌스는 단장으로서 선거를 총괄하게 된다. 한편 당선에 유력했던 후보들이 스캔들에 휘말리면서 교활한 음모와 탐욕이 수면 위로 드러나는데…",
                posterPath: "/prFbPHfaT1BASrfrjOFuVqcvFAh.jpg",
                genreIds: [.드라마],
                releaseDate: "2024-10-25",
                voteAverage: 7.059
            )
        ]
    )
}
