//
//  Checkbox.swift
//  EDTS_DS
//
//  Created by Yovita Handayiani on 15/05/26.
//

import UIKit

public enum EDTSCheckboxState: String {
    case `default` = "default"
    case disabled = "disabled"
}

public enum EDTSCheckboxType: String {
    case checked = "checked"
    case indeterminated = "indeterminated"
}

@IBDesignable
public class EDTSCheckbox: UIView {
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var vStackContainer: UIStackView!
    @IBOutlet weak var hStackContainer: UIStackView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var ivIconContainerView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    // MARK: - Inspectables
    @IBInspectable public var checkboxState: String?{
        didSet {
            setupCheckboxState()
        }
    }
    
    @IBInspectable public var checkboxType: String?{
        didSet {
            setupCheckboxType()
        }
    }
    
    @IBInspectable public var title: String?{
        didSet{
            lblTitle.attributedText = nil
            lblTitle.text = title
        }
    }
    
    public var titleAttributed: NSAttributedString? {
        didSet {
            lblTitle.text = nil
            lblTitle.attributedText = titleAttributed
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
            setupCheckboxState()
        }
    }
    
    @IBInspectable public var titleColorInactive: UIColor?{
        didSet{
            setupCheckboxState()
        }
    }
    
    @IBInspectable public var desc: String?{
        didSet{
            lblBody.attributedText = nil
            lblBody.text = desc
        }
    }
    
    public var descAttributed: NSAttributedString? {
        didSet {
            lblBody.text = nil
            lblBody.attributedText = descAttributed
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
            setupCheckboxState()
        }
    }
    
    @IBInspectable public var descColorInactive: UIColor?{
        didSet{
            setupCheckboxState()
        }
    }
    
    @IBInspectable public var icon: UIImage?{
        didSet{
            setupIcon()
        }
    }
    
    @IBInspectable public var iconTintColorActive: UIColor?{
        didSet{
            icon = icon?.withRenderingMode(.alwaysTemplate)
            setupCheckboxState()
        }
    }
    
    @IBInspectable public var iconTintColorInactive: UIColor?{
        didSet{
            icon = icon?.withRenderingMode(.alwaysTemplate)
            setupCheckboxState()
        }
    }
    
    @IBInspectable public var boxBgColorActive: UIColor?{
        didSet{
            setupCheckboxState()
        }
    }
    
