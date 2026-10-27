//
//  EDTSCardPromoModel.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 22/10/26.
//

import UIKit

// MARK: - Info

public struct EDTSCardPromoInfo {
    public var state: EDTSAlertboxState
    public var icon: UIImage?
    public var description: NSAttributedString
    public var buttonText: String
    public var accentColor: UIColor?
    public var backgroundColor: UIColor?

    public init(
        state: EDTSAlertboxState = .default,
        icon: UIImage? = nil,
        description: NSAttributedString = NSAttributedString(string: ""),
        buttonText: String = "",
        accentColor: UIColor? = nil,
        backgroundColor: UIColor? = nil
    ) {
        self.state = state
        self.icon = icon
        self.description = description
        self.buttonText = buttonText
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Card

public struct EDTSCardPromoModel {
    public let id: String
    public var title: String
    public var banner: UIImage?
    public var isAvailable: Bool
    public var isProductAvailable: Bool
    public var products: [EDTSCardPromoProductModel]
    public var info: EDTSCardPromoInfo

    public init(
        id: String? = nil,
        title: String,
        banner: UIImage? = nil,
        isAvailable: Bool = true,
        isProductAvailable: Bool = true,
        products: [EDTSCardPromoProductModel],
        info: EDTSCardPromoInfo = EDTSCardPromoInfo()
    ) {
        self.id = id ?? title
        self.title = title
        self.banner = banner
        self.isAvailable = isAvailable
        self.isProductAvailable = isProductAvailable
        self.products = products
        self.info = info
    }
}
