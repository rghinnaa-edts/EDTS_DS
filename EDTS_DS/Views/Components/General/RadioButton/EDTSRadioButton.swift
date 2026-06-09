//
//  EDTSRadioButton.swift
//  KlikIDM_DS
//
//  Created by Yovita Handayiani on 02/03/26.
//

import UIKit

public enum EDTSRadioButtonState: String {
    case `default` = "default"
    case disabled = "disabled"
}

@IBDesignable
public class EDTSRadioButton: UIView {
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var hStackContainer: UIStackView!
    @IBOutlet weak var vStackContainer: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var bulletContainerView: UIView!
    @IBOutlet weak var bulletView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivIconBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivIconLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivIconTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Inspectables
    @IBInspectable public var radioBtnState: String?{
        didSet {
            setupRadioButtonState()
        }
    }
    
    @IBInspectable public var title: String?{
        didSet{
            lblTitle.attributedText = nil
            lblTitle.text = title
            lblTitle.isHidden = title == nil || title?.isEmpty == true
            invalidateIntrinsicContentSize()
        }
    }
    
    public var titleAttributed: NSAttributedString? {
        didSet {
            lblTitle.text = nil
            lblTitle.attributedText = titleAttributed
            lblTitle.isHidden = titleAttributed == nil || titleAttributed?.string.isEmpty == true
            invalidateIntrinsicContentSize()
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
    
    @IBInspectable public var titleFontWeight: String = "" {
        didSet {
            setupTitleFont()
        }
    }
    
    @IBInspectable public var titleColorActive: UIColor?{
        didSet{
            setupRadioButtonState()
        }
    }
    
    @IBInspectable public var titleColorInactive: UIColor?{
        didSet{
            setupRadioButtonState()
        }
    }
    
    @IBInspectable public var desc: String?{
        didSet{
            lblBody.attributedText = nil
            lblBody.text = desc
            lblBody.isHidden = desc == nil || desc?.isEmpty == true
            invalidateIntrinsicContentSize()
        }
    }
    
    public var descAttributed: NSAttributedString? {
        didSet {
            lblBody.text = nil
            lblBody.attributedText = descAttributed
            lblBody.isHidden = descAttributed == nil || descAttributed?.string.isEmpty == true
            invalidateIntrinsicContentSize()
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
    
    @IBInspectable public var descFontWeight: String = "" {
        didSet {
            setupDescFont()
        }
    }
    
    @IBInspectable public var descColorActive: UIColor?{
        didSet{
            setupRadioButtonState()
        }
    }
    
    @IBInspectable public var descColorInactive: UIColor?{
        didSet{
            setupRadioButtonState()
        }
    }
    
    @IBInspectable public var iconActive: UIImage?{
        didSet{
            setupIcon()
            setupRadioButtonState()
        }
    }
    
    @IBInspectable public var iconInactive: UIImage?{
        didSet{
            setupIcon()
            setupRadioButtonState()
        }
    }
    
    @IBInspectable public var iconTintColorActive: UIColor?{
        didSet{
            setupRadioButtonState()
            setupIcon()
        }
    }
    
    @IBInspectable public var iconTintColorInactive: UIColor?{
        didSet{
            setupRadioButtonState()
            setupIcon()
        }
    }
    
    @IBInspectable public var iconBgColorActive: UIColor?{
        didSet{
            setupRadioButtonState()
        }
    }
    
    @IBInspectable public var iconBgColorInactive: UIColor?{
        didSet{
            setupRadioButtonState()
        }
    }
    
    @IBInspectable public var spacing: CGFloat = CGFloat.zero {
        didSet {
            hStackContainer.spacing = spacing
        }
    }
    
    @IBInspectable public var labelSpacing: CGFloat = CGFloat.zero {
        didSet {
            vStackContainer.spacing = labelSpacing
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = CGFloat.zero {
        didSet{
            bulletContainerView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColorActive: UIColor?{
        didSet{
            setupRadioButtonState()
        }
    }
    
    @IBInspectable public var borderColorInactive: UIColor?{
        didSet{
            setupRadioButtonState()
        }
    }
    
    @IBInspectable public var iconPadding: CGFloat = CGFloat.zero {
        didSet {
            setupIconConstraint()
        }
    }
    
    @IBInspectable public var paddingTop: CGFloat = CGFloat.zero {
        didSet {
            setupConstraint()
        }
    }
    
    @IBInspectable public var paddingBottom: CGFloat = CGFloat.zero {
        didSet {
            setupConstraint()
        }
    }
    
    @IBInspectable public var paddingLeading: CGFloat = CGFloat.zero {
        didSet {
            setupConstraint()
        }
    }
    
    @IBInspectable public var paddingTrailing: CGFloat = CGFloat.zero {
        didSet {
            setupConstraint()
        }
    }
    
    @IBInspectable public var isActive: Bool = false {
        didSet{
            setupRadioButtonState(isActive)
            setupIcon()
        }
    }
    
    // MARK: - Public Variable
    public weak var delegate: EDTSRadioButtonDelegate?
    
    // MARK: - Private Variable
    private var resolvedRadioButtonState: EDTSRadioButtonState {
        guard let type = radioBtnState else { return .`default` }
        let normalized = type.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return EDTSRadioButtonState(rawValue: normalized) ?? .`default`
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }
    
    public override var intrinsicContentSize: CGSize {
        guard let stack = hStackContainer else {
            return super.intrinsicContentSize
        }
        
        stack.setNeedsLayout()
        stack.layoutIfNeeded()
        
        let stackSize = stack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let totalHeight = paddingTop + stackSize.height + paddingBottom
        let totalWidth = paddingLeading + stackSize.width + paddingTrailing
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    // MARK: - Setup & Styling
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSRadioButton", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        
        setupUI()
    }
    
    private func setupUI() {
        setupIcon()
        setupIconGestures()
        setupRadioButtonState()
        setupTitleFont()
        setupDescFont()
        setupDefaultStyle()
    }
    
    private func setupDefaultStyle(){
        lblTitle.font = EDTSFont.B2.Medium.font
        lblBody.font = EDTSFont.B3.Regular.font
        borderWidth = 1
        title = "Title radio button"
        desc = ""
        iconPadding = 0
        paddingLeading = 2
        labelSpacing = 4
        spacing = 8
        bulletContainerView.applyCircular()
        bulletView.applyCircular()
        
        invalidateIntrinsicContentSize()
    }
    
    private func setupIcon() {
        let hasCustomIcon = iconInactive != nil || iconActive != nil
        bulletView.isHidden = hasCustomIcon
        
        let icon = isActive ? iconActive : iconInactive

        if let rbIcon = icon {
            ivIcon.isHidden = false
            ivIcon.image = rbIcon.withRenderingMode(.alwaysTemplate)
        } else {
            ivIcon.isHidden = true
        }
        
        if !hasCustomIcon {
            bulletView.isHidden = false
        }
    }
    
    private func setupFontWeight(from value: String) -> UIFont.Weight {
        let normalized = value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        let weight = FontWeight(rawValue: normalized) ?? .semibold
        
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
    
    private func setupTitleFont() {
        let size = titleFontSize
        let weight = setupFontWeight(from: titleFontWeight)
        
        if !titleFontName.isEmpty {
            lblTitle.font = UIFont(name: titleFontName, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            lblTitle.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    private func setupDescFont() {
        let size = descFontSize
        let weight = setupFontWeight(from: descFontWeight)
        
        if !descFontName.isEmpty {
            lblBody.font = UIFont(name: descFontName, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            lblBody.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    private func setupConstraint(){
        topConstraint?.constant = paddingTop
        bottomConstraint?.constant = paddingBottom
        leadingConstraint?.constant = paddingLeading
        trailingConstraint?.constant = paddingTrailing
        invalidateIntrinsicContentSize()
    }
    
    private func setupIconConstraint(){
        ivIconTopConstraint?.constant = iconPadding
        ivIconBottomConstraint?.constant = iconPadding
        ivIconLeadingConstraint?.constant = iconPadding
        ivIconTrailingConstraint?.constant = iconPadding
        invalidateIntrinsicContentSize()
    }
    
    private func setupRadioButtonState(_ isActive: Bool = false) {
        bulletContainerView.isUserInteractionEnabled = resolvedRadioButtonState != .disabled
        
        switch resolvedRadioButtonState {
        case .`default`:
            animateDefaultRadioButton(isActive)
        case .disabled:
            setupRadioButtonDisabled()
        }
    }
    
    private func setupRadioButtonDisabled() {
        switch self.isActive {
        case false:
            self.lblTitle.textColor = EDTSColor.grey40
            self.lblBody.textColor = EDTSColor.grey30
            self.bulletContainerView.backgroundColor = EDTSColor.grey20
            self.bulletView.backgroundColor = EDTSColor.grey20
            self.ivIcon.tintColor = EDTSColor.grey20
            self.bulletContainerView.layer.borderColor = EDTSColor.grey30.cgColor

            
        case true:
            self.lblTitle.textColor = EDTSColor.grey40
            self.lblBody.textColor = EDTSColor.grey30
            self.bulletContainerView.backgroundColor = EDTSColor.grey20
            self.bulletView.backgroundColor = EDTSColor.grey40
            self.ivIcon.tintColor = EDTSColor.grey40
            self.bulletContainerView.layer.borderColor = EDTSColor.grey40.cgColor
        }
    }
    
    // MARK: - Animation
    private func animateDefaultRadioButton(_ isActive: Bool = false, animated: Bool = true) {
        self.bulletView.isHidden = ivIcon.image != nil
        let changes = {
            switch self.isActive {
            case false:
                self.lblTitle.textColor = self.titleColorInactive ?? EDTSColor.grey60
                self.lblBody.textColor = self.descColorInactive ?? EDTSColor.grey50
                self.bulletContainerView.backgroundColor = self.iconBgColorInactive ?? EDTSColor.white
                self.bulletView.backgroundColor = self.iconTintColorInactive ?? EDTSColor.white
                self.ivIcon.tintColor = self.iconTintColorInactive ?? (self.iconInactive == nil ? EDTSColor.white : EDTSColor.blue50)
                self.bulletContainerView.layer.borderColor = self.borderColorInactive?.cgColor ?? EDTSColor.grey30.cgColor
                
            case true:
                self.lblTitle.textColor = self.titleColorActive ?? EDTSColor.grey60
                self.lblBody.textColor = self.descColorActive ?? EDTSColor.grey50
                self.bulletContainerView.backgroundColor = self.iconBgColorActive ?? EDTSColor.blue50
                self.bulletView.backgroundColor = self.iconTintColorActive ?? EDTSColor.white
                self.ivIcon.tintColor = self.iconTintColorActive ?? EDTSColor.white
                self.bulletContainerView.layer.borderColor = self.borderColorActive?.cgColor ?? UIColor.clear.cgColor
            }
        }
        
        if animated {
            self.bulletView.isHidden = ivIcon.image != nil
            self.bulletView.alpha = 0.5
            self.bulletView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            UIView.animate(
                withDuration: 0.15,
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    self.bulletView.alpha = 1.0
                },
                completion: nil
            )
            
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    self.bulletView.transform = .identity
                },
                completion: nil
            )
            
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                options: [.curveEaseInOut],
                animations: changes,
                completion: nil
            )
        } else {
            self.bulletView.alpha = 1.0
            self.bulletView.transform = .identity
            changes()
        }
    }
    
    private func setupIconGestures() {
        bulletContainerView.isUserInteractionEnabled = true
        
        let bulletContainerViewPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(onLongPressBulletContainerView(_:))
        )
        bulletContainerViewPress.minimumPressDuration = 0
        bulletContainerView.addGestureRecognizer(bulletContainerViewPress)
        
    }
    
    @objc private func onLongPressBulletContainerView(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            bulletContainerView.showRippleCircular(size: bulletContainerView.bounds.width + 16, color: EDTSColor.black.withAlphaComponent(0.12))
            
        case .ended:
            delegate?.didSelectRadioButton(self)
            bulletContainerView.hideRippleCircular()
            
        case .cancelled, .failed:
            bulletContainerView.hideRippleCircular()
            
        default:
            break
        }
    }
}

@MainActor
public protocol EDTSRadioButtonDelegate: AnyObject {
    func didSelectRadioButton(_ radioButton: EDTSRadioButton)
}
