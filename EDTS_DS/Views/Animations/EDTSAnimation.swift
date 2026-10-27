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
    
    //MARK: Card Selected Animation
    private static let cardTriangleID = "cardSelectedAnimation.triangle"

    public func cardSelectedAnimation(
        isSelected: Bool,
        tintColor: UIColor = EDTSColor.blue50,
        unselectedBorderColor: UIColor = EDTSColor.grey30,
        icon: UIImage? = UIImage(named: "ic_check"),
        iconTintColor: UIColor = EDTSColor.white,
        iconSize: CGFloat = 16,
        triangleSize: CGFloat = 32,
        durationAnimation: TimeInterval = 0.25,
        animated: Bool = true
    ) {
        // MARK: Border
        layer.masksToBounds = true
        if layer.borderWidth == 0 { layer.borderWidth = 1 }

        let newBorder = (isSelected ? tintColor : unselectedBorderColor).cgColor
        if animated {
            let anim = CABasicAnimation(keyPath: "borderColor")
            anim.fromValue = layer.borderColor
            anim.toValue = newBorder
            anim.duration = durationAnimation
            layer.add(anim, forKey: "cardBorderColor")
        }
        layer.borderColor = newBorder

        // MARK: Triangle
        var triangle = subviews.first { $0.accessibilityIdentifier == UIView.cardTriangleID }
        if triangle == nil {
            guard isSelected else { return }

            let t = UIView()
            t.accessibilityIdentifier = UIView.cardTriangleID
            t.backgroundColor = .clear
            t.isUserInteractionEnabled = false
            t.translatesAutoresizingMaskIntoConstraints = false

            let shape = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: triangleSize, y: 0))
            path.addLine(to: CGPoint(x: 0, y: triangleSize))
            path.close()
            shape.frame = CGRect(x: 0, y: 0, width: triangleSize, height: triangleSize)
            shape.path = path.cgPath
            t.layer.addSublayer(shape)

            let iconView = UIImageView()
            iconView.contentMode = .scaleAspectFit
            iconView.frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
            iconView.center = CGPoint(x: triangleSize / 3, y: triangleSize / 3)
            t.addSubview(iconView)

            addSubview(t)
            NSLayoutConstraint.activate([
                t.topAnchor.constraint(equalTo: topAnchor),
                t.leadingAnchor.constraint(equalTo: leadingAnchor),
                t.widthAnchor.constraint(equalToConstant: triangleSize),
                t.heightAnchor.constraint(equalToConstant: triangleSize)
            ])
            t.isHidden = true
            triangle = t
        }
        guard let triangle = triangle else { return }

        (triangle.layer.sublayers?.first as? CAShapeLayer)?.fillColor = tintColor.cgColor
        if let iconView = triangle.subviews.first as? UIImageView {
            let resolvedIcon = icon ?? UIImage(named: "ic_check", in: .edtsDS, compatibleWith: nil)
            iconView.image = resolvedIcon?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = iconTintColor
        }

        // MARK: Show / hide animation
        let offscreen = CGAffineTransform(translationX: -triangleSize, y: -triangleSize)
        triangle.layer.removeAllAnimations()

        if isSelected {
            triangle.isHidden = false
            if animated {
                triangle.alpha = 0
                triangle.transform = offscreen
                UIView.animate(withDuration: durationAnimation, delay: 0, options: .curveEaseOut) {
                    triangle.alpha = 1
                    triangle.transform = .identity
                }
            } else {
                triangle.alpha = 1
                triangle.transform = .identity
            }
        } else if animated {
            UIView.animate(withDuration: durationAnimation, delay: 0, options: .curveEaseIn, animations: {
                triangle.alpha = 0
                triangle.transform = offscreen
            }, completion: { _ in
                if self.layer.borderColor == unselectedBorderColor.cgColor {
                    triangle.isHidden = true
                }
            })
        } else {
            triangle.isHidden = true
            triangle.alpha = 1
            triangle.transform = .identity
        }
    }

}
