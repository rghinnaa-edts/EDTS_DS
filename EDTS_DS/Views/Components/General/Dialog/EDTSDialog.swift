//
//  EDTSDialog.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 10/06/26.
//

import UIKit

@IBDesignable
public class EDTSDialog: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UITextView!
    @IBOutlet weak var btnFilled: EDTSButton!
    @IBOutlet weak var btnOutlined: EDTSButton!
    
    @IBOutlet weak var ivImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivCloseWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivCloseHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivCloseTopConstraint: NSLayoutConstraint!
    
    // MARK: - Inspectables
    
    @IBInspectable public var title: String? {
        didSet {
            lblTitle.attributedText = nil
            lblTitle.text = title
        }
    }
    
    @IBInspectable public var titleAttributed: NSAttributedString? {
        didSet {
            lblTitle.text = nil
            lblTitle.attributedText = titleAttributed
        }
    }
    
    @IBInspectable public var titleColor: UIColor? {
        didSet {
            lblTitle.textColor = titleColor
        }
    }
    
    @IBInspectable public var titleFontName: String = "" {
        didSet {
            setupTitleFont()
        }
    }
    
    @IBInspectable public var titleFontSize: CGFloat = CGFloat.zero {
        didSet {
            setupTitleFont()
        }
    }
    
    @IBInspectable public var titleFontWeight: String? {
        didSet {
            setupTitleFont()
        }
    }
    
    @IBInspectable public var desc: String? {
        didSet {
            lblDesc.attributedText = nil
            lblDesc.text = desc
        }
    }
    
    @IBInspectable public var descAttributed: NSAttributedString? {
        didSet {
            lblDesc.text = nil
            lblDesc.attributedText = descAttributed
        }
    }
    
    @IBInspectable public var descColor: UIColor? {
        didSet {
            lblDesc.textColor = descColor
        }
    }
    
    @IBInspectable public var descFontName: String = "" {
        didSet {
            setupDescFont()
        }
    }
    
    @IBInspectable public var descFontSize: CGFloat = CGFloat.zero {
        didSet {
            setupDescFont()
        }
    }
    
    @IBInspectable public var descFontWeight: String? {
        didSet {
            setupDescFont()
        }
    }
    
    @IBInspectable public var btnCloseSize: CGFloat = 16.0 {
        didSet {
            setupCloseVisibility()
        }
    }
    
    @IBInspectable public var isBtnCloseHide: Bool = false {
        didSet {
            setupCloseVisibility()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    // MARK: - Public Function
    
    public static func showDialog(
        in vc: UIViewController,
        title: String,
        desc: String,
        primaryTitle: String = "OK",
        secondaryTitle: String? = nil,
        onPrimary: (() -> Void)? = nil,
        onSecondary: (() -> Void)? = nil
    ) -> EDTSDialog {
        let dialog = EDTSDialog()
        dialog.title = title
        dialog.desc = desc
        dialog.btnFilled.setTitle(primaryTitle, for: .normal)
        
        if let secondaryTitle {
            dialog.btnOutlined.setTitle(secondaryTitle, for: .normal)
            dialog.btnOutlined.isHidden = false
        } else {
            dialog.btnOutlined.isHidden = true
        }
        
        dialog.show(in: vc)
        return dialog
    }
    
    // MARK: - Private Function

    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSDialog", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            setupUI()
        }
    }
    
    private func setupUI() {
        vContainer.layer.cornerRadius = 12
        
        ivImageWidthConstraint?.constant = 0
        lblTitleTopConstraint?.isActive = false
        ivCloseTopConstraint?.isActive = false
        
        lblTitle.font = EDTSFont.H1.font
        lblTitle.textColor = EDTSColor.grey70
        
        lblDesc.font = EDTSFont.P1.Regular.font
        lblDesc.textColor = EDTSColor.grey50
        
        btnFilled.btnType = BtnType.primary.rawValue
        btnOutlined.btnType = BtnType.secondary.rawValue
    }
    
    private func setupTitleFont() {
        guard titleFontSize > 0 else { return }
        let weight = setupFontWeight(from: titleFontWeight ?? "regular")
        
        if !titleFontName.isEmpty {
            lblTitle.font = UIFont(name: titleFontName, size: titleFontSize) ?? UIFont.systemFont(ofSize: titleFontSize, weight: weight)
        } else {
            lblTitle.font = UIFont.systemFont(ofSize: titleFontSize, weight: weight)
        }
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupDescFont() {
        guard descFontSize > 0 else { return }
        let weight = setupFontWeight(from: descFontWeight ?? "regular")
        
        if !descFontName.isEmpty {
            lblDesc.font = UIFont(name: descFontName, size: descFontSize) ?? UIFont.systemFont(ofSize: descFontSize, weight: weight)
        } else {
            lblDesc.font = UIFont.systemFont(ofSize: descFontSize, weight: weight)
        }
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupTitle() {
        
    }
    
    private func setupDesc() {
        
    }
    
    private func setupButtonFilled() {
        
    }
    
    private func setupButtonOutlined() {
        
    }
    
    private func setupCloseVisibility() {
        ivCloseWidthConstraint?.constant = isBtnCloseHide ? 0 : btnCloseSize
        ivCloseHeightConstraint?.constant = isBtnCloseHide ? 0 : btnCloseSize
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Public Methods

    public func show(in viewController: UIViewController, animated: Bool = true) {
        // Create overlay
        let overlay = UIView(frame: viewController.view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.tag = 9999
        
        // Setup dialog size
        let dialogWidth = viewController.view.bounds.width - 48
        let dialogHeight: CGFloat = 300 // or use intrinsicContentSize
        let dialogX = (viewController.view.bounds.width - dialogWidth) / 2
        let dialogY = (viewController.view.bounds.height - dialogHeight) / 2
        
        self.frame = CGRect(x: dialogX, y: dialogY, width: dialogWidth, height: dialogHeight)
        
        overlay.addSubview(self)
        viewController.view.addSubview(overlay)
        
        // Animate
        if animated {
            overlay.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                overlay.alpha = 1
                self.transform = .identity
            }
        }
    }

    public func dismiss(animated: Bool = true) {
        guard let overlay = self.superview else { return }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                overlay.alpha = 0
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { _ in
                overlay.removeFromSuperview()
            }
        } else {
            overlay.removeFromSuperview()
        }
    }
    
}
