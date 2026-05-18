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

class EDTSAlertbox: UIView {
    
    @IBOutlet var containerView: UIView!
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
    
    @IBInspectable public var iconColor: UIColor? {
        didSet {
            ivIcon.tintColor = iconColor
        }
    }
    
    @IBInspectable public var btnCloseColor: UIColor? {
        didSet {
            ivClose.tintColor = btnCloseColor
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
        
    }
    
    private func setupState() {
        
    }
    
    private func setupButtonVisibility() {
        btnActionTopConstraint?.constant = isButtonHide ? 0 : 8
        btnActionHeightConstant?.constant = isButtonHide ? 0 : btnAction.intrinsicContentSize.height
    }
}
