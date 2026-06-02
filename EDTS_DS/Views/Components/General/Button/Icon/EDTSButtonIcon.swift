//
//  IconButton.swift
//  KlikIDM_DS
//
//  Created by Yovita Handayiani on 09/02/26.
//

import UIKit

@IBDesignable
public class EDTSButtonIcon: UIButton {
    // MARK: - Inspectables
    @IBInspectable public var btnType: String?{
        didSet {
            setupButtonType()
        }
    }
    
    @IBInspectable public var btnSize: String?{
        didSet {
            setupButtonSize()
        }
    }
    
    @IBInspectable public var btnState: String?{
        didSet {
            setupButtonType()
        }
    }
    
    @IBInspectable public var bgTintColor: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var bgFocusTintColor: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var bgDisabledTintColor: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var bgTintColorStart: UIColor?{
        didSet {
            setupBackground()
        }
    }
    
    @IBInspectable public var bgTintColorEnd: UIColor?{
        didSet {
            setupBackground()
        }
    }
    
    @IBInspectable public var bgTintColorOrientation: String?{
        didSet {
            setupBackground()
        }
    }
    
    @IBInspectable public var rippleColor: UIColor?{
            didSet{
                setupButtonType()
            }
        }
    
    @IBInspectable public var cornerRadius: CGFloat = -1.0 {
        didSet {
            setupButtonSize()
        }
    }
    
    @IBInspectable public var icon: UIImage?{
        didSet{
            setupIcon()
        }
    }
    
