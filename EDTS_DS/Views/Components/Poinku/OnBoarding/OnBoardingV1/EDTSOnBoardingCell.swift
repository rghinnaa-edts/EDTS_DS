//
//  OnBoardingCell.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 25/04/25.
//

import UIKit

public class EDTSOnBoardingCell: UICollectionViewCell {
    
    public static let identifier = String(describing: EDTSOnBoardingCell.self)
    
    @IBOutlet var ivSlide: UIImageView!
    
    public func setup(_ image: UIImage?) {
        ivSlide.image = image
        ivSlide.contentMode = .scaleAspectFill
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        ivSlide.image = nil
    }
}
