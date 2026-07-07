//
//
//  EDTSProgressTracker.swift
//  EDTS_DS
//
//  Created by Yovita Handayiani on 02/06/26.
//

import UIKit

@IBDesignable
public class EDTSProgressTracker: UIView {
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var trackView: UIView!
    @IBOutlet weak var fullTrackView: UIView!
    @IBOutlet weak var fillView: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var innerShadowView: InnerShadowView!
    
    @IBOutlet weak var topPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingPaddingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topFullTrackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomFullTrackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingFullTrackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingFullTrackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topFillViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomFillViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingFillViewConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var indicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var badgeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgeHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fillWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Poinku Inner Shadow Outlets
    @IBOutlet weak var innerShadowView1: InnerShadowView!
    @IBOutlet weak var innerShadowView2: InnerShadowView!
    @IBOutlet weak var innerShadowViewContainer: UIView!
    
    // MARK: - Inspectables
    @IBInspectable public var fillTintColor: UIColor?{
        didSet{
            setupFillBgColor()
        }
    }
    
    @IBInspectable public var fillTintColorStart: UIColor?{
        didSet{
            setupFillBgColor()
        }
    }
    
    @IBInspectable public var fillTintColorEnd: UIColor?{
        didSet{
            setupFillBgColor()
        }
    }
    
    @IBInspectable public var fillColorOrientation: String?{
        didSet {
            setupFillBgColor()
        }
    }
    
    @IBInspectable public var fullTrackTintColor: UIColor?{
        didSet{
            setupFullTrackBgColor()
        }
    }
    
    @IBInspectable public var fullTrackTintColorStart: UIColor?{
        didSet{
            setupFullTrackBgColor()
        }
    }
    
    @IBInspectable public var fullTrackTintColorEnd: UIColor?{
        didSet{
            setupFullTrackBgColor()
        }
    }
    
    @IBInspectable public var fullTrackColorOrientation: String?{
        didSet {
            setupFullTrackBgColor()
        }
    }
    
    @IBInspectable public var fillPaddingTop: CGFloat = -1.0 {
        didSet {
            setupFillPadding()
        }
    }
    
    @IBInspectable public var fillPaddingBottom: CGFloat = -1.0 {
        didSet {
            setupFillPadding()
        }
    }
    
    @IBInspectable public var fillPaddingLeading: CGFloat = -1.0 {
        didSet {
            setupFillPadding()
        }
    }
    
    @IBInspectable public var fillPaddingTrailing: CGFloat = -1.0 {
        didSet {
            setupFillPadding()
        }
    }
    
