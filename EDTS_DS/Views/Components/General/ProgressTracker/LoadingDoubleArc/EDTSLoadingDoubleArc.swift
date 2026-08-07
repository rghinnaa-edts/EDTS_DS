//
//  DoubleArc.swift
//  Poinku-DS-SB
//
//  Created by Rizka Ghinna Auliya on 09/01/25.
//

import UIKit

@IBDesignable
public class EDTSLoadingDoubleArc: UIView {
    
    @IBInspectable var progressColor: UIColor = .systemBlue {
        didSet {
            paint.strokeColor = progressColor.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var innerArcPadding: CGFloat = 8 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var progressThickness: CGFloat = 5 {
        didSet {
            paint.lineWidth = progressThickness
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var progressSize: CGFloat = 50 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var rotateSpeed: CGFloat = 6
    
    @IBInspectable var arcSweepAngle: CGFloat = 270 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private let paint: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.lineCap = .round
        layer.strokeColor = UIColor.systemBlue.cgColor
        return layer
    }()
    
    private var startAngleOuter: CGFloat = 0
    private var startAngleInner: CGFloat = 180
    private var isRunning: Bool = false
    private var displayLink: CADisplayLink?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.addSublayer(paint)
        paint.strokeColor = progressColor.cgColor
        paint.lineWidth = progressThickness
        startAnimation()
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: progressSize, height: progressSize)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        paint.frame = bounds
        updatePath()
    }
    
    private func updatePath() {
        let size = min(bounds.width, bounds.height)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let outerRadius = (size - 2 * innerArcPadding) / 2
        let innerRadius = (size - 4 * innerArcPadding) / 2
        
        let path = UIBezierPath()
        
        let outerStart = startAngleOuter.degreesToRadians
        let outerEnd = (startAngleOuter + arcSweepAngle).degreesToRadians
        path.addArc(withCenter: center,
                   radius: outerRadius,
                   startAngle: outerStart,
                   endAngle: outerEnd,
                   clockwise: true)
        
        let innerStart = startAngleInner.degreesToRadians
        let innerEnd = (startAngleInner + arcSweepAngle).degreesToRadians
        path.move(to: CGPoint(x: center.x + innerRadius * cos(innerStart),
                            y: center.y + innerRadius * sin(innerStart)))
        path.addArc(withCenter: center,
                   radius: innerRadius,
                   startAngle: innerStart,
                   endAngle: innerEnd,
                   clockwise: true)
        
        paint.path = path.cgPath
    }
    
    private func startAnimation() {
        stopAnimation()
        displayLink = CADisplayLink(target: self, selector: #selector(handleAnimation))
        displayLink?.preferredFramesPerSecond = 60
        displayLink?.add(to: .current, forMode: .common)
        isRunning = true
    }
    
    private func stopAnimation() {
        displayLink?.invalidate()
        displayLink = nil
        isRunning = false
    }
    
    @objc private func handleAnimation() {
        startAngleOuter = (startAngleOuter + rotateSpeed).truncatingRemainder(dividingBy: 360)
        startAngleInner = (startAngleInner - rotateSpeed).truncatingRemainder(dividingBy: 360)
        updatePath()
    }
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            startAnimation()
        } else {
            stopAnimation()
        }
    }
}

private extension CGFloat {
    var degreesToRadians: CGFloat {
        return self * .pi / 180
    }
}

