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
    
    @IBOutlet weak var fillWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var topFillViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomFillViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingFillViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topFullTrackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomFullTrackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingFullTrackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingFullTrackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var badgeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgeTopPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgeBottomPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgeLeadingPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgeTrailingPaddingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var indicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var trackHeightConstraint: NSLayoutConstraint!
    
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
    
    @IBInspectable public var limitValue: CGFloat = 100.0 {
        didSet{
            if EDTSColor.theme == .poinku{
                if limitValue > self.maxValue {
                    fullTrackTintColor = EDTSColor.blue10
                } else {
                    fullTrackTintColor = .clear
                }
            }
        }
    }
    
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
            if initialFillMinWidth < 2 {
                let minWidth: CGFloat = isHasIndicator ? (indicatorSize/2) + 1 : 0
                fillWidthConstraint.constant = minWidth
                indicatorTrailingConstraint.constant = -(indicatorSize/2)
                initialFillMinWidth += 1
            }
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
            setupBadgeSize()
        }
    }
    
    public var badgeLabelAttributed: NSAttributedString? {
        didSet {
            lblBadge.text = nil
            lblBadge.attributedText = badgeLabelAttributed
            setupBadge()
            setupBadgeSize()
        }
    }
    
    @IBInspectable public var badgeLabelColor: UIColor?{
        didSet{
            lblBadge.textColor = badgeLabelColor
        }
    }
    
    @IBInspectable public var badgeFontName: String = "" {
        didSet {
            setupBadgeFont()
            setupBadge()
            setupBadgeSize()
        }
    }
    
    @IBInspectable public var badgeFontSize: CGFloat = CGFloat.zero{
        didSet {
            setupBadgeFont()
            setupBadge()
            setupBadgeSize()
        }
    }
    
    @IBInspectable public var badgeFontWeight: String?{
        didSet {
            setupBadgeFont()
            setupBadge()
            setupBadgeSize()
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
            setupBadgeSize()
        }
    }
    
    @IBInspectable public var badgeCornerRadius: CGFloat = -1.0 {
        didSet {
            setupBadgeCornerRadius()
        }
    }
    
    @IBInspectable public var badgePaddingTop: CGFloat = 0 {
        didSet {
            setupBadgePadding()
            setupBadgeSize()
        }
    }
    
    @IBInspectable public var badgePaddingBottom: CGFloat = 0 {
        didSet {
            setupBadgePadding()
            setupBadgeSize()
        }
    }
    
    @IBInspectable public var badgePaddingLeading: CGFloat = 0 {
        didSet {
            setupBadgePadding()
            setupBadgeSize()
        }
    }
    
    @IBInspectable public var badgePaddingTrailing: CGFloat = 0 {
        didSet {
            setupBadgePadding()
            setupBadgeSize()
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
    
    @IBInspectable public var trackHeight: CGFloat = -1.0 {
        didSet {
            setupTrackHeight()
        }
    }
    
    @IBInspectable public var trackCornerRadius: CGFloat = -1.0 {
        didSet {
            setupTrackCornerRadius()
        }
    }
    
    @IBInspectable public var trackPaddingTop: CGFloat = -1.0 {
        didSet {
            setupTrackPadding()
        }
    }
    
    @IBInspectable public var trackPaddingBottom: CGFloat = -1.0 {
        didSet {
            setupTrackPadding()
        }
    }
    
    @IBInspectable public var trackPaddingLeading: CGFloat = -1.0 {
        didSet {
            setupTrackPadding()
        }
    }
    
    @IBInspectable public var trackPaddingTrailing: CGFloat = -1.0 {
        didSet {
            setupTrackPadding()
        }
    }
    
    @IBInspectable public var trackInnerShadowOpacity: Float = Float.zero {
        didSet {
            innerShadowViewContainer.isHidden = true
            innerShadowView.isHidden = false
            innerShadowView.shadowOpacity = trackInnerShadowOpacity
        }
    }
    
    @IBInspectable public var trackInnerShadowRadius: CGFloat = CGFloat.zero {
        didSet {
            innerShadowViewContainer.isHidden = true
            innerShadowView.isHidden = false
            innerShadowView.shadowRadius = trackInnerShadowRadius
        }
    }
    
    @IBInspectable public var trackInnerShadowOffset: CGSize = CGSize.zero {
        didSet {
            innerShadowViewContainer.isHidden = true
            innerShadowView.isHidden = false
            innerShadowView.shadowOffset = trackInnerShadowOffset
        }
    }
    
    @IBInspectable public var trackInnerShadowColor: UIColor?{
        didSet {
            innerShadowViewContainer.isHidden = true
            innerShadowView.isHidden = false
            innerShadowView.shadowColor = trackInnerShadowColor ?? EDTSColor.black
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
    private var trackGradientLayer: CAGradientLayer?
    private var fillGradientLayer: CAGradientLayer?
    private var fullTrackGradientLayer: CAGradientLayer?
    private var indicatorGradientLayer: CAGradientLayer?
    private var badgeGradientLayer: CAGradientLayer?
    
    private var lastProcessedValue: CGFloat = 0.0
    private var wasAtMaxValue: Bool = false
    private var isIndicatorVisible: Bool = false
    private var indicatorAnimationID: UUID = UUID()
    private var animationQueue: [() -> Void] = []
    private var isAnimating: Bool = false
    
    private var debounceTimer: Timer?
    private var pendingValue: CGFloat? = nil
    
    private var isUserInputSpam = false
    private var initialFillMinWidth = 0
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }
    
    // MARK: - Public Function
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if trackCornerRadius >= 0 {
            trackView.layer.cornerRadius = trackCornerRadius
            fullTrackView.layer.cornerRadius = trackCornerRadius
            fillView.layer.cornerRadius = trackCornerRadius
        } else {
            trackView.applyCircular()
            fullTrackView.applyCircular()
            fillView.layer.cornerRadius = fullTrackView.layer.cornerRadius
        }
        
        if indicatorCornerRadius >= 0 {
            indicatorView.layer.cornerRadius = indicatorCornerRadius
        } else {
            indicatorView.applyCircular()
        }
        
        if badgeCornerRadius >= 0 {
            badgeView.layer.cornerRadius = badgeCornerRadius
        } else {
            badgeView.applyCircular()
        }
        
        innerShadowView.cornerRadius = trackView.layer.cornerRadius
        innerShadowView1.cornerRadius = trackView.layer.cornerRadius
        innerShadowView2.cornerRadius = trackView.layer.cornerRadius
        innerShadowViewContainer.layer.cornerRadius = trackView.layer.cornerRadius

        fillView.layer.cornerRadius = fullTrackView.layer.cornerRadius
        
        trackGradientLayer?.frame = trackView.bounds
        trackGradientLayer?.cornerRadius = trackView.layer.cornerRadius
        
        fullTrackGradientLayer?.frame = fullTrackView.bounds
        fullTrackGradientLayer?.cornerRadius = fullTrackView.layer.cornerRadius
        
        fillGradientLayer?.frame = fillView.bounds
        fillGradientLayer?.cornerRadius = fullTrackView.layer.cornerRadius
        
        indicatorGradientLayer?.frame = indicatorView.bounds
        indicatorGradientLayer?.cornerRadius = indicatorView.layer.cornerRadius
        
        badgeGradientLayer?.frame = badgeView.bounds
        badgeGradientLayer?.cornerRadius = badgeView.layer.cornerRadius
    }
    
    override public var intrinsicContentSize: CGSize {
        let trackWidth = trackView.frame.width
        let badgeHeight = isHasBadge ? badgeSize : 0
        let indicatorHeight = isHasIndicator ? indicatorSize : 0
        let trackHeight = trackView.frame.height
        let height = max(trackHeight, indicatorHeight, badgeHeight)
        
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
        setupFillBgColor()
        setupIndicatorBgColor()
        setupBadgeBgColor()
        setupDefaultStyle()
        setupFullTrackBgColor()
        setupTrackPadding()
        setupTrackHeight()
        
        setupIndicator()
        setupIndicatorConstraint()
        setupIndicatorCornerRadius()
        
        setupBadge()
        setupBadgePadding()
        setupBadgeFont()
        setupBadgeSize()
        setupBadgeCornerRadius()
        
        setupTrackBgColor()
        setupTrackCornerRadius()
    }
    
    private func setupDefaultStyle(){
        if EDTSColor.theme == .klikIDM {
            trackPaddingTop = 1
            trackPaddingBottom = 1
            trackPaddingLeading = 1
            trackPaddingTrailing = 1
            fullTrackTintColor = EDTSColor.blue30
            trackTintColor = EDTSColor.grey20
            isHasIndicator = true
            isHasBadge = true
            
            innerShadowView.isHidden = false
            innerShadowView.shadowOpacity = 0.10
            innerShadowView.shadowOffset = CGSize(width: 0, height: 0)
            innerShadowView.shadowColor = EDTSColor.black
            innerShadowView.shadowRadius = 2
            innerShadowViewContainer.isHidden = true
        } else {
            trackPaddingTop = 0
            trackPaddingBottom = 0
            trackPaddingLeading = 0
            trackPaddingTrailing = 0
            
            trackTintColor = EDTSColor.white
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
        
        let gradient = CAGradientLayer()
        fillView.layer.insertSublayer(gradient, at: 0)
        fillGradientLayer = gradient
        fillGradientLayer?.frame = fillView.bounds
        fillGradientLayer?.cornerRadius = fullTrackView.layer.cornerRadius
        fillGradientLayer?.colors = [
            EDTSColor.skyblueLeading.cgColor,
            EDTSColor.skyblueTrailing.cgColor
        ]
        fillGradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
        fillGradientLayer?.endPoint   = CGPoint(x: 1, y: 0.5)
        fillView.backgroundColor = .clear
        
        let gradient1 = CAGradientLayer()
        indicatorView.layer.insertSublayer(gradient1, at: 0)
        indicatorGradientLayer = gradient1
        indicatorGradientLayer?.frame = fillView.bounds
        indicatorGradientLayer?.cornerRadius = indicatorView.layer.cornerRadius
        indicatorGradientLayer?.colors = [
            EDTSColor.skyblueLeading.cgColor,
            EDTSColor.skyblueTrailing.cgColor
        ]
        indicatorGradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
        indicatorGradientLayer?.endPoint   = CGPoint(x: 1, y: 0.5)
        indicatorView.backgroundColor = .clear
        
        let gradient2 = CAGradientLayer()
        badgeView.layer.insertSublayer(gradient2, at: 0)
        badgeGradientLayer = gradient2
        badgeGradientLayer?.frame = fillView.bounds
        badgeGradientLayer?.cornerRadius = badgeView.layer.cornerRadius
        badgeGradientLayer?.colors = [
            EDTSColor.skyblueLeading.cgColor,
            EDTSColor.skyblueTrailing.cgColor
        ]
        badgeGradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
        badgeGradientLayer?.endPoint   = CGPoint(x: 1, y: 0.5)
        badgeView.backgroundColor = .clear
        
        indicatorSize = 8
        badgeLabelColor = EDTSColor.white
        badgeFontSize = 8
        badgeFontWeight = "bold"
        badgeSize = 16
        
        badgePaddingTop = 2
        badgePaddingBottom = 2
        badgePaddingLeading = 4
        badgePaddingTrailing = 4
        limitValue = maxValue
    }
    
    // MARK: - Setup Fill
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
    
    // MARK: - Setup Indicator
    private func setupIndicator() {
        indicatorView.isHidden = !isHasIndicator
        invalidateIntrinsicContentSize()
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
    
    private func setupIndicatorConstraint() {
        guard indicatorSize > 0 else { return }
        indicatorWidthConstraint?.constant = indicatorSize
        indicatorHeightConstraint?.constant = indicatorSize
        indicatorTrailingConstraint.constant = -(indicatorSize/2)
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
        setNeedsLayout()
    }
    
    private func setupIndicatorCornerRadius() {
        if indicatorCornerRadius >= 0 {
            indicatorView.layer.cornerRadius = indicatorCornerRadius
        } else {
            indicatorView.applyCircular()
        }
        
        indicatorGradientLayer?.cornerRadius = indicatorView.layer.cornerRadius
    }
    
    // MARK: - Setup Badge
    private func setupBadge() {
        let displayLaps = lapCount + (
            (value > 0 && value.truncatingRemainder(dividingBy: maxValue) == 0) ? 1 : 0
        )
        let isComplete = displayLaps >= 1
        
        fullTrackView.isHidden = !isComplete
        
        let shouldShowBadge = isComplete && isHasBadge && limitValue > maxValue
        badgeView.isHidden = !shouldShowBadge
        lblBadge.isHidden = !shouldShowBadge
        
        invalidateIntrinsicContentSize()
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
    
    private func setupBadgeFont() {
        let size = badgeFontSize
        let weight = setupBadgeFontWeight(from: badgeFontWeight ?? "bold")
        
        if !badgeFontName.isEmpty {
            lblBadge.font = UIFont(name: badgeFontName, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            lblBadge.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }
    
    private func setupBadgeFontWeight(from value: String) -> UIFont.Weight {
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
    
    private func setupBadgeSize() {
        lblBadge.sizeToFit()
        
        let textWidth = lblBadge.intrinsicContentSize.width +
        badgePaddingLeading + badgePaddingTrailing
        
        let textHeight = lblBadge.intrinsicContentSize.height +
        badgePaddingTop + badgePaddingBottom
        
        let w = max(badgeSize, textWidth, textHeight)
        let h = max(badgeSize, textHeight)
        
        badgeWidthConstraint?.constant = w
        badgeHeightConstraint?.constant = h
        badgeGradientLayer?.frame = CGRect(x: 0, y: 0, width: w, height: h)
        badgeGradientLayer?.cornerRadius = badgeView.layer.cornerRadius
        invalidateIntrinsicContentSize()
    }
    
    private func setupBadgeCornerRadius() {
        if badgeCornerRadius >= 0 {
            badgeView.layer.cornerRadius = badgeCornerRadius
        } else {
            badgeView.applyCircular()
        }
        
        badgeGradientLayer?.cornerRadius = badgeView.layer.cornerRadius
    }
    
    private func setupBadgePadding() {
        badgeTopPaddingConstraint.constant = badgePaddingTop
        badgeBottomPaddingConstraint.constant = badgePaddingBottom
        badgeLeadingPaddingConstraint.constant = badgePaddingLeading
        badgeTrailingPaddingConstraint.constant = badgePaddingTrailing
        
        layoutIfNeeded()
    }
    
    // MARK: - Setup Track
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
    
    private func setupTrackHeight() {
        guard trackHeight >= 0 else { return }
        trackHeightConstraint?.constant = trackHeight
        
        invalidateIntrinsicContentSize()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func setupTrackCornerRadius() {
        if trackCornerRadius >= 0 {
            trackView.layer.cornerRadius = trackCornerRadius
            innerShadowView.cornerRadius = trackCornerRadius
            fullTrackView.layer.cornerRadius = trackCornerRadius
            fillView.layer.cornerRadius = trackCornerRadius
        } else {
            trackView.applyCircular()
            innerShadowView.cornerRadius = trackView.layer.cornerRadius
            fullTrackView.applyCircular()
            fillView.layer.cornerRadius = fullTrackView.layer.cornerRadius
        }
        
        trackGradientLayer?.frame = trackView.bounds
        trackGradientLayer?.cornerRadius = trackView.layer.cornerRadius
        
        fullTrackGradientLayer?.frame = fullTrackView.bounds
        fullTrackGradientLayer?.cornerRadius = fullTrackView.layer.cornerRadius
        
        fillGradientLayer?.frame = fillView.bounds
        fillGradientLayer?.cornerRadius = fullTrackView.layer.cornerRadius
    }
    
    private func setupTrackPadding() {
        if trackPaddingTop >= 0 {
            topFullTrackViewConstraint?.constant = trackPaddingTop
            topFillViewConstraint?.constant = trackPaddingTop
        }
        if trackPaddingBottom >= 0 {
            bottomFullTrackViewConstraint?.constant = trackPaddingBottom
            bottomFillViewConstraint?.constant = trackPaddingBottom
        }
        if trackPaddingLeading >= 0 {
            leadingFullTrackViewConstraint?.constant = trackPaddingLeading
            leadingFillViewConstraint?.constant = trackPaddingLeading
        }
        if trackPaddingTrailing >= 0 {
            trailingFullTrackViewConstraint?.constant = trackPaddingTrailing
        }
        
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Calculating Progress Bar Value
    private func calculateValue() {
        if pendingValue != nil {
            isUserInputSpam = true
        }
        
        pendingValue = value
        
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            guard let self, let target = self.pendingValue else { return }
            
            let isSpam = self.isUserInputSpam
            
            self.pendingValue = nil
            self.isUserInputSpam = false
            
            self.processValue(target, compressed: isSpam)
        }
    }
    
    private func processValue(_ targetValue: CGFloat, compressed: Bool) {
        guard maxValue > 0 else { return }
        
        let cappedValue = min(targetValue, limitValue)
        
        let jumpRatio = (cappedValue - lastProcessedValue) / maxValue
        let isSpam = compressed || jumpRatio > 2
        lastProcessedValue = cappedValue
        
        let ratio = cappedValue / maxValue
        let isAtMaxValue = cappedValue > 0 && cappedValue.truncatingRemainder(dividingBy: maxValue) == 0
        
        let newLapCount = isAtMaxValue ? Int(ratio) - 1 : Int(ratio)
        let newCycleRatio: CGFloat = isAtMaxValue ? 1.0 : ratio - CGFloat(Int(ratio))
        let finalDisplayLaps = isAtMaxValue ? newLapCount + 1 : newLapCount
        
        let trackWidth = trackView.frame.width
        guard trackWidth > 0 else { return }
        
        let minWidth: CGFloat = isHasIndicator ? indicatorSize + 2 : 0
        let fillLeadingOffset = leadingFillViewConstraint?.constant ?? 0
        let fillTrailingPad = trackPaddingTrailing >= 0 ? trackPaddingTrailing : 0
        let maxWidth: CGFloat = trackWidth - fillLeadingOffset - fillTrailingPad
        
        let previousLapCount = wasAtMaxValue ? lapCount + 1 : lapCount
        let lapsToAnimate = finalDisplayLaps - previousLapCount
        let hasRemainder = !isAtMaxValue && newCycleRatio > 0
        
        lapCount = newLapCount
        wasAtMaxValue = isAtMaxValue
        
        if isSpam && lapsToAnimate > 0 {
            enqueue {
                self.runFinishedLapAnimation(
                    trackWidth: maxWidth,
                    displayLaps: finalDisplayLaps,
                    isFirstLap: (previousLapCount == 0),
                    completion: self.dequeueAndRun
                )
            }
            
        } else if lapsToAnimate > 0 {
            for lap in (previousLapCount + 1)...finalDisplayLaps {
                enqueue {
                    self.runFinishedLapAnimation(
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
                self.runPartialLapAnimation(
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
    
    
    private func runFinishedLapAnimation(trackWidth: CGFloat, displayLaps: Int, isFirstLap: Bool, completion: @escaping () -> Void) {
        if fillView.isHidden {
            let minWidth: CGFloat = 0.0
            fillWidthConstraint.constant = minWidth
            fillGradientLayer?.frame = CGRect(x: 0, y: 0, width: minWidth, height: fillView.frame.height)
            UIView.performWithoutAnimation { self.layoutIfNeeded() }
        }
        fillView.isHidden = false
        fillView.alpha = 1
        
        animateFillWidthToMaxValue(trackWidth: trackWidth) {
            self.setupBadge()
            if self.badgeLabelAttributed == nil && self.badgeLabel == nil {
                self.lblBadge.text = "x\(displayLaps)"
                self.setupBadgeSize()
            }
            
            let shouldAnimateBadge = self.isHasBadge && self.limitValue > self.maxValue
            
            if shouldAnimateBadge {
                if isFirstLap {
                    self.animateScaleUpBadge()
                } else {
                    self.animatePulseBadge()
                }
            }
            
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
    
    private func runPartialLapAnimation(targetWidth: CGFloat, displayLaps: Int, completion: @escaping () -> Void) {
        let minWidth: CGFloat = 0.0
        
        if fillView.isHidden {
            fillWidthConstraint.constant = minWidth
            fillGradientLayer?.frame = CGRect(x: 0, y: 0, width: minWidth, height: fillView.frame.height)
            UIView.performWithoutAnimation { self.layoutIfNeeded() }
            
            fillView.isHidden = false
            
            UIView.performWithoutAnimation {
                self.layoutIfNeeded()
            }
            
            animateFillWidthToTargetValue(to: targetWidth, completion: completion)
        } else {
            animateFillWidthToTargetValue(to: targetWidth, completion: completion)
        }
        
        if badgeLabelAttributed == nil && badgeLabel == nil {
            lblBadge.text = "x\(displayLaps)"
            setupBadgeSize()
        }
        setupBadge()
    }
    
    // MARK: - Animation
    private func animateScaleUpIndicator() {
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
    
    private func animateScaleDownIndicator(completion: (() -> Void)? = nil) {
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
    
    private func animateScaleUpBadge() {
        badgeView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        badgeView.isHidden = false
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.badgeView.transform = .identity
            }
        )
    }
    
    private func animatePulseBadge() {
        badgeView.transform = .identity
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.badgeView.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: [.curveEaseInOut],
                    animations: {
                        self.badgeView.transform = .identity
                    }
                )
            }
        )
    }
    
    private func animateFillWidthToTargetValue(to targetWidth: CGFloat, completion: (() -> Void)? = nil) {
        if isHasIndicator && isIndicatorVisible {
            animateScaleDownIndicator {
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
                            self.animateScaleUpIndicator()
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
                        self.animateScaleUpIndicator()
                    }
                    completion?()
                }
            )
        }
    }
    
    private func animateFillWidthToMaxValue(trackWidth: CGFloat, completion: (() -> Void)? = nil) {
        if isHasIndicator && isIndicatorVisible {
            animateScaleDownIndicator {
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
