//
//  Search.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

struct Search: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}

extension Search {
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension Search {
    static let mock = Search(
        page: 1,
        results: [
            Movie(
                id: 299536,
                backdropPath: "/mDfJG3LC3Dqb67AZ52x3Z0jU0uB.jpg",
                title: "어벤져스: 인피니티 워",
                overview: "타노스는 6개의 인피니티 스톤을 획득해 신으로 군림하려 한다. 그것은 곧 인류의 절반을 학살해 우주의 균형을 맞추겠다는 뜻. 타노스는 닥터 스트레인지가 소유한 타임 스톤, 비전의 이마에 박혀 있는 마인드 스톤을 차지하기 위해 지구를 침략한다. 아이언맨과 스파이더맨은 가디언즈 오브 갤럭시의 멤버들과 타노스를 상대한다. 지구에선 캡틴 아메리카, 완다, 블랙 위도우, 블랙 팬서 등이 비전을 지키기 위해 뭉친다.",
                posterPath: "/kmP6viwzcEkZeoi1LaVcQemcvZh.jpg",
                genreIds: [.모험, .액션, .sf],
                releaseDate: "2018-04-25",
                voteAverage: 8.2
            ),
            Movie(
                id: 24428,
                backdropPath: "/gHLs7Fy3DzLmLsD4lmfqL55KGcl.jpg",
                title: "어벤져스",
                overview: "에너지원 큐브를 이용한 적의 등장으로 인류가 위험에 처하자 국제평화유지기구인 쉴드의 국장 닉 퓨리는 어벤져스 작전을 위해 전 세계에 흩어져 있던 슈퍼히어로들을 찾아나선다. 아이언맨부터 토르, 헐크, 캡틴 아메리카는 물론, 쉴드의 요원인 블랙 위도우, 호크 아이까지, 최고의 슈퍼히어로들이 어벤져스의 멤버로 모이게 되지만, 각기 개성이 강한 이들의 만남은 예상치 못한 방향으로 흘러가는데...",
                posterPath: "/krgjV3rJtBcEpQehODKXNCt6uFL.jpg",
                genreIds: [.sf, .액션, .모험],
                releaseDate: "2012-04-25",
                voteAverage: 7.727
            ),
            Movie(
                id: 299534,
                backdropPath: "/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg",
                title: "어벤져스: 엔드게임",
                overview: "어벤져스의 패배 이후 지구는 초토화됐고 남은 절반의 사람들은 정신적 고통을 호소하며 하루하루를 근근이 버텨나간다. 와칸다에서 싸우다 생존한 히어로들과 우주의 타이탄 행성에서 싸우다 생존한 히어로들이 뿔뿔이 흩어졌는데, 아이언맨과 네뷸라는 우주를 떠돌고 있고 지구에 남아 있는 어벤져스 멤버들은 닉 퓨리가 마지막에 신호를 보내다 만 송신기만 들여다보며 혹시 모를 우주의 응답을 기다리는 중이다. 애초 히어로의 삶을 잠시 내려놓고 가족과 시간을 보내던 호크아이 역시 헤아릴 수 없는 마음의 상처를 입은 채 사라지고 마는데...",
                posterPath: "/z7ilT5rNN9kDo8JZmgyhM6ej2xv.jpg",
                genreIds: [.모험, .sf, .액션],
                releaseDate: "2019-04-24",
                voteAverage: 8.244
            ),
            Movie(
                id: 99861,
                backdropPath: "/6YwkGolwdOMNpbTOmLjoehlVWs5.jpg",
                title: "어벤져스: 에이지 오브 울트론",
                overview: "토니 스타크는 뉴욕전쟁 때와 같은 사태가 벌어지지 않도록 한때 가동하려다 중단된 휴면 상태의 평화 유지 프로그램을 작동 시키려 한다. 배너 박사와 함께 지구를 지킬 최강의 인공지능 울트론을 탄생시키게 되지만, 울트론은 예상과 다르게 지배를 벗어나 폭주하기 시작하고 어벤져스는 지구의 운명이 걸린 거대한 시험대에 오르게 된다. 울트론이 자신을 복제해 위협을 가하자 이를 저지하기 위해 아이언맨, 캡틴 아메리카, 토르, 헐크, 블랙위도우, 호크아이 등으로 구성된 어벤져스와 새로 합류하게 되는 퀵 실버, 스칼렛 위치 남매와 불안한 동맹을 맺는다.",
                posterPath: "/y8pY5MIzpPAnF5vYUNm1tw1AzL3.jpg",
                genreIds: [.액션, .모험, .sf],
                releaseDate: "2015-04-22",
                voteAverage: 7.3
            ),
            Movie(
                id: 1359227,
                backdropPath: "/Al127H6f1RXpESdg0MGNL2g8mzO.jpg",
                title: "레고 마블 어벤져스: 미션 데몰리션",
                overview: "완전히 새로운 애니메이션 스페셜 ‘레고 마블: 미션 데몰리션’은 독창적인 매력이 확실한 유명 시리즈의 10번째 작품이다. 마블과 레고 그룹이 선보이는 이 최신 스페셜의 주인공은 히어로가 되고자 하는 젊은 슈퍼히어로 팬으로, 어벤져스의 세상을 파괴할 기회를 노리고 있는 강력한 새 악당을 우연한 계기로 해방시키고 만다.",
                posterPath: "/2gLpCJNao2AgHhCuuhwwlvL5hb1.jpg",
                genreIds: [.애니메이션, .코미디, .sf],
                releaseDate: "2024-10-17",
                voteAverage: 6.8
            ),
            Movie(
                id: 1003596,
                backdropPath: "/vrncuH8IDqQ5M47XPk19yxY8o1b.jpg",
                title: "어벤져스: 둠스데이",
                overview: "An upcoming film in the Marvel Cinematic Universe's (MCU) sixth Phase and part of The Multiverse Saga. Plot TBA.",
                posterPath: "/eO6OdA4RDRWeCVlDMcsoxWYFySD.jpg",
                genreIds: [.sf],
                releaseDate: "2026-04-29",
                voteAverage: 0.0
            ),
            Movie(
                id: 1771,
                backdropPath: "/yFuKvT4Vm3sKHdFY4eG6I4ldAnn.jpg",
                title: "퍼스트 어벤져",
                overview: "그의 이름은 ‘스티브 로저스’. 남들보다 왜소하고 마른 체격으로 인해 입대마저 번번히 거부당하던 그는 포기를 모르는 근성과 강한 희생 정신을 인정받아 최고의 전사를 양성하는 ‘슈퍼 솔져’ 프로젝트에 스카우트된다. 비밀리에 진행된 실험을 통해 가장 완벽한 육체와 인간의 한계를 초월한 신체 능력을 얻게 된 스티브. 그는 모두에게 ‘캡틴’으로 불리며, 시대의 영웅으로 새롭게 태어난다. 하지만 그의 등장에 맞서 거대한 ‘히드라’ 조직을 앞세운 적의 공격은 한층 막강해지고, 그 핵심에 선 ‘레드 스컬’은 인류를 위협하는 최후의 전투를 준비하는데...세계를 위협하는 전쟁, 그 한가운데로 향한 ‘캡틴’ 슈퍼히어로의 역사로 남을 그의 활약이 시작된다!",
                posterPath: "/b1bdTrFrKq487IscyRI5LH7cv17.jpg",
                genreIds: [.액션],
                releaseDate: "2011-07-22",
                voteAverage: 6.999
            ),
            Movie(
                id: 1003598,
                backdropPath: "/hcmzlQHqeTglKTgo0do9Qxr72NN.jpg",
                title: "어벤져스: 시크릿 워즈",
                overview: "An upcoming film in Phase 6 of the Marvel Cinematic Universe (MCU) and the finale of The Multiverse Saga. Plot TBA.",
                posterPath: "/f0YBuh4hyiAheXhh4JnJWoKi9g5.jpg",
                genreIds: [.sf],
                releaseDate: "2027-05-05",
                voteAverage: 0.0
            ),
            Movie(
                id: 10222,
                backdropPath: "/1XTiG6PZhIVsuoz29B3R2gdfeXM.jpg",
                title: "어벤저",
                overview: "킥복싱 챔비언인 에릭 슬로운(Eric Sloane : 데니스 알렉시오 분)은 동생 커트 슬로운(Kurt Sloane : 쟝-끌로드 반 담 분)과 함께 킥복싱의 본고장 태국에 도착한다. 태국의 챔피언인 동 포(Tong Po : 동 포 분)와의 시합에서 무참히 짓밟힌 에릭은 평생을 휠체어에 의지해야 하는 신세가 되었다. 커트는 형의 복수를 하기 위해 태국의 전통 무술을 배우러 스승을 찾아 나선다. 기이한 스승 시안 초우(Xian : 데니스 찬 분)을 만나 그 곳에서 혹독한 훈련을 받는다. 훈련 도중 그는 스승의 조카 딸인 마이리(Mylee : 로첼 애쉬어나 분)와 사랑에 빠지게 되고 그들 사랑이 더해감이 따라 훈련도 거의 마무리 단계에 이르게 된다. 드디어 생명을 건 동 포와의 결전의 날이 다가온다. 하지만 마이리와 형을 납치, 커트에게 시합에서 질 것을 요구, 커트는 거의 초죽음이 되도록 맞기만 하지만 마침내 그를 멋지게 꺾고 승리한다.",
                posterPath: "/gwjbASBw40dPJDU1Hiq3C46ids0.jpg",
                genreIds: [.액션, .범죄, .드라마],
                releaseDate: "1989-04-20",
                voteAverage: 6.8
            ),
            Movie(
                id: 1154598,
                backdropPath: "/oFSQEG1lJTTISj3QKB7cJ9ANkFw.jpg",
                title: "레고 마블 어벤져스: 코드 레드",
                overview: "뉴욕을 지키기 위해 모인 어벤져스. 그러나 블랙 위도우는 아버지 레드 가디언이 자신을 따라다니며 어린애 취급하자 화를 내고 만다. 그 후 레드 가디언이 갑자기 사라지고, 어벤져스는 '콜렉터'가 이름에 '레드'라는 단어가 들어간 영웅과 악당을 납치하고 다닌다는 사실을 알게 된다. 어벤져스는 힘을 합쳐 콜렉터의 은신처를 찾고 그의 수집품이 되어버린 영웅과 악당을 모두 구할 수 있을까?",
                posterPath: "/cCIKixVHGIynoZR2xMg9uygey5f.jpg",
                genreIds: [.애니메이션, .액션, .가족, .코미디],
                releaseDate: "2023-10-26",
                voteAverage: 6.6
            ),
            Movie(
                id: 257346,
                backdropPath: "/vqQhjCeXbGDz8IeB27IPk0alfKA.jpg",
                title: "어벤져스 컨피덴셜: 블랙 위도우 앤 퍼니셔",
                overview: "지구의 안보가 위협당하는 위기의 상황에서 슈퍼히어로들을 불러모아 세상을 구하는, 일명 [어벤져스] 작전. 지구의 평화를 위협하는 적의 등장으로 인류가 위험에 처하자 국제평화유지기구인 쉴드 (S.H.I.E.L.D)의 국장 닉 퓨이는 [어벤져스] 작전을 위해 전 세계에 흩어져 있던 슈퍼히어로들을 찾아나선다. 아이언맨부터 토르, 헐크, 캡틴 아메리카는 물론, 쉴드의 요원인 블랙 위도우, 호크 아이까지, 최고의 슈퍼히어로들이 [어벤져스]의 멤버로 모이게 되지만, 각기 개성이 강한 이들의 만남은 예상치 못한 방향으로 흘러가는데…",
                posterPath: "/bsXC1PaRg8eEvVXCTVtNwLLvcyl.jpg",
                genreIds: [.애니메이션, .범죄, .액션],
                releaseDate: "2014-04-19",
                voteAverage: 6.4
            ),
            Movie(
                id: 9320,
                backdropPath: "/fryen9fnjlm0YibKTDNGzWNBOSo.jpg",
                title: "어벤저",
                overview: "비와 안개의 나라로 알려진 영국 날씨, 정상적인 날씨를 위해 작동 중인 기상안전보호 프로그램에 이상이 생긴다. 날씨는 국가 안보와 밀접한 관련이 있기 때문에, '마더(mother): 짐 브로드벤트 분)'라 불리는 영국 첩보국장은 일급 비밀요원 존 스티드(John Steed: 랄프 피네스 분)를 시켜 이 사건을 조사하게 한다. 존은 중절모와 잘 다듬어진 테일러 양복을 입은 전형적인 영국 신사. 어떤 상황에서도 절대 흥분하지 않는 그는 사안이 사안인지라 날씨에 능통한 기상학 박사 에마 필(Emma Peel: 우마 써먼 분)을 파트너 삼아 사건을 조사한다. 존과 에마는 유력한 용의자로 의심되는 어거스트 드 윈터 박사(Sir August de Wynter: 숀 코넬리 분)를 찾아가고 여기서 존은 에마와 똑같은 사람의 공격을 받는다. 그러나 이는 어거스트가 에마와 똑같은 인물을 복제해 사람들을 혼란케 하고 에마를 위험에 몰아넣어서 자기 편으로 삼고자 하는 전략이다. 어거스트의 진짜 목적은 기괴한 날씨를 수단삼아 전 세계를 혼란에 빠뜨리고, 자기가 직접 날씨를 조작, 이를 팔아서 부와 권력을 손에 쥐려하는데 있다. 어거스트와 무시무시한 음모를 막고 평화를 지키려는 존과 에마의 싸움은 시작되었다.",
                posterPath: "/1p5thyQ4pCy876HpdvFARqJ62N9.jpg",
                genreIds: [.액션, .애니메이션, .sf, .코미디, .공포],
                releaseDate: "1998-08-13",
                voteAverage: 4.397
            ),
            Movie(
                id: 12721,
                backdropPath: "/hcmzlQHqeTglKTgo0do9Qxr72NN.jpg",
                title: "어벤저",
                overview: "남편과의 사별 이후, 혼자 딸 '베시'를 키우고 있는 '티나' 늦은 밤, 딸과 함께 집으로 돌아가던 중 괴한들에게 폭행과 강간을 당하게 된다. 하지만, '티나'에게 끔찍한 범죄를 저지른 4명의 남자들은 처벌받지 않고 풀려나게 된다. 그 사실은 알게 된 '베시'와 '티나'는 피 말리는 하루하루를 보내게 되고 이 모든 것을 지켜보던 경찰관 '존'은 자신이 직접 심판자가 되기로 마음을 먹게 되는데... 올겨울, 그들을 향한 핏빛 복수가 시작된다!",
                posterPath: "/laCZ3Oty8sURDm9S9LgW5xty4op.jpg",
                genreIds: [.액션, .드라마, .스릴러],
                releaseDate: "2017-03-16",
                voteAverage: 5.531
            ),
            Movie(
                id: 14609,
                backdropPath: "/xDh3CfsOsUmKeAOQ5rgXXJYtxfn.jpg",
                title: "어벤저 2",
                overview: "태국까지 가서 킥복싱 헤비급 세계 챔피언에 도전한 커트 슬론(Kurt Sloan: 엠마뉴엘 커빈 분)은 챔피언인 통포(Tong Po: 미셀 퀴시 분)를 물리치고 세계 챔피언이 되지만 킥복싱의 본고장에서 왕좌를 빼앗긴데 굴욕감을 느낀 통포의 손에 의해 방콕의 밤거리에서 동생 에릭, 애인 메이와 함께 숨을 거둔다. 형들의 귀환을 기다리던 막내동생 데이비드(David Sloan: 사샤 미첼 분)는 하늘이 무너지는 것 같은 슬픔을 딛고 일어서서 형들이 남긴 도장을 맡아 운영한다. 그러나 타고난 교육자로 돈벌이와는 인연이 먼 그는 점점 더 빚더미에 올라앉게 된다. 에릭의 친구이기도하며 도장의 총무인 잭크는 빚을 갚을 유일한 길은 데이비드가 시합을 하는 것이라고 압력을 가하지만 데이비드는 이 제안을 완강히 거절한다. 한편, 굴욕감에 못이긴 통포가 커트를 죽여버려서 명예를 회복할 길이 없어진 태국 흥행사 상가(Sanga: 캐리-히로유키 타가와 분)는 데이비드와 통포와의 시합을 주선하지만 데이비드는 이 역시 거절한다. 그러자 상가의 동업자인 저스틴 메이셔(Justin: 피터 보일 분)는 자기 수하의 킥복싱 선수인 버거스(Vargas: 매티아스 휴스 분)를 시켜 도장을 불지르게 하지만 불을 지르던 버거스는 데이비드에게 발각되자 데이비드의 무릎에 총을 쏘고 그런 소란 중에 한 소년이 불에 타죽는다. 버거스가 데이비드의 무릎을 상하게 하여 시합을 할 수 없에 만들자 노발대발한 상가는 버거스가 자신의 계획을 모두 망쳐 놓았기 때문에 메지셔에게 그를 죽이도록 시킨 후 데이비드가 사랑하는 수제자 브라이언(Brian Wagner: 빈스 무도코 분)을 스카웃하여 혹독한 트레이닝과 고행으로 온몸이 흉터 투성이가 된 통포와 시합을 시키고는 브라이언을 관중이 보는 앞에서 죽여 버린다.",
                posterPath: "/pNvuLT77H9eSStoqmB7EMLdlffv.jpg",
                genreIds: [.액션, .범죄, .스릴러],
                releaseDate: "1991-01-30",
                voteAverage: 5.4
            ),
            Movie(
                id: 14611,
                backdropPath: "/xv77AFzMUiTuUsC5qn31jBB21An.jpg",
                title: "얼티밋 어벤져스 2",
                overview: "신비한 와칸다는 세계 대부분이 알지 못하는 아프리카의 가장 어두운 심장부에 있습니다. 폐쇄된 국경 뒤에 숨겨진 고립된 땅, 젊은 왕 블랙 팬서에 의해 강력하게 보호됩니다. 하지만 잔인한 외계 침략자들이 공격할 때, 그 위협은 흑표범에게 그의 백성들의 신성한 법령을 거스르고 외부인들에게 도움을 요청하는 것 외에는 선택의 여지가 없게 합니다.",
                posterPath: "/2bfVNvLKWaxFh1LiOKlvxgiHOXn.jpg",
                genreIds: [.액션, .애니메이션, .sf, .코미디],
                releaseDate: "2006-08-08",
                voteAverage: 6.8
            ),
            Movie(
                id: 397415,
                backdropPath: "/jSOomjSssNJdU7Hrf3CROkNSv6n.jpg",
                title: "Vengeance: A Love Story",
                overview: "남편과의 사별 이후, 혼자 딸 '베시'를 키우고 있는 '티나' 늦은 밤, 딸과 함께 집으로 돌아가던 중 괴한들에게 폭행과 강간을 당하게 된다. 하지만, '티나'에게 끔찍한 범죄를 저지른 4명의 남자들은 처벌받지 않고 풀려나게 된다. 그 사실은 알게 된 '베시'와 '티나'는 피 말리는 하루하루를 보내게 되고 이 모든 것을 지켜보던 경찰관 '존'은 자신이 직접 심판자가 되기로 마음을 먹게 되는데... 올겨울, 그들을 향한 핏빛 복수가 시작된다!",
                posterPath: "/laCZ3Oty8sURDm9S9LgW5xty4op.jpg",
                genreIds: [.액션],
                releaseDate: "2017-03-16",
                voteAverage: 5.531
            )
        ],
        totalPages: 3,
        totalResults: 44
    )
}
