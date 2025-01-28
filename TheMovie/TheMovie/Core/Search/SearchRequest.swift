//
//  SearchRequest.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import Foundation

struct SearchRequest {
    let query: String
    let includeAdult: Bool = false
    let language: String = "ko-KR"
    let page: Int
}
