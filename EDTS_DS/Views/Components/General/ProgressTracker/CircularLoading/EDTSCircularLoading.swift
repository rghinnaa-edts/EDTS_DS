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
            setupLineCap()
        }
    }
    
    @IBInspectable public var doubleArcGap: CGFloat = 4.0 {
        didSet {
            setupRing()
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
    
    @IBInspectable public var trackSize: CGFloat = 50.0 {
        didSet {
            invalidateIntrinsicContentSize()
            setupRing()
        }
    }
    
    @IBInspectable public var trackThickness: CGFloat = -1.0 {
        didSet {
            setupRing()
        }
    }
    
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
    
    @IBInspectable public var trackPaddingTop: CGFloat = 0.0 {
        didSet {
            setupRing()
        }
    }
    
    @IBInspectable public var trackPaddingBottom: CGFloat = 0.0 {
        didSet {
            setupRing()
        }
    }
    
    @IBInspectable public var trackInnerShadowOpacity: Float = .zero {
        didSet {
            isInnerShadowEnabled = true
            innerShadowView.shadowOpacity = trackInnerShadowOpacity
            setupInnerShadowVisibility()
        }
    }
    
    @IBInspectable public var trackInnerShadowRadius: CGFloat = .zero {
        didSet {
            isInnerShadowEnabled = true
            innerShadowView.shadowRadius = trackInnerShadowRadius
            setupInnerShadowVisibility()
        }
    }
    
    @IBInspectable public var trackInnerShadowOffset: CGSize = .zero {
        didSet {
            isInnerShadowEnabled = true
            innerShadowView.shadowOffset = trackInnerShadowOffset
            setupInnerShadowVisibility()
        }
    }
    
    @IBInspectable public var trackInnerShadowColor: UIColor? {
        didSet {
            isInnerShadowEnabled = true
            innerShadowView.shadowColor = trackInnerShadowColor ?? EDTSColor.black
            setupInnerShadowVisibility()
        }
    }
    
    @IBInspectable public var trackShadowOpacity: Float = 0 {
        didSet {
            setupTrackShadow()
        }
    }
    
    @IBInspectable public var trackShadowRadius: CGFloat = 0 {
        didSet {
            setupTrackShadow()
        }
    }
    
    @IBInspectable public var trackShadowOffset: CGSize = .zero {
        didSet {
            setupTrackShadow()
        }
    }
    
    @IBInspectable public var trackShadowColor: UIColor? {
        didSet {
            setupTrackShadow()
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
    
    private var resolvedThickness: CGFloat {
        trackThickness >= 0 ? trackThickness : 6
    }
    
    private var resolvedIntermittentAnimationType: IntermittentAnimationType {
        let normalized = intermittentAnimationType
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        return IntermittentAnimationType(rawValue: normalized) ?? .stretch
    }
    
    private let fillAnimationDuration: CFTimeInterval = 1.0
    private let intermittentStretchRotationDuration: CFTimeInterval = 2.4
    private let intermittentSweepDuration: CFTimeInterval = 1.33
    private let intermittentFixedRotationDuration: CFTimeInterval = 1.0
    private let fixedSweepFraction: CGFloat = 0.25
    private let intermittentDoubleArcRotationDuration: CFTimeInterval = 1.4
    private let doubleArcSweepFraction: CGFloat = 0.75
    private let animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    
    private var _value: CGFloat = 0.0
    
    private let trackLayer = CAShapeLayer()
    private let trackMaskShape = CAShapeLayer()
    private var trackGradientLayer: CAGradientLayer?
    
    private let fillLayer = CAShapeLayer()
    private let fillMaskShape = CAShapeLayer()
    private var fillGradientLayer: CAGradientLayer?
    private var activeFillLayer: CAShapeLayer {
        fillGradientLayer != nil ? fillMaskShape : fillLayer
    }
    
    private let rotationLayer = CALayer()
    private let doubleArcInnerLayer = CAShapeLayer()
    private let doubleArcInnerRotationLayer = CALayer()
    private let doubleArcInnerMaskShape = CAShapeLayer()
    private var doubleArcInnerGradientLayer: CAGradientLayer?
    private var activeDoubleArcLayer: CAShapeLayer {
        doubleArcInnerGradientLayer != nil ? doubleArcInnerMaskShape : doubleArcInnerLayer
    }
    
    private var isDoubleArcActive: Bool = false
    private var isInnerShadowEnabled: Bool = false
    
    private let innerShadowView = InnerShadow()
    private let innerCircleShadowLayer = CAShapeLayer()
    private let innerCircleShadowMaskLayer = CAShapeLayer()
    
    // MARK: - Initializers
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
        
        setupRing()
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: trackSize, height: trackSize)
    }
    
    // MARK: - Setup & Styling
    private func setupUI() {
        //Setup Track
        backgroundColor = .clear
        
        trackLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)
        
        trackMaskShape.fillColor = UIColor.clear.cgColor
        trackMaskShape.strokeColor = EDTSColor.black.cgColor
        
        rotationLayer.frame = bounds
        layer.addSublayer(rotationLayer)
        
        //Setup Fill
        fillLayer.fillColor = UIColor.clear.cgColor
        fillLayer.strokeEnd = 0
        rotationLayer.addSublayer(fillLayer)
        
        fillMaskShape.fillColor = UIColor.clear.cgColor
        fillMaskShape.strokeColor = EDTSColor.black.cgColor
        fillMaskShape.strokeEnd = 0
        
        //Setup Double Arc
        doubleArcInnerRotationLayer.frame = bounds
        layer.addSublayer(doubleArcInnerRotationLayer)
        
        doubleArcInnerLayer.fillColor = UIColor.clear.cgColor
        doubleArcInnerLayer.strokeEnd = 0
        doubleArcInnerMaskShape.fillColor = UIColor.clear.cgColor
        doubleArcInnerMaskShape.strokeColor = EDTSColor.black.cgColor
        doubleArcInnerMaskShape.strokeEnd = 0
        doubleArcInnerLayer.isHidden = true
        doubleArcInnerRotationLayer.addSublayer(doubleArcInnerLayer)
        
        //Setup Track Inner Shadow
        innerShadowView.isUserInteractionEnabled = false
        innerShadowView.isHidden = true
        innerShadowView.backgroundColor = .clear
        addSubview(innerShadowView)
        layer.insertSublayer(innerShadowView.layer, above: trackLayer)
        
        innerCircleShadowLayer.fillColor = UIColor.clear.cgColor
        innerCircleShadowLayer.isHidden = true
        innerCircleShadowMaskLayer.fillRule = .evenOdd
        innerCircleShadowMaskLayer.fillColor = UIColor.black.cgColor
        innerCircleShadowLayer.mask = innerCircleShadowMaskLayer
        layer.insertSublayer(innerCircleShadowLayer, above: trackLayer)
        
        trackInnerShadowOpacity = 0.10
        trackInnerShadowOffset = CGSize(width: 0, height: 0)
        trackInnerShadowColor = EDTSColor.black
        trackInnerShadowRadius = 2
        
        setupTrackColor()
        setupFillColor()
        setupLineCap()
        setupDefaultFillGradient()
    }
    
    // MARK: - Setup Track
    private func setupTrackColor() {
        setupRingGradient(
            start: trackTintColorStart,
            end: trackTintColorEnd,
            solid: trackTintColor ?? EDTSColor.grey20,
            orientation: trackColorOrientation,
            solidLayer: trackLayer,
            maskShape: trackMaskShape,
            gradientLayer: &trackGradientLayer
        )
    }
    
    private func setupTrackShadow() {
        let targetLayer: CALayer = trackGradientLayer ?? trackLayer
        
        targetLayer.shadowOpacity = trackShadowOpacity
        targetLayer.shadowRadius = trackShadowRadius
        targetLayer.shadowOffset = trackShadowOffset
        targetLayer.shadowColor = (trackShadowColor ?? EDTSColor.black).cgColor
        
        targetLayer.shadowPath = setupTrackShadowPath()
    }
    
    private func setupTrackShadowPath() -> CGPath? {
        guard let centerlinePath = trackLayer.path else { return nil }
        
        let lineCap: CGLineCap
        
        switch resolvedLineCap {
        case .butt:
            lineCap = .butt
        case .square:
            lineCap = .square
        default:
            lineCap = .round
        }
        
        return centerlinePath.copy(
            strokingWithWidth: resolvedThickness,
            lineCap: lineCap,
            lineJoin: .round,
            miterLimit: 0
        )
    }
    
    private func setupTrackVisibility(_ hidden: Bool) {
        trackLayer.isHidden = hidden
        trackGradientLayer?.isHidden = hidden
    }
    
    // MARK: - Setup Fill
    private func setupDefaultFillGradient(){
        let fillGradient = CAGradientLayer()
        fillGradient.colors = [
            EDTSColor.skyblueLeading.cgColor,
            EDTSColor.skyblueTrailing.cgColor
        ]
        fillGradient.startPoint = CGPoint(x: 0, y: 0.5)
        fillGradient.endPoint = CGPoint(x: 1, y: 0.5)
        fillGradient.mask = fillMaskShape
        rotationLayer.insertSublayer(fillGradient, above: fillLayer)
        fillGradientLayer = fillGradient
        
        let doubleArcGradient = CAGradientLayer()
        doubleArcGradient.colors = [
            EDTSColor.skyblueLeading.cgColor,
            EDTSColor.skyblueTrailing.cgColor
        ]
        doubleArcGradient.startPoint = CGPoint(x: 0, y: 0.5)
        doubleArcGradient.endPoint = CGPoint(x: 1, y: 0.5)
        doubleArcGradient.mask = doubleArcInnerMaskShape
        doubleArcInnerRotationLayer.insertSublayer(
            doubleArcGradient,
            above: doubleArcInnerLayer
        )
        doubleArcInnerGradientLayer = doubleArcGradient
    }
    
    private func setupFillColor() {
        let start = trackFillTintColorStart
        let end = trackFillTintColorEnd
        let solid = trackFillTintColor ?? .clear
        let orientation = trackFillColorOrientation
        
        setupRingGradient(
            start: start,
            end: end,
            solid: solid,
            orientation: orientation,
            solidLayer: fillLayer,
            maskShape: fillMaskShape,
            gradientLayer: &fillGradientLayer
        )
        
        setupRingGradient(
            start: start,
            end: end,
            solid: solid,
            orientation: orientation,
            solidLayer: doubleArcInnerLayer,
            maskShape: doubleArcInnerMaskShape,
            gradientLayer: &doubleArcInnerGradientLayer
        )
        
        setupDoubleArcVisibility()
    }
    
    private func setupLineCap(force cap: CAShapeLayerLineCap? = nil) {
        let lineCap = cap ?? resolvedLineCap
        
        [trackLayer, trackMaskShape, fillLayer, fillMaskShape, doubleArcInnerLayer, doubleArcInnerMaskShape].forEach {
            $0.lineCap = lineCap
        }
    }

    private func setupDoubleArcVisibility() {
        if doubleArcInnerGradientLayer != nil {
            doubleArcInnerLayer.isHidden = true
            doubleArcInnerGradientLayer?.isHidden = !isDoubleArcActive
        } else {
            doubleArcInnerLayer.isHidden = !isDoubleArcActive
        }
        setupInnerShadowVisibility()
    }
    
    // MARK: - Setup Ring
    private func setupRingGradient(
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
            
            let minX = ringGradientRect.minX / bounds.width
            let maxX = ringGradientRect.maxX / bounds.width
            let minY = ringGradientRect.minY / bounds.height
            let maxY = ringGradientRect.maxY / bounds.height

            switch resolvedOrientation {
            case .horizontal:
                gradient.startPoint = CGPoint(x: minX, y: 0.5)
                gradient.endPoint = CGPoint(x: maxX, y: 0.5)
            case .vertical:
                gradient.startPoint = CGPoint(x: 0.5, y: minY)
                gradient.endPoint = CGPoint(x: 0.5, y: maxY)
            case .diagonalUp:
                let (start, end) = gradientPoints(ringGradientRect, angleDegrees: 10, in: bounds)
                gradient.startPoint = start
                gradient.endPoint = end
            case .diagonalDown:
                let (start, end) = gradientPoints(ringGradientRect, angleDegrees: 170, in: bounds)
                gradient.startPoint = end
                gradient.endPoint = start
            }
            
            gradient.mask = maskShape
        } else {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = nil
            solidLayer.isHidden = false
            solidLayer.strokeColor = solid.cgColor
        }
    }
    
    private func gradientPoints(_ rect: CGRect, angleDegrees: CGFloat, in bounds: CGRect) -> (CGPoint, CGPoint) {
        let radians = angleDegrees * .pi / 180
        let dx = cos(radians)
        let dy = -sin(radians)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let halfWidth = rect.width / 2
        let halfHeight = rect.height / 2
        
        
        let scale: CGFloat
        if dx == 0 {
            scale = halfHeight / abs(dy)
        } else if dy == 0 {
            scale = halfWidth / abs(dx)
        } else {
            scale = min(halfWidth / abs(dx), halfHeight / abs(dy))
        }
        
        let endPoint = CGPoint(x: center.x + dx * scale, y: center.y + dy * scale)
        let startPoint = CGPoint(x: center.x - dx * scale, y: center.y - dy * scale)
        
        let start = CGPoint(x: startPoint.x / bounds.width, y: startPoint.y / bounds.height)
        let end = CGPoint(x: endPoint.x / bounds.width, y: endPoint.y / bounds.height)
        
        return (start, end)
    }
    
    private var ringGradientRect: CGRect {
        let rect = drawRing
        let inset = -resolvedThickness / 2
        return rect.insetBy(dx: inset, dy: inset)
    }
    
    private var drawRing: CGRect {
        let insetBounds = bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
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
    
    private func drawRingShadowPath(
        center: CGPoint,
        outerRadius: CGFloat,
        innerRadius: CGFloat
    ) -> CGPath {
        let path = CGMutablePath()
        
        path.addEllipse(
            in: CGRect(
                x: center.x - outerRadius,
                y: center.y - outerRadius,
                width: outerRadius * 2,
                height: outerRadius * 2
            )
        )
        
        path.addEllipse(
            in: CGRect(
                x: center.x - innerRadius,
                y: center.y - innerRadius,
                width: innerRadius * 2,
                height: innerRadius * 2
            )
        )
        
        return path
    }
    
    private func setupRing() {
        let thickness = resolvedThickness
        let rect = drawRing
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
        
        let outerEdge = radius + thickness / 2
        let innerEdge = radius - thickness / 2
        let fillOuterEdge = outerEdge - trackPaddingTop
        let fillInnerEdge = innerEdge + trackPaddingBottom
        let fillThickness = max(fillOuterEdge - fillInnerEdge, 0)
        let fillRadius = (fillOuterEdge + fillInnerEdge) / 2
        
        let fillPath = UIBezierPath(
            arcCenter: center,
            radius: fillRadius,
            startAngle: -CGFloat.pi / 2,
            endAngle: -CGFloat.pi / 2 + 2 * CGFloat.pi,
            clockwise: true
        ).cgPath
        
        [trackLayer, trackMaskShape].forEach {
            $0.frame = bounds
            $0.path = path
            $0.lineWidth = thickness
        }
        
        [fillLayer, fillMaskShape].forEach {
            $0.frame = bounds
            $0.path = fillPath
            $0.lineWidth = fillThickness
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
            [doubleArcInnerLayer, doubleArcInnerMaskShape].forEach {
                $0.frame = bounds
                $0.path = doubleArcPath
                $0.lineWidth = fillThickness
            }
            doubleArcInnerGradientLayer?.frame = bounds
            doubleArcInnerRotationLayer.frame = bounds
            doubleArcInnerRotationLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
            doubleArcInnerRotationLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            CATransaction.commit()
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let shadowPath = drawRingShadowPath(
            center: center,
            outerRadius: outerEdge,
            innerRadius: innerEdge
        )
        
        let shadowDiameter = outerEdge * 2
        innerShadowView.frame = CGRect(
            x: center.x - outerEdge,
            y: center.y - outerEdge,
            width: shadowDiameter,
            height: shadowDiameter
        )
        innerShadowView.cornerRadius = outerEdge
        
        let innerCirclePath = UIBezierPath(
            arcCenter: center,
            radius: innerEdge,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        ).cgPath
        innerCircleShadowLayer.frame = bounds
        innerCircleShadowLayer.path = innerCirclePath
        innerCircleShadowLayer.shadowPath = innerCirclePath
        
        innerCircleShadowMaskLayer.frame = bounds
        innerCircleShadowMaskLayer.path = shadowPath
        CATransaction.commit()
        
        setupTrackShadow()
        setupInnerCircleInnerShadow()
    }
    
    // MARK: - Setup Inner Shadow
    private func setupInnerCircleInnerShadow() {
        innerCircleShadowLayer.shadowOpacity = trackInnerShadowOpacity
        innerCircleShadowLayer.shadowRadius = trackInnerShadowRadius
        innerCircleShadowLayer.shadowOffset = trackInnerShadowOffset
        innerCircleShadowLayer.shadowColor = (trackInnerShadowColor ?? EDTSColor.black).cgColor
    }
    
    private func setupInnerShadowVisibility() {
        let shouldHide = !isInnerShadowEnabled || isDoubleArcActive
        innerShadowView.isHidden = shouldHide
        innerCircleShadowLayer.isHidden = shouldHide
    }
    
    // MARK: - Setup Progress
    private func calculateValue(animated: Bool = true) {
        guard maxValue > 0 else { return }
        
        let ratio = min(max(value / maxValue, 0), 1)
        setupProgress(to: ratio, animated: animated)
    }
    
    private func setupProgress(to ratio: CGFloat, animated: Bool) {
        guard !isIntermittentState else { return }
        
        let active = activeFillLayer
        let inactive = (active === fillLayer) ? fillMaskShape : fillLayer
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        inactive.strokeStart = 0
        inactive.strokeEnd = ratio
        active.strokeStart = 0
        
        if !animated {
            active.strokeEnd = ratio
        }
        
        CATransaction.commit()
        
        if ratio > 0 {
            setupLineCap()
        }
        
        guard animated else {
            if ratio == 0 {
                setupLineCap(force: .butt)
            }
            return
        }
        
        animateFill(
            on: active,
            to: ratio,
            duration: fillAnimationDuration,
            timingFunction: animationTimingFunction
        )
    }
    
    // MARK: - Animation
    private func animateFill(
        on layer: CAShapeLayer,
        to value: CGFloat,
        duration: CFTimeInterval,
        timingFunction: CAMediaTimingFunction?
    ) {
        let currentValue = layer.presentation()?.strokeEnd ?? layer.strokeEnd
        
        layer.removeAnimation(forKey: "strokeEndAnimation")
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.strokeEnd = currentValue
        CATransaction.commit()
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = currentValue
        animation.toValue = value
        animation.duration = duration
        animation.timingFunction = timingFunction
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.strokeEnd = value
        CATransaction.commit()
        
        if value == 0 {
            CATransaction.setCompletionBlock { [weak self, weak layer] in
                guard let self, self.value == 0 else { return }
                layer?.lineCap = .butt
            }
            
            layer.add(animation, forKey: "strokeEndAnimation")
            CATransaction.commit()
        } else {
            layer.add(animation, forKey: "strokeEndAnimation")
        }
    }
    
    private func setupIntermittentState() {
        if isIntermittentState {
            startIntermittentAnimation()
        } else {
            stopIntermittentAnimation()
        }
    }
    
    private func startIntermittentAnimation() {
        setupLineCap()
        activeFillLayer.removeAnimation(forKey: "strokeEndAnimation")
        
        switch resolvedIntermittentAnimationType {
        case .stretch:
            setupTrackVisibility(false)
            animateIntermittentRotation(duration: intermittentStretchRotationDuration, on: rotationLayer)
            animateStretch()
        case .fixed:
            setupTrackVisibility(false)
            animateIntermittentRotation(duration: intermittentFixedRotationDuration, on: rotationLayer)
            animateFixed()
        case .doubleArc:
            setupTrackVisibility(true)
            animateDoubleArc()
        }
    }
    
    private func restartIntermittentAnimation() {
        stopIntermittentAnimation()
        startIntermittentAnimation()
    }
    
    private func stopIntermittentAnimation() {
        rotationLayer.removeAnimation(forKey: "intermittentRotation")
        doubleArcInnerRotationLayer.removeAnimation(forKey: "intermittentRotation")
        activeFillLayer.removeAnimation(forKey: "intermittentSweep")
        activeFillLayer.removeAnimation(forKey: "strokeEndAnimation")
        
        isDoubleArcActive = false
        setupDoubleArcVisibility()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        doubleArcInnerLayer.strokeStart = 0
        doubleArcInnerLayer.strokeEnd = 0
        doubleArcInnerMaskShape.strokeStart = 0
        doubleArcInnerMaskShape.strokeEnd = 0
        CATransaction.commit()
        
        setupTrackVisibility(false)
        setupLineCap()
        
        calculateValue(animated: false)
    }
    
    private func animateIntermittentRotation(duration: CFTimeInterval, clockwise: Bool = true, on targetLayer: CALayer) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = clockwise ? CGFloat.pi * 2 : -CGFloat.pi * 2
        rotation.duration = duration
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        targetLayer.add(rotation, forKey: "intermittentRotation")
    }
    
    private func animateStretch() {
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
    
    private func animateFixed() {
        activeFillLayer.removeAnimation(forKey: "intermittentSweep")
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        activeFillLayer.strokeStart = 0
        activeFillLayer.strokeEnd = fixedSweepFraction
        CATransaction.commit()
    }
    
    private func animateDoubleArc() {
        activeFillLayer.removeAnimation(forKey: "intermittentSweep")
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        activeFillLayer.strokeStart = 0
        activeFillLayer.strokeEnd = doubleArcSweepFraction
        CATransaction.commit()
        animateIntermittentRotation(duration: intermittentDoubleArcRotationDuration, clockwise: true, on: rotationLayer)
        
        isDoubleArcActive = true
        setupDoubleArcVisibility()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        doubleArcInnerLayer.strokeStart = 0
        doubleArcInnerLayer.strokeEnd = doubleArcSweepFraction
        doubleArcInnerMaskShape.strokeStart = 0
        doubleArcInnerMaskShape.strokeEnd = doubleArcSweepFraction
        CATransaction.commit()
        
        animateIntermittentRotation(duration: intermittentDoubleArcRotationDuration, clockwise: false, on: doubleArcInnerRotationLayer)
    }
}
