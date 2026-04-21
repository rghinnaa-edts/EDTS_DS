//
//  Button.swift
//  KlikIDM_DS
//
//  Created by Yovita Handayiani on 09/01/26.
//

import UIKit

@IBDesignable
public class Button: UIButton {
    // MARK: - Inspectables
    @IBInspectable public var btnType: String?{
        didSet {
            setupButtonType(resolvedButtonState)
        }
    }
    
    @IBInspectable public var btnSize: String?{
        didSet {
            setupButtonSize()
        }
    }
    
    @IBInspectable public var btnState: String?{
        didSet {
            setupButtonType(resolvedButtonState)
        }
    }
    
    @IBInspectable public var label: String?{
        didSet{
            lblTitle.attributedText = nil
            lblTitle.text = label ?? "Button"
        }
    }
    
    public var labelAttributed: NSAttributedString? {
        didSet {
            lblTitle.text = nil
            lblTitle.attributedText = labelAttributed
        }
    }
    
    @IBInspectable public var labelColor: UIColor?{
        didSet{
            lblTitle.textColor = labelColor
        }
    }
    
    @IBInspectable public var fontName: String = "" {
        didSet {
            setupFont()
        }
    }
    
    @IBInspectable public var fontSize: CGFloat = CGFloat.zero{
        didSet {
            setupButtonSize()
        }
    }
    
    @IBInspectable public var fontWeight: String?{
        didSet {
            setupButtonSize()
        }
    }
    
    @IBInspectable public var bgColor: UIColor?{
        didSet{
            setupButtonType(resolvedButtonState)
        }
    }
    
    @IBInspectable public var bgColorStart: UIColor?{
        didSet {
            setupBackground()
        }
    }
    
    @IBInspectable public var bgColorEnd: UIColor?{
        didSet {
            setupBackground()
        }
    }
    
