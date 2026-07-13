//
//  EDTSCardShoppingType.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 02/07/26.
//

import UIKit

public enum ShoppingType {
    case first
    case second
}

@IBDesignable
public class EDTSCardShoppingType: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var vIndicator: UIView!
    @IBOutlet weak var vTypeFirst: UIView!
    @IBOutlet weak var vTypeSecond: UIView!
    @IBOutlet weak var ivTypeFirst: UIImageView!
    @IBOutlet weak var ivTypeSecond: UIImageView!
    @IBOutlet weak var lblTitleTypeFirst: UILabel!
    @IBOutlet weak var lblDescTypeFirst: UILabel!
    @IBOutlet weak var lblTitleTypeSecond: UILabel!
    @IBOutlet weak var lblDescTypeSecond: UILabel!
    
    @IBOutlet weak var vIndicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var vIndicatorLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Inspectables
    
    @IBInspectable public var titleFirst: String? {
        didSet {
            lblTitleTypeFirst.attributedText = nil
            lblTitleTypeFirst.text = titleFirst
        }
    }
    
    @IBInspectable public var titleAttributedFirst: NSAttributedString? {
        didSet {
            lblTitleTypeFirst.text = nil
            lblTitleTypeFirst.attributedText = titleAttributedFirst
        }
    }
    
    @IBInspectable public var descFirst: String? {
        didSet {
            lblDescTypeFirst.attributedText = nil
            lblDescTypeFirst.text = descFirst
        }
    }
    
    @IBInspectable public var descAttributedFirst: NSAttributedString? {
        didSet {
            lblDescTypeFirst.text = nil
            lblDescTypeFirst.attributedText = descAttributedFirst
        }
    }
    
    @IBInspectable public var iconFirst: UIImage? {
        didSet {
            ivTypeFirst.image = iconFirst?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @IBInspectable public var indicatorColorFirst: UIColor? {
        didSet {
            firstIndicatorColor = indicatorColorFirst
            updateIndicatorState(animated: false)
        }
    }
    
    @IBInspectable public var titleSecond: String? {
        didSet {
            lblTitleTypeSecond.attributedText = nil
            lblTitleTypeSecond.text = titleSecond
        }
    }
    
    @IBInspectable public var titleAttributedSecond: NSAttributedString? {
        didSet {
            lblTitleTypeSecond.text = nil
            lblTitleTypeSecond.attributedText = titleAttributedSecond
        }
    }
    
    @IBInspectable public var descSecond: String? {
        didSet {
            lblDescTypeSecond.attributedText = nil
            lblDescTypeSecond.text = descSecond
        }
    }
    
    @IBInspectable public var descAttributedSecond: NSAttributedString? {
        didSet {
            lblDescTypeSecond.text = nil
            lblDescTypeSecond.attributedText = descAttributedSecond
        }
    }
    
    @IBInspectable public var iconSecond: UIImage? {
        didSet {
            ivTypeSecond.image = iconSecond?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @IBInspectable public var indicatorColorSecond: UIColor? {
        didSet {
            secondIndicatorColor = indicatorColorSecond
            updateIndicatorState(animated: false)
        }
    }
    
    @IBInspectable public var titleColor: UIColor? {
        didSet {
            titleLabelColor = titleColor
            updateIndicatorState(animated: false)
        }
    }
    
    @IBInspectable public var descColor: UIColor? {
        didSet {
            descLabelColor = descColor
            updateIndicatorState(animated: false)
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
    
    @IBInspectable public var iconTintColor: UIColor? {
        didSet {
            iconColor = iconTintColor
            updateIndicatorState(animated: false)
        }
    }
    
    @IBInspectable public var activeTintColor: UIColor? {
        didSet {
            activeColor = activeTintColor
            updateIndicatorState(animated: false)
        }
    }
    
    @IBInspectable public var bgColor: UIColor? {
        didSet {
            containerColor = bgColor
            setupBackground()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 8.0 {
        didSet {
            setupBackground()
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = 0.4 {
        didSet {
            vContainer.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0){
        didSet {
            vContainer.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 3.0 {
        didSet {
            vContainer.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? = EDTSColor.grey40 {
        didSet {
            vContainer.layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    // MARK: - Public Variables
    
    public weak var delegate: EDTSCardShoppingTypeDelegate?
    
    // MARK: - Private Variables
    
    private var containerColor: UIColor? = EDTSColor.grey20
    private var firstIndicatorColor: UIColor? = EDTSColor.xpress
    private var secondIndicatorColor: UIColor? = EDTSColor.xtra
    
    private var iconColor: UIColor? = EDTSColor.grey60
    private var titleLabelColor: UIColor? = EDTSColor.grey60
    private var descLabelColor: UIColor? = EDTSColor.grey40
    private var activeColor: UIColor? = EDTSColor.white
    
    private var selectedType: ShoppingType = .first
    
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
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
    }
 
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        updateIndicatorWidth()
    }
    
    // MARK: - Public Functions
    
    public func setSelectedType(_ type: ShoppingType, animated: Bool = false) {
        guard selectedType != type else { return }
        selectedType = type
        updateIndicatorState(animated: animated)
    }
    
    // MARK: - Private Functions
 
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSCardShoppingType", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            setupUI()
        }
    }
    
    private func setupUI() {
        setupBackground()
        setupLabel()
        setupLabelFont()
        setupImageColor()
        setupDefaultValue()
        
        let tapFirst = UITapGestureRecognizer(target: self, action: #selector(didTapTypeFirst))
        vTypeFirst.addGestureRecognizer(tapFirst)
        vTypeFirst.isUserInteractionEnabled = true
        
        let tapSecond = UITapGestureRecognizer(target: self, action: #selector(didTapTypeSecond))
        vTypeSecond.addGestureRecognizer(tapSecond)
        vTypeSecond.isUserInteractionEnabled = true
        
        updateIndicatorState(animated: false)
    }
    
    private func setupTitleFont() {
        guard titleFontSize > 0 else { return }
        let weight = setupFontWeight(from: titleFontWeight ?? "regular")
        
        if !titleFontName.isEmpty {
            lblTitleTypeFirst.font = UIFont(name: titleFontName, size: titleFontSize) ?? UIFont.systemFont(ofSize: titleFontSize, weight: weight)
            lblTitleTypeSecond.font = UIFont(name: titleFontName, size: titleFontSize) ?? UIFont.systemFont(ofSize: titleFontSize, weight: weight)
        } else {
            lblTitleTypeFirst.font = UIFont.systemFont(ofSize: titleFontSize, weight: weight)
            lblTitleTypeSecond.font = UIFont.systemFont(ofSize: titleFontSize, weight: weight)
        }
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupDescFont() {
        guard descFontSize > 0 else { return }
        let weight = setupFontWeight(from: descFontWeight ?? "regular")
        
        if !descFontName.isEmpty {
            lblDescTypeFirst.font = UIFont(name: descFontName, size: descFontSize) ?? UIFont.systemFont(ofSize: descFontSize, weight: weight)
            lblDescTypeSecond.font = UIFont(name: descFontName, size: descFontSize) ?? UIFont.systemFont(ofSize: descFontSize, weight: weight)
        } else {
            lblDescTypeFirst.font = UIFont.systemFont(ofSize: descFontSize, weight: weight)
            lblDescTypeSecond.font = UIFont.systemFont(ofSize: descFontSize, weight: weight)
        }
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    private func setupBackground() {
        vIndicator.layer.cornerRadius = cornerRadius
        vContainer.layer.cornerRadius = cornerRadius
        
        vContainer.backgroundColor = containerColor
        
        vIndicator.layer.shadowColor = shadowColor?.cgColor
        vIndicator.layer.shadowOpacity = shadowOpacity
        vIndicator.layer.shadowOffset = shadowOffset
        vIndicator.layer.shadowRadius = shadowRadius
    }
    
    private func setupLabel() {
        lblTitleTypeFirst.textColor = titleLabelColor
        lblDescTypeFirst.textColor = descLabelColor
        lblTitleTypeSecond.textColor = titleLabelColor
        lblDescTypeSecond.textColor = descLabelColor
    }
    
    private func setupLabelFont() {
        lblTitleTypeFirst.font = EDTSFont.H3.font
        lblDescTypeFirst.font = EDTSFont.B4.Regular.font
        lblTitleTypeSecond.font = EDTSFont.H3.font
        lblDescTypeSecond.font = EDTSFont.B4.Regular.font
    }
    
    private func setupDefaultValue() {
        let bundle = Bundle(for: type(of: self))
        ivTypeFirst.image = UIImage(named: "ic_xpress", in: bundle, compatibleWith: nil)
        lblTitleTypeFirst.text = "Belanja Xpress"
        lblDescTypeFirst.text = "1 Jam Sampai"
        
        let bundleSecond = Bundle(for: type(of: self))
        ivTypeSecond.image = UIImage(named: "ic_xtra", in: bundleSecond, compatibleWith: nil)
        lblTitleTypeSecond.text = "Belanja Xtra"
        lblDescTypeSecond.text = "Tiba 1-3 hari"
    }
    
    private func setupImageColor() {
        ivTypeFirst.tintColor = iconColor
        ivTypeSecond.tintColor = iconColor
    }
    
    // MARK: - Indicator handling
    
    private func updateIndicatorWidth() {
        let halfWidth = containerView.bounds.width / 2
        guard halfWidth > 0, vIndicatorWidthConstraint.constant != halfWidth else { return }
        vIndicatorWidthConstraint.constant = halfWidth
        if selectedType == .second {
            vIndicatorLeadingConstraint.constant = halfWidth
        }
    }
    
    private func updateIndicatorState(animated: Bool) {
        updateIndicatorWidth()
        
        let halfWidth = containerView.bounds.width / 2
        let indicatorColor: UIColor?
        
        switch selectedType {
        case .first:
            vIndicatorLeadingConstraint.constant = 0
            indicatorColor = firstIndicatorColor
        case .second:
            vIndicatorLeadingConstraint.constant = halfWidth
            indicatorColor = secondIndicatorColor
        }
        
        let applyAnimatableChanges = { [weak self] in
            guard let self = self else { return }
            self.vIndicator.backgroundColor = indicatorColor
            self.layoutIfNeeded()
        }
        
        let applyColorChanges = { [weak self] in
            guard let self = self else { return }
            
            self.ivTypeFirst.tintColor = self.selectedType == .first ? self.activeColor : self.titleLabelColor
            self.lblTitleTypeFirst.textColor = self.selectedType == .first ? self.activeColor : self.titleLabelColor
            self.lblDescTypeFirst.textColor = self.selectedType == .first ? self.activeColor : self.descLabelColor
            self.ivTypeSecond.tintColor = self.selectedType == .second ? self.activeColor : self.titleLabelColor
            self.lblTitleTypeSecond.textColor = self.selectedType == .second ? self.activeColor : self.titleLabelColor
            self.lblDescTypeSecond.textColor = self.selectedType == .second ? self.activeColor : self.descLabelColor
        }
        
        if animated {
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.2,
                options: [.curveEaseOut],
                animations: applyAnimatableChanges
            )
            
            UIView.transition(with: vTypeFirst, duration: 0.25, options: [.transitionCrossDissolve, .curveEaseInOut], animations: applyColorChanges)
            UIView.transition(with: vTypeSecond, duration: 0.25, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {})
        } else {
            applyAnimatableChanges()
            applyColorChanges()
        }
    }
    
    // MARK: - Action
    
    @objc private func didTapTypeFirst() {
        guard selectedType != .first else { return }
        selectedType = .first
        updateIndicatorState(animated: true)
        
        delegate?.didSelectShoppingType(isFirstActive: selectedType == .first, self)
    }
    
    @objc private func didTapTypeSecond() {
        guard selectedType != .second else { return }
        selectedType = .second
        updateIndicatorState(animated: true)
        
        delegate?.didSelectShoppingType(isFirstActive: selectedType == .first, self)
    }
}

@MainActor
public protocol EDTSCardShoppingTypeDelegate: AnyObject {
    func didSelectShoppingType(isFirstActive: Bool, _ card: EDTSCardShoppingType)
}
