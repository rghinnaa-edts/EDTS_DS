//
//  OnBoardingSlide.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 24/04/25.
//

import UIKit

public struct EDTSOnBoardingV2Slide {
    let imageIllustration: UIImage?
    let imageBackground: UIImage?
    let title: String
    let description: String
    
    public init(
        imageIllustration: UIImage? = nil,
        imageBackground: UIImage? = nil,
        title: String,
        description: String
    ) {
        self.imageIllustration = imageIllustration
        self.imageBackground = imageBackground
        self.title = title
        self.description = description
    }
}