    @IBInspectable public var trackHeight: CGFloat = -1.0 {
        didSet {
            setupTrackConstraint()
            invalidateIntrinsicContentSize()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable public var value: CGFloat = 0.0 {
        didSet {
            if value > limitValue {
                value = limitValue
                calculateValue()
                return
            }

            calculateValue()
        }
    }
    
    @IBInspectable public var maxValue: CGFloat = 100.0
//    {
//        didSet{
//            calculateValue()
//        }
//    }
    
    @IBInspectable public var limitValue: CGFloat = 100.0
//    {
//        didSet{
//            calculateValue()
//        }
//    }
    
    @IBInspectable public var indicatorTintColor: UIColor?{
        didSet{
            setupIndicatorBgColor()
        }
    }
    
    @IBInspectable public var indicatorTintColorStart: UIColor?{
        didSet{
            setupIndicatorBgColor()
        }
    }
    
    @IBInspectable public var indicatorTintColorEnd: UIColor?{
        didSet{
            setupIndicatorBgColor()
        }
    }
    
    @IBInspectable public var indicatorColorOrientation: String?{
        didSet {
            setupIndicatorBgColor()
        }
    }
    
    @IBInspectable public var indicatorSize: CGFloat = -1.0{
        didSet {
            setupIndicatorConstraint()
        }
    }
    
    @IBInspectable public var indicatorCornerRadius: CGFloat = -1.0 {
        didSet {
            setupIndicatorCornerRadius()
        }
    }
    
    @IBInspectable public var badgeLabel: String?{
        didSet{
            lblBadge.attributedText = nil
            lblBadge.text = badgeLabel
            setupBadge()
            setupBadgeConstraint()
        }
    }
    
    public var badgeLabelAttributed: NSAttributedString? {
        didSet {
            lblBadge.text = nil
            lblBadge.attributedText = badgeLabelAttributed
            setupBadge()
            setupBadgeConstraint()
        }
    }
    
    @IBInspectable public var badgeLabelColor: UIColor?{
        didSet{
            lblBadge.textColor = badgeLabelColor
        }
    }
    
    @IBInspectable public var badgeFontName: String = "" {
        didSet {
            setupFont()
        }
    }
    
    @IBInspectable public var badgeFontSize: CGFloat = CGFloat.zero{
        didSet {
            setupFont()
        }
    }
    
    @IBInspectable public var badgeFontWeight: String?{
        didSet {
            setupFont()
        }
    }
    
    @IBInspectable public var badgeTintColor: UIColor?{
        didSet{
            setupBadgeBgColor()
        }
    }
    
    @IBInspectable public var badgeTintColorStart: UIColor?{
        didSet{
            setupBadgeBgColor()
        }
    }
    
    @IBInspectable public var badgeTintColorEnd: UIColor?{
        didSet{
            setupBadgeBgColor()
        }
    }
    
    @IBInspectable public var badgeColorOrientation: String?{
        didSet {
            setupBadgeBgColor()
        }
    }
    
    @IBInspectable public var badgeSize: CGFloat = CGFloat.zero{
        didSet {
            setupBadgeConstraint()
        }
    }
    
    @IBInspectable public var badgeCornerRadius: CGFloat = -1.0 {
        didSet {
            setupBadgeCornerRadius()
        }
    }
    
    @IBInspectable public var trackTintColor: UIColor?{
        didSet{
            setupTrackBgColor()
        }
    }
    
    @IBInspectable public var trackTintColorStart: UIColor?{
        didSet {
            setupTrackBgColor()
        }
    }
    
    @IBInspectable public var trackTintColorEnd: UIColor?{
        didSet {
            setupTrackBgColor()
        }
    }
    
    @IBInspectable public var trackColorOrientation: String?{
        didSet {
            setupTrackBgColor()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = -1.0 {
        didSet {
            setupProgressBarCornerRadius()
        }
    }
    
//    @IBInspectable public var borderWidth: CGFloat = CGFloat.zero{
//        didSet{
//            trackView.layer.borderWidth = borderWidth
//        }
//    }
//    
//    @IBInspectable public var borderColor: UIColor?{
//        didSet{
//            trackView.layer.borderColor = borderColor?.cgColor
//        }
//    }
    
    @IBInspectable public var trackInnerShadowOpacity: Float = Float.zero {
        didSet {
            innerShadowViewContainer.isHidden = true
            innerShadowView.shadowOpacity = trackInnerShadowOpacity
        }
    }
    
    @IBInspectable public var trackInnerShadowRadius: CGFloat = CGFloat.zero {
        didSet {
            innerShadowViewContainer.isHidden = true
            innerShadowView.shadowRadius = trackInnerShadowRadius
        }
    }
    
    @IBInspectable public var trackInnerShadowOffset: CGSize = CGSize.zero {
        didSet {
            innerShadowViewContainer.isHidden = true
            innerShadowView.shadowOffset = trackInnerShadowOffset
        }
    }
    
    @IBInspectable public var trackInnerShadowColor: UIColor?{
        didSet {
            innerShadowViewContainer.isHidden = true
            innerShadowView.shadowColor = trackInnerShadowColor ?? EDTSColor.black
        }
    }
    
    @IBInspectable public var paddingTop: CGFloat = -1.0 {
        didSet {
            setupProgressBarConstraint()
        }
    }
    
    @IBInspectable public var paddingBottom: CGFloat = -1.0 {
        didSet {
            setupProgressBarConstraint()
        }
    }
    
    @IBInspectable public var paddingLeading: CGFloat = -1.0 {
        didSet {
            setupProgressBarConstraint()
        }
    }
    
    @IBInspectable public var paddingTrailing: CGFloat = -1.0 {
        didSet {
            setupProgressBarConstraint()
        }
    }
    
    @IBInspectable public var isHasIndicator: Bool = false {
        didSet {
            setupIndicator()
        }
    }
    
    @IBInspectable public var isHasBadge: Bool = false {
        didSet {
            setupBadge()
        }
    }
    
    // MARK: - Private Variable
    private var lapCount: Int = 0
//    private var cycleRatio: CGFloat = 0.0
    private var trackGradientLayer: CAGradientLayer?
    private var fillGradientLayer: CAGradientLayer?
    private var fullTrackGradientLayer: CAGradientLayer?
    private var indicatorGradientLayer: CAGradientLayer?
    private var badgeGradientLayer: CAGradientLayer?
    
    private var lastProcessedValue: CGFloat = 0.0
    private var wasAtMaxValue: Bool = false
//    private var lastDisplayedLaps: Int = 0
    private var isIndicatorVisible: Bool = false
    private var indicatorAnimationID: UUID = UUID()
    private var animationQueue: [() -> Void] = []
    private var isAnimating: Bool = false
    
    private var debounceTimer: Timer?
    private var pendingValue: CGFloat? = nil
    
    private var receivedMultipleUpdates = false
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        trackView.applyCircular()
        innerShadowView.cornerRadius = trackView.layer.cornerRadius
        innerShadowView1.cornerRadius = trackView.layer.cornerRadius
        innerShadowView2.cornerRadius = trackView.layer.cornerRadius
        innerShadowViewContainer.layer.cornerRadius = trackView.layer.cornerRadius
        fullTrackView.applyCircular()
        fillView.layer.cornerRadius = fullTrackView.layer.cornerRadius
        indicatorView.applyCircular()
        badgeView.applyCircular()
        
        fillGradientLayer?.frame = fillView.bounds
        fillGradientLayer?.cornerRadius = trackView.frame.height / 2.0
        
        fullTrackGradientLayer?.frame = fullTrackView.bounds
        fullTrackGradientLayer?.cornerRadius = fullTrackView.layer.cornerRadius
        
        indicatorGradientLayer?.frame = indicatorView.bounds
        indicatorGradientLayer?.cornerRadius = indicatorView.layer.cornerRadius
        
        badgeGradientLayer?.frame = badgeView.bounds
        badgeGradientLayer?.cornerRadius = badgeView.layer.cornerRadius
        
        trackGradientLayer?.frame = trackView.bounds
        trackGradientLayer?.cornerRadius = trackView.layer.cornerRadius
    }
    
    override public var intrinsicContentSize: CGSize {
        let trackWidth = trackView.frame.width
        let badgeHeight = badgeSize
        let indicatorHeight = indicatorSize
//        trackHeight
        let height = isHasBadge ? badgeHeight : indicatorHeight
        print("height: \(height)")
        print("badgeSize: \(badgeSize)")
        print("indicatorSize: \(indicatorSize)")

        return CGSize(width: trackWidth, height: height)
    }
    
    // MARK: - Setup & Styling
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSProgressTracker", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        
        setupUI()
    }
    
    private func setupUI() {
        setupDefaultStyle()
        setupFillBgColor()
        setupFullTrackBgColor()
        setupFillPadding()
        setupTrackConstraint()
        
        setupIndicator()
        setupIndicatorBgColor()
        setupIndicatorConstraint()
        setupIndicatorCornerRadius()
        
        setupBadge()
        setupFont()
        setupBadgeBgColor()
        
        setupBadgeConstraint()
        setupBadgeCornerRadius()
        setupTrackBgColor()
        setupProgressBarCornerRadius()
        setupProgressBarConstraint()
    }
    
    private func setupDefaultStyle(){
        if EDTSColor.theme == .klikIDM {
            fillTintColorStart = EDTSColor.skyblueLeading
            fillTintColorEnd = EDTSColor.skyblueTrailing
            fillColorOrientation = "horizontal"
            fillPaddingTop = 1
            fillPaddingBottom = 1
            fillPaddingLeading = 1
            fillPaddingTrailing = 1
            fullTrackTintColor = EDTSColor.blue30
            indicatorTintColorStart = EDTSColor.skyblueLeading
            indicatorTintColorEnd = EDTSColor.skyblueTrailing
            indicatorColorOrientation = "horizontal"
            indicatorSize = 8
            badgeLabelColor = EDTSColor.white
            badgeFontSize = 8
            badgeFontWeight = "bold"
            badgeTintColorStart = EDTSColor.skyblueLeading
            badgeTintColorEnd = EDTSColor.skyblueTrailing
            badgeColorOrientation = "horizontal"
            badgeSize = 16
            trackTintColor = EDTSColor.grey20
//            borderWidth = 0
            paddingTop = 5
            paddingBottom = 5
            isHasIndicator = true
            isHasBadge = true
            
            innerShadowView.isHidden = false
            innerShadowView.shadowOpacity = 0.10
            innerShadowView.shadowOffset = CGSize(width: 0, height: 0)
            innerShadowView.shadowColor = EDTSColor.black
            innerShadowView.shadowRadius = 2
            innerShadowViewContainer.isHidden = true
        } else {
            fillTintColorStart = EDTSColor.skyblueLeading
            fillTintColorEnd = EDTSColor.skyblueTrailing
            fillPaddingTop = 0
            fillPaddingBottom = 0
            fillPaddingLeading = 0
            fillPaddingTrailing = 0
            if limitValue > self.maxValue {
                fullTrackTintColor = EDTSColor.blue10
            } else {
                fullTrackTintColor = .clear
            }
            indicatorSize = 0
            badgeLabelColor = EDTSColor.white
            badgeFontSize = 8
            badgeFontWeight = "bold"
            badgeTintColorStart = EDTSColor.skyblueLeading
            badgeTintColorEnd = EDTSColor.skyblueTrailing
            badgeColorOrientation = "horizontal"
            badgeSize = 16
            trackTintColor = EDTSColor.white
//            borderWidth = 0
            paddingTop = 0
            paddingBottom = 0
            isHasIndicator = false
            isHasBadge = false
            
            innerShadowView.isHidden = true
            innerShadowViewContainer.isHidden = false
            innerShadowView1.shadowOpacity = 0.08
            innerShadowView1.shadowOffset = CGSize(width: 0, height: 1)
            innerShadowView1.shadowColor = EDTSColor.black
            innerShadowView1.shadowRadius = 2
            
            innerShadowView2.shadowOpacity = 0.10
            innerShadowView2.shadowOffset = CGSize(width: 0, height: -4)
            innerShadowView2.shadowColor = EDTSColor.black
            innerShadowView2.shadowRadius = 2
        }
        
//        limitValue = maxValue
        let minWidth: CGFloat = isHasIndicator ? indicatorSize + 2 : 0
        fillWidthConstraint.constant = minWidth
    }
    
    private func setupFillBgColor() {
        if (fillTintColorStart != nil || fillTintColorEnd != nil) {
            if fillGradientLayer == nil {
                let gradient = CAGradientLayer()
                fillView.layer.insertSublayer(gradient, at: 0)
                fillGradientLayer = gradient
            }
            
            fillGradientLayer?.frame = fillView.bounds
            fillGradientLayer?.cornerRadius = fullTrackView.layer.cornerRadius
            
            fillGradientLayer?.colors = [
                fillTintColorStart?.cgColor ?? UIColor.clear.cgColor,
                fillTintColorEnd?.cgColor ?? UIColor.clear.cgColor
            ]
            
            let normalized = fillColorOrientation?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            let orientation = Orientation(rawValue: normalized ?? "horizontal") ?? .horizontal
            
            switch orientation {
            case .horizontal:
                fillGradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
                fillGradientLayer?.endPoint   = CGPoint(x: 1, y: 0.5)
            case .vertical:
                fillGradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
                fillGradientLayer?.endPoint   = CGPoint(x: 0.5, y: 1)
            }
            
            fillView.backgroundColor = .clear
        } else {
            if fillGradientLayer != nil {
                fillGradientLayer?.removeFromSuperlayer()
                fillGradientLayer = nil
            }
            fillView.backgroundColor = fillTintColor ?? .clear
        }
    }
    
    private func setupFullTrackBgColor() {
        if (fullTrackTintColorStart != nil || fullTrackTintColorEnd != nil) {
            if fullTrackGradientLayer == nil {
                let gradient = CAGradientLayer()
                fullTrackView.layer.insertSublayer(gradient, at: 0)
                fullTrackGradientLayer = gradient
            }
            
            fullTrackGradientLayer?.frame = fullTrackView.bounds
            fullTrackGradientLayer?.cornerRadius = fullTrackView.layer.cornerRadius
            
            fullTrackGradientLayer?.colors = [
                fullTrackTintColorStart?.cgColor ?? UIColor.clear.cgColor,
                fullTrackTintColorEnd?.cgColor ?? UIColor.clear.cgColor
            ]
            
            let normalized = fullTrackColorOrientation?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            let orientation = Orientation(rawValue: normalized ?? "horizontal") ?? .horizontal
            
            switch orientation {
            case .horizontal:
                fullTrackGradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
                fullTrackGradientLayer?.endPoint   = CGPoint(x: 1, y: 0.5)
            case .vertical:
                fullTrackGradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
                fullTrackGradientLayer?.endPoint   = CGPoint(x: 0.5, y: 1)
            }
            
            fullTrackView.backgroundColor = .clear
        } else {
            if fullTrackGradientLayer != nil {
                fullTrackGradientLayer?.removeFromSuperlayer()
                fullTrackGradientLayer = nil
            }
            fullTrackView.backgroundColor = fullTrackTintColor
        }
    }
    
    private func setupFillPadding() {
        if fillPaddingTop >= 0 {
            topFullTrackViewConstraint?.constant = fillPaddingTop
            topFillViewConstraint?.constant = fillPaddingTop
        }
        if fillPaddingBottom >= 0 {
            bottomFullTrackViewConstraint?.constant = fillPaddingBottom
            bottomFillViewConstraint?.constant = fillPaddingBottom
        }
        if fillPaddingLeading >= 0 {
            leadingFullTrackViewConstraint?.constant = fillPaddingLeading
            leadingFillViewConstraint?.constant = fillPaddingLeading
        }
        if fillPaddingTrailing >= 0 {
            trailingFullTrackViewConstraint?.constant = fillPaddingTrailing
        }
        invalidateIntrinsicContentSize()
    }
    
    private func setupIndicator() {
        indicatorView.isHidden = !isHasIndicator
    }
    
    private func setupIndicatorBgColor() {
        if (indicatorTintColorStart != nil || indicatorTintColorEnd != nil) {
            if indicatorGradientLayer == nil {
                let gradient = CAGradientLayer()
                indicatorView.layer.insertSublayer(gradient, at: 0)
                indicatorGradientLayer = gradient
            }
            
            indicatorGradientLayer?.frame = indicatorView.bounds
            indicatorGradientLayer?.cornerRadius = indicatorView.layer.cornerRadius
            
            indicatorGradientLayer?.colors = [
                indicatorTintColorStart?.cgColor ?? UIColor.clear.cgColor,
                indicatorTintColorEnd?.cgColor ?? UIColor.clear.cgColor
            ]
            
            let normalized = indicatorColorOrientation?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            let orientation = Orientation(rawValue: normalized ?? "horizontal") ?? .horizontal
            
            switch orientation {
            case .horizontal:
                indicatorGradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
                indicatorGradientLayer?.endPoint   = CGPoint(x: 1, y: 0.5)
            case .vertical:
                indicatorGradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
                indicatorGradientLayer?.endPoint   = CGPoint(x: 0.5, y: 1)
            }
            
            indicatorView.backgroundColor = .clear
        } else {
            if indicatorGradientLayer != nil {
                indicatorGradientLayer?.removeFromSuperlayer()
                indicatorGradientLayer = nil
            }
            indicatorView.backgroundColor = indicatorTintColor ?? .clear
        }
    }
    
    private func setupTrackConstraint() {
        guard trackHeight >= 0 else { return }
//        trackHeightConstraint?.constant = trackHeight
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }
    
    private func setupIndicatorConstraint() {
        guard indicatorSize > 0 else { return }
        indicatorWidthConstraint?.constant = indicatorSize
        indicatorHeightConstraint?.constant = indicatorSize
        invalidateIntrinsicContentSize()
    }
    
    private func setupIndicatorCornerRadius() {
        if indicatorCornerRadius >= 0 {
            indicatorView.layer.cornerRadius = indicatorCornerRadius
        } else {
            indicatorView.applyCircular()
        }
    }
    
    private func setupBadge() {
        let displayLaps = lapCount + (
            (value > 0 && value.truncatingRemainder(dividingBy: maxValue) == 0) ? 1 : 0
        )
        let isComplete = displayLaps >= 1
        
        fullTrackView.isHidden = !isComplete
        
        let shouldShowBadge = isComplete && isHasBadge && limitValue > maxValue
        badgeView.isHidden = !shouldShowBadge
        lblBadge.isHidden = !shouldShowBadge
    }
    
    private func calculateValue() {
        if pendingValue != nil {
            receivedMultipleUpdates = true
        }

        pendingValue = value

        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            guard let self, let target = self.pendingValue else { return }

            let isSpam = self.receivedMultipleUpdates

            self.pendingValue = nil
            self.receivedMultipleUpdates = false

            self.processValue(target, compressed: isSpam)
        }
    }

    private func processValue(_ targetValue: CGFloat, compressed: Bool) {
        guard maxValue > 0 else { return }

        let cappedValue = min(targetValue, limitValue)

        let previousValue = lastProcessedValue
        let jumpRatio = (cappedValue - previousValue) / maxValue
        let isSpam = compressed || jumpRatio > 2
        lastProcessedValue = cappedValue

        let ratio = cappedValue / maxValue
//        let badgeWidth = badgeSize > 0 ? badgeSize : (lblBadge.intrinsicContentSize.width + 8)
        let isAtMaxValue = cappedValue > 0 && cappedValue.truncatingRemainder(dividingBy: maxValue) == 0

        let newLapCount = isAtMaxValue ? Int(ratio) - 1 : Int(ratio)
        let newCycleRatio: CGFloat = isAtMaxValue ? 1.0 : ratio - CGFloat(Int(ratio))
        let finalDisplayLaps = isAtMaxValue ? newLapCount + 1 : newLapCount

        let trackWidth = trackView.frame.width
        guard trackWidth > 0 else { return }

        let minWidth: CGFloat = isHasIndicator ? indicatorSize + 2 : 0
        let fillLeadingOffset = leadingFillViewConstraint?.constant ?? 0
        let fillTrailingPad = fillPaddingTrailing >= 0 ? fillPaddingTrailing : 0
        let maxWidth: CGFloat = trackWidth - fillLeadingOffset - fillTrailingPad

        let previousLapCount = wasAtMaxValue ? lapCount + 1 : lapCount
        let lapsToAnimate = finalDisplayLaps - previousLapCount
        let hasRemainder = !isAtMaxValue && newCycleRatio > 0

        lapCount = newLapCount
//        cycleRatio = newCycleRatio
        wasAtMaxValue = isAtMaxValue

        if isSpam && lapsToAnimate > 0 {
            enqueue {
                self.runLapCycleAnimation(
                    trackWidth: maxWidth,
                    displayLaps: finalDisplayLaps,
                    isFirstLap: (previousLapCount == 0),
                    completion: self.dequeueAndRun
                )
            }

        } else if lapsToAnimate > 0 {
            for lap in (previousLapCount + 1)...finalDisplayLaps {
                enqueue {
                    self.runLapCycleAnimation(
                        trackWidth: maxWidth,
                        displayLaps: lap,
                        isFirstLap: (lap == 1),
                        completion: self.dequeueAndRun
                    )
                }
            }
        }

        if hasRemainder || (lapsToAnimate == 0 && !isAtMaxValue) {
            let fillWidth = minWidth + (maxWidth - minWidth) * newCycleRatio
            let targetWidth = min(max(fillWidth, minWidth), maxWidth)
            enqueue {
                self.runRemainderAnimation(
                    targetWidth: targetWidth,
                    displayLaps: finalDisplayLaps,
                    completion: self.dequeueAndRun
                )
            }
        }

        if !isAnimating {
            dequeueAndRun()
        }

        layoutIfNeeded()
    }

    private func enqueue(_ step: @escaping () -> Void) {
        animationQueue.append(step)
    }

    private func dequeueAndRun() {
        guard !animationQueue.isEmpty else {
            isAnimating = false
            return
        }
        isAnimating = true
        let next = animationQueue.removeFirst()
        next()
    }

    private func runLapCycleAnimation(trackWidth: CGFloat, displayLaps: Int, isFirstLap: Bool, completion: @escaping () -> Void) {
        
//        let minWidth: CGFloat = 0.0
//        fillView.isHidden = false
//        fillView.alpha = 1
//        fillWidthConstraint.constant = minWidth
//        fillGradientLayer?.frame = CGRect(x: 0, y: 0, width: minWidth, height: fillView.frame.height)
//        UIView.performWithoutAnimation { self.layoutIfNeeded() }

        if fillView.isHidden {
            let minWidth: CGFloat = 0.0
            fillWidthConstraint.constant = minWidth
            fillGradientLayer?.frame = CGRect(x: 0, y: 0, width: minWidth, height: fillView.frame.height)
            UIView.performWithoutAnimation { self.layoutIfNeeded() }
        }
        fillView.isHidden = false
        fillView.alpha = 1
        
        animateFillWidthAtMaxValue(trackWidth: trackWidth) {
            self.setupBadge()
            if self.badgeLabelAttributed == nil && self.badgeLabel == nil {
                self.lblBadge.text = "x\(displayLaps)"
                self.setupBadgeConstraint()
            }
            
            let shouldAnimateBadge = self.isHasBadge && self.limitValue > self.maxValue

            if shouldAnimateBadge {
                if isFirstLap {
                    self.animateBadgeScaleFromZero()
                } else {
                    self.animateBadgeScaleFromIdentity()
                }
            }
            
//            self.lastDisplayedLaps = displayLaps

            var shouldShowAnimatedFullTrack: Bool {
                let hasColor =
                (self.fullTrackTintColor != nil) ||
                (self.fullTrackTintColorStart != nil) ||
                (self.fullTrackTintColorEnd != nil)
                
                return self.limitValue > self.maxValue && hasColor
            }
            
            if shouldShowAnimatedFullTrack {
                self.animateFillFadeOut(startingFullAlpha: isFirstLap ? 0 : 1) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        completion()
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    completion()
                }
            }
        }
    }

