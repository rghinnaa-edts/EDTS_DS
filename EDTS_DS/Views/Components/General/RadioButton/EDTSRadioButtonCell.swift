//
//  RadioButtonCell.swift
//  KlikIDM_DS
//
//  Created by Yovita Handayiani on 09/03/26.
//

import UIKit

public class EDTSRadioButtonCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var radioButtonItem: EDTSRadioButton!
    
    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.backgroundColor = .clear
        containerView.clipsToBounds = false
        clipsToBounds = false
        layer.masksToBounds = false
    }
    
    // MARK: - Public Function
    public func setData(title: String, description: String) {
        radioButtonItem.titleAttributed = nil
        radioButtonItem.descAttributed = nil
        radioButtonItem.title = title
        radioButtonItem.desc = description
        radioButtonItem.isActive = false
    }
    
    public func setDataAttribute(title: NSAttributedString, description: NSAttributedString) {
        radioButtonItem.title = nil
        radioButtonItem.desc = nil
        radioButtonItem.titleAttributed = title
        radioButtonItem.descAttributed = description
        radioButtonItem.isActive = false
    }
    
    public func setDelegate(_ delegate: EDTSRadioButtonDelegate) {
        radioButtonItem?.delegate = delegate
    }
    
    static func instantiateForSizing() -> EDTSRadioButtonCell {
        let nib = UINib(nibName: "EDTSRadioButtonCell", bundle: Bundle(for: EDTSRadioButtonCell.self))
        return nib.instantiate(withOwner: nil, options: nil).first as! EDTSRadioButtonCell
    }
}
