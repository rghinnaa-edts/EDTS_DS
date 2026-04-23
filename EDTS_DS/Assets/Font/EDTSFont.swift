//
//  EDTSFont.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 08/04/26.
//

import UIKit

public enum FontWeight: String {
    case ultralight = "ultralight"
    case thin = "thin"
    case light = "light"
    case regular = "regular"
    case medium = "medium"
    case semibold = "semibold"
    case bold = "bold"
    case heavy = "heavy"
    case black = "black"
}

struct EDTSFont {
    struct FontStyle {
        let font: UIFont
        let lineHeight: CGFloat
        let fontSize: CGFloat
    }
    
    enum BaseFont: String {
        case regular = "Inter-Regular"
        case medium = "Inter-Medium"
        case semibold = "Inter-SemiBold"
        case bold = "Inter-Bold"
        
        static func regular(size: CGFloat, lineHeight: CGFloat) -> FontStyle {
            FontStyle(
                font: UIFont(name: BaseFont.regular.rawValue, size: size)!,
                lineHeight: lineHeight,
                fontSize: size
            )
        }
        
        static func medium(size: CGFloat, lineHeight: CGFloat) -> FontStyle {
            FontStyle(
                font: UIFont(name: BaseFont.medium.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .semibold),
                lineHeight: lineHeight,
                fontSize: size
            )
        }
        
        static func semibold(size: CGFloat, lineHeight: CGFloat) -> FontStyle {
            FontStyle(
                font: UIFont(name: BaseFont.semibold.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .semibold),
                lineHeight: lineHeight,
                fontSize: size
            )
        }
        
        static func bold(size: CGFloat, lineHeight: CGFloat) -> FontStyle {
            FontStyle(
                font: UIFont(name: BaseFont.bold.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .semibold),
                lineHeight: lineHeight,
                fontSize: size
            )
        }
    }
    
    static let D1 = BaseFont.semibold(size: 28, lineHeight: 30)
    static let D2 = BaseFont.semibold(size: 24, lineHeight: 26)
    
    static let H1 = BaseFont.semibold(size: 16, lineHeight: 18)
    static let H2 = BaseFont.semibold(size: 14, lineHeight: 16)
    static let H3 = BaseFont.semibold(size: 12, lineHeight: 14)
    
    struct B1 {
        static let Bold = BaseFont.bold(size: 16, lineHeight: 18)
        static let Medium = BaseFont.semibold(size: 16, lineHeight: 18)
        static let Regular = BaseFont.regular(size: 16, lineHeight: 18)
    }
    
    struct B2 {
        static let Bold = BaseFont.bold(size: 14, lineHeight: 16)
        static let Semibold = BaseFont.semibold(size: 14, lineHeight: 16)
        static let Medium = BaseFont.medium(size: 14, lineHeight: 16)
        static let Regular = BaseFont.regular(size: 14, lineHeight: 16)
    }
    
    struct B3 {
        static let Semibold = BaseFont.semibold(size: 12, lineHeight: 16)
        static let Medium = BaseFont.medium(size: 12, lineHeight: 16)
        static let Regular = BaseFont.regular(size: 12, lineHeight: 16)
    }
    
    struct B4 {
        static let Bold = BaseFont.bold(size: 10, lineHeight: 14)
        static let Semibold = BaseFont.semibold(size: 10, lineHeight: 14)
        static let Regular = BaseFont.regular(size: 10, lineHeight: 14)
    }

    struct P1 {
        static let Semibold = BaseFont.semibold(size: 14, lineHeight: 20)
        static let Regular = BaseFont.regular(size: 14, lineHeight: 20)
    }
    
    struct P2 {
        static let Semibold = BaseFont.semibold(size: 12, lineHeight: 16)
        static let Regular = BaseFont.regular(size: 12, lineHeight: 16)
    }
    
    struct Button {
        static let Big = BaseFont.semibold(size: 14, lineHeight: 24)
        static let Medium = BaseFont.semibold(size: 14, lineHeight: 16)
        static let Small = BaseFont.semibold(size: 12, lineHeight: 16)
    }
}