    private func runRemainderAnimation(targetWidth: CGFloat, displayLaps: Int, completion: @escaping () -> Void) {
        let minWidth: CGFloat = 0.0

        if fillView.isHidden {
            fillWidthConstraint.constant = minWidth
            fillGradientLayer?.frame = CGRect(x: 0, y: 0, width: minWidth, height: fillView.frame.height)
            UIView.performWithoutAnimation { self.layoutIfNeeded() }
            
            fillView.isHidden = false
            
            UIView.performWithoutAnimation {
                self.layoutIfNeeded()
            }
            
            animateFillWidth(to: targetWidth, completion: completion)
        } else {
            animateFillWidth(to: targetWidth, completion: completion)
        }
        
        if badgeLabelAttributed == nil && badgeLabel == nil {
            lblBadge.text = "x\(displayLaps)"
            setupBadgeConstraint()
        }
//        lastDisplayedLaps = displayLaps
        setupBadge()
    }
    
    private func setupFont() {
        let size = badgeFontSize
        let weight = setupFontWeight(from: badgeFontWeight ?? "Semibold")
        
        if !badgeFontName.isEmpty {
            lblBadge.font = UIFont(name: badgeFontName, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            lblBadge.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }
    
    private func setupFontWeight(from value: String) -> UIFont.Weight {
        let normalized = value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        let weight = FontWeight(rawValue: normalized) ?? .regular
        
        switch weight {
        case .ultralight: return .ultraLight
        case .thin:       return .thin
        case .light:      return .light
        case .regular:    return .regular
        case .medium:     return .medium
        case .semibold:   return .semibold
        case .bold:       return .bold
        case .heavy:      return .heavy
        case .black:      return .black
        }
    }
    
    private func setupBadgeBgColor() {
        if (badgeTintColorStart != nil || badgeTintColorEnd != nil) {
            if badgeGradientLayer == nil {
                let gradient = CAGradientLayer()
                badgeView.layer.insertSublayer(gradient, at: 0)
                badgeGradientLayer = gradient
            }
            
            badgeGradientLayer?.frame = badgeView.bounds
            badgeGradientLayer?.cornerRadius = badgeView.layer.cornerRadius
            
            badgeGradientLayer?.colors = [
                badgeTintColorStart?.cgColor ?? UIColor.clear.cgColor,
                badgeTintColorEnd?.cgColor ?? UIColor.clear.cgColor
            ]
            
            let normalized = badgeColorOrientation?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            let orientation = Orientation(rawValue: normalized ?? "horizontal") ?? .horizontal
            
            switch orientation {
            case .horizontal:
                badgeGradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
                badgeGradientLayer?.endPoint   = CGPoint(x: 1, y: 0.5)
            case .vertical:
                badgeGradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
                badgeGradientLayer?.endPoint   = CGPoint(x: 0.5, y: 1)
            }
            
            badgeView.backgroundColor = .clear
        } else {
            if badgeGradientLayer != nil {
                badgeGradientLayer?.removeFromSuperlayer()
                badgeGradientLayer = nil
            }
            badgeView.backgroundColor = badgeTintColor ?? .clear
        }
    }
    
    private func setupBadgeConstraint() {
        lblBadge.sizeToFit()
        let textWidth = lblBadge.intrinsicContentSize.width + 8
        let textHeight = lblBadge.intrinsicContentSize.height + 4

        badgeWidthConstraint?.constant = max(badgeSize, textWidth, textHeight)
        badgeHeightConstraint?.constant = max(badgeSize, textHeight)

        invalidateIntrinsicContentSize()
        
        let w = max(badgeSize, textWidth, textHeight)
        let h = max(badgeSize, textHeight)
        badgeGradientLayer?.frame = CGRect(x: 0, y: 0, width: w, height: h)
        badgeGradientLayer?.cornerRadius = h / 2
    }
    
    private func setupBadgeCornerRadius() {
        if badgeCornerRadius >= 0 {
            badgeView.layer.cornerRadius = badgeCornerRadius
        } else {
            badgeView.applyCircular()
        }
    }
    
    private func setupTrackBgColor() {
        if (trackTintColorStart != nil || trackTintColorEnd != nil) {
            if trackGradientLayer == nil {
                let gradient = CAGradientLayer()
                trackView.layer.insertSublayer(gradient, at: 0)
                trackGradientLayer = gradient
            }
            
            trackGradientLayer?.frame = trackView.bounds
            trackGradientLayer?.cornerRadius = trackView.layer.cornerRadius
            
            trackGradientLayer?.colors = [
                trackTintColorStart?.cgColor ?? UIColor.clear.cgColor,
                trackTintColorEnd?.cgColor ?? UIColor.clear.cgColor
            ]
            
            let normalized = trackColorOrientation?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            let orientation = Orientation(rawValue: normalized ?? "horizontal") ?? .horizontal
            
            switch orientation {
            case .horizontal:
                trackGradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
                trackGradientLayer?.endPoint   = CGPoint(x: 1, y: 0.5)
            case .vertical:
                trackGradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
                trackGradientLayer?.endPoint   = CGPoint(x: 0.5, y: 1)
            }
            
            trackView.backgroundColor = .clear
        } else {
            if trackGradientLayer != nil {
                trackGradientLayer?.removeFromSuperlayer()
                trackGradientLayer = nil
            }
            trackView.backgroundColor = trackTintColor ?? .clear
        }
    }
    
    private func setupProgressBarCornerRadius() {
        if cornerRadius >= 0 {
            trackView.layer.cornerRadius = cornerRadius
            innerShadowView.cornerRadius = cornerRadius
            fullTrackView.layer.cornerRadius = cornerRadius
            fillView.layer.cornerRadius = cornerRadius
        } else {
            trackView.applyCircular()
            innerShadowView.cornerRadius = trackView.frame.height / 2.0
            fullTrackView.applyCircular()
            fillView.layer.cornerRadius = fullTrackView.layer.cornerRadius
        }
    }
    
    private func setupProgressBarConstraint() {
        if paddingTop >= 0 {
            topPaddingConstraint?.constant = paddingTop
        }
        if paddingBottom >= 0 {
            bottomPaddingConstraint?.constant = paddingBottom
        }
        if paddingLeading >= 0 {
            leadingPaddingConstraint?.constant = paddingLeading
        }
        if paddingTrailing >= 0 {
            trailingPaddingConstraint?.constant = paddingTrailing
        }
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Animation
    private func animateIndicator() {
        let animID = UUID()
        indicatorAnimationID = animID
        indicatorView.layer.removeAllAnimations()
        indicatorView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        indicatorView.isHidden = false
        indicatorView.alpha = 1
        isIndicatorVisible = true

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.indicatorView.transform = .identity
            },
            completion: { finished in
                guard self.indicatorAnimationID == animID else { return }
                if finished {
                    self.indicatorView.transform = .identity
                }
            }
        )
    }

    private func animateIndicatorToZero(completion: (() -> Void)? = nil) {
        let animID = UUID()
        indicatorAnimationID = animID

        indicatorView.layer.removeAllAnimations()
        indicatorView.isHidden = false
        indicatorView.alpha = 1
        isIndicatorVisible = false

        indicatorView.transform = .identity

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.indicatorView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            },
            completion: { finished in
                guard self.indicatorAnimationID == animID else {
                    completion?()
                    return
                }
                
                if finished {
                    self.indicatorView.isHidden = true
                    self.indicatorView.transform = .identity
                }
                
                completion?()
            }
        )
    }
    
    private func animateBadgeScaleFromZero() {
        badgeView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        badgeView.isHidden = false

        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.badgeView.transform = .identity
            }
        )
    }
    
    private func animateBadgeScaleFromIdentity() {
        badgeView.transform = .identity

        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.badgeView.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.2,
                    animations: {
                        self.badgeView.transform = .identity
                    }
                )
            }
        )
    }
    
    private func animateFillWidth(to targetWidth: CGFloat, completion: (() -> Void)? = nil) {
        if isHasIndicator && isIndicatorVisible {
            animateIndicatorToZero {
                self.fillWidthConstraint?.constant = targetWidth
                self.invalidateIntrinsicContentSize()

                CATransaction.begin()
                CATransaction.setAnimationDuration(0.8)
                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
                self.fillGradientLayer?.frame = CGRect(x: 0, y: 0, width: targetWidth, height: self.fillView.frame.height)
                CATransaction.commit()

                let animID = UUID()
                self.indicatorAnimationID = animID

                UIView.animate(
                    withDuration: 0.8,
                    delay: 0,
                    options: [.curveEaseInOut],
                    animations: { self.layoutIfNeeded() },
                    completion: { finished in
                        guard finished else { return }
                        self.fillGradientLayer?.frame = self.fillView.bounds
                        self.fillGradientLayer?.cornerRadius = self.fullTrackView.layer.cornerRadius
                        guard self.indicatorAnimationID == animID else { return }
                        if self.isHasIndicator && !self.fillView.isHidden {
                            self.animateIndicator()
                        }
                        completion?()
                    }
                )
            }
        } else {
            indicatorView.layer.removeAllAnimations()
            indicatorView.isHidden = true
            indicatorView.transform = .identity
            isIndicatorVisible = false
            
            fillWidthConstraint?.constant = targetWidth
            invalidateIntrinsicContentSize()

            CATransaction.begin()
            CATransaction.setAnimationDuration(0.8)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
            fillGradientLayer?.frame = CGRect(x: 0, y: 0, width: targetWidth, height: fillView.frame.height)
            CATransaction.commit()

            let animID = UUID()
            indicatorAnimationID = animID

            UIView.animate(
                withDuration: 0.8,
                delay: 0,
                options: [.curveEaseInOut],
                animations: { self.layoutIfNeeded() },
                completion: { finished in
                    guard finished else { return }
                    self.fillGradientLayer?.frame = self.fillView.bounds
                    self.fillGradientLayer?.cornerRadius = self.fullTrackView.layer.cornerRadius
                    guard self.indicatorAnimationID == animID else { return }
                    if self.isHasIndicator && !self.fillView.isHidden {
                        self.animateIndicator()
                    }
                    completion?()
                }
            )
        }
    }

    private func animateFillWidthAtMaxValue(trackWidth: CGFloat, completion: (() -> Void)? = nil) {
        if isHasIndicator && isIndicatorVisible {
                animateIndicatorToZero {
                    self.indicatorView.layer.removeAllAnimations()
                    self.indicatorView.isHidden = true
                    self.indicatorView.transform = .identity
                    self.isIndicatorVisible = false

                    self.fillWidthConstraint?.constant = trackWidth
                    self.invalidateIntrinsicContentSize()

                    CATransaction.begin()
                    CATransaction.setAnimationDuration(0.8)
                    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
                    self.fillGradientLayer?.frame = CGRect(x: 0, y: 0, width: trackWidth, height: self.fillView.frame.height)
                    CATransaction.commit()

                    UIView.animate(
                        withDuration: 0.8,
                        delay: 0,
                        options: [.curveEaseInOut],
                        animations: {
                            self.layoutIfNeeded()
                        },
                        completion: { finished in
                            self.fillGradientLayer?.frame = self.fillView.bounds
                            self.fillGradientLayer?.cornerRadius = self.fullTrackView.layer.cornerRadius

                            if finished {
                                completion?()
                            }
                        }
                    )
                }
            } else {
                indicatorView.layer.removeAllAnimations()
                indicatorView.isHidden = true
                indicatorView.transform = .identity
                isIndicatorVisible = false
                
                indicatorView.layer.removeAllAnimations()
                indicatorView.isHidden = true
                indicatorView.transform = .identity
                isIndicatorVisible = false

                fillWidthConstraint?.constant = trackWidth
                invalidateIntrinsicContentSize()

                CATransaction.begin()
                CATransaction.setAnimationDuration(0.8)
                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
                fillGradientLayer?.frame = CGRect(x: 0, y: 0, width: trackWidth, height: fillView.frame.height)
                CATransaction.commit()

                UIView.animate(
                    withDuration: 0.8,
                    delay: 0,
                    options: [.curveEaseInOut],
                    animations: {
                        self.layoutIfNeeded()
                    },
                    completion: { finished in
                        self.fillGradientLayer?.frame = self.fillView.bounds
                        self.fillGradientLayer?.cornerRadius = self.fullTrackView.layer.cornerRadius

                        if finished {
                            completion?()
                        }
                    }
                )
            }
    }
    
    private func animateFillFadeOut(startingFullAlpha: CGFloat = 0, completion: (() -> Void)? = nil) {
        UIView.performWithoutAnimation {
            self.fullTrackView.isHidden = false
            self.layoutIfNeeded()
        }
        fullTrackGradientLayer?.frame = fullTrackView.bounds
        fullTrackGradientLayer?.cornerRadius = fullTrackView.layer.cornerRadius
        fullTrackView.alpha = startingFullAlpha

        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.fillView.alpha = 0
                self.fullTrackView.alpha = 1
            },
            completion: { finished in
                self.fillView.isHidden = true
                self.fillView.alpha = 1
                self.fillView.layer.removeAllAnimations()

                self.fillWidthConstraint.constant = 0
                self.fillGradientLayer?.frame = CGRect(
                    x: 0, y: 0, width: 0,
                    height: self.fillView.frame.height
                )
                UIView.performWithoutAnimation { self.layoutIfNeeded() }
                completion?()
            }
        )
    }
}
