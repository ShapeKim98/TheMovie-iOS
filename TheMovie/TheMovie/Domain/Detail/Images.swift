//
//  Images.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import Foundation

struct Images: Decodable {
    let id: Int
    let backdrops: [FilePath]
    let posters: [FilePath]
}

extension Images {
    struct FilePath: Decodable {
        let filePath: String
        
        enum CodingKeys: String, CodingKey {
            case filePath = "file_path"
        }
    }
}

extension Images {
    static let mock = Images(
        id: 610251,
        backdrops: [
            Images.FilePath(filePath: "/biJctq3zk4Km3hYkRQWN91yt0rY.jpg"),
            Images.FilePath(filePath: "/7I7Zd4NBnJmkfTd32J6ZJ2C0HrB.jpg"),
            Images.FilePath(filePath: "/yIQNcekWHdAhfMwhcR8W0Mq7hBS.jpg"),
            Images.FilePath(filePath: "/gLMFuqTY3zDQ8MiCniOJQIecM2U.jpg"),
            Images.FilePath(filePath: "/v3gkLh6xWdh4qprFbt27C7h4P1l.jpg"),
            Images.FilePath(filePath: "/mM1sQob9fviSbk1KgEiGRq2SqLf.jpg"),
            Images.FilePath(filePath: "/rGP0l2rmGuBUzTWutK5IdnmCXJO.jpg"),
            Images.FilePath(filePath: "/itaSJ7rAyKq7WmORfXWigiYWiaR.jpg"),
            Images.FilePath(filePath: "/vSkyOE44wdnyy0h9u6NSB3GmVYn.jpg"),
            Images.FilePath(filePath: "/sHwz1Ke3wwevROu6tOpEoyjdaVP.jpg"),
            Images.FilePath(filePath: "/gfgKjaOjWMAIBITDOH0pBhx0VKo.jpg"),
            Images.FilePath(filePath: "/r6o4YlRKmQtbtjCgIkPWsEt1DGo.jpg"),
            Images.FilePath(filePath: "/t1QTegA4lWFpvcMuYkYgI5iXqVZ.jpg"),
            Images.FilePath(filePath: "/iYpeTQgakVaAP4n7pihfRhHSwyB.jpg"),
            Images.FilePath(filePath: "/iHIuyx38mLCmBFesnxAmnF0BgGz.jpg"),
            Images.FilePath(filePath: "/zK9EjZDp6VCj1Tp8R7LF4U4bKJJ.jpg"),
            Images.FilePath(filePath: "/pjyoke5Q4E39RAPINfluoqbv7x3.jpg"),
            Images.FilePath(filePath: "/aLn9FfF1hjdvKnR4V4arv0RuxpC.jpg"),
            Images.FilePath(filePath: "/2o5c30fVzfLMwkSZW2XKUilRGLC.jpg"),
            Images.FilePath(filePath: "/AwjFgKdJIJgQR1GDZWi407yXCzC.jpg"),
            Images.FilePath(filePath: "/ytmIXlHA1sAAxBoQWawoVcZjoiu.jpg"),
            Images.FilePath(filePath: "/6zinIICcyiEsQzbUxMyfKZcuZSh.jpg"),
            Images.FilePath(filePath: "/qiCVjNkQMmLBKOc2v0bzOUd8wrr.jpg"),
            Images.FilePath(filePath: "/XlAj0dQge0PD9LDpPoQ6pu4nWM.jpg"),
            Images.FilePath(filePath: "/ev4OqeLFTz7JADX1d7Twl6ImUcu.jpg"),
            Images.FilePath(filePath: "/qPgZdwscA5a0AQ6U2J9jYNHuCLM.jpg"),
            Images.FilePath(filePath: "/9my4ZYAojCwtfHLjc2R4satYMyT.jpg"),
            Images.FilePath(filePath: "/vR0ddK6RGyrXuPMgVAFUTPeE4Hg.jpg"),
            Images.FilePath(filePath: "/s4CHPnfCDL1qLAq0DpkjeNqIPjJ.jpg"),
            Images.FilePath(filePath: "/zWT2UGi88ZDxzjzYFOO7gptS6yi.jpg")
        ],
        posters: [
            Images.FilePath(filePath: "/oNA9eRaFCLlFKRZlzYEldPZlFpg.jpg"),
            Images.FilePath(filePath: "/68D8dptiLWxUqwM9Iop1pNedSZL.jpg"),
            Images.FilePath(filePath: "/q8nJ1g6xy2Wr3dQYR0sGQiEzbgD.jpg"),
            Images.FilePath(filePath: "/FTqmjFZslBrbfhqGDh2iYYJkVQ.jpg"),
            Images.FilePath(filePath: "/zEOYgeqc0m6fSxVfwDfCGRl8Nvc.jpg"),
            Images.FilePath(filePath: "/yElsh6GVnjjkY8Glqvftu7Hvyxw.jpg"),
            Images.FilePath(filePath: "/9ksaorA7d8Bic4cWD74QvukjZ8Y.jpg"),
            Images.FilePath(filePath: "/q0kdGx8RtV2bMxvMtu3WimvsMYZ.jpg"),
            Images.FilePath(filePath: "/2Jks3eKTqmsxeA8chLsUSfqaWLX.jpg"),
            Images.FilePath(filePath: "/dFGihZQOHwJWOZ3XCsYcL1S9UyB.jpg"),
            Images.FilePath(filePath: "/8112pDOJk9dMO9AuUo3i7P65iwo.jpg"),
            Images.FilePath(filePath: "/2LWlDBqNBl43E3vNFpRWeCtEhB8.jpg"),
            Images.FilePath(filePath: "/peishCAlG9BXTY8S8rCfVKqG9GM.jpg"),
            Images.FilePath(filePath: "/kpY9OHrjGIUTSjiguhFdkIQzzxp.jpg"),
            Images.FilePath(filePath: "/8N6Y3YeJjgqCzns2vD8acdtlBfB.jpg"),
            Images.FilePath(filePath: "/qi3x8K971iEulXf195yk4EeV4Bg.jpg"),
            Images.FilePath(filePath: "/3fodDLpy4skgYhMNqHGjJMkqbcC.jpg"),
            Images.FilePath(filePath: "/inDxLGUQrMiiOqRIn5RROSUGBDW.jpg"),
            Images.FilePath(filePath: "/tII86NkVx6nNABsmSKf7mkviqTp.jpg"),
            Images.FilePath(filePath: "/sEft4yQ5iIspC1q6LsizDN4ayol.jpg"),
            Images.FilePath(filePath: "/gmPp3qi4OEsotFYUN4CLlp1HAhO.jpg"),
            Images.FilePath(filePath: "/6bdJtcNYNUYg9D9F3AAIpeRiZTt.jpg"),
            Images.FilePath(filePath: "/vxVcfMwO8NRmUNHQS2TJZsOnOgu.jpg"),
            Images.FilePath(filePath: "/4TyUcXhZpxmWUdajW0iV8bf8Ipv.jpg"),
            Images.FilePath(filePath: "/8wvfDPYrk8nMwQSxv3xLDza7gcR.jpg"),
            Images.FilePath(filePath: "/m1fbsYMGdEbUtfmbfJCksMcYYV.jpg"),
            Images.FilePath(filePath: "/agCELyFKMDIFAlrVayGrVodaymA.jpg"),
            Images.FilePath(filePath: "/tSB3X6hElOyZYsw9B6PE8mkskdb.jpg"),
            Images.FilePath(filePath: "/6YpUetvtEM6ZngycEUCFrv5GuDG.jpg"),
            Images.FilePath(filePath: "/gdUO7MmbdZqjweyltyRna3c8DcR.jpg"),
            Images.FilePath(filePath: "/fCn4GMRXhUJrKQgyN4Q5j5NXBHZ.jpg"),
            Images.FilePath(filePath: "/bkhTCWkI8UonmCYX5CjhsD1KNbP.jpg")
        ]
    )
}
