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
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var vTextField: UIView!
    @IBOutlet weak var ivLeading: UIImageView!
    @IBOutlet weak var ivTrailing: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRequired: UILabel!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var lblSupport: UILabel!
    @IBOutlet weak var lblCounter: UILabel!

    @IBOutlet weak var ivLeadingWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var vTextFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivTrailingWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var vTextFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblSupportHeightConstraint: NSLayoutConstraint!
    
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
            setupState()
        }
    }
    
    @IBInspectable public var label: String? {
        didSet {
            lblTitle.text = label
        }
    }
    
    @IBInspectable public var labelColor: UIColor? {
        didSet {
            tfLabelColor = labelColor
        }
    }
    
    @IBInspectable public var labelFocusColor: UIColor? {
        didSet {
            tfLabelFocusColor = labelFocusColor
        }
    }
    
    @IBInspectable public var labelErrorColor: UIColor? {
        didSet {
            tfLabelErrorColor = labelErrorColor
        }
    }
    
    @IBInspectable public var labelDisabledColor: UIColor? {
        didSet {
            tfLabelDisabledColor = labelDisabledColor
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
        }
    }
    
    @IBInspectable public var placeholderFocusColor: UIColor? {
        didSet {
            tfPlaceholderFocusColor = placeholderFocusColor
        }
    }
    
    @IBInspectable public var placeholderErrorColor: UIColor? {
        didSet {
            tfPlaceholderErrorColor = placeholderErrorColor
        }
    }
    
    @IBInspectable public var placeholderDisabledColor: UIColor? {
        didSet {
            tfPlaceholderDisabledColor = placeholderDisabledColor
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
        }
    }
    
    @IBInspectable public var valueFocusColor: UIColor? {
        didSet {
            tfValueFocusColor = valueFocusColor
        }
    }
    
    @IBInspectable public var valueErrorColor: UIColor? {
        didSet {
            tfValueErrorColor = valueErrorColor
        }
    }
    
    @IBInspectable public var valueDisabledColor: UIColor? {
        didSet {
            tfValueDisabledColor = valueDisabledColor
        }
    }
    
    @IBInspectable public var iconLeading: UIImage? {
        didSet {
            setupIconLeading()
        }
    }
    
    @IBInspectable public var iconLeadingColor: UIColor? {
        didSet {
            tfIconLeadingColor = iconLeadingColor
        }
    }
    
    @IBInspectable public var iconLeadingFocusColor: UIColor? {
        didSet {
            tfIconLeadingFocusColor = iconLeadingFocusColor
        }
    }
    
    @IBInspectable public var iconLeadingErrorColor: UIColor? {
        didSet {
            tfIconLeadingErrorColor = iconLeadingErrorColor
        }
    }
    
    @IBInspectable public var iconLeadingDisabledColor: UIColor? {
        didSet {
            tfIconLeadingDisabledColor = iconLeadingDisabledColor
        }
    }
    
    @IBInspectable public var iconTrailing: UIImage? {
        didSet {
            setupIconTrailing()
        }
    }
    
    @IBInspectable public var iconTrailingColor: UIColor? {
        didSet {
            tfIconTrailingColor = iconTrailingColor
        }
    }
    
    @IBInspectable public var iconTrailingFocusColor: UIColor? {
        didSet {
            tfIconTrailingFocusColor = iconTrailingFocusColor
        }
    }
    
    @IBInspectable public var iconTrailingErrorColor: UIColor? {
        didSet {
            tfIconTrailingErrorColor = iconTrailingErrorColor
        }
    }
    
    @IBInspectable public var iconTrailingDisabledColor: UIColor? {
        didSet {
            tfIconTrailingDisabledColor = iconTrailingDisabledColor
        }
    }
    
    @IBInspectable public var bgColor: UIColor? {
        didSet {
            tfBackgroundColor = bgColor
        }
    }
    
    @IBInspectable public var bgFocusColor: UIColor? {
        didSet {
            tfBackgroundFocusColor = bgFocusColor
        }
    }
    
    @IBInspectable public var bgErrorColor: UIColor? {
        didSet {
            tfBackgroundErrorColor = bgErrorColor
        }
    }
    
    @IBInspectable public var bgDisabledColor: UIColor? {
        didSet {
            tfBackgroundDisabledColor = bgDisabledColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 1.0 {
        didSet {
            tfBorderColor = borderColor
        }
    }
    
    @IBInspectable public var borderFocusWidth: CGFloat = 1.0 {
        didSet {
            tfBorderFocusWidth = borderFocusWidth
        }
    }
    
    @IBInspectable public var borderErrorWidth: CGFloat = 1.0 {
        didSet {
            tfBorderErrorWidth = borderErrorWidth
        }
    }
    
    @IBInspectable public var borderDisabledWidth: CGFloat = 1.0 {
        didSet {
            tfBorderDisabledWidth = borderDisabledWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            tfBorderColor = borderColor
        }
    }
    
    @IBInspectable public var borderFocusColor: UIColor? {
        didSet {
            tfBorderFocusColor = borderFocusColor
        }
    }
    
    @IBInspectable public var borderErrorColor: UIColor? {
        didSet {
            tfBorderErrorColor = borderErrorColor
        }
    }
    
    @IBInspectable public var borderDisabledColor: UIColor? {
        didSet {
            tfBorderDisabledColor = borderDisabledColor
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
        }
    }
    
    @IBInspectable public var supportMessageFocusColor: UIColor? {
        didSet {
            tfSupportFocusColor = supportMessageFocusColor
        }
    }
    
    @IBInspectable public var supportMessageErrorColor: UIColor? {
        didSet {
            tfSupportErrorColor = supportMessageErrorColor
        }
    }
    
    @IBInspectable public var supportMessageDisabledColor: UIColor? {
        didSet {
            tfSupportDisabledColor = supportMessageDisabledColor
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
        }
    }
    
    @IBInspectable public var counterFocusColor: UIColor? {
        didSet {
            tfCounterFocusColor = counterFocusColor
        }
    }
    
    @IBInspectable public var counterErrorColor: UIColor? {
        didSet {
            tfCounterErrorColor = counterErrorColor
        }
    }
    
    @IBInspectable public var counterDisabledColor: UIColor? {
        didSet {
            tfCounterDisabledColor = counterDisabledColor
        }
    }
    
    @IBInspectable public var isCounterHide: Bool = false {
        didSet {
            setupCounterText()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 4.0 {
        didSet {
            vTextField.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var isRequired: Bool = false {
        didSet {
            lblRequired.isHidden = !isRequired
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
        guard let nib = bundle.loadNibNamed("EDTSTextField", owner: self, options: nil),
              let view = nib.first as? UIView else {
            print("Failed to load TextField XIB")
            return
        }

        containerView = view
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        setupActions()
        setupTextField()
        setupState()
        setupIconLeading()
        setupIconTrailing()
        setupSupportText()
        setupCounterText()
        setupRequired()
    }

    private func setupActions() {
        tfValue.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tfValue.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        tfValue.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }

    private func setupTextField() {
        tfValue.font = EDTSFont.B2.Regular.font
        tfValue.borderStyle = .none
        vTextField.layer.cornerRadius = cornerRadius
    }

    private func setupState() {
        setupTitleColor()
        setupPlaceholderColor()
        setupValueColor()
        setupIconLeadingColor()
        setupIconTrailingColor()
        setupBackgroundColor()
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
    
    private func setupTitleColor() {
        lblTitle.font = EDTSFont.H3.font
        lblTitle.textColor = themed(
            default: tfLabelColor,
            focus: tfLabelFocusColor,
            error: tfLabelErrorColor,
            disabled: tfLabelDisabledColor
        )
    }

    // MARK: - Placeholder

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
        
        ivLeadingWidthConstraint?.constant = hasIcon ? 24 : 0
        vTextFieldLeadingConstraint?.constant = hasIcon ? 8 : 0
        
        layoutIfNeeded()
    }

    private func setupIconTrailing() {
        guard !isPassword else { return }

        ivTrailing.image = iconTrailing?.withRenderingMode(.alwaysTemplate)
        ivTrailing.tintColor = EDTSColor.grey60

        let hasIcon = iconTrailing != nil
        ivTrailing.isHidden = !hasIcon
        
        ivTrailingWidthConstraint?.constant = hasIcon ? 24 : 0
        vTextFieldTrailingConstraint?.constant = hasIcon ? 8 : 0
        
        layoutIfNeeded()
    }

    // MARK: - Background & Border

    private func setupBackgroundColor() {
        vTextField.backgroundColor = themed(
            default: tfBackgroundColor,
            focus: tfBackgroundFocusColor,
            error: tfBackgroundErrorColor,
            disabled: tfBackgroundDisabledColor
        )
    }

    private func setupBorderColor() {
        vTextField.layer.borderWidth = themed(
            default: tfBorderWidth,
            focus: tfBorderFocusWidth,
            error: tfBorderErrorWidth,
            disabled: tfBorderDisabledWidth
        )
        vTextField.layer.borderColor = themed(
            default: tfBorderColor,
            focus: tfBorderFocusColor,
            error: tfBorderErrorColor,
            disabled: tfBorderDisabledColor
        )?.cgColor
    }

    // MARK: - Support Label

    private func setupSupportText() {
        lblSupport.font = EDTSFont.B4.Regular.font
        lblSupport.textColor = EDTSColor.grey60
        setupSupportTextVisibility()
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
        lblCounter.textColor = EDTSColor.grey60

        let hasCounter = counterMax != -1 && !isCounterHide
        lblCounter.isHidden = !hasCounter
        lblCounter.text = hasCounter ? "\(tfValue.text?.count ?? 0)/\(counterMax)" : ""

        if hasCounter {
            if supportMessage == nil { lblSupport.text = "placeholder" }
            lblSupportHeightConstraint?.isActive = false
        }

        layoutIfNeeded()
        invalidateIntrinsicContentSize()
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
        let iconName = tfValue.isSecureTextEntry ? "ic_eye_hide" : "ic_eye_show"
        let bundle = Bundle(for: type(of: self))
        ivTrailing.image = UIImage(named: iconName, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
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

    //MARK: Action
    
    @objc private func textFieldDidChange() {
        if counterMax != -1 {
            let currentText = tfValue.text ?? ""
            if currentText.count > counterMax {
                tfValue.text = String(currentText.prefix(counterMax))
            }
        }
        
        updateCounterText()
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: tfValue)
    }
    
    @objc private func textFieldDidBeginEditing() {
        state = EDTSTextFieldState.focus.rawValue
        setupState()
    }
    
    @objc private func textFieldDidEndEditing() {
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
}
