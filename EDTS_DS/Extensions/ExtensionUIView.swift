//
//  ExtensionView.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 06/08/25.
//

import UIKit

public enum Orientation: String {
    case horizontal = "horizontal"
    case vertical = "vertical"
}

extension UIView {
    // MARK: - Gradient Background
    public func setGradientBackground(_ gradient: [UIColor], orientation: Orientation = .horizontal, cornerRadius: CGFloat = 0, corners: UIRectCorner = .allCorners, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {

        layer.sublayers?.removeAll { $0 is CAGradientLayer }
        
        layer.borderWidth = 0
        layer.cornerRadius = 0
        layer.masksToBounds = false
        
        layoutIfNeeded()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradient.map { $0.cgColor }
        gradientLayer.frame = bounds
        
        switch orientation {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        }
        
        if cornerRadius > 0 {
            let maskPath = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            gradientLayer.mask = maskLayer
            
            if borderWidth > 0, let borderColor = borderColor {
                let borderLayer = CAShapeLayer()
                borderLayer.path = maskPath.cgPath
                borderLayer.fillColor = UIColor.clear.cgColor
                borderLayer.strokeColor = borderColor.cgColor
                borderLayer.lineWidth = borderWidth
                borderLayer.frame = bounds
                
                layer.addSublayer(borderLayer)
            }
        } else {
            if borderWidth > 0 {
                layer.borderWidth = borderWidth
                layer.borderColor = borderColor?.cgColor
            }
        }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Shaping View To Circle/Elipse
    func applyCircular() {
        layoutIfNeeded()
        layer.cornerRadius = min(layer.bounds.width, layer.bounds.height) / 2
    }
    
    // MARK: - Ripple Animation
    private struct RippleKeys {
        static var viewRippleLayer: UInt8 = 0
        static var iconRippleLayer: UInt8 = 0
        static var rippleStartTime: UInt8 = 0
    }
    
    private var rippleStartTime: Date? {
        get { objc_getAssociatedObject(self, &RippleKeys.rippleStartTime) as? Date }
        set { objc_setAssociatedObject(self, &RippleKeys.rippleStartTime, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var activeRippleLayers: [CAShapeLayer] {
        get { objc_getAssociatedObject(self, &RippleKeys.viewRippleLayer) as? [CAShapeLayer] ?? [] }
        set { objc_setAssociatedObject(self, &RippleKeys.viewRippleLayer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func showRipple(from touchPoint: CGPoint, cornerRadius: CGFloat? = nil) {
        rippleStartTime = Date()
        let radius = cornerRadius ?? layer.cornerRadius

        let maxRadius = [
            CGPoint(x: bounds.minX, y: bounds.minY),
            CGPoint(x: bounds.maxX, y: bounds.minY),
            CGPoint(x: bounds.minX, y: bounds.maxY),
            CGPoint(x: bounds.maxX, y: bounds.maxY)
        ]
        .map { hypot(touchPoint.x - $0.x, touchPoint.y - $0.y) }
        .max() ?? hypot(bounds.width, bounds.height)

        let ripple = CAShapeLayer()
        ripple.opacity = 0
        ripple.fillColor = UIColor.grey30?.withAlphaComponent(0.12).cgColor
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        ripple.mask = maskLayer
        ripple.frame = bounds
        
        let startPath = UIBezierPath(arcCenter: touchPoint, radius: 1, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
        let endPath = UIBezierPath(arcCenter: touchPoint, radius: maxRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
        ripple.path = startPath
        ripple.setValue(Date(), forKey: "rippleStartTime")
        
        layer.addSublayer(ripple)
        activeRippleLayers.append(ripple)
        
        let expandAnimation = CABasicAnimation(keyPath: "path")
        expandAnimation.fromValue = startPath
        expandAnimation.toValue = endPath
        expandAnimation.duration = 0.40
        expandAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        expandAnimation.fillMode = .forwards
        expandAnimation.isRemovedOnCompletion = false

        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0
        fadeIn.toValue = 1
        fadeIn.duration = 0.10
        fadeIn.timingFunction = CAMediaTimingFunction(name: .easeOut)
        fadeIn.fillMode = .forwards
        fadeIn.isRemovedOnCompletion = false

        let group = CAAnimationGroup()
        group.animations = [expandAnimation, fadeIn]
        group.duration = 0.40
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false

        ripple.add(group, forKey: "rippleExpand")
    }
    
    func hideRipple() {
        let layersToHide = activeRippleLayers
        activeRippleLayers = []
        
        for ripple in layersToHide {
            let startTime = ripple.value(forKey: "rippleStartTime") as? Date ?? Date()
            let elapsed = Date().timeIntervalSince(startTime)
            let remaining = max(0, 0.40 - elapsed)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + remaining) {
                let fadeOut = CABasicAnimation(keyPath: "opacity")
                fadeOut.fromValue = ripple.presentation()?.opacity ?? 1
                fadeOut.toValue = 0
                fadeOut.duration = 0.22
                fadeOut.timingFunction = CAMediaTimingFunction(name: .easeOut)
                fadeOut.fillMode = .forwards
                fadeOut.isRemovedOnCompletion = false
                
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    ripple.removeFromSuperlayer()
                }
                ripple.add(fadeOut, forKey: "fadeOut")
                CATransaction.commit()
            }
        }
    }
    
    private var iconRippleLayer: CAShapeLayer? {
        get { objc_getAssociatedObject(self, &RippleKeys.iconRippleLayer) as? CAShapeLayer }
        set { objc_setAssociatedObject(self, &RippleKeys.iconRippleLayer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func showIconRipple(size: CGFloat = 32,
                    color: UIColor? = UIColor.grey30?.withAlphaComponent(0.22)) {

        guard iconRippleLayer == nil else { return }
        guard superview != nil else { return }

        let container = superview!

        let circle = CAShapeLayer()

        let rect = CGRect(
            x: frame.midX - size/2,
            y: frame.midY - size/2,
            width: size,
            height: size
        )

        circle.path = UIBezierPath(ovalIn: rect).cgPath
        circle.fillColor = color?.cgColor
        circle.opacity = 0

        container.layer.insertSublayer(circle, below: layer)
        iconRippleLayer = circle

        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0
        fadeIn.toValue = 1
        fadeIn.duration = 0.1
        fadeIn.isRemovedOnCompletion = false
        fadeIn.fillMode = .forwards

        circle.add(fadeIn, forKey: "fadeIn")
    }
    
    func hideIconRipple() {
        guard let circle = iconRippleLayer else { return }

        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 1
        fadeOut.toValue = 0
        fadeOut.duration = 0.2
        fadeOut.isRemovedOnCompletion = false
        fadeOut.fillMode = .forwards

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            circle.removeFromSuperlayer()
            self?.iconRippleLayer = nil
        }

        circle.add(fadeOut, forKey: "fadeOut")
        CATransaction.commit()
    }

    // MARK: - Grayscale
    private struct GrayscaleKeys {
        static var grayscaleLayer: UInt8 = 0
        static var isApplyingGrayscale: UInt8 = 1
    }

    private var grayscaleLayer: CALayer? {
        get {
            return objc_getAssociatedObject(self, &GrayscaleKeys.grayscaleLayer) as? CALayer
        }
        set {
            objc_setAssociatedObject(self, &GrayscaleKeys.grayscaleLayer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var isApplyingGrayscale: Bool {
        get {
            return objc_getAssociatedObject(self, &GrayscaleKeys.isApplyingGrayscale) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &GrayscaleKeys.isApplyingGrayscale, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func applyGrayscale(_ isGrayscale: Bool) {
        isApplyingGrayscale = isGrayscale
        
        if isGrayscale {
            layoutIfNeeded()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self, self.isApplyingGrayscale else { return }
                guard self.bounds.width > 0 && self.bounds.height > 0 else {
                    return
                }
                
                self.addGrayscaleEffect()
            }
        } else {
            removeGrayscaleEffect()
        }
    }

    private func addGrayscaleEffect() {
        removeGrayscaleEffect()
        
        layoutIfNeeded()
        guard bounds.width > 0 && bounds.height > 0 else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        layer.render(in: context)
        
        guard let capturedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }
        UIGraphicsEndImageContext()
        
        guard let ciImage = CIImage(image: capturedImage) else { return }
        
        let grayscaleFilter = CIFilter(name: "CIPhotoEffectMono")
        grayscaleFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = grayscaleFilter?.outputImage else { return }
        
        let ciContext = CIContext(options: nil)
        guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let imageLayer = CALayer()
        imageLayer.contents = cgImage
        imageLayer.frame = bounds
        imageLayer.contentsScale = UIScreen.main.scale
        
        layer.addSublayer(imageLayer)
        grayscaleLayer = imageLayer
    }

    public func removeGrayscaleEffect() {
        grayscaleLayer?.removeFromSuperlayer()
        grayscaleLayer = nil
    }
    
    // MARK: - Coupon Background
    public func createCouponPath(
        in rect: CGRect,
        notchRadius: CGFloat,
        notchPosition: CGFloat,
        cornerRadius: CGFloat
    ) -> UIBezierPath {
        let path = UIBezierPath()
        
        let width = bounds.width
        let height = bounds.height
        
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .pi,
                    endAngle: .pi * 1.5,
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        
        path.addArc(withCenter: CGPoint(x: width - cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .pi * 1.5,
                    endAngle: 0,
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: width, y: notchPosition))
        
        path.addArc(withCenter: CGPoint(x: width, y: notchPosition),
                    radius: notchRadius,
                    startAngle: 0,
                    endAngle: .pi,
                    clockwise: false)
        
        path.addArc(withCenter: CGPoint(x: width, y: notchPosition),
                    radius: notchRadius,
                    startAngle: .pi,
                    endAngle: 0,
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
        
        path.addArc(withCenter: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: 0,
                    endAngle: .pi * 0.5,
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: cornerRadius, y: height))
        
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .pi * 0.5,
                    endAngle: .pi,
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: 0, y: notchPosition))
        
        path.addArc(withCenter: CGPoint(x: 0, y: notchPosition),
                    radius: notchRadius,
                    startAngle: .pi,
                    endAngle: 0,
                    clockwise: false)
        
        path.addArc(withCenter: CGPoint(x: 0, y: notchPosition),
                    radius: notchRadius,
                    startAngle: 0,
                    endAngle: .pi,
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        
        path.close()
        return path
    }
    
    public func applyCouponBackground(
        notchRadius: CGFloat = 8,
        notchPosition: CGFloat,
        cornerRadius: CGFloat = 12
    ) {
        let path = createCouponPath(
            in: bounds,
            notchRadius: notchRadius,
            notchPosition: notchPosition,
            cornerRadius: cornerRadius
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