    @IBInspectable public var bgColorOrientation: String?{
        didSet {
            setupBackground()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = -1.0 {
        didSet {
            setupButtonSize()
        }
    }
    
    @IBInspectable public var iconLeading: UIImage?{
        didSet{
            setupIcon()
        }
    }
    
    @IBInspectable public var iconTintLeading: UIColor?{
        didSet{
            setupButtonType(resolvedButtonState)
        }
    }
    
    @IBInspectable public var iconTrailing: UIImage?{
        didSet{
            setupIcon()
        }
    }
    
    @IBInspectable public var iconTintTrailing: UIColor?{
        didSet{
            setupButtonType(resolvedButtonState)
        }
    }
    
    @IBInspectable public var iconSpacing: CGFloat = CGFloat.zero{
        didSet {
            hStackContainer.spacing = iconSpacing
        }
    }
    
    @IBInspectable public var iconSize: CGFloat = CGFloat.zero{
        didSet {
            setupIconConstraint()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = CGFloat.zero{
        didSet{
            setupButtonType(resolvedButtonState)
        }
    }
    
    @IBInspectable public var borderColor: UIColor?{
        didSet{
            setupButtonType(resolvedButtonState)
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
            layer.shadowColor = shadowColor?.cgColor
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
    private let ivLeadingIcon = UIImageView()
    private let ivTrailingIcon = UIImageView()
    private let lblTitle = UILabel()
    private let hStackContainer = UIStackView()
    private let defaultValue : CGFloat = -1.0
    
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    private var leadingIconWidthConstraint: NSLayoutConstraint?
    private var leadingIconHeightConstraint: NSLayoutConstraint?
    private var trailingIconWidthConstraint: NSLayoutConstraint?
    private var trailingIconHeightConstraint: NSLayoutConstraint?
    
    private var gradientLayer: CAGradientLayer?
    
    private var tempIconTintLeading: UIColor?
    private var tempIconTintTrailing: UIColor?
    private var tempLabelColor: UIColor?
    private var tempBgColor: UIColor?
    private var tempBorderColor: UIColor?
    private var tempBorderWidth: CGFloat = CGFloat.zero
    private var tempIconSize: CGFloat = CGFloat.zero
    private var tempFontSize: CGFloat = CGFloat.zero
    private var tempFontWeight: String?
    private var tempCornerRadius: CGFloat = -1.0
    private var tempIconSpacing: CGFloat = CGFloat.zero
    private var tempPaddingTop: CGFloat = -1.0
    private var tempPaddingBottom: CGFloat = -1.0
    private var tempPaddingLeading: CGFloat = -1.0
    private var tempPaddingTrailing: CGFloat = -1.0
    
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
        guard let state = btnState else { return .rest }
        let normalized = state.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return BtnState(rawValue: normalized) ?? .rest
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
    }
    
    override public var intrinsicContentSize: CGSize {
        let stackSize = hStackContainer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(
            width: stackSize.width + paddingLeading + paddingTrailing,
            height: stackSize.height + paddingTop + paddingBottom
        )
    }
    
    // MARK: - Setup & Styling
    private func setupUI() {
        tintColor = .clear
        titleLabel?.isHidden = true
        backgroundColor = .clear
        
        [ivLeadingIcon, ivTrailingIcon].forEach {
            $0.contentMode = .scaleAspectFit
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = UIColor.white
        }
        
        lblTitle.text = "Button"
        lblTitle.textAlignment = .center
        hStackContainer.axis = .horizontal
        hStackContainer.alignment = .center
        hStackContainer.spacing = 8
        hStackContainer.addArrangedSubview(ivLeadingIcon)
        hStackContainer.addArrangedSubview(lblTitle)
        hStackContainer.addArrangedSubview(ivTrailingIcon)
        addSubview(hStackContainer)
        hStackContainer.isUserInteractionEnabled = false
        
        initConstraint()
        initIconConstraint()
        setupButtonSize()
        setupButtonType(resolvedButtonState)
        setupPressGesture()
    }
    
    private func setupIcon() {
        if let icon = iconLeading {
            ivLeadingIcon.isHidden = false
            ivLeadingIcon.image = icon.withRenderingMode(.alwaysTemplate)
        } else {
            ivLeadingIcon.isHidden = true
            ivLeadingIcon.image = nil
        }
        
        if let icon = iconTrailing {
            ivTrailingIcon.isHidden = false
            ivTrailingIcon.image = icon.withRenderingMode(.alwaysTemplate)
        } else {
            ivTrailingIcon.isHidden = true
            ivTrailingIcon.image = nil
        }
    }
    
    private func setupBackground() {
        if (bgColorStart != nil || bgColorEnd != nil) {
            if gradientLayer == nil {
                let gradient = CAGradientLayer()
                gradient.frame = bounds
                layer.insertSublayer(gradient, at: 0)
                gradientLayer = gradient
            }
            
            gradientLayer?.colors = [
                bgColorStart?.cgColor ?? UIColor.clear.cgColor,
                bgColorEnd?.cgColor ?? UIColor.clear.cgColor
            ]
            
            let normalized = bgColorOrientation?
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
            if tempBgColor == UIColor.clear {
                backgroundColor = .clear
            } else {
                backgroundColor = tempBgColor
            }
        }
    }
    
    private func setupFont() {
        let size = tempFontSize
        let weight = setupFontWeight(from: tempFontWeight ?? "Semibold")
        
        if !fontName.isEmpty {
            lblTitle.font = UIFont(name: fontName, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            lblTitle.font = UIFont.systemFont(ofSize: size, weight: weight)
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
    
    private func initIconConstraint() {
        ivLeadingIcon.translatesAutoresizingMaskIntoConstraints = false
        ivTrailingIcon.translatesAutoresizingMaskIntoConstraints = false
        
        leadingIconWidthConstraint = ivLeadingIcon.widthAnchor.constraint(equalToConstant: iconSize)
        leadingIconHeightConstraint = ivLeadingIcon.heightAnchor.constraint(equalToConstant: iconSize)
        trailingIconWidthConstraint = ivTrailingIcon.widthAnchor.constraint(equalToConstant: iconSize)
        trailingIconHeightConstraint = ivTrailingIcon.heightAnchor.constraint(equalToConstant: iconSize)
        
        NSLayoutConstraint.activate([
            leadingIconWidthConstraint!,
            leadingIconHeightConstraint!,
            trailingIconWidthConstraint!,
            trailingIconHeightConstraint!
        ])
    }
    
    private func initConstraint() {
        hStackContainer.translatesAutoresizingMaskIntoConstraints = false
        
        topConstraint = hStackContainer.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop)
        bottomConstraint = hStackContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingBottom)
        leadingConstraint = hStackContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingLeading)
        trailingConstraint = hStackContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddingTrailing)
        
        NSLayoutConstraint.activate([
            topConstraint!,
            bottomConstraint!,
            leadingConstraint!,
            trailingConstraint!
        ])
    }
    
    private func setupIconConstraint(){
        leadingIconWidthConstraint?.constant = tempIconSize
        leadingIconHeightConstraint?.constant = tempIconSize
        trailingIconWidthConstraint?.constant = tempIconSize
        trailingIconHeightConstraint?.constant = tempIconSize
    }
    
    private func setupConstraint(){
        topConstraint?.constant = tempPaddingTop
        bottomConstraint?.constant = -tempPaddingBottom
        leadingConstraint?.constant = tempPaddingLeading
        trailingConstraint?.constant = -tempPaddingTrailing
        invalidateIntrinsicContentSize()
    }
    
    private func setupButtonStyle() {
        setupIcon()
        ivLeadingIcon.tintColor = tempIconTintLeading
        ivTrailingIcon.tintColor = tempIconTintTrailing
        lblTitle.textColor = tempLabelColor
        layer.borderColor = tempBorderColor?.cgColor
        layer.borderWidth = tempBorderWidth
        setupBackground()
        setupFont()
    }
    
    private func setupButtonSize() {
        switch resolvedButtonSize {
        case .small:
            tempIconSize = iconSize == CGFloat.zero ? 16 : iconSize
            tempFontSize = fontSize == CGFloat.zero ? 12 : fontSize
            tempFontWeight = fontWeight ?? "semibold"
            tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            tempIconSpacing = iconSpacing == CGFloat.zero ? 8 : iconSpacing
            tempPaddingTop = paddingTop == defaultValue ? 6 : paddingTop
            tempPaddingBottom = paddingBottom == defaultValue ? 6 : paddingBottom
            tempPaddingLeading = paddingLeading == defaultValue ? 12 : paddingLeading
            tempPaddingTrailing = paddingTrailing == defaultValue ? 12 : paddingTrailing
            
        case .medium:
            tempIconSize = iconSize == CGFloat.zero ? 16 : iconSize
            tempFontSize = fontSize == CGFloat.zero ? 14 : fontSize
            tempFontWeight = fontWeight ?? "semibold"
            tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            tempIconSpacing = iconSpacing == CGFloat.zero ? 8 : iconSpacing
            tempPaddingTop = paddingTop == defaultValue ? 8 : paddingTop
            tempPaddingBottom = paddingBottom == defaultValue ? 8 : paddingBottom
            tempPaddingLeading = paddingLeading == defaultValue ? 12 : paddingLeading
            tempPaddingTrailing = paddingTrailing == defaultValue ? 12 : paddingTrailing
            
        case .large:
            tempIconSize = iconSize == CGFloat.zero ? 24 : iconSize
            tempFontSize = fontSize == CGFloat.zero ? 14 : fontSize
            tempFontWeight = fontWeight ?? "semibold"
            tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            tempIconSpacing = iconSpacing == CGFloat.zero ? 8 : iconSpacing
            tempPaddingTop = paddingTop == defaultValue ? 8 : paddingTop
            tempPaddingBottom = paddingBottom == defaultValue ? 8 : paddingBottom
            tempPaddingLeading = paddingLeading == defaultValue ? 12 : paddingLeading
            tempPaddingTrailing = paddingTrailing == defaultValue ? 12 : paddingTrailing
        }
        
        setupIconConstraint()
        setupConstraint()
        hStackContainer.spacing = tempIconSpacing
        layer.cornerRadius = tempCornerRadius
        setupFont()
    }
    
    private func setupButtonType(_ state: BtnState) {
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
        case .rest:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.white
            tempLabelColor = labelColor ?? EDTSColor.white
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.white
            tempBgColor = bgColor ?? EDTSColor.blueDefault
            tempBorderColor = borderColor ?? EDTSColor.blueDefault
            tempBorderWidth = borderWidth == CGFloat.zero ? 0 : borderWidth
            
        case .pressed:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.white
            tempLabelColor = labelColor ?? EDTSColor.white
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.white
            tempBgColor = bgColor ?? EDTSColor.bluePressed
            tempBorderColor = borderColor ?? EDTSColor.bluePressed
            tempBorderWidth = borderWidth == CGFloat.zero ? 0 : borderWidth
            
        case .focused:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.white
            tempLabelColor = labelColor ?? EDTSColor.white
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.white
            tempBgColor = bgColor ?? EDTSColor.blueDefault
            tempBorderColor = borderColor ?? EDTSColor.blue30
            tempBorderWidth = borderWidth == CGFloat.zero ? 2 : borderWidth
            
        case .danger:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.white
            tempLabelColor = labelColor ?? EDTSColor.white
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.white
            tempBgColor = bgColor ?? EDTSColor.errorStrong
            tempBorderColor = borderColor ?? EDTSColor.errorStrong
            tempBorderWidth = borderWidth == CGFloat.zero ? 0 : borderWidth
            
        case .disabled:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.white
            tempLabelColor = labelColor ?? EDTSColor.white
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.white
            tempBgColor = bgColor ?? EDTSColor.disabled
            tempBorderColor = borderColor ?? EDTSColor.disabled
            tempBorderWidth = borderWidth == CGFloat.zero ? 0 : borderWidth
            isUserInteractionEnabled = false
        }
        
        setupButtonStyle()
    }
    
    private func setupButtonSecondary(_ state: BtnState) {
        switch state {
        case .rest:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.blueDefault
            tempLabelColor = labelColor ?? EDTSColor.blueDefault
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.blueDefault
            tempBgColor = bgColor ?? EDTSColor.white
            tempBorderColor = borderColor ?? EDTSColor.blueDefault
            tempBorderWidth = borderWidth == CGFloat.zero ? 1 : borderWidth
            
        case .pressed:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.bluePressed
            tempLabelColor = labelColor ?? EDTSColor.bluePressed
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.bluePressed
            tempBgColor = bgColor ?? EDTSColor.white
            tempBorderColor = borderColor ?? EDTSColor.bluePressed
            tempBorderWidth = borderWidth == CGFloat.zero ? 1 : borderWidth
            
        case .focused:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.blueDefault
            tempLabelColor = labelColor ?? EDTSColor.blueDefault
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.blueDefault
            tempBgColor = bgColor ?? EDTSColor.white
            tempBorderColor = borderColor ?? EDTSColor.blue30
            tempBorderWidth = borderWidth == CGFloat.zero ? 2 : borderWidth
            
        case .danger:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.errorStrong
            tempLabelColor = labelColor ?? EDTSColor.errorStrong
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.errorStrong
            tempBgColor = bgColor ?? EDTSColor.white
            tempBorderColor = borderColor ?? EDTSColor.errorStrong
            tempBorderWidth = borderWidth == CGFloat.zero ? 1 : borderWidth
            
        case .disabled:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.disabled
            tempLabelColor = labelColor ?? EDTSColor.disabled
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.disabled
            tempBgColor = bgColor ?? EDTSColor.white
            tempBorderColor = borderColor ?? EDTSColor.disabled
            tempBorderWidth = borderWidth == CGFloat.zero ? 1 : borderWidth
            isUserInteractionEnabled = false
        }
        
        setupButtonStyle()
    }
    
    private func setupButtonTertiary(_ state: BtnState) {
        switch state {
        case .rest:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.greyText
            tempLabelColor = labelColor ?? EDTSColor.greyText
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.greyText
            tempBgColor = bgColor ?? EDTSColor.white
            tempBorderColor = borderColor ?? EDTSColor.greyDefault
            tempBorderWidth = borderWidth == CGFloat.zero ? 1 : borderWidth
            
        case .pressed:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.greyText
            tempLabelColor = labelColor ?? EDTSColor.greyText
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.greyText
            tempBgColor = bgColor ?? EDTSColor.grey20
            tempBorderColor = borderColor ?? EDTSColor.greyPressed
            tempBorderWidth = borderWidth == CGFloat.zero ? 1 : borderWidth
            
        case .focused:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.greyText
            tempLabelColor = labelColor ?? EDTSColor.greyText
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.greyText
            tempBgColor = bgColor ?? EDTSColor.grey20
            tempBorderColor = borderColor ?? EDTSColor.greyPressed
            tempBorderWidth = borderWidth == CGFloat.zero ? 2 : borderWidth
            
        case .danger:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.errorStrong
            tempLabelColor = labelColor ?? EDTSColor.errorStrong
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.errorStrong
            tempBgColor = bgColor ?? EDTSColor.white
            tempBorderColor = borderColor ?? EDTSColor.disabled
            tempBorderWidth = borderWidth == CGFloat.zero ? 1 : borderWidth
            
        case .disabled:
            tempIconTintLeading = iconTintLeading ?? EDTSColor.disabled
            tempLabelColor = labelColor ?? EDTSColor.disabled
            tempIconTintTrailing = iconTintTrailing ?? EDTSColor.disabled
            tempBgColor = bgColor ?? EDTSColor.white
            tempBorderColor = borderColor ?? EDTSColor.disabled
            tempBorderWidth = borderWidth == CGFloat.zero ? 1 : borderWidth
            isUserInteractionEnabled = false
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
            
            if(resolvedButtonState == .danger){
                setupButtonType(.danger)
            }else{
                setupButtonType(.pressed)
            }
            animateScaleDown()
            if (bgColor != nil && bgColor != .clear && bgColorStart == nil && bgColorEnd == nil){
                showRipple(from: gesture.location(in: self), cornerRadius: tempCornerRadius)
            }
        case .ended:
            guard resolvedButtonState != .disabled else { return }
            setupButtonType(resolvedButtonState)
            animateScaleUp()
            hideRipple()
        case .cancelled, .failed:
            animateScaleUp()
            hideRipple()
        default:
            break
        }
    }
}

public enum BtnState: String {
    case rest = "rest"
    case pressed = "pressed"
    case focused = "focused"
    case danger = "danger"
    case disabled = "disabled"
}

public enum BtnType: String {
    case primary = "primary"
    case secondary = "secondary"
    case tertiary = "tertiary"
}

public enum BtnSize: String {
    case small = "small"
    case medium = "medium"
    case large = "large"
}
