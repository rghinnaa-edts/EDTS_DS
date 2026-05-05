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

public struct EDTSFont {
    
    public struct FontStyle {
        public let font: UIFont
        public let lineHeight: CGFloat
        public let fontSize: CGFloat
    }
    
    public enum BaseFont: String {
        case regular = "Inter-Regular"
        case medium = "Inter-Medium"
        case semibold = "Inter-SemiBold"
        case bold = "Inter-Bold"
        
        public static func regular(size: CGFloat, lineHeight: CGFloat) -> FontStyle {
            FontStyle(
                font: UIFont(name: BaseFont.regular.rawValue, size: size)!,
                lineHeight: lineHeight,
                fontSize: size
            )
        }
        
        public static func medium(size: CGFloat, lineHeight: CGFloat) -> FontStyle {
            FontStyle(
                font: UIFont(name: BaseFont.medium.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .semibold),
                lineHeight: lineHeight,
                fontSize: size
            )
        }
        
        public static func semibold(size: CGFloat, lineHeight: CGFloat) -> FontStyle {
            FontStyle(
                font: UIFont(name: BaseFont.semibold.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .semibold),
                lineHeight: lineHeight,
                fontSize: size
            )
        }
        
        public static func bold(size: CGFloat, lineHeight: CGFloat) -> FontStyle {
            FontStyle(
                font: UIFont(name: BaseFont.bold.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .semibold),
                lineHeight: lineHeight,
                fontSize: size
            )
        }
    }
    
    public static let D1 = BaseFont.semibold(size: 28, lineHeight: 30)
    public static let D2 = BaseFont.semibold(size: 24, lineHeight: 26)
    
    public static let H1 = BaseFont.semibold(size: 16, lineHeight: 18)
    public static let H2 = BaseFont.semibold(size: 14, lineHeight: 16)
    public static let H3 = BaseFont.semibold(size: 12, lineHeight: 14)
    
    public struct B1 {
        public static let Bold = BaseFont.bold(size: 16, lineHeight: 18)
        public static let Medium = BaseFont.semibold(size: 16, lineHeight: 18)
        public static let Regular = BaseFont.regular(size: 16, lineHeight: 18)
    }
    
    public struct B2 {
        public static let Bold = BaseFont.bold(size: 14, lineHeight: 16)
        public static let Semibold = BaseFont.semibold(size: 14, lineHeight: 16)
        public static let Medium = BaseFont.medium(size: 14, lineHeight: 16)
        public static let Regular = BaseFont.regular(size: 14, lineHeight: 16)
    }
    
    public struct B3 {
        public static let Semibold = BaseFont.semibold(size: 12, lineHeight: 16)
        public static let Medium = BaseFont.medium(size: 12, lineHeight: 16)
        public static let Regular = BaseFont.regular(size: 12, lineHeight: 16)
    }
    
    public struct B4 {
        public static let Bold = BaseFont.bold(size: 10, lineHeight: 14)
        public static let Semibold = BaseFont.semibold(size: 10, lineHeight: 14)
        public static let Regular = BaseFont.regular(size: 10, lineHeight: 14)
    }

    public struct P1 {
        public static let Semibold = BaseFont.semibold(size: 14, lineHeight: 20)
        public static let Regular = BaseFont.regular(size: 14, lineHeight: 20)
    }
    
    public struct P2 {
        public static let Semibold = BaseFont.semibold(size: 12, lineHeight: 16)
        public static let Regular = BaseFont.regular(size: 12, lineHeight: 16)
    }
    
    public struct Button {
        public static let Big = BaseFont.semibold(size: 14, lineHeight: 24)
        public static let Medium = BaseFont.semibold(size: 14, lineHeight: 16)
        public static let Small = BaseFont.semibold(size: 12, lineHeight: 16)
    }
}
