//
//  EDTSCircularLoading.swift
//  EDTS_DS
//
//  Created by Yovita Handayiani on 06/08/26.
//

import UIKit

@IBDesignable
public class EDTSCircularLoading: UIView {
    // MARK: - Inspectables
    @IBInspectable public var value: CGFloat {
        get { _value }
        set {
            let clamped = min(newValue, maxValue)
            _value = clamped
            calculateValue()
        }
    }
    
    @IBInspectable public var maxValue: CGFloat = 100.0 {
        didSet {
            if value > maxValue { value = maxValue }
            calculateValue()
        }
    }
    
    @IBInspectable public var lineCapStyle: String = "round" {
        didSet {
            updateLineCap()
        }
    }
    
    @IBInspectable public var doubleArcGap: CGFloat = 4.0 {
        didSet {
            updateGeometry()
        }
    }
    
    @IBInspectable public var trackSize: CGFloat = 50.0 {
        didSet {
            invalidateIntrinsicContentSize()
            updateGeometry()
        }
    }
    
    @IBInspectable public var trackThickness: CGFloat = -1.0 {
        didSet {
            updateGeometry()
        }
    }
    
    @IBInspectable public var trackPaddingTop: CGFloat = -1.0 {
        didSet {
            updateGeometry()
        }
    }
    
    @IBInspectable public var trackPaddingBottom: CGFloat = -1.0 {
        didSet {
            updateGeometry()
        }
    }
    
    @IBInspectable public var trackPaddingLeading: CGFloat = -1.0 {
        didSet {
            updateGeometry()
        }
    }
    
    @IBInspectable public var trackPaddingTrailing: CGFloat = -1.0 {
        didSet {
            updateGeometry()
        }
    }
    
    // MARK: - Track Color Inspectables
    @IBInspectable public var trackTintColor: UIColor? {
        didSet {
            setupTrackColor()
        }
    }
    
    @IBInspectable public var trackTintColorStart: UIColor? {
        didSet {
            setupTrackColor()
        }
    }
    
    @IBInspectable public var trackTintColorEnd: UIColor? {
        didSet {
            setupTrackColor()
        }
    }
    
    @IBInspectable public var trackColorOrientation: String? {
        didSet {
            setupTrackColor()
        }
    }
    
    @IBInspectable public var trackFillTintColor: UIColor? {
        didSet {
            setupFillColor()
        }
    }
    
    @IBInspectable public var trackFillTintColorStart: UIColor? {
        didSet {
            setupFillColor()
        }
    }
    
    @IBInspectable public var trackFillTintColorEnd: UIColor? {
        didSet {
            setupFillColor()
        }
    }
    
    @IBInspectable public var trackFillColorOrientation: String? {
        didSet {
            setupFillColor()
        }
    }
    
    @IBInspectable public var trackInnerShadowOpacity: Float = .zero {
        didSet {
            innerShadowView.isHidden = false
            innerShadowView.shadowOpacity = trackInnerShadowOpacity
        }
    }
    
    @IBInspectable public var trackInnerShadowRadius: CGFloat = .zero {
        didSet {
            innerShadowView.isHidden = false
            innerShadowView.shadowRadius = trackInnerShadowRadius
        }
    }
    
    @IBInspectable public var trackInnerShadowOffset: CGSize = .zero {
        didSet {
            innerShadowView.isHidden = false
            innerShadowView.shadowOffset = trackInnerShadowOffset
        }
    }
    
    @IBInspectable public var trackInnerShadowColor: UIColor? {
        didSet {
            innerShadowView.isHidden = false
            innerShadowView.shadowColor = trackInnerShadowColor ?? EDTSColor.black
        }
    }
    
    @IBInspectable public var trackShadowOpacity: Float = 0 {
        didSet {
            updateTrackShadow()
        }
    }
    
    @IBInspectable public var trackShadowRadius: CGFloat = 0 {
        didSet {
            updateTrackShadow()
        }
    }
    
