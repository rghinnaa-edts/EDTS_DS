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
//    @IBOutlet weak var lblTitleTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var ivCloseTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var ivCloseLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivCloseWidthConstraint: NSLayoutConstraint!
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
    
    @IBInspectable public var btnCloseTintColor: UIColor? {
        didSet {
            ivClose.tintColor = btnCloseTintColor
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
            vContainer.layer.cornerRadius = borderWidth
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
    
    @IBInspectable public var isButtonHide: Bool = false {
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
        setupTextColor()
        setupIcon()
        setupIconColor()
        setupBackgroundColor()
        setupBorderColor()
        setupButtonVisibility()
    }
    
    private func setupTheme() {
        if EDTSColor.theme == .klikIDM {
            lblTitle.font = EDTSFont.P2.Regular.font
            
            vContainerTopConstraint?.constant = 12
            vContainerBottomConstraint?.constant = 12
//            lblTitleTopConstraint?.constant = 12
//            ivCloseTopConstraint?.constant = 12
        } else {
            lblTitle.font = EDTSFont.B3.Regular.font
            
            isButtonHide = true
            setupButtonVisibility()
            
            vContainerTopConstraint?.constant = 8
            vContainerBottomConstraint?.constant = 8
//            lblTitleTopConstraint?.constant = 8
//            ivCloseTopConstraint?.constant = 8
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
    }
    
    private func setupTextColor() {
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
    
    private func setupButtonVisibility() {
        btnAction.isHidden = isButtonHide
        btnAction.label = isButtonHide ? "" : btnLabel
        
        let padding: CGFloat = EDTSColor.theme == EDTSColorTheme.klikIDM ? 12 : 8
        
        vContainerBottomConstraint?.constant = isButtonHide ? padding : 0
        btnActionTopConstraint?.constant = isButtonHide ? 0 : 8
        btnActionHeightConstant?.constant = isButtonHide ? 0 : btnAction.intrinsicContentSize.height
        
        stackView.setNeedsLayout()
        stackView.layoutIfNeeded()
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
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
        
        isButtonHide = true
        setupButtonVisibility()
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
}
