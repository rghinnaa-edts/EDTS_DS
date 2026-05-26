//
//  CardSelectionCell.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 09/12/25.
//

import UIKit

public class EDTSCardSelectionCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var cardSelection: EDTSCardSelection!
    
    public var cardTitleColor: UIColor? {
        didSet {
            updateColorState()
        }
    }
    
    public var cardTitleActiveColor: UIColor? {
        didSet {
            updateColorState()
        }
    }
    
    public var cardDescColor: UIColor? {
        didSet {
            updateColorState()
        }
    }
    
    public var cardDescActiveColor: UIColor? {
        didSet {
            updateColorState()
        }
    }
    
    public var cardBackgroundColor: UIColor? {
        didSet {
            updateColorState()
        }
    }
    
    public var cardBackgroundActiveColor: UIColor? {
        didSet {
            updateColorState()
        }
    }
    
    public var cardBorderWidth: CGFloat = 0.0 {
        didSet {
            cardSelection.cardBorderWidth = cardBorderWidth
        }
    }
    
    public var cardBorderColor: UIColor? = UIColor.systemBlue {
        didSet {
            updateColorState()
        }
    }
    
    public var cardBorderActiveColor: UIColor? = UIColor.systemBlue {
        didSet {
            updateColorState()
        }
    }
    
    public var cardCornerRadius: CGFloat = 0.0 {
        didSet {
            cardSelection.cardCornerRadius = cardCornerRadius
        }
    }
    
    public var cardShadowOpacity: Float = 0.0 {
        didSet {
            cardSelection.cardShadowOpacity = cardShadowOpacity
        }
    }
    
    public var cardShadowOffset: CGSize = CGSize.zero {
        didSet {
            cardSelection.cardShadowOffset = cardShadowOffset
        }
    }
    
    public var cardShadowRadius: CGFloat = 0.0 {
        didSet {
            cardSelection.cardShadowRadius = cardShadowRadius
        }
    }
    
    public var cardShadowColor: UIColor? {
        didSet {
            if !isSelectedState {
                cardSelection.cardShadowColor = cardShadowColor
            }
        }
    }
    
    public var cardShadowActiveColor: UIColor? {
        didSet {
            if isSelectedState {
                cardSelection.cardShadowActiveColor = cardShadowActiveColor
            }
        }
    }
    
    public var isSelectedState: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    public var isEnabled: Bool = true {
        didSet {
            updateColorState()
        }
    }
    
    public var isUserTapped: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    public func loadData(data: CardSelectionModel) {
        cardSelection.lblTitle.text = data.title
        cardSelection.lblDesc.text = data.description
        isEnabled = data.isEnabled
    }
        
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSCardSelectionCell", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(containerView)
        }
    }
    
    private func updateAppearance() {
        if !isSelectedState {
            if isUserTapped {
                cardSelection.animateCardSelection(
                    fromBorderColor: cardBorderActiveColor,
                    toBorderColor: cardBorderColor
                )
            } else {
                cardSelection.cardBorderColor = cardBorderColor
            }
        } else {
            cardSelection.animateCardSelection(
                fromBorderColor: cardBorderColor,
                toBorderColor: cardBorderActiveColor
            )
        }
    }
    
    private func updateColorState() {
        if isEnabled {
            cardSelection.cardTitleColor = isSelectedState ? cardTitleActiveColor : cardTitleColor
            cardSelection.cardDescColor = isSelectedState ? cardDescActiveColor : cardDescColor
            cardSelection.cardBackgroundColor = isSelectedState ? cardBackgroundActiveColor : cardBackgroundColor
            cardSelection.cardBorderColor = isSelectedState ? cardBorderActiveColor : cardBorderColor
            cardSelection.cardBorderWidth = 1
        } else {
            cardSelection.cardTitleColor = EDTSColor.disabled
            cardSelection.cardDescColor = EDTSColor.disabled
            cardSelection.cardBorderColor = EDTSColor.grey20
            cardSelection.cardBorderWidth = 0.5
        }
        
        self.isUserInteractionEnabled = isEnabled
    }
}

public struct CardSelectionModel {
    public var id: String
    public var title: String
    public var description: String
    public var isEnabled: Bool
    
    public init(id: String, title: String, description: String, isEnabled: Bool = true) {
        self.id = id
        self.title = title
        self.description = description
        self.isEnabled = isEnabled
    }
}
