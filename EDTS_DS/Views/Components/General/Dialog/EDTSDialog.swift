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
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblSupport: UILabel!
    @IBOutlet weak var btnPrimary: EDTSButton!
    @IBOutlet weak var btnSecondary: EDTSButton!
    
    @IBOutlet weak var ivImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivCloseWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivCloseHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitleTopConstraint: NSLayoutConstraint!
    
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
    
    @IBInspectable public var titleAlignment: NSTextAlignment = .left {
        didSet {
            lblTitle.textAlignment = titleAlignment
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
    
    @IBInspectable public var descAlignment: NSTextAlignment = .left {
        didSet {
            lblDesc.textAlignment = descAlignment
        }
    }
    
    @IBInspectable public var support: String? {
        didSet {
            lblSupport.attributedText = nil
            lblSupport.text = support
            lblSupport.isHidden = false
        }
    }
    
    @IBInspectable public var supportAttributed: NSAttributedString? {
        didSet {
            lblSupport.text = nil
            lblSupport.attributedText = supportAttributed
            lblSupport.isHidden = false
        }
    }
    
    @IBInspectable public var supportColor: UIColor? {
        didSet {
            lblSupport.textColor = supportColor
        }
    }
    
    @IBInspectable public var supportFontName: String = "" {
        didSet {
            setupSupportFont()
        }
    }
    
    @IBInspectable public var supportFontSize: CGFloat = CGFloat.zero {
        didSet {
            setupSupportFont()
        }
    }
    
    @IBInspectable public var supportFontWeight: String? {
        didSet {
            setupSupportFont()
        }
    }
    
    @IBInspectable public var supportAlignment: NSTextAlignment = .left {
        didSet {
            lblSupport.textAlignment = supportAlignment
        }
    }
    
    @IBInspectable public var image: UIImage? {
        didSet {
            dialogImage = image
            setupImage()
        }
    }
    
    @IBInspectable public var imageSize: CGFloat = 0.0 {
        didSet {
            dialogImageSize = imageSize
            setupImage()
        }
    }
    
    @IBInspectable public var btnCloseSize: CGFloat = 16.0 {
        didSet {
            setupCloseVisibility()
        }
    }
    
    @IBInspectable public var btnOrientation: String = Orientation.vertical.rawValue {
        didSet {
            setupButtonOrientation()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 12.0 {
        didSet {
            dialogCornerRadius = cornerRadius
            vContainer.layer.cornerRadius = dialogCornerRadius
        }
    }
    
    @IBInspectable public var isBtnCloseHide: Bool = false {
        didSet {
            setupCloseVisibility()
        }
    }
    
    @IBInspectable public var isBtnPrimaryHide: Bool = false {
        didSet {
            setupButtonVisibility()
        }
    }
    
    @IBInspectable public var isBtnSecondaryHide: Bool = false {
        didSet {
            setupButtonVisibility()
        }
    }
    
    @IBInspectable public var isBtnPositionAtTopLabel: Bool = false {
        didSet {
            setupButtonPosition()
        }
    }
    
    @IBInspectable public var isDialogImage: Bool = false {
        didSet {
            if isDialogImage {
                setupDialogImage()
            }
        }
    }
    
    // MARK: - Public Variable
    
    public weak var delegate: EDTSDialogDelegate?
    
    // MARK: - Private Variable
    
    private var dialogImage: UIImage? = nil
    private var dialogImageSize: CGFloat = 256.0
    private var dialogCornerRadius: CGFloat = 12.0
    private var btnStackView: UIStackView?
    private var btnStackTopConstraint: NSLayoutConstraint?
    private var btnStackBottomConstraint: NSLayoutConstraint?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    // MARK: - Public Function
    
    public func configureButtonPrimary(_ instance: (EDTSButton) -> Void) {
        guard btnPrimary != nil else { return }
        instance(btnPrimary)
    }
    
    public func configureButtonSecondary(_ instance: (EDTSButton) -> Void) {
        guard btnSecondary != nil else { return }
        instance(btnSecondary)
    }
    
    public func show(in viewController: UIViewController, animated: Bool = true) {
        let overlay = UIView(frame: viewController.view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.tag = 9999
 
        let dialogWidth = viewController.view.bounds.width - 48
 
        self.frame = CGRect(x: 0, y: 0, width: dialogWidth, height: 0)
        self.setNeedsLayout()
        self.layoutIfNeeded()
 
        let dialogHeight = self.systemLayoutSizeFitting(
            CGSize(width: dialogWidth, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
 
        let dialogX = (viewController.view.bounds.width - dialogWidth) / 2
        let dialogY = (viewController.view.bounds.height - dialogHeight) / 2
 
        self.frame = CGRect(x: dialogX, y: dialogY, width: dialogWidth, height: dialogHeight)
 
        overlay.addSubview(self)
        viewController.view.addSubview(overlay)
 
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
        lblTitleTopConstraint?.constant = 0
        ivImageWidthConstraint?.constant = 0
        
        vContainer.layer.cornerRadius = dialogCornerRadius
        
        lblTitle.font = EDTSFont.H1.font
        lblTitle.textColor = EDTSColor.grey70
        
        lblDesc.font = EDTSFont.P1.Regular.font
        lblDesc.textColor = EDTSColor.grey50
        
        ivClose.tintColor = EDTSColor.grey50
        
        lblSupport.text = ""
        lblSupport.isHidden = true
        lblSupport.font = EDTSFont.P2.Regular.font
        lblSupport.textColor = EDTSColor.grey40
        
        btnPrimary.btnType = BtnType.primary.rawValue
        btnPrimary.btnSize = BtnSize.large.rawValue
        btnSecondary.btnType = BtnType.secondary.rawValue
        btnSecondary.btnSize = BtnSize.large.rawValue
        
        setupCloseButton()
        setupButtonOrientation()
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
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
    
    private func setupSupportFont() {
        guard supportFontSize > 0 else { return }
        let weight = setupFontWeight(from: supportFontWeight ?? "regular")
        
        if !supportFontName.isEmpty {
            lblSupport.font = UIFont(name: supportFontName, size: supportFontSize) ?? UIFont.systemFont(ofSize: supportFontSize, weight: weight)
        } else {
            lblSupport.font = UIFont.systemFont(ofSize: supportFontSize, weight: weight)
        }
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupImage() {
        ivImage.image = dialogImage
        ivImageWidthConstraint?.constant = dialogImageSize
        
        setupButtonPosition()
    }
    
    private func setupCloseButton() {
        let bundle = Bundle(for: type(of: self))
        ivClose.image = UIImage(named: "ic_close", in: bundle, compatibleWith: nil)
        ivClose.tintColor = EDTSColor.grey50
        
        ivClose.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCloseTap))
        ivClose.addGestureRecognizer(tap)
    }
    
    private func setupCloseVisibility() {
        ivCloseWidthConstraint?.constant = isBtnCloseHide ? 0 : btnCloseSize
        ivCloseHeightConstraint?.constant = isBtnCloseHide ? 0 : btnCloseSize
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupButtonVisibility() {
        guard btnPrimary != nil, btnSecondary != nil else { return }
        
        btnPrimary.isHidden = isBtnPrimaryHide
        btnPrimary.alpha = isBtnPrimaryHide ? 0 : 1
        
        btnSecondary.isHidden = isBtnSecondaryHide
        btnSecondary.alpha = isBtnSecondaryHide ? 0 : 1
        btnStackView?.isHidden = isBtnPrimaryHide && isBtnSecondaryHide
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupButtonOrientation() {
        guard btnPrimary != nil, btnSecondary != nil else { return }
        
        let isHorizontal = btnOrientation == Orientation.horizontal.rawValue
        
        if let existingStack = btnStackView {
            btnPrimary.removeFromSuperview()
            btnSecondary.removeFromSuperview()
            existingStack.removeFromSuperview()
            btnStackView = nil
            btnStackTopConstraint = nil
            btnStackBottomConstraint = nil
        }
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.distribution = .fillEqually
        
        if isHorizontal {
            stack.axis = .horizontal
            stack.addArrangedSubview(btnSecondary)
            stack.addArrangedSubview(btnPrimary)
        } else {
            stack.axis = .vertical
            stack.addArrangedSubview(btnPrimary)
            stack.addArrangedSubview(btnSecondary)
        }
        
        vContainer.addSubview(stack)
        btnStackView = stack
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: vContainer.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: vContainer.trailingAnchor, constant: -16)
        ])
        
        setupButtonPosition()
        setupButtonVisibility()
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupButtonPosition() {
        guard let stack = btnStackView else { return }
        
        btnStackTopConstraint?.isActive = false
        btnStackBottomConstraint?.isActive = false
        
        let newTopConstraint: NSLayoutConstraint
        let newBottomConstraint: NSLayoutConstraint
        
        if isBtnPositionAtTopLabel {
            newTopConstraint = stack.topAnchor.constraint(equalTo: ivImage.bottomAnchor, constant: 16)
            lblTitleTopConstraint?.isActive = false
            lblTitleTopConstraint = lblTitle.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 24)
            lblTitleTopConstraint?.isActive = true
            
            let bottomAnchorView: UIView = (lblSupport.isHidden) ? lblDesc : lblSupport
            newBottomConstraint = vContainer.bottomAnchor.constraint(equalTo: bottomAnchorView.bottomAnchor, constant: 16)
        } else {
            newTopConstraint = stack.topAnchor.constraint(equalTo: lblSupport.bottomAnchor, constant: 32)
            lblTitleTopConstraint?.isActive = false
            if image == nil {
                lblTitleTopConstraint = lblTitle.topAnchor.constraint(equalTo: ivImage.bottomAnchor, constant: 0)
            } else {
                lblTitleTopConstraint = lblTitle.topAnchor.constraint(equalTo: ivImage.bottomAnchor, constant: 16)
            }
            lblTitleTopConstraint?.isActive = true
            
            newBottomConstraint = vContainer.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 16)
        }
        
        newTopConstraint.isActive = true
        newBottomConstraint.isActive = true
        btnStackTopConstraint = newTopConstraint
        btnStackBottomConstraint = newBottomConstraint
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupDialogImage() {
        lblTitle.font = EDTSFont.D4.font
        lblTitle.textAlignment = .center
        lblDesc.textAlignment = .center
        lblSupport.textAlignment = .center
        lblSupport.isHidden = false
        
        isBtnCloseHide = true
        isBtnPositionAtTopLabel = true
        
        if image == nil {
            let bundle = Bundle(for: type(of: self))
            ivImage.image = UIImage(named: "ic_placeholder", in: bundle, compatibleWith: nil)
            ivImageWidthConstraint?.constant = dialogImageSize
        }
        if support == nil {
            lblSupport.text = "A dialog is a type of modal window that appears in front of app content to provide critical information, or prompt for a decision to be made."
        }
        
        setupCloseVisibility()
        setupButtonPosition()
    }
    
    // MARK: Actions
    
    @objc private func handleCloseTap() {
        delegate?.didTapCloseDialog(self)
        dismiss()
    }
    
    @IBAction func btnPrimaryAction(_ sender: Any) {
        delegate?.didTapButtonPrimaryDialog(self)
    }
    
    @IBAction func btnSecondaryAction(_ sender: Any) {
        delegate?.didTapButtonSecondaryDialog(self)
    }
}

@MainActor
public protocol EDTSDialogDelegate: AnyObject {
    func didTapCloseDialog(_ dialog: EDTSDialog)
    func didTapButtonPrimaryDialog(_ dialog: EDTSDialog)
    func didTapButtonSecondaryDialog(_ dialog: EDTSDialog)
}