    @IBInspectable public var trackShadowOffset: CGSize = .zero {
        didSet {
            updateTrackShadow()
        }
    }
    
    @IBInspectable public var trackShadowColor: UIColor? {
        didSet {
            updateTrackShadow()
        }
    }
    
    @IBInspectable public var isIntermittentState: Bool = false {
        didSet {
            guard isIntermittentState != oldValue else { return }
            setupIntermittentState()
        }
    }
    
    @IBInspectable public var intermittentAnimationType: String = "stretch" {
        didSet {
            guard oldValue.lowercased() != intermittentAnimationType.lowercased() else { return }
            guard isIntermittentState else { return }
            restartIntermittentAnimation()
        }
    }
    
    // MARK: - Private Variable
    private let fillAnimationDuration: CFTimeInterval = 1.0
    private let intermittentStretchRotationDuration: CFTimeInterval = 2.4
    private let intermittentSweepDuration: CFTimeInterval = 1.33
    
    private let intermittentFixedRotationDuration: CFTimeInterval = 1.0
    private let fixedSweepFraction: CGFloat = 0.25
    
    private let doubleArcSweepFraction: CGFloat = 0.75
    private let intermittentDoubleArcRotationDuration: CFTimeInterval = 1.4
    
    private let animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    
    private var resolvedIntermittentAnimationType: IntermittentAnimationType {
        let normalized = intermittentAnimationType
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        return IntermittentAnimationType(rawValue: normalized) ?? .stretch
    }
    
    private var resolvedThickness: CGFloat {
        trackThickness >= 0 ? trackThickness : 6
    }
    
    private var _value: CGFloat = 0.0
    
    private let trackLayer = CAShapeLayer()
    private let trackMaskShape = CAShapeLayer()
    private var trackGradientLayer: CAGradientLayer?
    
    private let fillLayer = CAShapeLayer()
    private let fillMaskShape = CAShapeLayer()
    private var fillGradientLayer: CAGradientLayer?
    
    private let rotationLayer = CALayer()
    private let doubleArcInnerLayer = CAShapeLayer()
    private let doubleArcInnerRotationLayer = CALayer()
    
    private let innerShadowView = InnerShadow()
    
    private var activeFillLayer: CAShapeLayer {
        fillGradientLayer != nil ? fillMaskShape : fillLayer
    }
    
