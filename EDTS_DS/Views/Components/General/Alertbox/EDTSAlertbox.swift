//
//  EDTSAlertbox.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 13/05/26.
//

import UIKit

public enum EDTSAlertboxState: String {
    case `default` = "default"
    case success = "success"
    case error = "error"
    case warning = "warning"
    case info = "info"
}

//@IBDesignable
public class EDTSAlertbox: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAction: EDTSButton!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var vContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var vContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var vContainerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var vContainerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivCloseWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivCloseHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnActionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnActionHeightConstant: NSLayoutConstraint!
    
    @IBInspectable public var state: String = EDTSAlertboxState.default.rawValue {
        didSet {
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
            alertTextColor = labelColor
            lblTitle.textColor = labelColor
        }
    }
    
    @IBInspectable public var fontName: String = "" {
        didSet {
            setupLabelFont()
        }
    }
    
    @IBInspectable public var fontSize: CGFloat = CGFloat.zero {
        didSet {
            setupLabelFont()
        }
    }
    
    @IBInspectable public var fontWeight: String? {
        didSet {
            setupLabelFont()
        }
    }
    
    @IBInspectable public var icon: UIImage? {
        didSet {
            ivIcon.image = icon
        }
    }
    
    @IBInspectable public var iconTintColor: UIColor? {
        didSet {
            alertIconColor = iconTintColor
            
            ivIcon.image = ivIcon.image?.withRenderingMode(.alwaysTemplate)
            ivIcon.tintColor = iconTintColor
        }
    }
    
    @IBInspectable public var iconSize: CGFloat = 24.0 {
        didSet {
            setupIconSizing()
        }
    }
    
    @IBInspectable public var btnCloseTintColor: UIColor? {
        didSet {
            ivClose.tintColor = btnCloseTintColor
        }
    }
    
    @IBInspectable public var btnCloseSize: CGFloat = 16.0 {
        didSet {
            setupCloseVisibility()
        }
    }
    
    @IBInspectable public var btnLabel: String? {
        didSet {
            btnAction.label = btnLabel
        }
    }
    
    @IBInspectable public var bgColor: UIColor? {
        didSet {
            alertBgColor = bgColor
            vContainer.backgroundColor = bgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 1.0 {
        didSet {
            alertBorderWidth = borderWidth
            vContainer.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            alertBorderColor = borderColor
            vContainer.layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 1.0 {
        didSet {
            alertCornerRadius = cornerRadius
            vContainer.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var isBtnCloseHide: Bool = false {
        didSet {
            setupCloseVisibility()
        }
    }
    
    @IBInspectable public var isBtnHide: Bool = false {
        didSet {
            setupButtonVisibility()
        }
    }
    
    @IBInspectable public var isRibbonStyle: Bool = false {
        didSet {
            setupRibbonStyle()
        }
    }
    
    private var currentState: EDTSAlertboxState {
        EDTSAlertboxState(rawValue: state) ?? .default
    }
    
    private var alertIcon: String = "ic_information"
    private var alertTextColor: UIColor? = EDTSColor.grey60
    private var alertIconColor: UIColor? = EDTSColor.grey50
    private var alertBgColor: UIColor? = EDTSColor.grey10
    private var alertBorderColor: UIColor? = EDTSColor.grey30
    private var alertBorderWidth: CGFloat = 1.0
    private var alertCornerRadius: CGFloat = 8.0
    
    public func configureButton(_ instance: (EDTSButton) -> Void) {
        guard btnAction != nil else { return }
        instance(btnAction)
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
        if let nib = bundle.loadNibNamed("EDTSAlertbox", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            setupUI()
        }
    }
    
    private func setupUI() {
        btnLabel = "Button"
        
        let bundle = Bundle(for: type(of: self))
        ivClose.image = UIImage(named: "ic_close", in: bundle, compatibleWith: nil)
        ivClose.tintColor = EDTSColor.grey50
        
        setupState()
    }
    
    private func setupState() {
        if isRibbonStyle { return }
        
        setupTheme()
        setupAlertboxView()
        setupLabelColor()
        setupIcon()
        setupIconColor()
        setupBackgroundColor()
        setupBorderColor()
        setupButtonVisibility()
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupTheme() {
        if fontSize > 0 {
            setupLabelFont()
        } else if EDTSColor.theme == .klikIDM {
            lblTitle.font = EDTSFont.P2.Regular.font
            
            vContainerTopConstraint?.constant = 12
            vContainerBottomConstraint?.constant = 12
        } else {
            lblTitle.font = EDTSFont.B3.Regular.font
            
            isBtnHide = true
            setupButtonVisibility()
            
            vContainerTopConstraint?.constant = 8
            vContainerBottomConstraint?.constant = 8
        }
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - State Helpers

    private func themed<T>(`default`: T, info: T, success: T, error: T, warning: T) -> T {
        switch currentState {
        case .default: return `default`
        case .info: return info
        case .success: return success
        case .error: return error
        case .warning: return warning
        }
    }
    
    private func setupAlertboxView() {
        vContainer.layer.cornerRadius = alertCornerRadius
        vContainer.layer.borderWidth = alertBorderWidth
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupLabelFont() {
        guard fontSize > 0 else { return }
        let weight = setupFontWeight(from: fontWeight ?? "regular")
        
        if !fontName.isEmpty {
            lblTitle.font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: weight)
        } else {
            lblTitle.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        }
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupFontWeight(from string: String) -> UIFont.Weight {
        switch string.lowercased() {
        case "ultraLight": return .ultraLight
        case "thin":       return .thin
        case "light":      return .light
        case "regular":    return .regular
        case "medium":     return .medium
        case "semibold":   return .semibold
        case "bold":       return .bold
        case "heavy":      return .heavy
        case "black":      return .black
        default:           return .regular
        }
    }
    
    private func setupLabelColor() {
        if EDTSColor.theme == EDTSColorTheme.klikIDM {
            alertTextColor = EDTSColor.grey60
        } else {
            alertTextColor = themed(
                default: EDTSColor.grey50,
                info: EDTSColor.blue50,
                success: EDTSColor.successStrong,
                error: EDTSColor.errorStrong,
                warning: EDTSColor.warningStrong
            )
        }
        
        lblTitle.textColor = alertTextColor
    }
    
    private func setupIcon() {
        if EDTSColor.theme == EDTSColorTheme.klikIDM {
            alertIcon = themed(
                default: "ic_information",
                info: "ic_information",
                success: "ic_success",
                error: "ic_error",
                warning: "ic_attention"
            )
        } else {
            alertIcon = themed(
                default: "ic_information",
                info: "ic_information",
                success: "ic_success",
                error: "ic_attention",
                warning: "ic_notice"
            )
        }
        
        let bundle = Bundle(for: type(of: self))
        ivIcon.image = UIImage(named: alertIcon, in: bundle, compatibleWith: nil)
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupIconSizing() {
        ivIconWidthConstraint?.constant = iconSize
        ivIconHeightConstraint?.constant = iconSize
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupIconColor() {
        alertIconColor = themed(
            default: EDTSColor.grey50,
            info: EDTSColor.blue50,
            success: EDTSColor.successStrong,
            error: EDTSColor.errorStrong,
            warning: EDTSColor.warningStrong
        )
        
        ivIcon.tintColor = alertIconColor
    }
    
    private func setupBackgroundColor() {
        alertBgColor = themed(
            default: EDTSColor.grey10,
            info: EDTSColor.primaryWeak,
            success: EDTSColor.successWeak,
            error: EDTSColor.errorWeak,
            warning: EDTSColor.warningWeak
        )
        
        vContainer.backgroundColor = alertBgColor
    }
    
    private func setupBorderColor() {
        alertBorderColor = themed(
            default: EDTSColor.grey30,
            info: EDTSColor.primaryStrong,
            success: EDTSColor.successStrong,
            error: EDTSColor.errorStrong,
            warning: EDTSColor.warningStrong
        )
        
        vContainer.layer.borderColor = alertBorderColor?.cgColor
    }
    
    private func setupCloseVisibility() {
        ivCloseWidthConstraint?.constant = isBtnCloseHide ? 0 : btnCloseSize
        ivCloseHeightConstraint?.constant = isBtnCloseHide ? 0 : btnCloseSize
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupButtonVisibility() {
        btnAction.isHidden = isBtnHide
        btnAction.label = isBtnHide ? "" : btnLabel
        
        let padding: CGFloat = EDTSColor.theme == EDTSColorTheme.klikIDM ? 12 : 8
        
        vContainerBottomConstraint?.constant = isBtnHide ? padding : 0
        btnActionTopConstraint?.constant = isBtnHide ? 0 : 8
        btnActionHeightConstant?.constant = isBtnHide ? 0 : btnAction.intrinsicContentSize.height
        
        stackView.setNeedsLayout()
        stackView.layoutIfNeeded()
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Style Ribbon
    
    private func setupRibbonStyle() {
        alertBgColor = themed(
            default: EDTSColor.grey50,
            info: EDTSColor.primaryStrong,
            success: EDTSColor.successStrong,
            error: EDTSColor.errorStrong,
            warning: EDTSColor.warningStrong
        )
        
        alertTextColor = EDTSColor.white
        alertIconColor = EDTSColor.white
        
        vContainer.backgroundColor = alertBgColor
        lblTitle.textColor = alertTextColor
        ivIcon.tintColor = alertIconColor
        vContainer.layer.borderWidth = 0
        vContainer.layer.cornerRadius = 0
        
        vContainerLeadingConstraint?.constant = 8
        vContainerTrailingConstraint?.constant = 8
        
        ivCloseWidthConstraint?.constant = 0
        ivCloseHeightConstraint?.constant = 0
        
        isBtnHide = true
        setupButtonVisibility()
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
}
