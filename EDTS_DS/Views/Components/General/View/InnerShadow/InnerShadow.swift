//
//  InnerShadow.swift
//  EDTS_DS
//
//  Created by Yovita Handayiani on 29/06/26.
//
import UIKit

@IBDesignable
public class InnerShadow: UIView {
    private let innerShadow = InsetShadowView()
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            innerShadow.cornerRadius = cornerRadius
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = EDTSColor.black {
        didSet {
            innerShadow.shadowColor = shadowColor
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = 0.1 {
        didSet {
            innerShadow.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 2 {
        didSet {
            innerShadow.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = .zero {
        didSet {
            innerShadow.shadowOffset = shadowOffset
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.mask = {
            let mask = CAShapeLayer()
            mask.path = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: cornerRadius
            ).cgPath
            return mask
        }()
    }
    
    private func setup() {
        clipsToBounds = true
        
        addSubview(innerShadow)
        innerShadow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            innerShadow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -1),
            innerShadow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1),
            innerShadow.topAnchor.constraint(equalTo: topAnchor, constant: -1),
            innerShadow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1),
        ])
    }
}
