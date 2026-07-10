//
//  EDTSAnimation.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 28/04/26.
//

import UIKit

extension UIView {
    public func startAnimationGradientBorder(width: CGFloat = 2, colors: [UIColor] = [EDTSColor.white, EDTSColor.blue30], duration: TimeInterval = 2.0) {
        layer.removeAnimation(forKey: "gradientBorder")
        layer.borderWidth = 0
        layer.sublayers?.filter { $0.name == "gradientBorderLayer" }.forEach { $0.removeFromSuperlayer() }
        
        let borderPath = UIBezierPath(roundedRect: bounds.insetBy(dx: width/2, dy: width/2),
                                      cornerRadius: layer.cornerRadius > 0 ? layer.cornerRadius - width/2 : 0)
        
        let borderLayer = CAShapeLayer()
        borderLayer.name = "gradientBorderLayer"
        borderLayer.path = borderPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.lineWidth = width
        borderLayer.frame = bounds
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientBorderLayer"
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.mask = borderLayer
        
        layer.addSublayer(gradientLayer)
        
        let startPointAnimation = CAKeyframeAnimation(keyPath: "startPoint")
        startPointAnimation.values = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 0)
        ]
        
        let endPointAnimation = CAKeyframeAnimation(keyPath: "endPoint")
        endPointAnimation.values = [
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1)
        ]
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [startPointAnimation, endPointAnimation]
        animationGroup.duration = duration
        animationGroup.repeatCount = .infinity
        animationGroup.isRemovedOnCompletion = false
        
        gradientLayer.add(animationGroup, forKey: "moveGradient")
    }
 
    public func stopAnimationGradientBorder(withDuration duration: TimeInterval = 0.5) {
        layer.sublayers?.filter { $0.name == "gradientBorderLayer" }.forEach { gradientLayer in
            guard let gradientLayer = gradientLayer as? CAGradientLayer else { return }
            let presentationLayer = gradientLayer.presentation()
            
            gradientLayer.removeAnimation(forKey: "moveGradient")
            
            if let presentationLayer = presentationLayer {
                gradientLayer.startPoint = presentationLayer.startPoint
                gradientLayer.endPoint = presentationLayer.endPoint
            }
            
            let colorAnimation = CABasicAnimation(keyPath: "colors")
            colorAnimation.fromValue = gradientLayer.colors
            colorAnimation.toValue = [EDTSColor.blue30.cgColor, EDTSColor.blue30.cgColor]
            
            let startPointAnimation = CABasicAnimation(keyPath: "startPoint")
            startPointAnimation.fromValue = gradientLayer.startPoint
            startPointAnimation.toValue = CGPoint(x: 0, y: 0)
            
            let endPointAnimation = CABasicAnimation(keyPath: "endPoint")
            endPointAnimation.fromValue = gradientLayer.endPoint
            endPointAnimation.toValue = CGPoint(x: 1, y: 0)
            
            let animationGroup = CAAnimationGroup()
            animationGroup.animations = [colorAnimation, startPointAnimation, endPointAnimation]
            animationGroup.duration = duration
            animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animationGroup.fillMode = .both
            animationGroup.isRemovedOnCompletion = false
            
            gradientLayer.add(animationGroup, forKey: "fadeToBlue")
        }
    }
    
    public func startAnimationNeonPulse(color: CGColor = EDTSColor.blue30.cgColor, duration: TimeInterval = 1.0) {
        self.layer.masksToBounds = false
        
        let pulseAnimation = CABasicAnimation(keyPath: "shadowRadius")
        pulseAnimation.fromValue = 0.5
        pulseAnimation.toValue = 12
        pulseAnimation.duration = duration
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let opacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        opacityAnimation.fromValue = 0.1
        opacityAnimation.toValue = 0.5
        opacityAnimation.duration = duration
        opacityAnimation.autoreverses = true
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 0.1
        
        self.layer.add(pulseAnimation, forKey: "continuousPulse")
        self.layer.add(opacityAnimation, forKey: "continuousOpacity")
    }
    
    public func stopAnimationNeonPulse() {
        self.layer.removeAllAnimations()
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