    private var resolvedLineCap: CAShapeLayerLineCap {
        switch lineCapStyle
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() {
        case "butt":
            return .butt
        case "square":
            return .square
        case "round":
            return .round
        default:
            return .round
        }
    }
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateGeometry()
    }
    
    public override var intrinsicContentSize: CGSize {
        let top = max(trackPaddingTop, 0)
        let bottom = max(trackPaddingBottom, 0)
        let leading = max(trackPaddingLeading, 0)
        let trailing = max(trackPaddingTrailing, 0)
        
        return CGSize(
            width: trackSize + leading + trailing,
            height: trackSize + top + bottom
        )
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        trackLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)
        
        trackMaskShape.fillColor = UIColor.clear.cgColor
        trackMaskShape.strokeColor = UIColor.black.cgColor
        
        rotationLayer.frame = bounds
        layer.addSublayer(rotationLayer)
        
        fillLayer.fillColor = UIColor.clear.cgColor
        fillLayer.strokeEnd = 0
        rotationLayer.addSublayer(fillLayer)
        
        fillMaskShape.fillColor = UIColor.clear.cgColor
        fillMaskShape.strokeColor = UIColor.black.cgColor
        fillMaskShape.strokeEnd = 0
        
        doubleArcInnerRotationLayer.frame = bounds
        layer.addSublayer(doubleArcInnerRotationLayer)
        
        doubleArcInnerLayer.fillColor = UIColor.clear.cgColor
        doubleArcInnerLayer.strokeEnd = 0
        doubleArcInnerLayer.isHidden = true
        doubleArcInnerRotationLayer.addSublayer(doubleArcInnerLayer)
        
        innerShadowView.isUserInteractionEnabled = false
        innerShadowView.isHidden = true
        innerShadowView.backgroundColor = .clear
        addSubview(innerShadowView)
        
        setupTrackColor()
        setupFillColor()
        updateLineCap()
    }
    
    private func updateLineCap(force cap: CAShapeLayerLineCap? = nil) {
        let lineCap = cap ?? resolvedLineCap
        
        [
            trackLayer,
            trackMaskShape,
            fillLayer,
            fillMaskShape,
            doubleArcInnerLayer
        ].forEach {
            $0.lineCap = lineCap
        }
    }
    
    private func setTrackSize(_ size: CGFloat) {
        self.trackSize = size
    }
    
    private func updateTrackShadow() {
        let targetLayer: CALayer = trackGradientLayer ?? trackLayer
        
        targetLayer.shadowOpacity = trackShadowOpacity
        targetLayer.shadowRadius = trackShadowRadius
        targetLayer.shadowOffset = trackShadowOffset
        targetLayer.shadowColor = (trackShadowColor ?? UIColor.black).cgColor
        
        targetLayer.shadowPath = trackLayer.path
    }
    
    private var ringRect: CGRect {
        let insetTop = trackPaddingTop >= 0 ? trackPaddingTop : 0
        let insetBottom = trackPaddingBottom >= 0 ? trackPaddingBottom : 0
        let insetLeading = trackPaddingLeading >= 0 ? trackPaddingLeading : 0
        let insetTrailing = trackPaddingTrailing >= 0 ? trackPaddingTrailing : 0
        
        let insetBounds = bounds.inset(by: UIEdgeInsets(top: insetTop, left: insetLeading, bottom: insetBottom, right: insetTrailing))
        
        let available = min(insetBounds.width, insetBounds.height)
        let targetOuterDiameter: CGFloat = (trackSize > 0) ? min(trackSize, available) : available
        
        let pathDiameter = max(targetOuterDiameter - resolvedThickness, 0)
        
        return CGRect(
            x: insetBounds.midX - pathDiameter / 2,
            y: insetBounds.midY - pathDiameter / 2,
            width: pathDiameter,
            height: pathDiameter
        )
    }
    
    private func updateGeometry() {
        let thickness = resolvedThickness
        let rect = ringRect
        guard rect.width > 0, rect.height > 0 else { return }
        
        let radius = rect.width / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: -CGFloat.pi / 2 + 2 * CGFloat.pi,
            clockwise: true
        ).cgPath
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        [trackLayer, trackMaskShape, fillLayer, fillMaskShape].forEach {
            $0.frame = bounds
            $0.path = path
            $0.lineWidth = thickness
        }
        rotationLayer.frame = bounds
        rotationLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        rotationLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        trackGradientLayer?.frame = bounds
        fillGradientLayer?.frame = bounds
        
        CATransaction.commit()
        
        let doubleArcInnerRadius = radius - thickness - doubleArcGap
        if doubleArcInnerRadius > 0 {
            let doubleArcPath = UIBezierPath(
                arcCenter: center,
                radius: doubleArcInnerRadius,
                startAngle: -CGFloat.pi / 2,
                endAngle: -CGFloat.pi / 2 + 2 * CGFloat.pi,
                clockwise: true
            ).cgPath
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            doubleArcInnerLayer.frame = bounds
            doubleArcInnerLayer.path = doubleArcPath
            doubleArcInnerLayer.lineWidth = thickness
            doubleArcInnerRotationLayer.frame = bounds
            doubleArcInnerRotationLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
            doubleArcInnerRotationLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            CATransaction.commit()
        }
        
        innerShadowView.frame = bounds
        innerShadowView.cornerRadius = rect.width / 2
        
        let shadowMask = CAShapeLayer()
        shadowMask.frame = bounds
        shadowMask.path = path
        shadowMask.fillColor = UIColor.clear.cgColor
        shadowMask.strokeColor = UIColor.black.cgColor
        shadowMask.lineWidth = thickness
        innerShadowView.layer.mask = shadowMask
        
        updateTrackShadow()
    }
    
    private func setupTrackColor() {
        applyRingGradient(
            start: trackTintColorStart,
            end: trackTintColorEnd,
            solid: trackTintColor ?? UIColor(white: 0.9, alpha: 1),
            orientation: trackColorOrientation,
            solidLayer: trackLayer,
            maskShape: trackMaskShape,
            gradientLayer: &trackGradientLayer
        )
    }
    
    private func setupFillColor() {
        applyRingGradient(
            start: trackFillTintColorStart,
            end: trackFillTintColorEnd,
            solid: trackFillTintColor ?? .systemBlue,
            orientation: trackFillColorOrientation,
            solidLayer: fillLayer,
            maskShape: fillMaskShape,
            gradientLayer: &fillGradientLayer
        )
        
        doubleArcInnerLayer.strokeColor = (trackFillTintColor ?? .systemBlue).cgColor
    }
    
    private func applyRingGradient(
        start: UIColor?,
        end: UIColor?,
        solid: UIColor,
        orientation: String?,
        solidLayer: CAShapeLayer,
        maskShape: CAShapeLayer,
        gradientLayer: inout CAGradientLayer?
    ) {
        guard let superlayer = solidLayer.superlayer else { return }
        
        if start != nil || end != nil {
            solidLayer.isHidden = true
            
            let gradient = gradientLayer ?? CAGradientLayer()
            if gradientLayer == nil {
                superlayer.insertSublayer(gradient, above: solidLayer)
                gradientLayer = gradient
            }
            
            gradient.frame = bounds
            gradient.colors = [
                (start ?? .clear).cgColor,
                (end ?? .clear).cgColor
            ]
            
            let normalized = orientation?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            let resolvedOrientation = Orientation(rawValue: normalized ?? "horizontal") ?? .horizontal
            
            switch resolvedOrientation {
            case .horizontal:
                gradient.startPoint = CGPoint(x: 0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1, y: 0.5)
            case .vertical:
                gradient.startPoint = CGPoint(x: 0.5, y: 0)
                gradient.endPoint = CGPoint(x: 0.5, y: 1)
            }
            
            gradient.mask = maskShape
        } else {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = nil
            solidLayer.isHidden = false
            solidLayer.strokeColor = solid.cgColor
        }
    }
    
    private func calculateValue(animated: Bool = true) {
        guard maxValue > 0 else { return }
        
        let ratio = min(max(value / maxValue, 0), 1)
        setFill(to: ratio, animated: animated)
    }
    
    private func setFill(to ratio: CGFloat, animated: Bool) {
        guard !isIntermittentState else { return }
        
        let active = activeFillLayer
        let inactive = (active === fillLayer) ? fillMaskShape : fillLayer
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        inactive.strokeStart = 0
        inactive.strokeEnd = ratio
        active.strokeStart = 0
        if !animated { active.strokeEnd = ratio }
        CATransaction.commit()
        
        if ratio > 0 {
            updateLineCap()
        }
        
        guard animated else {
            if ratio == 0 {
                updateLineCap(force: .butt)
            }
            return
        }
        
        let currentValue = active.presentation()?.strokeEnd ?? active.strokeEnd
        
        active.removeAnimation(forKey: "strokeEndAnimation")
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        active.strokeEnd = currentValue
        CATransaction.commit()
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = currentValue
        animation.toValue = ratio
        animation.duration = fillAnimationDuration
        animation.timingFunction = animationTimingFunction
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        active.strokeEnd = ratio
        
        if ratio == 0 {
            CATransaction.begin()
            CATransaction.setCompletionBlock { [weak self, weak active, weak inactive] in
                guard let self, self.value == 0 else { return }
                active?.lineCap = .butt
                inactive?.lineCap = .butt
            }
            active.add(animation, forKey: "strokeEndAnimation")
            CATransaction.commit()
        } else {
            active.add(animation, forKey: "strokeEndAnimation")
        }
    }
    
    private func setupIntermittentState() {
        if isIntermittentState {
            startIntermittentAnimation()
        } else {
            stopIntermittentAnimation()
        }
    }
    
    private func restartIntermittentAnimation() {
        stopIntermittentAnimation()
        startIntermittentAnimation()
    }
    
    private func startIntermittentAnimation() {
        updateLineCap()
        activeFillLayer.removeAnimation(forKey: "strokeEndAnimation")
        
        switch resolvedIntermittentAnimationType {
        case .stretch:
            setTrackHidden(false)
            addRotationAnimation(duration: intermittentStretchRotationDuration, on: rotationLayer)
            animateStretchSweep()
        case .fixed:
            setTrackHidden(false)
            addRotationAnimation(duration: intermittentFixedRotationDuration, on: rotationLayer)
            applyFixedSweep()
        case .doubleArc:
            setTrackHidden(true)
            startDoubleArcAnimation()
        }
    }
    
    private func addRotationAnimation(duration: CFTimeInterval, clockwise: Bool = true, on targetLayer: CALayer) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = clockwise ? CGFloat.pi * 2 : -CGFloat.pi * 2
        rotation.duration = duration
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        targetLayer.add(rotation, forKey: "intermittentRotation")
    }
    
    private func stopIntermittentAnimation() {
        rotationLayer.removeAnimation(forKey: "intermittentRotation")
        doubleArcInnerRotationLayer.removeAnimation(forKey: "intermittentRotation")
        activeFillLayer.removeAnimation(forKey: "intermittentSweep")
        activeFillLayer.removeAnimation(forKey: "strokeEndAnimation")
        
        doubleArcInnerLayer.isHidden = true
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        doubleArcInnerLayer.strokeStart = 0
        doubleArcInnerLayer.strokeEnd = 0
        CATransaction.commit()
        
        setTrackHidden(false)
        updateLineCap()
        
        calculateValue(animated: false)
    }
    
    private func setTrackHidden(_ hidden: Bool) {
        trackLayer.isHidden = hidden
        trackGradientLayer?.isHidden = hidden
    }
    
    private func animateStretchSweep() {
        let headAnimation = CAKeyframeAnimation(keyPath: "strokeStart")
        headAnimation.values = [0, 0, 0.75, 1]
        headAnimation.keyTimes = [0, 0.25, 0.75, 1]
        
        let tailAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        tailAnimation.values = [0, 0.75, 1, 1]
        tailAnimation.keyTimes = [0, 0.25, 0.75, 1]
        
        let group = CAAnimationGroup()
        group.animations = [headAnimation, tailAnimation]
        group.duration = intermittentSweepDuration
        group.repeatCount = .infinity
        group.timingFunction = animationTimingFunction
        group.isRemovedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        activeFillLayer.strokeStart = 0
        activeFillLayer.strokeEnd = 0
        CATransaction.commit()
        
        activeFillLayer.add(group, forKey: "intermittentSweep")
    }
    
    private func applyFixedSweep() {
        activeFillLayer.removeAnimation(forKey: "intermittentSweep")
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        activeFillLayer.strokeStart = 0
        activeFillLayer.strokeEnd = fixedSweepFraction
        CATransaction.commit()
    }
    
    private func startDoubleArcAnimation() {
        activeFillLayer.removeAnimation(forKey: "intermittentSweep")
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        activeFillLayer.strokeStart = 0
        activeFillLayer.strokeEnd = doubleArcSweepFraction
        CATransaction.commit()
        addRotationAnimation(duration: intermittentDoubleArcRotationDuration, clockwise: true, on: rotationLayer)
        
        doubleArcInnerLayer.isHidden = false
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        doubleArcInnerLayer.strokeStart = 0
        doubleArcInnerLayer.strokeEnd = doubleArcSweepFraction
        CATransaction.commit()
        addRotationAnimation(duration: intermittentDoubleArcRotationDuration, clockwise: false, on: doubleArcInnerRotationLayer)
    }
}