    @IBInspectable public var boxBgColorInactive: UIColor?{
        didSet{
            setupCheckboxState()
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
            ivIconContainerView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColorActive: UIColor?{
        didSet{
            setupCheckboxState()
        }
    }
    
    @IBInspectable public var borderColorInactive: UIColor?{
        didSet{
            setupCheckboxState()
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
            setupCheckboxState(isActive)
        }
    }
    
    // MARK: - Public Variable
    public weak var delegate: EDTSCheckboxDelegate?
    
    // MARK: - Private Variable
    private var resolvedCheckboxState: EDTSCheckboxState {
        guard let type = checkboxState else { return .default }
        let normalized = type.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return EDTSCheckboxState(rawValue: normalized) ?? .default
    }
    
    private var resolvedCheckboxType: EDTSCheckboxType {
        guard let type = checkboxType else { return .checked }
        let normalized = type.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return EDTSCheckboxType(rawValue: normalized) ?? .checked
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
        if let nib = bundle.loadNibNamed("EDTSCheckbox", owner: self, options: nil),
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
        setupCheckboxState()
        setupCheckboxType()
        setupTitleFont()
        setupDescFont()
        setupDefaultStyle()
    }
    
    private func setupDefaultStyle(){
        lblTitle.font = EDTSFont.B2.Medium.font
        lblBody.font = EDTSFont.B3.Regular.font
        borderWidth = 1
        title = "Title checkboxes"
        desc = "Body text goes here"
        paddingLeading = 2
        labelSpacing = 4
        spacing = 8
        ivIconContainerView.layer.cornerRadius = 4
        
        invalidateIntrinsicContentSize()
    }
    
    private func setupIcon() {
        if let rbIcon = icon {
            ivIcon.isHidden = false
            ivIcon.image = rbIcon.withRenderingMode(.alwaysTemplate)
        } else {
            ivIcon.isHidden = true
        }
        setupCheckboxType()
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
    
    private func setupCheckboxState(_ isActive: Bool = false) {
        ivIconContainerView.isUserInteractionEnabled = resolvedCheckboxState != .disabled
        vStackContainer.isUserInteractionEnabled = resolvedCheckboxState != .disabled
        
        switch resolvedCheckboxState {
        case .default:
            animateDefaultCheckbox(isActive)
        case .disabled:
            setupCheckboxDisabled()
        }
    }
    
    private func setupCheckboxType() {
        if(icon == nil){
            switch resolvedCheckboxType {
            case .checked:
                let bundle = Bundle(for: type(of: self))
                ivIcon.image = UIImage(named: "ic_check", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            case .indeterminated:
                let bundle = Bundle(for: type(of: self))
                ivIcon.image = UIImage(named: "ic_minus", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            }
        }else{
            ivIcon.image = icon?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    private func setupCheckboxDisabled() {
        switch self.isActive {
        case false:
            self.lblTitle.textColor = EDTSColor.grey40
            self.lblBody.textColor = EDTSColor.grey30
            self.ivIconContainerView.backgroundColor = EDTSColor.grey20
            self.ivIcon.tintColor = EDTSColor.grey20
            self.ivIconContainerView.layer.borderColor = EDTSColor.grey30.cgColor

            
        case true:
            self.lblTitle.textColor = EDTSColor.grey40
            self.lblBody.textColor = EDTSColor.grey30
            self.ivIconContainerView.backgroundColor = EDTSColor.grey20
            self.ivIcon.tintColor = EDTSColor.grey40
            self.ivIconContainerView.layer.borderColor = EDTSColor.grey40.cgColor
        }
    }
    
    // MARK: - Animation
    private func animateDefaultCheckbox(_ isActive: Bool = false, animated: Bool = true) {
        self.ivIcon.isHidden = ivIcon.image == nil
        let changes = {
            switch self.isActive {
            case false:
                self.lblTitle.textColor = self.titleColorInactive ?? EDTSColor.grey60
                self.lblBody.textColor = self.descColorInactive ?? EDTSColor.grey50
                self.ivIconContainerView.backgroundColor = self.boxBgColorInactive ?? EDTSColor.white
                self.ivIcon.tintColor = self.iconTintColorInactive ?? EDTSColor.white
                self.ivIconContainerView.layer.borderColor = self.borderColorInactive?.cgColor ?? EDTSColor.grey30.cgColor
                
            case true:
                self.lblTitle.textColor = self.titleColorActive ?? EDTSColor.grey60
                self.lblBody.textColor = self.descColorActive ?? EDTSColor.grey50
                self.ivIconContainerView.backgroundColor = self.boxBgColorActive ?? EDTSColor.blue50
                self.ivIcon.tintColor = self.iconTintColorActive ?? EDTSColor.white
                self.ivIconContainerView.layer.borderColor = self.borderColorActive?.cgColor ?? UIColor.clear.cgColor
            }
        }
        
        if animated {
            self.ivIcon.isHidden = ivIcon.image == nil
            self.ivIcon.alpha = 0.5
            
            UIView.animate(
                withDuration: 0.15,
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    self.ivIcon.alpha = 1.0
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
            self.ivIcon.alpha = 1.0
            changes()
        }
    }
    
    private func setupIconGestures() {
        ivIconContainerView.isUserInteractionEnabled = true
        vStackContainer.isUserInteractionEnabled = true
        
        let ivIconContainerViewPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(onLongPressBulletContainerView(_:))
        )
        ivIconContainerViewPress.minimumPressDuration = 0
        ivIconContainerView.addGestureRecognizer(ivIconContainerViewPress)
        
        let vStackContainerPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(onLongPressBulletContainerView(_:))
        )
        vStackContainerPress.minimumPressDuration = 0
        vStackContainer.addGestureRecognizer(vStackContainerPress)
        
    }
    
    @objc private func onLongPressBulletContainerView(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            ivIconContainerView.showRippleCircular(size: ivIconContainerView.bounds.width + 16, color: EDTSColor.black.withAlphaComponent(0.12))
            
        case .ended:
            delegate?.didSelectCheckbox(self)
            ivIconContainerView.hideRippleCircular()
            
        case .cancelled, .failed:
            ivIconContainerView.hideRippleCircular()
            
        default:
            break
        }
    }
}

@MainActor
public protocol EDTSCheckboxDelegate: AnyObject {
    func didSelectCheckbox(_ checkbox: EDTSCheckbox)
}
