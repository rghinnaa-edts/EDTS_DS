//
//  LiquidGlassBackgroundView.swift
//  KlikIDM_DS
//
//  Created by Yovita Handayiani on 09/01/26.
//

import UIKit

class LiquidGlassBackgroundView: UIView {
    private var blurView: UIVisualEffectView
    private let gradientOverlay = CAGradientLayer()
    private let gradientBorder = CAGradientLayer()
    private let borderMask = CAShapeLayer()
    
    override init(frame: CGRect) {
        blurView = UIVisualEffectView()
        super.init(frame: frame)
        setupBlurEffect()
    }
    
    required init?(coder: NSCoder) {
        blurView = UIVisualEffectView()
        super.init(coder: coder)
        setupBlurEffect()
    }
    
    private func setupBlurEffect(){
        let blurEffect: UIBlurEffect
        
        if #available(iOS 13.0, *) {
            blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        } else {
            blurEffect = UIBlurEffect(style: .extraLight)
        }
        
        blurView = UIVisualEffectView(effect: blurEffect)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 8
        addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        if #available(iOS 13.0, *) {
            blurView.alpha = 0.5
        } else {
            blurView.alpha = 0.3
        }
        
        setupGradientStroke()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientOverlay.frame = blurView.bounds
        gradientBorder.frame = blurView.bounds
        borderMask.path = UIBezierPath(roundedRect: blurView.bounds, cornerRadius: blurView.layer.cornerRadius).cgPath
    }
    
    private func setupGradientStroke(){
        var colors: [CGColor] = []

        colors.append(EDTSColor.white.withAlphaComponent(2.0).cgColor)
        for i in 0..<60 {
            colors.append(UIColor.clear.cgColor)
        }
        colors.append(EDTSColor.white.withAlphaComponent(2.0).cgColor)
        
        gradientBorder.colors = colors
        gradientBorder.startPoint = CGPoint(x: 0, y: 0.5)
        gradientBorder.endPoint = CGPoint(x: 1, y: 0.5)
        gradientBorder.frame = blurView.bounds
        gradientBorder.cornerRadius = blurView.layer.cornerRadius
        
        borderMask.path = UIBezierPath(roundedRect: blurView.bounds, cornerRadius: blurView.layer.cornerRadius).cgPath
        borderMask.lineWidth = 2
        borderMask.fillColor = UIColor.clear.cgColor
        borderMask.strokeColor = EDTSColor.white.cgColor
        
        gradientBorder.mask = borderMask
        blurView.layer.addSublayer(gradientBorder)
    }
}
