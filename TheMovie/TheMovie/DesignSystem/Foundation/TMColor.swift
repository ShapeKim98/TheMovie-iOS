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
            case .blue: return UIColor(resource: .tmBrand)
            case .gray: return UIColor(resource: .tmGray)
            case .graySecondary: return UIColor(resource: .tmGraySecondary)
            case .black: return UIColor(resource: .tmBlack)
            case .white: return UIColor(resource: .tmWhite)
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
                case .brand: return UIColor(resource: .tmBrand)
                case .primary: return UIColor(resource: .tmBlack)
                case .secondary: return UIColor(resource: .tmGray)
                case .tertiary: return UIColor(resource: .tmGraySecondary)
                case .quaternary: return UIColor(resource: .tmWhite)
                }
            case let .text(type):
                switch type {
                case .brand: return UIColor(resource: .tmBrand)
                case .primary: return UIColor(resource: .tmWhite)
                case .secondary: return UIColor(resource: .tmGraySecondary)
                case .tertiary: return UIColor(resource: .tmGray)
                case .quaternary: return UIColor(resource: .tmBlack)
                }
            case let .border(type):
                switch type {
                case .brand: return UIColor(resource: .tmBrand)
                case .primary: return UIColor(resource: .tmWhite)
                case .secondary: return UIColor(resource: .tmGraySecondary)
                case .tertiary: return UIColor(resource: .tmGray)
                case .quaternary: return UIColor(resource: .tmBlack)
                }
            case let .icon(type):
                switch type {
                case .brand: return UIColor(resource: .tmBrand)
                case .primary: return UIColor(resource: .tmWhite)
                case .secondary: return UIColor(resource: .tmGraySecondary)
                case .tertiary: return UIColor(resource: .tmGray)
                case .quaternary: return UIColor(resource: .tmBlack)
                }
            }
        }
        
        var cgColor: CGColor {
            self.uiColor.cgColor
        }
    }
}
