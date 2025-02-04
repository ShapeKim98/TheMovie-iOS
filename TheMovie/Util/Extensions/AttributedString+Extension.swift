//
//  AttributedString+Extension.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

extension AttributedString {
    static func make(
        _ string: String,
        _ attributes: [NSAttributedString.Key : Any]
    ) -> AttributedString {
        return AttributedString(
            string,
            attributes: AttributeContainer(attributes)
        )
    }
}
