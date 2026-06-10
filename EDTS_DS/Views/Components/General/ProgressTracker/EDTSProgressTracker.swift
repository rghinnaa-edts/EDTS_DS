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
    @IBOutlet weak var trailingFillViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var indicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var badgeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgeHeightConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var fillWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Inspectables
    @IBInspectable public var fillColor: UIColor?{
        didSet{
            setupFillBgColor()
        }
    }
    
    @IBInspectable public var fillColorStart: UIColor?{
        didSet{
            setupFillBgColor()
        }
    }
    
    @IBInspectable public var fillColorEnd: UIColor?{
        didSet{
            setupFillBgColor()
        }
    }
    
    @IBInspectable public var fillColorOrientation: String?{
        didSet {
            setupFillBgColor()
        }
    }
    
    @IBInspectable public var fullTrackColor: UIColor?{
        didSet{
            setupFullTrackBgColor()
        }
    }
    
    @IBInspectable public var fullTrackColorStart: UIColor?{
        didSet{
            setupFullTrackBgColor()
        }
    }
    
    @IBInspectable public var fullTrackColorEnd: UIColor?{
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
    
    @IBInspectable public var value: CGFloat = 0.0 {
        didSet{
            calculateValue()
        }
    }
    
    @IBInspectable public var maxValue: CGFloat = 100.0 {
        didSet{
            calculateValue()
        }
    }
    
    @IBInspectable public var indicatorColor: UIColor?{
        didSet{
            setupIndicatorBgColor()
        }
    }
    
    @IBInspectable public var indicatorColorStart: UIColor?{
        didSet{
            setupIndicatorBgColor()
        }
    }
    
    @IBInspectable public var indicatorColorEnd: UIColor?{
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
            setupBadge()
        }
    }
    
    public var badgeLabelAttributed: NSAttributedString? {
        didSet {
            lblBadge.text = nil
            lblBadge.attributedText = badgeLabelAttributed
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
    
    @IBInspectable public var badgeColor: UIColor?{
        didSet{
            setupBadgeBgColor()
        }
    }
    
    @IBInspectable public var badgeColorStart: UIColor?{
        didSet{
            setupBadgeBgColor()
        }
    }
    
    @IBInspectable public var badgeColorEnd: UIColor?{
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
    
    @IBInspectable public var trackColor: UIColor?{
        didSet{
            setupTrackBgColor()
        }
    }
    
    @IBInspectable public var trackColorStart: UIColor?{
        didSet {
            setupTrackBgColor()
        }
    }
    
    @IBInspectable public var trackColorEnd: UIColor?{
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
    
    @IBInspectable public var borderWidth: CGFloat = CGFloat.zero{
        didSet{
            trackView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor?{
        didSet{
            trackView.layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = Float.zero {
        didSet {
            trackView.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = CGFloat.zero {
        didSet {
            trackView.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize.zero {
        didSet {
            trackView.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable public var shadowColor: UIColor?{
        didSet {
            trackView.layer.shadowColor = shadowColor?.cgColor
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
    private var currentValue: CGFloat?
    private var lapCount: Int = 0
    private var cycleRatio: CGFloat = 0.0
    private var trackGradientLayer: CAGradientLayer?
    private var fillGradientLayer: CAGradientLayer?
    private var fullTrackGradientLayer: CAGradientLayer?
    private var indicatorGradientLayer: CAGradientLayer?
    private var badgeGradientLayer: CAGradientLayer?
    
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
        fullTrackView.applyCircular()
        fillView.applyCircular()
        indicatorView.applyCircular()
        badgeView.applyCircular()
        
        fillGradientLayer?.frame = fillView.bounds
        fillGradientLayer?.cornerRadius = fillView.layer.cornerRadius
        
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
        let trackHeight = trackView.frame.height
        let trackWidth = trackView.frame.width
        
        let height = badgeView.frame.height
        
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
        
        setupIndicator()
        setupIndicatorBgColor()
        setupIndicatorConstraint()
        setupIndicatorCornerRadius()
        
        setupBadge()
        calculateValue()
        setupFont()
        setupBadgeBgColor()
        
        setupBadgeConstraint()
        setupBadgeCornerRadius()
        setupTrackBgColor()
        setupProgressBarCornerRadius()
        setupProgressBarConstraint()
    }
    
    private func setupDefaultStyle(){
        fillColorStart = EDTSColor.skyblueLeading
        fillColorEnd = EDTSColor.skyblueTrailing
        fillColorOrientation = "horizontal"
        fillPaddingTop = 1
        fillPaddingBottom = 1
        fillPaddingLeading = 1
        fillPaddingTrailing = 1
        indicatorColorStart = EDTSColor.skyblueLeading
        indicatorColorEnd = EDTSColor.skyblueTrailing
        indicatorColorOrientation = "horizontal"
        indicatorSize = 8
        badgeLabelColor = EDTSColor.white
        badgeFontSize = 8
        badgeFontWeight = "bold"
        badgeColorStart = EDTSColor.skyblueLeading
        badgeColorEnd = EDTSColor.skyblueTrailing
        badgeColorOrientation = "horizontal"
        badgeSize = 16
        trackColor = EDTSColor.grey20
        borderWidth = 0
        paddingTop = 5
        paddingBottom = 5
        isHasIndicator = true
        isHasBadge = true
    }
    
    private func setupFillBgColor() {
        if (fillColorStart != nil || fillColorEnd != nil) {
            if fillGradientLayer == nil {
                let gradient = CAGradientLayer()
                fillView.layer.insertSublayer(gradient, at: 0)
                fillGradientLayer = gradient
            }
            
            fillGradientLayer?.frame = fillView.bounds
            fillGradientLayer?.cornerRadius = fillView.layer.cornerRadius
            
            fillGradientLayer?.colors = [
                fillColorStart?.cgColor ?? UIColor.clear.cgColor,
                fillColorEnd?.cgColor ?? UIColor.clear.cgColor
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
            fillView.backgroundColor = fillColor ?? .clear
        }
    }
    
    private func setupFullTrackBgColor() {
        if (fullTrackColorStart != nil || fullTrackColorEnd != nil) {
            if fullTrackGradientLayer == nil {
                let gradient = CAGradientLayer()
                fullTrackView.layer.insertSublayer(gradient, at: 0)
                fullTrackGradientLayer = gradient
            }
            
            fullTrackGradientLayer?.frame = fullTrackView.bounds
            fullTrackGradientLayer?.cornerRadius = fullTrackView.layer.cornerRadius
            
            fullTrackGradientLayer?.colors = [
                fullTrackColorStart?.cgColor ?? UIColor.clear.cgColor,
                fullTrackColorEnd?.cgColor ?? UIColor.clear.cgColor
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
            fullTrackView.backgroundColor = fullTrackColor ?? EDTSColor.blue30
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
        if (indicatorColorStart != nil || indicatorColorEnd != nil) {
            if indicatorGradientLayer == nil {
                let gradient = CAGradientLayer()
                indicatorView.layer.insertSublayer(gradient, at: 0)
                indicatorGradientLayer = gradient
            }
            
            indicatorGradientLayer?.frame = indicatorView.bounds
            indicatorGradientLayer?.cornerRadius = indicatorView.layer.cornerRadius
            
            indicatorGradientLayer?.colors = [
                indicatorColorStart?.cgColor ?? UIColor.clear.cgColor,
                indicatorColorEnd?.cgColor ?? UIColor.clear.cgColor
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
            indicatorView.backgroundColor = indicatorColor ?? .clear
        }
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
        
        let shouldShowBadge = isComplete && isHasBadge
        badgeView.isHidden = !shouldShowBadge
        lblBadge.isHidden = !shouldShowBadge
        
        if shouldShowBadge {
            if lblBadge.attributedText == nil {
                lblBadge.text = badgeLabel
            }
        }
    }
    
    private func calculateValue() {
        guard maxValue > 0 else { return }
        
        let ratio = value / maxValue
        
        let isAtBoundary = value > 0 && value.truncatingRemainder(dividingBy: maxValue) == 0
        
        lapCount = isAtBoundary
        ? Int(ratio) - 1
        : Int(ratio)
        
        cycleRatio = isAtBoundary
        ? 1.0
        : ratio - CGFloat(Int(ratio))
        
        currentValue = cycleRatio
        
        let displayLaps = isAtBoundary ? lapCount + 1 : lapCount
        badgeLabel = "x\(displayLaps)"
        
        let shouldHideProgress = isAtBoundary
        fillView.isHidden = shouldHideProgress
        indicatorView.isHidden = shouldHideProgress || !isHasIndicator
        
        let trackWidth = trackView.frame.width
        guard trackWidth > 0 else { return }
        
        let minWidth: CGFloat = isHasIndicator ? 1 + indicatorSize : 0
        let maxWidth: CGFloat = trackWidth
        
        let fillWidth = cycleRatio == 0
        ? minWidth
        : minWidth + (maxWidth - minWidth) * cycleRatio
        
//        fillWidthConstraint?.constant = min(max(fillWidth, minWidth), maxWidth)
//        print("lapCount: \(displayLaps), cycleRatio: \(cycleRatio), fillWidth: \(fillWidthConstraint.constant)")
        
        setupBadge()
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
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
        if (badgeColorStart != nil || badgeColorEnd != nil) {
            if badgeGradientLayer == nil {
                let gradient = CAGradientLayer()
                badgeView.layer.insertSublayer(gradient, at: 0)
                badgeGradientLayer = gradient
            }
            
            badgeGradientLayer?.frame = badgeView.bounds
            badgeGradientLayer?.cornerRadius = badgeView.layer.cornerRadius
            
            badgeGradientLayer?.colors = [
                badgeColorStart?.cgColor ?? UIColor.clear.cgColor,
                badgeColorEnd?.cgColor ?? UIColor.clear.cgColor
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
            badgeView.backgroundColor = badgeColor ?? .clear
        }
    }
    
    private func setupBadgeConstraint() {
        guard badgeSize > 0 else { return }
        badgeWidthConstraint.constant = max(badgeSize, lblBadge.intrinsicContentSize.width + 4)
//        badgeWidthConstraint?.constant = badgeSize
        badgeHeightConstraint?.constant = badgeSize
        invalidateIntrinsicContentSize()
    }
    
    private func setupBadgeCornerRadius() {
        if badgeCornerRadius >= 0 {
            badgeView.layer.cornerRadius = badgeCornerRadius
        } else {
            badgeView.applyCircular()
        }
    }
    
    private func setupTrackBgColor() {
        if (trackColorStart != nil || trackColorEnd != nil) {
            if trackGradientLayer == nil {
                let gradient = CAGradientLayer()
                trackView.layer.insertSublayer(gradient, at: 0)
                trackGradientLayer = gradient
            }
            
            trackGradientLayer?.frame = trackView.bounds
            trackGradientLayer?.cornerRadius = trackView.layer.cornerRadius
            
            trackGradientLayer?.colors = [
                trackColorStart?.cgColor ?? UIColor.clear.cgColor,
                trackColorEnd?.cgColor ?? UIColor.clear.cgColor
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
            trackView.backgroundColor = trackColor ?? .clear
        }
    }
    
    private func setupProgressBarCornerRadius() {
        if cornerRadius >= 0 {
            trackView.layer.cornerRadius = cornerRadius
            fullTrackView.layer.cornerRadius = cornerRadius
            fillView.layer.cornerRadius = cornerRadius
        } else {
            trackView.applyCircular()
            fullTrackView.applyCircular()
            fillView.applyCircular()
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
    private func animateScaleDown() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        )
    }
    
    private func animateScaleUp() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.transform = .identity
            }
        )
    }
}
