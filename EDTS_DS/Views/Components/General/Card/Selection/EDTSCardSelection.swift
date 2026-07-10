//
//  CardSelection.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 04/12/25.
//

import UIKit

@IBDesignable
public class EDTSCardSelection: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var containerBackgroundView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBInspectable public var cardTitle: String? {
        didSet {
            lblTitle.text = cardTitle
        }
    }
    
    @IBInspectable public var cardDescription: String? {
        didSet {
            lblDesc.text = cardDescription
        }
    }
    
    @IBInspectable public var cardTitleColor: UIColor? {
        didSet {
            lblTitle.textColor = cardTitleColor
        }
    }
    
    @IBInspectable public var cardDescColor: UIColor? {
        didSet {
            lblDesc.textColor = cardDescColor
        }
    }
    
    @IBInspectable public var cardBackgroundColor: UIColor? {
        didSet {
            containerBackgroundView.backgroundColor = cardBackgroundColor
        }
    }
    
    @IBInspectable public var cardBorderWidth: CGFloat = 0.0 {
        didSet {
            containerBackgroundView.layer.borderWidth = cardBorderWidth
        }
    }
    
    @IBInspectable public var cardBorderColor: UIColor? {
        didSet {
            containerBackgroundView.layer.borderColor = cardBorderColor?.cgColor
        }
    }
    
    @IBInspectable public var cardCornerRadius: CGFloat = 0.0 {
        didSet {
            containerBackgroundView.layer.cornerRadius = cardCornerRadius
        }
    }
    
    @IBInspectable public var cardShadowOpacity: Float = 0.0 {
        didSet {
            containerBackgroundView.layer.shadowOpacity = cardShadowOpacity
        }
    }
    
    @IBInspectable public var cardShadowOffset: CGSize = CGSize.zero {
        didSet {
            containerBackgroundView.layer.shadowOffset = cardShadowOffset
        }
    }
    
    @IBInspectable public var cardShadowRadius: CGFloat = 0.0 {
        didSet {
            containerBackgroundView.layer.shadowRadius = cardShadowRadius
        }
    }
    
    @IBInspectable public var cardShadowColor: UIColor? = UIColor.black {
        didSet {
            containerBackgroundView.layer.shadowColor = cardShadowColor?.cgColor
        }
    }
    
    @IBInspectable public var cardShadowActiveColor: UIColor? = UIColor.black {
        didSet {
            containerBackgroundView.layer.shadowColor = cardShadowActiveColor?.cgColor
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    public func animateCardSelection(
        fromBorderColor: UIColor?,
        toBorderColor: UIColor?
    ) {
        let animationDuration: TimeInterval = 0.3
        
        let borderAnimation = CABasicAnimation(keyPath: "borderColor")
        borderAnimation.fromValue = fromBorderColor?.cgColor
        borderAnimation.toValue = toBorderColor?.cgColor
        borderAnimation.duration = animationDuration
        borderAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        containerBackgroundView.layer.add(borderAnimation, forKey: "borderAnimation")
        containerBackgroundView.layer.borderColor = toBorderColor?.cgColor
    }
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSCardSelection", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(containerView)
        } else {
            print("Failed to load Card Selection XIB")
        }
    }
}
