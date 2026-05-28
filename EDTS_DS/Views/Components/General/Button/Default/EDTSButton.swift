//
//  Button.swift
//  KlikIDM_DS
//
//  Created by Yovita Handayiani on 09/01/26.
//

import UIKit

public enum BtnState: String {
    case `default` = "default"
    case focus = "focus"
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

@IBDesignable
public class EDTSButton: UIButton {
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
            setupButtonType()
        }
    }
    
    @IBInspectable public var labelFocusColor: UIColor?{
        didSet{
            lblTitle.textColor = labelFocusColor
            setupButtonType()
        }
    }
    
    @IBInspectable public var labelDangerColor: UIColor?{
        didSet{
            lblTitle.textColor = labelDangerColor
            setupButtonType()
        }
    }
    
    @IBInspectable public var labelDisabledColor: UIColor?{
        didSet{
            lblTitle.textColor = labelDisabledColor
            setupButtonType()
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
            setupButtonType()
        }
    }
    
    @IBInspectable public var bgFocusColor: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var bgDangerColor: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var bgDisabledColor: UIColor?{
        didSet{
            setupButtonType()
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
    
    @IBInspectable public var iconLeading: UIImage?{
        didSet{
            setupIcon()
        }
    }
    
    @IBInspectable public var iconTintColorLeading: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var iconFocusTintColorLeading: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var iconDangerTintColorLeading: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var iconDisabledTintColorLeading: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var iconTrailing: UIImage?{
        didSet{
            setupIcon()
        }
    }
    
    @IBInspectable public var iconTintColorTrailing: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var iconFocusTintColorTrailing: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var iconDangerTintColorTrailing: UIColor?{
        didSet{
            setupButtonType()
        }
    }
    
    @IBInspectable public var iconDisabledTintColorTrailing: UIColor?{
        didSet{
            setupButtonType()
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
    
    @IBInspectable public var borderDangerColor: UIColor?{
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
    
    @IBInspectable public var shadowDangerColor: UIColor?{
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
    
    private var tempIconTintColorLeading: UIColor?
    private var tempIconTintColorTrailing: UIColor?
    private var tempLabelColor: UIColor?
    private var tempBgColor: UIColor?
    private var tempRippleColor: UIColor?
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
    private var tempResolvedButtonState: BtnState? = nil
    
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
    }
    
    override public var intrinsicContentSize: CGSize {
        let stackSize = hStackContainer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(
            width: stackSize.width + tempPaddingLeading + tempPaddingTrailing,
            height: stackSize.height + tempPaddingTop + tempPaddingBottom
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
            $0.tintColor = EDTSColor.white
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
        setupButtonType()
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
        
        topConstraint = hStackContainer.topAnchor.constraint(equalTo: topAnchor, constant: tempPaddingTop)
        bottomConstraint = hStackContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -tempPaddingBottom)
        leadingConstraint = hStackContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: tempPaddingLeading)
        trailingConstraint = hStackContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -tempPaddingTrailing)
        
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
        lblTitle.textColor = tempLabelColor
        layer.borderWidth = tempBorderWidth
        setupBackground()
        setupFont()
        
        switch resolvedButtonType {
        case .primary:
            ivLeadingIcon.tintColor = tempIconTintColorLeading
            ivTrailingIcon.tintColor = tempIconTintColorTrailing
            layer.borderColor = tempBorderColor?.cgColor
        case .secondary, .tertiary:
            if(labelColor != nil){
                if (iconTintColorLeading == nil){
                    ivLeadingIcon.tintColor = tempLabelColor
                }else{
                    ivLeadingIcon.tintColor = tempIconTintColorLeading
                }
                if (iconTintColorTrailing == nil){
                    ivTrailingIcon.tintColor = tempLabelColor
                }else{
                    ivTrailingIcon.tintColor = tempIconTintColorTrailing
                }
                if (borderColor == nil){
                    layer.borderColor = tempLabelColor?.cgColor
                }else{
                    layer.borderColor = tempBorderColor?.cgColor
                }
            }else{
                ivLeadingIcon.tintColor = tempIconTintColorLeading
                ivTrailingIcon.tintColor = tempIconTintColorTrailing
                layer.borderColor = tempBorderColor?.cgColor
            }
        }
        
        if rippleColor == nil {
            if tempBgColor == EDTSColor.white {
                tempRippleColor = tempLabelColor?.withAlphaComponent(0.12)
            }else if tempBgColor == .clear {
                tempRippleColor = tempLabelColor?.withAlphaComponent(0.12)
            }else if tempBgColor != EDTSColor.white {
                tempRippleColor = EDTSColor.grey70.withAlphaComponent(0.12)
            }
        } else {
            tempRippleColor = rippleColor?.withAlphaComponent(0.12)
        }
    }
    
    private func setupButtonSize() {
        switch resolvedButtonSize {
        case .small:
            tempIconSize = iconSize == CGFloat.zero ? 16 : iconSize
            lblTitle.font = EDTSFont.Button.Small.font
            tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            tempIconSpacing = iconSpacing == CGFloat.zero ? 8 : iconSpacing
            tempPaddingTop = paddingTop == defaultValue ? 6 : paddingTop
            tempPaddingBottom = paddingBottom == defaultValue ? 6 : paddingBottom
            tempPaddingLeading = paddingLeading == defaultValue ? 12 : paddingLeading
            tempPaddingTrailing = paddingTrailing == defaultValue ? 12 : paddingTrailing
            
        case .medium:
            tempIconSize = iconSize == CGFloat.zero ? 16 : iconSize
            lblTitle.font = EDTSFont.Button.Medium.font
            tempCornerRadius = cornerRadius == defaultValue ? 4 : cornerRadius
            tempIconSpacing = iconSpacing == CGFloat.zero ? 8 : iconSpacing
            tempPaddingTop = paddingTop == defaultValue ? 8 : paddingTop
            tempPaddingBottom = paddingBottom == defaultValue ? 8 : paddingBottom
            tempPaddingLeading = paddingLeading == defaultValue ? 12 : paddingLeading
            tempPaddingTrailing = paddingTrailing == defaultValue ? 12 : paddingTrailing
            
        case .large:
            tempIconSize = iconSize == CGFloat.zero ? 24 : iconSize
            lblTitle.font = EDTSFont.Button.Large.font
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
            tempIconTintColorLeading = iconTintColorLeading ?? EDTSColor.white
            tempLabelColor = labelColor ?? EDTSColor.white
            tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.white
            tempBgColor = bgColor ?? EDTSColor.blueDefault
            tempBorderColor = borderColor ?? EDTSColor.blueDefault
            tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            layer.shadowColor = shadowColor?.cgColor

        case .focus:
            tempIconTintColorLeading = iconFocusTintColorLeading ?? EDTSColor.white
            tempLabelColor = labelFocusColor ?? EDTSColor.white
            tempIconTintColorTrailing = iconFocusTintColorTrailing ?? EDTSColor.white
            tempBgColor = bgFocusColor ?? EDTSColor.blueDefault
            tempBorderColor = borderFocusColor ?? EDTSColor.blue30
            tempBorderWidth = borderWidth == .zero ? 2 : borderWidth
            layer.shadowColor = shadowFocusColor?.cgColor ?? shadowColor?.cgColor

        case .danger:
            tempIconTintColorLeading = iconDangerTintColorLeading ?? EDTSColor.white
            tempLabelColor = labelDangerColor ?? EDTSColor.white
            tempIconTintColorTrailing = iconDangerTintColorTrailing ?? EDTSColor.white
            tempBgColor = bgDangerColor ?? EDTSColor.errorStrong
            tempBorderColor = borderDangerColor ?? EDTSColor.errorStrong
            tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            layer.shadowColor = shadowDangerColor?.cgColor ?? shadowColor?.cgColor

        case .disabled:
            tempIconTintColorLeading = iconDisabledTintColorLeading ?? EDTSColor.white
            tempLabelColor = labelDisabledColor ?? EDTSColor.white
            tempIconTintColorTrailing = iconDisabledTintColorTrailing ?? EDTSColor.white
            tempBgColor = bgDisabledColor ?? EDTSColor.disabled
            tempBorderColor = borderDisabledColor ?? EDTSColor.disabled
            tempBorderWidth = borderWidth == .zero ? 0 : borderWidth
            layer.shadowColor = shadowDisabledColor?.cgColor ?? shadowColor?.cgColor
            isUserInteractionEnabled = false
        }

        setupButtonStyle()
    }
    
    private func setupButtonSecondary(_ state: BtnState) {
        switch state {
        case .default:
            tempIconTintColorLeading = iconTintColorLeading ?? EDTSColor.blueDefault
            tempLabelColor = labelColor ?? EDTSColor.blueDefault
            tempIconTintColorTrailing = iconTintColorTrailing ?? EDTSColor.blueDefault
            tempBgColor = bgColor ?? EDTSColor.white
            tempBorderColor = borderColor ?? EDTSColor.blueDefault
            tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            layer.shadowColor = shadowColor?.cgColor

        case .focus:
            tempIconTintColorLeading = iconFocusTintColorLeading ?? EDTSColor.blueDefault
            tempLabelColor = labelFocusColor ?? EDTSColor.blueDefault
            tempIconTintColorTrailing = iconFocusTintColorTrailing ?? EDTSColor.blueDefault
            tempBgColor = bgFocusColor ?? EDTSColor.white
            tempBorderColor = borderFocusColor ?? EDTSColor.blue30
            tempBorderWidth = borderWidth == .zero ? 2 : borderWidth
            layer.shadowColor = shadowFocusColor?.cgColor ?? shadowColor?.cgColor

        case .danger:
            tempIconTintColorLeading = iconDangerTintColorLeading ?? EDTSColor.errorStrong
            tempLabelColor = labelDangerColor ?? EDTSColor.errorStrong
            tempIconTintColorTrailing = iconDangerTintColorTrailing ?? EDTSColor.errorStrong
            tempBgColor = bgDangerColor ?? EDTSColor.white
            tempBorderColor = borderDangerColor ?? EDTSColor.errorStrong
            tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            layer.shadowColor = shadowDangerColor?.cgColor ?? shadowColor?.cgColor

        case .disabled:
            tempIconTintColorLeading = iconDisabledTintColorLeading ?? EDTSColor.disabled
            tempLabelColor = labelDisabledColor ?? EDTSColor.disabled
            tempIconTintColorTrailing = iconDisabledTintColorTrailing ?? EDTSColor.disabled
            tempBgColor = bgDisabledColor ?? EDTSColor.white
            tempBorderColor = borderDisabledColor ?? EDTSColor.disabled
            tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            layer.shadowColor = shadowDisabledColor?.cgColor ?? shadowColor?.cgColor
            isUserInteractionEnabled = false
        }

        setupButtonStyle()
    }

    private func setupButtonTertiary(_ state: BtnState) {
        switch state {
        case .default:
            tempIconTintColorLeading = iconTintColorLeading ?? EDTSColor.greyText
            tempLabelColor = labelColor ?? EDTSColor.greyText
            tempIconTintColorTrailing = iconTintColorLeading ?? EDTSColor.greyText
            tempBgColor = bgColor ?? EDTSColor.white
            tempBorderColor = borderColor ?? EDTSColor.greyDefault
            tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            layer.shadowColor = shadowColor?.cgColor

        case .focus:
            tempIconTintColorLeading = iconFocusTintColorLeading ?? EDTSColor.greyText
            tempLabelColor = labelFocusColor ?? EDTSColor.greyText
            tempIconTintColorTrailing = iconFocusTintColorTrailing ?? EDTSColor.greyText
            tempBgColor = bgFocusColor ?? EDTSColor.grey20
            tempBorderColor = borderFocusColor ?? EDTSColor.greyPressed
            tempBorderWidth = borderWidth == .zero ? 2 : borderWidth
            layer.shadowColor = shadowFocusColor?.cgColor ?? shadowColor?.cgColor

        case .danger:
            tempIconTintColorLeading = iconDangerTintColorLeading ?? EDTSColor.errorStrong
            tempLabelColor = labelDangerColor ?? EDTSColor.errorStrong
            tempIconTintColorTrailing = iconDangerTintColorTrailing ?? EDTSColor.errorStrong
            tempBgColor = bgDangerColor ?? EDTSColor.white
            tempBorderColor = borderDangerColor ?? EDTSColor.disabled
            tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            layer.shadowColor = shadowDangerColor?.cgColor ?? shadowColor?.cgColor

        case .disabled:
            tempIconTintColorLeading = iconDisabledTintColorLeading ?? EDTSColor.disabled
            tempLabelColor = labelDisabledColor ?? EDTSColor.disabled
            tempIconTintColorTrailing = iconDisabledTintColorTrailing ?? EDTSColor.disabled
            tempBgColor = bgDisabledColor ?? EDTSColor.white
            tempBorderColor = borderDisabledColor ?? EDTSColor.disabled
            tempBorderWidth = borderWidth == .zero ? 1 : borderWidth
            layer.shadowColor = shadowDisabledColor?.cgColor ?? shadowColor?.cgColor
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
            tempResolvedButtonState = resolvedButtonState
            setupButtonType()
            animateScaleDown()
            if (bgColorStart == nil && bgColorEnd == nil){
                showRipple(from: gesture.location(in: self), cornerRadius: tempCornerRadius, color: tempRippleColor)
            }
        case .ended:
            guard resolvedButtonState != .disabled else { return }
            tempResolvedButtonState = nil
            setupButtonType()
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
