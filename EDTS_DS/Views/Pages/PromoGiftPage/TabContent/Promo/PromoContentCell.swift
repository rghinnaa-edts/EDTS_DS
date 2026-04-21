//
//  Untitled.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 15/05/25.
//

import UIKit

class EDTSPromoContentCell: UICollectionViewCell {
    
    static let identifier = String(describing: EDTSPromoContentCell.self)
    
    @IBOutlet var imgBanner: UIImageView!
    @IBOutlet var lblTitleBanner: UILabel!
    @IBOutlet var lblSeeFair: UILabel!
    
    func setup(_ data: EDTSPromoContentModel) {
        if let image = data.banner {
            imgBanner.image = image
            imgBanner.contentMode = .scaleAspectFill
        }
        lblTitleBanner.text = data.title
        
        lblSeeFair.isHidden = !data.isEnable
    }
    
}
