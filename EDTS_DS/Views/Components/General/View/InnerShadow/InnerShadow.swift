//
//  InnerShadowView.swift
//  EDTS_DS
//
//  Created by Yovita Handayiani on 11/06/26.
//

import UIKit

class InnerShadow: UIView {
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            setNeedsLayout()
        }
    }
    
    var shadowColor: UIColor = EDTSColor.black {
        didSet {
            innerShadowLayer.shadowColor = shadowColor.cgColor
        }
    }
    
    var shadowOpacity: Float = 0.10 {
        didSet {
            innerShadowLayer.shadowOpacity = shadowOpacity
        }
    }
    
    var shadowRadius: CGFloat = 3 {
        didSet {
            innerShadowLayer.shadowRadius = shadowRadius
            setNeedsLayout()
        }
    }
    
    var shadowOffset: CGSize = .zero {
        didSet {
            innerShadowLayer.shadowOffset = shadowOffset
        }
    }
    
    // MARK: - Private Variable
    private lazy var innerShadowLayer: CAShapeLayer = {
        let shadowLayer = CAShapeLayer()
        shadowLayer.fillRule = .evenOdd
        return shadowLayer
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        innerShadowLayer.frame = bounds
        
        let radius = layer.cornerRadius
        let inset = shadowRadius + 2
        
        let innerRect = bounds
        let outerRect = bounds.insetBy(dx: -inset, dy: -inset)
        
        let path = CGMutablePath()
        path.addRoundedRect(in: outerRect,
                            cornerWidth: radius + inset,
                            cornerHeight: radius + inset)
        path.addRoundedRect(in: innerRect,
                            cornerWidth: radius,
                            cornerHeight: radius)
        
        innerShadowLayer.path = path
        innerShadowLayer.fillRule = .evenOdd
        innerShadowLayer.fillColor = UIColor.black.cgColor
    }
    
    // MARK: - Setup & Styling
    private func setupUI() {
        backgroundColor = .clear
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        innerShadowLayer.shadowColor = shadowColor.cgColor
        innerShadowLayer.shadowOpacity = shadowOpacity
        innerShadowLayer.shadowRadius = shadowRadius
        innerShadowLayer.shadowOffset = shadowOffset

        layer.addSublayer(innerShadowLayer)
    }
}
