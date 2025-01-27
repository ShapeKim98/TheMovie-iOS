//
//  DateStyle.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

enum DateStyle: String, CaseIterable {
    case yyyy_MM_dd = "yyyy-MM-dd"
    case yy_o_MM_o_dd = "yy.MM.dd"
    case yyyy_o_MM_o_dd = "yyyy. MM. dd"
    
   var strategy: Date.ParseStrategy {
        switch self {
        case .yyyy_MM_dd:
            return Date.ParseStrategy(
                format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)",
                timeZone: .autoupdatingCurrent
            )
        case .yy_o_MM_o_dd:
            return Date.ParseStrategy(
                format: "\(year: .twoDigits).\(month: .twoDigits).\(day: .twoDigits)",
                timeZone: .autoupdatingCurrent
            )
        case .yyyy_o_MM_o_dd:
            return Date.ParseStrategy(
                format: "\(year: .defaultDigits). \(month: .defaultDigits). \(day: .defaultDigits)",
                timeZone: .autoupdatingCurrent
            )
        }
    }
}

extension Date {
    func toString(format: DateStyle) -> String {
        switch format {
        case .yyyy_MM_dd:
            "\(self.formatted(.dateTime.year(.defaultDigits)))-\(self.formatted(.dateTime.month(.defaultDigits)))-\(self.formatted(.dateTime.day(.defaultDigits)))"
        case .yy_o_MM_o_dd:
            "\(self.formatted(.dateTime.year(.twoDigits))).\(self.formatted(.dateTime.month(.defaultDigits))).\(self.formatted(.dateTime.day(.defaultDigits)))"
        case .yyyy_o_MM_o_dd:
            "\(self.formatted(.dateTime.year(.defaultDigits))). \(self.formatted(.dateTime.month(.defaultDigits))). \(self.formatted(.dateTime.day(.defaultDigits)))"
        }
    }
}

extension String {
    func date(format: DateStyle) -> Date? {
        return try? Date(self, strategy: format.strategy)
    }
}
