//
//  TMColor.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit

enum TMColor {
    case primitive(Primitive)
    case semantic(Semantic)
    
    var uiColor: UIColor {
        switch self {
        case let .primitive(primitive):
            return primitive.uiColor
        case let .semantic(semantic):
            return semantic.uiColor
        }
    }
    
    var cgColor: CGColor {
        self.uiColor.cgColor
    }
}

extension TMColor {
    enum Primitive {
        case blue
        case gray
        case graySecondary
        case black
        case white
        
        var uiColor: UIColor {
            switch self {
            case .blue: return UIColor(resource: .brand)
            case .gray: return UIColor(resource: .gray)
            case .graySecondary: return UIColor(resource: .graySecondary)
            case .black: return UIColor(resource: .black)
            case .white: return UIColor(resource: .white)
            }
        }
        
        var cgColor: CGColor {
            self.uiColor.cgColor
        }
    }
    
    enum Semantic {
        case background(SemanticType)
        case text(SemanticType)
        case border(SemanticType)
        case icon(SemanticType)
        
        enum SemanticType {
            case brand
            case primary
            case secondary
            case tertiary
            case quaternary
        }
        
        var uiColor: UIColor {
            switch self {
            case let .background(type):
                switch type {
                case .brand: return UIColor(resource: .brand)
                case .primary: return UIColor(resource: .black)
                case .secondary: return UIColor(resource: .gray)
                case .tertiary: return UIColor(resource: .graySecondary)
                case .quaternary: return UIColor(resource: .white)
                }
            case let .text(type):
                switch type {
                case .brand: return UIColor(resource: .brand)
                case .primary: return UIColor(resource: .white)
                case .secondary: return UIColor(resource: .graySecondary)
                case .tertiary: return UIColor(resource: .gray)
                case .quaternary: return UIColor(resource: .black)
                }
            case let .border(type):
                switch type {
                case .brand: return UIColor(resource: .brand)
                case .primary: return UIColor(resource: .white)
                case .secondary: return UIColor(resource: .graySecondary)
                case .tertiary: return UIColor(resource: .gray)
                case .quaternary: return UIColor(resource: .black)
                }
            case let .icon(type):
                switch type {
                case .brand: return UIColor(resource: .brand)
                case .primary: return UIColor(resource: .white)
                case .secondary: return UIColor(resource: .graySecondary)
                case .tertiary: return UIColor(resource: .gray)
                case .quaternary: return UIColor(resource: .black)
                }
            }
        }
        
        var cgColor: CGColor {
            self.uiColor.cgColor
        }
    }
}
