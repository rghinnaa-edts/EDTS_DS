//
//  OnBoardingSlide.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 24/04/25.
//

import UIKit

public struct EDTSOnBoardingSlide {
    let image: UIImage?
    let title: String
    let description: String
    
    public init(image: UIImage?, title: String, description: String) {
        self.image = image
        self.title = title
        self.description = description
    }
}