    @IBInspectable public var iconTintColor: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var iconFocusTintColor: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var iconDisabledTintColor: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var iconSize: CGFloat = CGFloat.zero{
        didSet {
            setupIconConstraint()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = CGFloat.zero{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var borderColor: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var borderFocusColor: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var borderDisabledColor: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = Float.zero {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = CGFloat.zero {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize.zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable public var shadowColor: UIColor?{
        didSet {
            setupButtonType()
        }
    }
    
    @IBInspectable public var shadowFocusColor: UIColor?{
        didSet {
            setupButtonType()
        }
    }
    
    @IBInspectable public var shadowDisabledColor: UIColor?{
        didSet {
            setupButtonType()
        }
    }
    
    @IBInspectable public var paddingTop: CGFloat = -1.0 {
        didSet {
            setupButtonSize()
        }
    }
    
    @IBInspectable public var paddingBottom: CGFloat = -1.0 {
        didSet {
            setupButtonSize()
        }
    }
    
    @IBInspectable public var paddingLeading: CGFloat = -1.0 {
        didSet {
            setupButtonSize()
        }
    }
    
    @IBInspectable public var paddingTrailing: CGFloat = -1.0 {
        didSet {
            setupButtonSize()
        }
    }
    
    // MARK: - Private Variable
    private let ivIcon = UIImageView()
    private let defaultValue : CGFloat = -1.0

    private var iconWidthConstraint: NSLayoutConstraint?
    private var iconHeightConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    private var gradientLayer: CAGradientLayer?
    
    private var tempIconTintColor: UIColor?
    private var tempBgTintColor: UIColor?
    private var tempRippleColor: UIColor?
    private var tempBorderColor: UIColor?
    private var tempBorderWidth: CGFloat = CGFloat.zero
    private var tempIconSize: CGFloat = CGFloat.zero
    private var tempCornerRadius: CGFloat = -1.0
    private var tempPaddingTop: CGFloat = -1.0
    private var tempPaddingBottom: CGFloat = -1.0
    private var tempPaddingLeading: CGFloat = -1.0
    private var tempPaddingTrailing: CGFloat = -1.0
    private var tempResolvedButtonState: BtnState? = nil
    
    private let cvBadge = EDTSBadge()
    private var badgeTopConstraint: NSLayoutConstraint?
    private var badgeTrailingConstraint: NSLayoutConstraint?
    
    private var resolvedButtonSize: BtnSize {
        guard let size = btnSize else { return .large }
        let normalized = size.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return BtnSize(rawValue: normalized) ?? .large
    }
    
    private var resolvedButtonType: BtnType {
        guard let type = btnType else { return .primary }
        let normalized = type.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return BtnType(rawValue: normalized) ?? .primary
    }
    
    private var resolvedButtonState: BtnState {
        guard let state = btnState else { return .`default` }
        let normalized = state.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return BtnState(rawValue: normalized) ?? .`default`
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
        gradientLayer?.cornerRadius = tempCornerRadius
        layer.cornerRadius = tempCornerRadius
        cvBadge.cornerRadius = cvBadge.bounds.height / 2
    }
    
    override public var intrinsicContentSize: CGSize {
        let iconSize = CGSize(width: tempIconSize, height: tempIconSize)
        return CGSize(
            width: iconSize.width + tempPaddingLeading + tempPaddingTrailing,
            height: iconSize.height + tempPaddingTop + tempPaddingBottom
        )
    }
    
    // MARK: - Setup & Styling
    private func setupUI() {
        tintColor = .clear
        titleLabel?.isHidden = true
        backgroundColor = .clear
        
        ivIcon.contentMode = .scaleAspectFit
        ivIcon.setContentHuggingPriority(.required, for: .horizontal)
        ivIcon.image = icon?.withRenderingMode(.alwaysTemplate)
        ivIcon.tintColor = EDTSColor.white
        
        
        addSubview(ivIcon)
        ivIcon.isUserInteractionEnabled = false
        
        initConstraint()
        initIconConstraint()
        initBadgeConstraint()
        setupIcon()
        setupButtonSize()
        setupButtonType()
        setupPressGesture()
        setupBadge()
    }
    
    private func setupIcon() {
        ivIcon.isHidden = false
        let bundle = Bundle(for: type(of: self))
        ivIcon.image = UIImage(named: "ic_placeholder", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    
    private func setupBackground() {
        if (bgTintColorStart != nil || bgTintColorEnd != nil) {
            if gradientLayer == nil {
                let gradient = CAGradientLayer()
                gradient.frame = bounds
                layer.insertSublayer(gradient, at: 0)
                gradientLayer = gradient
            }
            
            gradientLayer?.colors = [
                bgTintColorStart?.cgColor ?? UIColor.clear.cgColor,
                bgTintColorEnd?.cgColor ?? UIColor.clear.cgColor
            ]
            
            let normalized = bgTintColorOrientation?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            let orientation = Orientation(rawValue: normalized ?? "vertical") ?? .vertical
            
            switch orientation {
            case .horizontal:
                gradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
                gradientLayer?.endPoint   = CGPoint(x: 1, y: 0.5)
            case .vertical:
                gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
                gradientLayer?.endPoint   = CGPoint(x: 0.5, y: 1)
            }
            
            backgroundColor = .clear
        } else {
            if gradientLayer != nil {
                gradientLayer?.removeFromSuperlayer()
                gradientLayer = nil
            }
            if tempBgTintColor == UIColor.clear {
                backgroundColor = .clear
            } else {
                backgroundColor = tempBgTintColor
            }
        }
    }
    
    private func initIconConstraint() {
        ivIcon.translatesAutoresizingMaskIntoConstraints = false
        iconWidthConstraint = ivIcon.widthAnchor.constraint(equalToConstant: iconSize)
        iconHeightConstraint = ivIcon.heightAnchor.constraint(equalToConstant: iconSize)
        
        NSLayoutConstraint.activate([
            iconWidthConstraint!,
            iconHeightConstraint!,
            ivIcon.widthAnchor.constraint(equalTo: ivIcon.heightAnchor, multiplier: 1.0)
        ])
    }
    
    private func initConstraint() {
        ivIcon.translatesAutoresizingMaskIntoConstraints = false
        
        topConstraint = ivIcon.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop)
        bottomConstraint = ivIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingBottom)
        leadingConstraint = ivIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingLeading)
        trailingConstraint = ivIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddingTrailing)
        
        NSLayoutConstraint.activate([
            topConstraint!,
            bottomConstraint!,
            leadingConstraint!,
            trailingConstraint!
        ])
    }
    
    private func initBadgeConstraint() {
        cvBadge.translatesAutoresizingMaskIntoConstraints = false
        cvBadge.isUserInteractionEnabled = false
        addSubview(cvBadge)
        
        badgeTopConstraint = cvBadge.topAnchor.constraint(equalTo: ivIcon.topAnchor, constant: -4)
        badgeTrailingConstraint = cvBadge.trailingAnchor.constraint(equalTo: ivIcon.trailingAnchor, constant: 4)
        
        NSLayoutConstraint.activate([
            badgeTopConstraint!,
            badgeTrailingConstraint!
        ])
        
        cvBadge.isHidden = true
    }
    
    private func setupIconConstraint(){
        iconWidthConstraint?.constant = tempIconSize
        iconHeightConstraint?.constant = tempIconSize
    }
    
    private func setupConstraint() {
        topConstraint?.constant = tempPaddingTop
        bottomConstraint?.constant = -tempPaddingBottom
        leadingConstraint?.constant = tempPaddingLeading
        trailingConstraint?.constant = -tempPaddingTrailing
        invalidateIntrinsicContentSize()
    }
    
    private func setupBadge(){
        cvBadge.labelColor = EDTSColor.white
        cvBadge.bgColor = EDTSColor.red30
        cvBadge.borderColor = EDTSColor.white
        cvBadge.borderWidth = 1
        cvBadge.label = "1"
    }
    
    public func configureBadge(_ instance: (EDTSBadge) -> Void) {
        cvBadge.isHidden = false
        instance(cvBadge)
    }
    
    private func setupButtonSize() {
        switch resolvedButtonSize {
        case .small:
            tempIconSize = iconSize == CGFloat.zero ? 16 : iconSize
            tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            tempPaddingTop = paddingTop == defaultValue ? 4 : paddingTop
            tempPaddingBottom = paddingBottom == defaultValue ? 4 : paddingBottom
            tempPaddingLeading = paddingLeading == defaultValue ? 4 : paddingLeading
            tempPaddingTrailing = paddingTrailing == defaultValue ? 4 : paddingTrailing
            
        case .medium:
            tempIconSize = iconSize == CGFloat.zero ? 16 : iconSize
            tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            tempPaddingTop = paddingTop == defaultValue ? 8 : paddingTop
            tempPaddingBottom = paddingBottom == defaultValue ? 8 : paddingBottom
            tempPaddingLeading = paddingLeading == defaultValue ? 8 : paddingLeading
            tempPaddingTrailing = paddingTrailing == defaultValue ? 8 : paddingTrailing
            
        case .large:
            tempIconSize = iconSize == CGFloat.zero ? 24 : iconSize
            tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            tempPaddingTop = paddingTop == defaultValue ? 8 : paddingTop
            tempPaddingBottom = paddingBottom == defaultValue ? 8 : paddingBottom
            tempPaddingLeading = paddingLeading == defaultValue ? 8 : paddingLeading
            tempPaddingTrailing = paddingTrailing == defaultValue ? 8 : paddingTrailing
        }
        
        setupIconConstraint()
        setupConstraint()
        layer.cornerRadius = tempCornerRadius
    }
    
    private func setupButtonStyle() {
        setupIcon()
        ivIcon.tintColor = tempIconTintColor
        layer.borderWidth = tempBorderWidth
        setupBackground()
        
        switch resolvedButtonType {
        case .primary:
            layer.borderColor = tempBorderColor?.cgColor
        case .secondary, .tertiary:
            if(iconTintColor != nil){
                if (borderColor == nil){
                    layer.borderColor = tempIconTintColor?.cgColor
                }else{
                    layer.borderColor = tempBorderColor?.cgColor
                }
            }else{
                layer.borderColor = tempBorderColor?.cgColor
            }
        }
        
        if rippleColor == nil {
            if tempBgTintColor == EDTSColor.white {
                tempRippleColor = tempIconTintColor?.withAlphaComponent(0.12)
            }else if tempBgTintColor == .clear {
                tempRippleColor = tempIconTintColor?.withAlphaComponent(0.12)
            }else if tempBgTintColor != EDTSColor.white {
                tempRippleColor = EDTSColor.grey70.withAlphaComponent(0.12)
            }
        } else {
            tempRippleColor = rippleColor?.withAlphaComponent(0.12)
        }
    }
    
    private func setupButtonType() {
        let state = tempResolvedButtonState ?? resolvedButtonState
        isUserInteractionEnabled = state != .disabled
        
        switch resolvedButtonType {
        case .primary:
            setupButtonPrimary(state)
        case .secondary:
            setupButtonSecondary(state)
        case .tertiary:
            setupButtonTertiary(state)
        }
    }
    
    private func setupButtonPrimary(_ state: BtnState) {
        switch state {
        case .default:
            tempIconTintColor = iconTintColor ?? EDTSColor.white
            tempBgTintColor = bgTintColor ?? EDTSColor.blueDefault
            tempBorderColor = borderColor ?? EDTSColor.blueDefault
            tempBorderWidth = borderWidth == CGFloat.zero ? 0 : borderWidth
            layer.shadowColor = shadowColor?.cgColor
            
        case .focus:
            tempIconTintColor = iconFocusTintColor ?? EDTSColor.white
            tempBgTintColor = bgFocusTintColor ?? EDTSColor.blueDefault
            tempBorderColor = borderFocusColor ?? EDTSColor.blue30
            tempBorderWidth = borderWidth == CGFloat.zero ? 2 : borderWidth
            layer.shadowColor = shadowFocusColor?.cgColor
            
        case .disabled:
            tempIconTintColor = iconDisabledTintColor ?? EDTSColor.white
            tempBgTintColor = bgDisabledTintColor ?? EDTSColor.disabled
            tempBorderColor = borderDisabledColor ?? EDTSColor.disabled
            tempBorderWidth = borderWidth == CGFloat.zero ? 0 : borderWidth
            layer.shadowColor = shadowDisabledColor?.cgColor
            isUserInteractionEnabled = false
        
        case .danger:
            break
        }
        
        setupButtonStyle()
    }
    
    private func setupButtonSecondary(_ state: BtnState) {
        switch state {
        case .default:
            tempIconTintColor = iconTintColor ?? EDTSColor.blueDefault
            tempBgTintColor = bgTintColor ?? EDTSColor.white
            tempBorderColor = borderColor ?? EDTSColor.blueDefault
            tempBorderWidth = borderWidth == CGFloat.zero ? 1 : borderWidth
            layer.shadowColor = shadowColor?.cgColor
            
        case .focus:
            tempIconTintColor = iconFocusTintColor ?? EDTSColor.blueDefault
            tempBgTintColor = bgFocusTintColor ?? EDTSColor.white
            tempBorderColor = borderFocusColor ?? EDTSColor.blue30
            tempBorderWidth = borderWidth == CGFloat.zero ? 2 : borderWidth
            layer.shadowColor = shadowFocusColor?.cgColor
            
        case .disabled:
            tempIconTintColor = iconDisabledTintColor ?? EDTSColor.disabled
            tempBgTintColor = bgDisabledTintColor ?? EDTSColor.white
            tempBorderColor = borderDisabledColor ?? EDTSColor.disabled
            tempBorderWidth = borderWidth == CGFloat.zero ? 1 : borderWidth
            layer.shadowColor = shadowDisabledColor?.cgColor
            isUserInteractionEnabled = false
        
        case .danger:
            break
        }
        
        setupButtonStyle()
    }
    
    private func setupButtonTertiary(_ state: BtnState) {
        switch state {
        case .default:
            tempIconTintColor = iconTintColor ?? EDTSColor.greyText
            tempBgTintColor = bgTintColor ?? EDTSColor.white
            tempBorderColor = borderColor ?? EDTSColor.greyDefault
            tempBorderWidth = borderWidth == CGFloat.zero ? 1 : borderWidth
            layer.shadowColor = shadowColor?.cgColor
            
        case .focus:
            tempIconTintColor = iconFocusTintColor ?? EDTSColor.greyText
            tempBgTintColor = bgFocusTintColor ?? EDTSColor.grey20
            tempBorderColor = borderFocusColor ?? EDTSColor.greyPressed
            tempBorderWidth = borderWidth == CGFloat.zero ? 2 : borderWidth
            layer.shadowColor = shadowFocusColor?.cgColor
            
        case .disabled:
            tempIconTintColor = iconDisabledTintColor ?? EDTSColor.disabled
            tempBgTintColor = bgDisabledTintColor ?? EDTSColor.white
            tempBorderColor = borderDisabledColor ?? EDTSColor.disabled
            tempBorderWidth = borderWidth == CGFloat.zero ? 1 : borderWidth
            layer.shadowColor = shadowDisabledColor?.cgColor
            isUserInteractionEnabled = false
        
        case .danger:
            break
        }
        
        setupButtonStyle()
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
    
    private func setupPressGesture() {
        let pressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handlePress(_:))
        )
        pressGesture.minimumPressDuration = 0
        pressGesture.cancelsTouchesInView = false
        addGestureRecognizer(pressGesture)
    }
    
    @objc private func handlePress(_ gesture: UILongPressGestureRecognizer) {
        guard resolvedButtonState != .disabled else { return }
        
        switch gesture.state {
        case .began:
            guard resolvedButtonState != .disabled else { return }
            tempResolvedButtonState = resolvedButtonState
            setupButtonType()
            animateScaleDown()
            if (bgTintColorStart == nil && bgTintColorEnd == nil){
                showRipple(from: gesture.location(in: self), cornerRadius: tempCornerRadius, color: tempRippleColor)
            }
        case .ended:
            guard resolvedButtonState != .disabled else { return }
            setupButtonType()
            tempResolvedButtonState = nil
            animateScaleUp()
            hideRipple()
        case .cancelled, .failed:
            tempResolvedButtonState = nil
            animateScaleUp()
            hideRipple()
        default:
            break
        }
    }
}
