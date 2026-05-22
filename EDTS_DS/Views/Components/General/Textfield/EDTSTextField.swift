//
//  EDTSTextField.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 06/05/26.
//

import UIKit

public enum EDTSTextFieldState: String {
    case `default` = "default"
    case focus = "focus"
    case error = "error"
    case disabled = "disabled"
}

@IBDesignable
public class EDTSTextField: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var vTextField: UIView!
    @IBOutlet weak var ivLeading: UIImageView!
    @IBOutlet weak var ivTrailing: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRequired: UILabel!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var lblSupport: UILabel!
    @IBOutlet weak var lblCounter: UILabel!

    @IBOutlet weak var tfLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivLeadingWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivLeadingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vTextFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivTrailingWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivTrailingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vTextFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblSupportHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Inspectable
    
    @IBInspectable public var isStateDefault: Bool = false {
        didSet {
            state = EDTSTextFieldState.default.rawValue
            setupState()
        }
    }
    
    @IBInspectable public var isStateFocus: Bool = false {
        didSet {
            state = EDTSTextFieldState.focus.rawValue
            setupState()
        }
    }
    
    @IBInspectable public var isStateError: Bool = false {
        didSet {
            state = EDTSTextFieldState.error.rawValue
            setupState()
        }
    }
    
    @IBInspectable public var isStateDisabled: Bool = false {
        didSet {
            state = EDTSTextFieldState.disabled.rawValue
            tfValue.isEnabled = false
            setupState()
        }
    }
    
    @IBInspectable public var label: String? {
        didSet {
            lblTitle.attributedText = nil
            lblTitle.text = label
            
            setupLabelVisibility()
        }
    }
    
    public var labelAttributed: NSAttributedString? {
        didSet {
            lblTitle.text = nil
            lblTitle.attributedText = labelAttributed
        }
    }
    
    @IBInspectable public var labelColor: UIColor? {
        didSet {
            tfLabelColor = labelColor
            setupLabelColor()
        }
    }
    
    @IBInspectable public var labelFocusColor: UIColor? {
        didSet {
            tfLabelFocusColor = labelFocusColor
            setupLabelColor()
        }
    }
    
    @IBInspectable public var labelErrorColor: UIColor? {
        didSet {
            tfLabelErrorColor = labelErrorColor
            setupLabelColor()
        }
    }
    
    @IBInspectable public var labelDisabledColor: UIColor? {
        didSet {
            tfLabelDisabledColor = labelDisabledColor
            setupLabelColor()
        }
    }
    
    @IBInspectable public var labelfontName: String = "" {
        didSet {
            setupLabelFont()
        }
    }
    
    @IBInspectable public var labelFontSize: CGFloat = CGFloat.zero {
        didSet {
            setupLabelFont()
        }
    }
    
    @IBInspectable public var labelFontWeight: String? {
        didSet {
            setupLabelFont()
        }
    }
    
    @IBInspectable public var placeholder: String? {
        didSet {
            tfValue.placeholder = placeholder
        }
    }
    
    @IBInspectable public var placeholderColor: UIColor? {
        didSet {
            tfPlaceholderColor = placeholderColor
            setupPlaceholderColor()
        }
    }
    
    @IBInspectable public var placeholderFocusColor: UIColor? {
        didSet {
            tfPlaceholderFocusColor = placeholderFocusColor
            setupPlaceholderColor()
        }
    }
    
    @IBInspectable public var placeholderErrorColor: UIColor? {
        didSet {
            tfPlaceholderErrorColor = placeholderErrorColor
            setupPlaceholderColor()
        }
    }
    
    @IBInspectable public var placeholderDisabledColor: UIColor? {
        didSet {
            tfPlaceholderDisabledColor = placeholderDisabledColor
            setupPlaceholderColor()
        }
    }
    
    @IBInspectable public var placeholderFontName: String = "" {
        didSet {
            setupPlaceholderFont()
        }
    }
    
    @IBInspectable public var placeholderFontSize: CGFloat = CGFloat.zero {
        didSet {
            setupPlaceholderFont()
        }
    }
    
    @IBInspectable public var placeholderFontWeight: String? {
        didSet {
            setupPlaceholderFont()
        }
    }
    
    @IBInspectable public var value: String? {
        didSet {
            tfValue.text = value
        }
    }
    
    @IBInspectable public var valueColor: UIColor? {
        didSet {
            tfValueColor = valueColor
            setupValueColor()
        }
    }
    
    @IBInspectable public var valueFocusColor: UIColor? {
        didSet {
            tfValueFocusColor = valueFocusColor
            setupValueColor()
        }
    }
    
    @IBInspectable public var valueErrorColor: UIColor? {
        didSet {
            tfValueErrorColor = valueErrorColor
            setupValueColor()
        }
    }
    
    @IBInspectable public var valueDisabledColor: UIColor? {
        didSet {
            tfValueDisabledColor = valueDisabledColor
            setupValueColor()
        }
    }
    
    @IBInspectable public var valueFontName: String = "" {
        didSet {
            setupValueFont()
        }
    }
    
    @IBInspectable public var valueFontSize: CGFloat = CGFloat.zero {
        didSet {
            setupValueFont()
        }
    }
    
    @IBInspectable public var valueFontWeight: String? {
        didSet {
            setupValueFont()
        }
    }
    
    @IBInspectable public var iconLeading: UIImage? {
        didSet {
            setupIconLeading()
        }
    }
    
    @IBInspectable public var iconTintColorLeading: UIColor? {
        didSet {
            tfIconLeadingColor = iconTintColorLeading
            setupIconLeadingColor()
        }
    }
    
    @IBInspectable public var iconFocusTintColorLeading: UIColor? {
        didSet {
            tfIconLeadingFocusColor = iconFocusTintColorLeading
            setupIconLeadingColor()
        }
    }
    
    @IBInspectable public var iconErrorTintColorLeading: UIColor? {
        didSet {
            tfIconLeadingErrorColor = iconErrorTintColorLeading
            setupIconLeadingColor()
        }
    }
    
    @IBInspectable public var iconDisabledTintColorLeading: UIColor? {
        didSet {
            tfIconLeadingDisabledColor = iconDisabledTintColorLeading
            setupIconLeadingColor()
        }
    }
    
    @IBInspectable public var iconTrailing: UIImage? {
        didSet {
            setupIconTrailing()
        }
    }
    
    @IBInspectable public var iconTintColorTrailing: UIColor? {
        didSet {
            tfIconTrailingColor = iconTintColorTrailing
            setupIconTrailingColor()
        }
    }
    
    @IBInspectable public var iconFocusTintColorTrailing: UIColor? {
        didSet {
            tfIconTrailingFocusColor = iconFocusTintColorTrailing
            setupIconTrailingColor()
        }
    }
    
    @IBInspectable public var iconErrorTintColorTrailing: UIColor? {
        didSet {
            tfIconTrailingErrorColor = iconErrorTintColorTrailing
            setupIconTrailingColor()
        }
    }
    
    @IBInspectable public var iconDisabledTintColorTrailing: UIColor? {
        didSet {
            tfIconTrailingDisabledColor = iconDisabledTintColorTrailing
            setupIconTrailingColor()
        }
    }
    
    @IBInspectable public var bgColor: UIColor? {
        didSet {
            tfBackgroundColor = bgColor
            setupBackgroundColor()
        }
    }
    
    @IBInspectable public var bgFocusColor: UIColor? {
        didSet {
            tfBackgroundFocusColor = bgFocusColor
            setupBackgroundColor()
        }
    }
    
    @IBInspectable public var bgErrorColor: UIColor? {
        didSet {
            tfBackgroundErrorColor = bgErrorColor
            setupBackgroundColor()
        }
    }
    
    @IBInspectable public var bgDisabledColor: UIColor? {
        didSet {
            tfBackgroundDisabledColor = bgDisabledColor
            setupBackgroundColor()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 1.0 {
        didSet {
            tfBorderWidth = borderWidth
            setupBorderWidth()
        }
    }
    
    @IBInspectable public var borderFocusWidth: CGFloat = 1.0 {
        didSet {
            tfBorderFocusWidth = borderFocusWidth
            setupBorderWidth()
        }
    }
    
    @IBInspectable public var borderErrorWidth: CGFloat = 1.0 {
        didSet {
            tfBorderErrorWidth = borderErrorWidth
            setupBorderWidth()
        }
    }
    
    @IBInspectable public var borderDisabledWidth: CGFloat = 1.0 {
        didSet {
            tfBorderDisabledWidth = borderDisabledWidth
            setupBorderWidth()
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            tfBorderColor = borderColor
            setupBorderColor()
        }
    }
    
    @IBInspectable public var borderFocusColor: UIColor? {
        didSet {
            tfBorderFocusColor = borderFocusColor
            setupBorderColor()
        }
    }
    
    @IBInspectable public var borderErrorColor: UIColor? {
        didSet {
            tfBorderErrorColor = borderErrorColor
            setupBorderColor()
        }
    }
    
    @IBInspectable public var borderDisabledColor: UIColor? {
        didSet {
            tfBorderDisabledColor = borderDisabledColor
            setupBorderColor()
        }
    }
    
    @IBInspectable public var supportMessage: String? {
        didSet {
            setupSupportTextVisibility()
        }
    }
    
    @IBInspectable public var supportMessageColor: UIColor? {
        didSet {
            tfSupportColor = supportMessageColor
            setupSupportTextColor()
        }
    }
    
    @IBInspectable public var supportMessageFocusColor: UIColor? {
        didSet {
            tfSupportFocusColor = supportMessageFocusColor
            setupSupportTextColor()
        }
    }
    
    @IBInspectable public var supportMessageErrorColor: UIColor? {
        didSet {
            tfSupportErrorColor = supportMessageErrorColor
            setupSupportTextColor()
        }
    }
    
    @IBInspectable public var supportMessageDisabledColor: UIColor? {
        didSet {
            tfSupportDisabledColor = supportMessageDisabledColor
            setupSupportTextColor()
        }
    }
    
    @IBInspectable public var supportMessageFontName: String = "" {
        didSet {
            setupSupportTextFont()
        }
    }
    
    @IBInspectable public var supportMessageFontSize: CGFloat = CGFloat.zero {
        didSet {
            setupSupportTextFont()
        }
    }
    
    @IBInspectable public var supportMessageFontWeight: String? {
        didSet {
            setupSupportTextFont()
        }
    }
    
    @IBInspectable public var counterMax: Int = -1 {
        didSet {
            setupCounterText()
            tfCounterMax = counterMax
        }
    }
    
    @IBInspectable public var counterColor: UIColor? {
        didSet {
            tfCounterColor = counterColor
            setupCounterTextColor()
        }
    }
    
    @IBInspectable public var counterFocusColor: UIColor? {
        didSet {
            tfCounterFocusColor = counterFocusColor
            setupCounterTextColor()
        }
    }
    
    @IBInspectable public var counterErrorColor: UIColor? {
        didSet {
            tfCounterErrorColor = counterErrorColor
            setupCounterTextColor()
        }
    }
    
    @IBInspectable public var counterDisabledColor: UIColor? {
        didSet {
            tfCounterDisabledColor = counterDisabledColor
            setupCounterTextColor()
        }
    }
    
    @IBInspectable public var counterfontName: String = "" {
        didSet {
            setupCounterTextFont()
        }
    }
    
    @IBInspectable public var counterFontSize: CGFloat = CGFloat.zero {
        didSet {
            setupCounterTextFont()
        }
    }
    
    @IBInspectable public var counterFontWeight: String? {
        didSet {
            setupCounterTextFont()
        }
    }
    
    @IBInspectable public var isCounterHide: Bool = false {
        didSet {
            setupCounterText()
        }
    }
    
    @IBInspectable public var isRequired: Bool = false {
        didSet {
            setupRequired()
        }
    }
    
    @IBInspectable public var isIconLeadingClickable: Bool = false {
        didSet {
            ivLeading.isUserInteractionEnabled = isIconLeadingClickable
        }
    }

    @IBInspectable public var isIconTrailingClickable: Bool = false {
        didSet {
            ivTrailing.isUserInteractionEnabled = isIconTrailingClickable
        }
    }
    
    @IBInspectable public var isPassword: Bool = false {
        didSet {
            setupPasswordToggle()
        }
    }
    
    @IBInspectable public var isPasswordToggleHide: Bool = false {
        didSet {
            setupPasswordToggle()
        }
    }
    
    @IBInspectable public var isClearable: Bool = false {
        didSet {
            setupClearButton()
        }
    }
    
    @IBInspectable public var isEditable: Bool = false {
        didSet {
            tfValue.isEnabled = !isEditable
        }
    }
    
    @IBInspectable public var padding: CGFloat = 4.0 {
        didSet {
            tfPaddingLeading = padding
            tfPaddingTrailing = padding
            tfPaddingTop = padding
            tfPaddingBottom = padding
            setupPadding()
        }
    }
    
    @IBInspectable public var paddingLeading: CGFloat = 12.0 {
        didSet {
            tfPaddingLeading = paddingLeading
            setupPadding()
        }
    }
    
    @IBInspectable public var paddingTrailing: CGFloat = 12.0 {
        didSet {
            tfPaddingTrailing = paddingTrailing
            setupPadding()
        }
    }
    
    @IBInspectable public var paddingTop: CGFloat = 12.0 {
        didSet {
            tfPaddingTop = paddingTop
            setupPadding()
        }
    }
    
    @IBInspectable public var paddingBottom: CGFloat = 12.0 {
        didSet {
            tfPaddingBottom = paddingBottom
            setupPadding()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 4.0 {
        didSet {
            vTextField.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var keyboardType: UIKeyboardType = .alphabet {
        didSet {
            tfValue.keyboardType = keyboardType
        }
    }
    
    @IBInspectable public var returnKeyType: UIReturnKeyType = .done {
        didSet {
            tfValue.returnKeyType = returnKeyType
        }
    }
    
    // MARK: - Public Variable
    
    public var onTextChanged: ((String) -> Void)?
    
    // MARK: - Private Variable
    
    private weak var delegate: EDTSTextFieldDelegate?
    
    private var state: String = EDTSTextFieldState.default.rawValue {
        didSet {
            setupState()
        }
    }
    
    private var currentState: EDTSTextFieldState {
        EDTSTextFieldState(rawValue: state) ?? .default
    }
    
    private var tfCounterMax: Int = 255
    
    private var tfLabelColor: UIColor? = EDTSColor.grey60
    private var tfLabelFocusColor: UIColor? = EDTSColor.grey60
    private var tfLabelErrorColor: UIColor? = EDTSColor.grey60
    private var tfLabelDisabledColor: UIColor? = EDTSColor.grey60
    
    private var tfPlaceholderColor: UIColor? = EDTSColor.grey50
    private var tfPlaceholderFocusColor: UIColor? = EDTSColor.grey50
    private var tfPlaceholderErrorColor: UIColor? = EDTSColor.grey50
    private var tfPlaceholderDisabledColor: UIColor? = EDTSColor.grey50
    
    private var tfValueColor: UIColor? = EDTSColor.grey80
    private var tfValueFocusColor: UIColor? = EDTSColor.grey80
    private var tfValueErrorColor: UIColor? = EDTSColor.grey80
    private var tfValueDisabledColor: UIColor? = EDTSColor.grey60
    
    private var tfIconLeadingColor: UIColor? = EDTSColor.grey60
    private var tfIconLeadingFocusColor: UIColor? = EDTSColor.grey60
    private var tfIconLeadingErrorColor: UIColor? = EDTSColor.grey60
    private var tfIconLeadingDisabledColor: UIColor? = EDTSColor.grey60
    
    private var tfIconTrailingColor: UIColor? = EDTSColor.grey60
    private var tfIconTrailingFocusColor: UIColor? = EDTSColor.grey60
    private var tfIconTrailingErrorColor: UIColor? = EDTSColor.grey60
    private var tfIconTrailingDisabledColor: UIColor? = EDTSColor.grey60
    
    private var tfBackgroundColor: UIColor? = EDTSColor.white
    private var tfBackgroundFocusColor: UIColor? = EDTSColor.white
    private var tfBackgroundErrorColor: UIColor? = EDTSColor.errorWeak
    private var tfBackgroundDisabledColor: UIColor? = EDTSColor.grey20
    
    private var tfBorderColor: UIColor? = EDTSColor.grey30
    private var tfBorderFocusColor: UIColor? = EDTSColor.blue30
    private var tfBorderErrorColor: UIColor? = EDTSColor.errorStrong
    private var tfBorderDisabledColor: UIColor? = EDTSColor.grey30
    
    private var tfBorderWidth: CGFloat = 1.0
    private var tfBorderFocusWidth: CGFloat = 1.0
    private var tfBorderErrorWidth: CGFloat = 1.0
    private var tfBorderDisabledWidth: CGFloat = 1.0
    
    private var tfSupportColor: UIColor? = EDTSColor.grey50
    private var tfSupportFocusColor: UIColor? = EDTSColor.grey50
    private var tfSupportErrorColor: UIColor? = EDTSColor.errorStrong
    private var tfSupportDisabledColor: UIColor? = EDTSColor.grey50
    
    private var tfCounterColor: UIColor? = EDTSColor.grey50
    private var tfCounterFocusColor: UIColor? = EDTSColor.grey50
    private var tfCounterErrorColor: UIColor? = EDTSColor.errorStrong
    private var tfCounterDisabledColor: UIColor? = EDTSColor.grey50
    
    private var tfPaddingLeading: CGFloat = 12.0
    private var tfPaddingTop: CGFloat = 12.0
    private var tfPaddingTrailing: CGFloat = 12.0
    private var tfPaddingBottom: CGFloat = 12.0
    
    // MARK: Public Func
    
    public var currentTextFieldState: EDTSTextFieldState {
        return currentState
    }

    public var text: String? {
        return tfValue.text
    }
    
    // MARK: - First Responder

    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        return tfValue.becomeFirstResponder()
    }

    @discardableResult
    override public func resignFirstResponder() -> Bool {
        return tfValue.resignFirstResponder()
    }
    
    // MARK: - Intrinsic Size

    override public var intrinsicContentSize: CGSize {
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
        return containerView.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )
    }

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }

    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSTextField", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            setupUI()
        }
    }

    // MARK: - Setup

    private func setupUI() {
        setupActions()
        setupTextField()
        setupState()
        setupIconLeading()
        setupIconTrailing()
        setupClearButton()
        setupSupportText()
        setupCounterText()
        setupRequired()
        setupPadding()
    }

    private func setupTextField() {
        tfValue.font = EDTSFont.B2.Regular.font
        tfValue.borderStyle = .none
        tfValue.isEnabled = true
        vTextField.layer.cornerRadius = cornerRadius
    }

    private func setupState() {
        setupLabelColor()
        setupPlaceholderColor()
        setupValueColor()
        setupIconLeadingColor()
        setupIconTrailingColor()
        setupBackgroundColor()
        setupBorderWidth()
        setupBorderColor()
        setupSupportTextColor()
        setupCounterTextColor()
    }
    
    // MARK: - State Helpers

    private func themed<T>(`default`: T, focus: T, error: T, disabled: T) -> T {
        switch currentState {
        case .default:  return `default`
        case .focus:    return focus
        case .error:    return error
        case .disabled: return disabled
        }
    }
    
    // MARK: - Text
    
    private func setupLabelFont() {
        let size = labelFontSize
        let weight = setupFontWeight(from: labelFontWeight ?? "semibold")
        
        if !labelfontName.isEmpty {
            lblTitle.font = UIFont(name: labelfontName, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            lblTitle.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    private func setupLabelColor() {
        lblTitle.font = EDTSFont.H3.font
        lblTitle.textColor = themed(
            default: tfLabelColor,
            focus: tfLabelFocusColor,
            error: tfLabelErrorColor,
            disabled: tfLabelDisabledColor
        )
        
        setupLabelVisibility()
    }
    
    private func setupLabelVisibility() {
        let isLabelHide = label == nil || label == ""
        if isLabelHide {
            lblTitle.text = ""
            lblRequired.text = ""
        } else {
            lblRequired.text = isRequired ? "*" : ""
        }
        lblTitleBottomConstraint?.constant = !isLabelHide ? 8 : 0
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }

    // MARK: - Placeholder
    
    private func setupPlaceholderFont() {
        let placeholderSize = placeholderFontSize
        let placeholderWeight = setupFontWeight(from: placeholderFontWeight ?? "light")
        
        let placeholderFont: UIFont
        if !placeholderFontName.isEmpty {
            placeholderFont = UIFont(name: placeholderFontName, size: placeholderSize)
                           ?? UIFont.systemFont(ofSize: placeholderSize, weight: placeholderWeight)
        } else {
            placeholderFont = UIFont.systemFont(ofSize: placeholderSize, weight: placeholderWeight)
        }
        
        tfValue.attributedPlaceholder = NSAttributedString(
            string: tfValue.placeholder ?? "",
            attributes: [
                .font: placeholderFont,
                .foregroundColor: UIColor.placeholderText
            ]
        )
    }

    private func setupPlaceholderColor() {
        let color = themed(
            default: tfPlaceholderColor,
            focus: tfPlaceholderFocusColor,
            error: tfPlaceholderErrorColor,
            disabled: tfPlaceholderDisabledColor
        ) ?? EDTSColor.grey50

        tfValue.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: color, .font: EDTSFont.B2.Regular.font]
        )
    }

    // MARK: - Value

    private func setupValueFont() {
        let valueSize = valueFontSize
        let valueWeight = setupFontWeight(from: valueFontWeight ?? "light")
        
        if !valueFontName.isEmpty {
            tfValue.font = UIFont(name: valueFontName, size: valueSize)
                        ?? UIFont.systemFont(ofSize: valueSize, weight: valueWeight)
        } else {
            tfValue.font = UIFont.systemFont(ofSize: valueSize, weight: valueWeight)
        }
    }
    
    private func setupValueColor() {
        tfValue.textColor = themed(
            default: tfValueColor,
            focus: tfValueFocusColor,
            error: tfValueErrorColor,
            disabled: tfValueDisabledColor
        )
    }

    // MARK: - Icons

    private func setupIconLeadingColor() {
        ivLeading.tintColor = themed(
            default: tfIconLeadingColor,
            focus: tfIconLeadingFocusColor,
            error: tfIconLeadingErrorColor,
            disabled: tfIconLeadingDisabledColor
        )
    }

    private func setupIconTrailingColor() {
        guard !isPassword else { return }
        ivTrailing.tintColor = themed(
            default: tfIconTrailingColor,
            focus: tfIconTrailingFocusColor,
            error: tfIconTrailingErrorColor,
            disabled: tfIconTrailingDisabledColor
        )
    }

    private func setupIconLeading() {
        ivLeading.image = iconLeading?.withRenderingMode(.alwaysTemplate)
        ivLeading.tintColor = EDTSColor.grey60

        let hasIcon = iconLeading != nil
        ivLeading.isHidden = !hasIcon
        ivLeading.isUserInteractionEnabled = isIconLeadingClickable
        
        ivLeadingWidthConstraint?.constant = hasIcon ? 24 : 0
        ivLeadingHeightConstraint?.constant = hasIcon ? 24 : 0
        vTextFieldLeadingConstraint?.constant = hasIcon ? 8 : 0
        
        layoutIfNeeded()
    }

    private func setupIconTrailing() {
        guard !isPassword else { return }

        ivTrailing.image = iconTrailing?.withRenderingMode(.alwaysTemplate)
        ivTrailing.tintColor = EDTSColor.grey60

        let hasIcon = iconTrailing != nil
        ivTrailing.isHidden = !hasIcon
        ivTrailing.isUserInteractionEnabled = isIconTrailingClickable
        
        ivTrailingWidthConstraint?.constant = hasIcon ? 24 : 0
        ivTrailingHeightConstraint?.constant = hasIcon ? 24 : 0
        vTextFieldTrailingConstraint?.constant = hasIcon ? 8 : 0
        
        layoutIfNeeded()
    }

    // MARK: - Background & Border

    private func setupBackgroundColor() {
        let color = themed(
            default: tfBackgroundColor,
            focus: tfBackgroundFocusColor,
            error: tfBackgroundErrorColor,
            disabled: tfBackgroundDisabledColor
        )
        
        let animation = CABasicAnimation(keyPath: "bgColor")
        animation.fromValue = vTextField.backgroundColor
        animation.toValue = color
        animation.duration = 0.25
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        vTextField.layer.add(animation, forKey: "bgColor")
        vTextField.backgroundColor = color
    }
    
    private func setupBorderWidth() {
        vTextField.layer.borderWidth = themed(
            default: tfBorderWidth,
            focus: tfBorderFocusWidth,
            error: tfBorderErrorWidth,
            disabled: tfBorderDisabledWidth
        )
    }

    private func setupBorderColor() {
        let color = themed(
            default: tfBorderColor,
            focus: tfBorderFocusColor,
            error: tfBorderErrorColor,
            disabled: tfBorderDisabledColor
        )?.cgColor
        
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = vTextField.layer.presentation()?.borderColor
        animation.toValue = color
        animation.duration = 0.25
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        vTextField.layer.add(animation, forKey: "borderColor")
        vTextField.layer.borderColor = color
    }

    // MARK: - Support Label

    private func setupSupportText() {
        lblSupport.font = EDTSFont.B4.Regular.font
        setupSupportTextVisibility()
    }
    
    private func setupSupportTextFont() {
        let size = supportMessageFontSize
        let weight = setupFontWeight(from: supportMessageFontWeight ?? "light")
        
        if !supportMessageFontName.isEmpty {
            lblSupport.font = UIFont(name: supportMessageFontName, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            lblSupport.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
    }

    private func setupSupportTextColor() {
        lblSupport.textColor = themed(
            default: tfSupportColor,
            focus: tfSupportFocusColor,
            error: tfSupportErrorColor,
            disabled: tfSupportDisabledColor
        )
    }

    private func setupSupportTextVisibility() {
        let hasMessage = supportMessage != nil
        lblSupport.isHidden = !hasMessage
        lblSupport.text = supportMessage ?? ""
        lblSupportHeightConstraint?.isActive = !hasMessage
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }

    // MARK: - Counter Label

    private func setupCounterText() {
        lblCounter.font = EDTSFont.B4.Regular.font

        let hasCounter = counterMax != -1 && !isCounterHide
        lblCounter.isHidden = !hasCounter
        lblCounter.text = hasCounter ? "\(tfValue.text?.count ?? 0)/\(counterMax)" : ""

        if hasCounter {
            if supportMessage == nil { lblSupport.text = "ic_placeholder" }
            lblSupportHeightConstraint?.isActive = false
        }

        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupCounterTextFont() {
        let size = counterFontSize
        let weight = setupFontWeight(from: counterFontWeight ?? "light")
        
        if !counterfontName.isEmpty {
            lblCounter.font = UIFont(name: counterfontName, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            lblCounter.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
    }

    private func setupCounterTextColor() {
        lblCounter.textColor = themed(
            default: tfCounterColor,
            focus: tfCounterFocusColor,
            error: tfCounterErrorColor,
            disabled: tfCounterDisabledColor
        )
    }

    private func updateCounterText() {
        guard counterMax != -1 else {
            lblCounter.text = ""
            return
        }
        let currentCount = tfValue.text?.count ?? 0
        lblCounter.text = "\(currentCount)/\(counterMax)"
    }

    // MARK: - Required Label

    private func setupRequired() {
        lblRequired.font = EDTSFont.H3.font
        lblRequired.textColor = EDTSColor.red30
        lblRequired.isHidden = !isRequired
        lblRequired.text = "*"
        
        setupLabelVisibility()
    }

    // MARK: - Password Toggle

    private func setupPasswordToggle() {
        guard isPassword else {
            tfValue.isSecureTextEntry = false
            setupIconTrailing()
            return
        }

        tfValue.isSecureTextEntry = true

        guard !isPasswordToggleHide else {
            ivTrailing.isHidden = true
            ivTrailingWidthConstraint?.constant = 0
            vTextFieldTrailingConstraint?.constant = 0
            layoutIfNeeded()
            return
        }

        updatePasswordIcon()

        ivTrailing.isHidden = false
        ivTrailing.tintColor = EDTSColor.grey50
        ivTrailingWidthConstraint?.constant = 24
        vTextFieldTrailingConstraint?.constant = 8
        layoutIfNeeded()

        ivTrailing.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        ivTrailing.addGestureRecognizer(tap)
    }

    private func updatePasswordIcon() {
        let iconName = tfValue.isSecureTextEntry ? "ic_visibility_off" : "ic_visibility_on"
        let bundle = Bundle(for: type(of: self))
        ivTrailing.image = UIImage(named: iconName, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    
    // MARK: - Clear Button

    private func setupClearButton() {
        guard isClearable else { return }

        let hasText = !(tfValue.text?.isEmpty ?? true)
        let bundle = Bundle(for: type(of: self))
        ivTrailing.image = UIImage(named: "ic_error", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        ivTrailing.tintColor = EDTSColor.grey50
        ivTrailing.isHidden = false
        ivTrailingWidthConstraint?.constant = 24
        ivTrailingHeightConstraint?.constant = 24
        vTextFieldTrailingConstraint?.constant = 8
        layoutIfNeeded()

        UIView.animate(withDuration: 0.2) {
            self.ivTrailing.alpha = hasText ? 1 : 0
        }
    }
    
    // MARK: - Setup Padding
    
    private func setupPadding() {
        tfLeadingConstraint?.constant = tfPaddingLeading
        tfTrailingConstraint?.constant = tfPaddingTrailing
        tfTopConstraint?.constant = tfPaddingTop
        tfBottomConstraint?.constant = tfPaddingBottom
    }

    //MARK: Action
    
    private func setupActions() {
        tfValue.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tfValue.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        tfValue.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        
        ivLeading.isUserInteractionEnabled = true
        let leadingPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(onLongPressLeadingIcon(_:))
        )
        leadingPress.minimumPressDuration = 0
        ivLeading.addGestureRecognizer(leadingPress)
        
        ivTrailing.isUserInteractionEnabled = true
        let trailingPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(onLongPressTrailingIcon(_:))
        )
        trailingPress.minimumPressDuration = 0
        ivTrailing.addGestureRecognizer(trailingPress)
    }
    
    @objc private func textFieldDidChange() {
        if counterMax != -1 {
            let currentText = tfValue.text ?? ""
            if currentText.count > counterMax {
                tfValue.text = String(currentText.prefix(counterMax))
            }
        }

        if isClearable { setupClearButton() }
        onTextChanged?(tfValue.text ?? "")
        updateCounterText()
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: tfValue)
    }
    
    @objc private func textFieldDidBeginEditing() {
        isStateFocus = true
        state = EDTSTextFieldState.focus.rawValue
        setupState()
    }
    
    @objc private func textFieldDidEndEditing() {
        isStateDefault = true
        state = EDTSTextFieldState.default.rawValue
        setupState()
    }
    
    @objc private func togglePasswordVisibility() {
        guard isPassword else { return }

        ivTrailing.showIconRipple(color: EDTSColor.grey30.withAlphaComponent(0.40))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.ivTrailing.hideIconRipple()
        }

        tfValue.isSecureTextEntry.toggle()
        updatePasswordIcon()
        ivTrailing.tintColor = EDTSColor.grey50
    }
    
    @objc private func onLongPressLeadingIcon(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            ivLeading.showIconRipple(size: ivLeading.bounds.width + 8, color: EDTSColor.grey30.withAlphaComponent(0.40))
            
        case .ended:
            delegate?.didSelectTextFieldIconLeading(self)
            ivLeading.hideIconRipple()
            
        case .cancelled, .failed:
            ivLeading.hideIconRipple()
            
        default:
            break
        }
    }
    
    @objc private func onLongPressTrailingIcon(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            ivTrailing.showIconRipple(size: ivTrailing.bounds.width + 8, color: EDTSColor.grey30.withAlphaComponent(0.40))
            
        case .ended:
            if isClearable {
                tfValue.text = ""
                onTextChanged?("")
                updateCounterText()
                setupClearButton()
                NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: tfValue)
            } else {
                delegate?.didSelectTextFieldIconTrailing(self)
            }
            ivTrailing.hideIconRipple()
            
        case .cancelled, .failed:
            ivTrailing.hideIconRipple()
            
        default:
            break
        }
    }
}

// MARK: Delegate

@MainActor
public protocol EDTSTextFieldDelegate: AnyObject {
    func didSelectTextFieldIconLeading(_ textField: EDTSTextField)
    func didSelectTextFieldIconTrailing(_ textField: EDTSTextField)
}
