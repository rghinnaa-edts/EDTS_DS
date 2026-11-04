//
//  EDTSCardPromoProductModel.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 22/10/26.
//

import UIKit

public struct EDTSCardPromoProductModel {
    public var isAvailable: Bool
    public let image: UIImage
    public let title: String
    public let price: String
    public let realPrice: String
    public let discountPercent: String
    public var isSelected: Bool

    public init(
        isAvailable: Bool = true,
        image: UIImage,
        title: String,
        price: String,
        realPrice: String,
        discountPercent: String,
        isSelected: Bool = false
    ) {
        self.isAvailable = isAvailable
        self.image = image
        self.title = title
        self.price = price
        self.realPrice = realPrice
        self.discountPercent = discountPercent
        self.isSelected = isSelected
    }
}
