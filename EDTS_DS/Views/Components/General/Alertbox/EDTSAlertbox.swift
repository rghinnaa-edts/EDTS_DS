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

public enum EDTSAlertboxStyle: String {
    case `default` = "default"
    case ribbon = "ribbon"
}

class EDTSAlertbox: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAction: EDTSButton!
    
    @IBOutlet weak var btnActionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnActionHeightConstant: NSLayoutConstraint!
    
    @IBInspectable public var state: String = EDTSAlertboxState.default.rawValue {
        didSet {
            setupState()
        }
    }
    
    @IBInspectable public var style: String = EDTSAlertboxStyle.default.rawValue {
        didSet {
            setupStyle()
        }
    }
    
    @IBInspectable public var label: String? {
        didSet {
            lblTitle.text = label
        }
    }
    
    @IBInspectable public var labelColor: UIColor? {
        didSet {
            lblTitle.textColor = labelColor
        }
    }
    
    @IBInspectable public var icon: UIImage? {
        didSet {
            ivIcon.image = icon?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        }
    }
    
    @IBInspectable public var iconTintColor: UIColor? {
        didSet {
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
            btnAction.label = label
        }
    }
    
    @IBInspectable public var isButtonHide: Bool = false {
        didSet {
            setupButtonVisibility()
        }
    }
    
    private var currentState: EDTSAlertboxState {
        EDTSAlertboxState(rawValue: state) ?? .default
    }
    
    private var alertIcon: String = "ic_information"
    private var alertTextColor: UIColor? = EDTSColor.grey60
    private var alertIconColor: UIColor? = EDTSColor.grey50
    private var alertBgColor: UIColor? = EDTSColor.grey10
    private var alertBorderColor: UIColor = EDTSColor.grey30
    
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
        guard let nib = bundle.loadNibNamed("EDTSAlertbox", owner: self, options: nil),
              let view = nib.first as? UIView else {
            print("Failed to load Alertbox XIB")
            return
        }

        containerView = view
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setupUI()
    }
    
    private func setupUI() {
        setupAlertbox()
    }
    
    private func setupState() {
        setupTextColor()
        setupIcon()
        setupIconColor()
        setupBackgroundColor()
        setupBorderColor()
        
        setupAlertbox()
    }
    
    private func setupStyle() {
        
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
    
    private func setupAlertbox() {
        vContainer.layer.cornerRadius = 8
        vContainer.layer.borderWidth = 1
        vContainer.layer.borderColor = alertBorderColor.cgColor
        vContainer.backgroundColor = alertBgColor
        lblTitle.textColor = alertTextColor
        ivIcon.tintColor = alertIconColor
    }
    
    private func setupTextColor() {
        if EDTSColor.theme == EDTSColorTheme.klikIDM {
            alertTextColor = EDTSColor.grey80
        } else {
            alertTextColor = themed(
                default: EDTSColor.grey50,
                info: EDTSColor.blue50,
                success: EDTSColor.successStrong,
                error: EDTSColor.errorStrong,
                warning: EDTSColor.warningStrong
            )
        }
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
    }
    
    private func setupIconColor() {
        alertIconColor = themed(
            default: EDTSColor.grey50,
            info: EDTSColor.blue50,
            success: EDTSColor.successStrong,
            error: EDTSColor.errorStrong,
            warning: EDTSColor.warningStrong
        )
    }
    
    private func setupBackgroundColor() {
        alertBgColor = themed(
            default: EDTSColor.grey10,
            info: EDTSColor.primaryWeak,
            success: EDTSColor.successWeak,
            error: EDTSColor.errorWeak,
            warning: EDTSColor.warningWeak
        )
    }
    
    private func setupBorderColor() {
        alertBgColor = themed(
            default: EDTSColor.grey30,
            info: EDTSColor.primaryStrong,
            success: EDTSColor.successStrong,
            error: EDTSColor.errorStrong,
            warning: EDTSColor.warningStrong
        )
    }
    
    private func setupButtonVisibility() {
        btnAction.isHidden = isButtonHide
        btnActionTopConstraint?.constant = isButtonHide ? 0 : 8
        btnActionHeightConstant?.constant = isButtonHide ? 0 : btnAction.intrinsicContentSize.height
    }
}
