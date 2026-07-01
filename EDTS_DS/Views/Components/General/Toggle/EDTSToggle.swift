//
//  EDTSToggle.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 18/06/26.
//

import UIKit

@IBDesignable
public class EDTSToggle: UIView {
    
    // MARK: Outlets
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var vStackView: UIStackView!
    @IBOutlet weak var vTrack: UIView!
    @IBOutlet weak var vIndicator: UIView!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var vContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var vContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vStackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var vStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var vStackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var vTrackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var vTrackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var vIndicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var vIndicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var vIndicatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivIconHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Inspectables
    
    @IBInspectable public var title: String? {
        didSet {
            lblTitle.attributedText = nil
            lblTitle.text = title
            
            setupLabel()
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
            
            setupLabel()
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
 
    @IBInspectable public var trackTintColor: UIColor = EDTSColor.grey30 {
        didSet {
            updateState(animated: false)
        }
    }
 
    @IBInspectable public var trackActiveTintColor: UIColor = EDTSColor.blue50 {
        didSet {
            updateState(animated: false)
        }
    }
    
    @IBInspectable public var trackWidth: CGFloat = 44 {
        didSet {
            if !isUpdatingTrackWidthInternally {
                isTrackWidthExplicit = true
            }
            updateSizing()
        }
    }
 
    @IBInspectable public var indicatorTintColor: UIColor = EDTSColor.white {
        didSet {
            updateState(animated: false)
        }
    }
    
    @IBInspectable public var indicatorActiveTintColor: UIColor = EDTSColor.white {
        didSet {
            updateState(animated: false)
        }
    }
 
    @IBInspectable public var indicatorPadding: CGFloat = 2 {
        didSet {
            updateSizing()
        }
    }
 
    @IBInspectable public var indicatorSize: CGFloat = 16 {
        didSet {
            guard indicatorSize != oldValue else { return }
            if !isTrackWidthExplicit {
                let derivedWidth = indicatorSize * Self.trackToIndicatorRatio
                isUpdatingTrackWidthInternally = true
                trackWidth = derivedWidth
                isUpdatingTrackWidthInternally = false
            }
            updateSizing()
        }
    }
    
    @IBInspectable public var icon: UIImage? {
        didSet {
            toggleIcon = icon
            updateState(animated: false)
        }
    }
    
    @IBInspectable public var iconActive: UIImage? {
        didSet {
            toggleIconActive = iconActive
            updateState(animated: false)
        }
    }
    
    @IBInspectable public var iconTintColor: UIColor = EDTSColor.white {
        didSet {
            updateState(animated: false)
        }
    }
    
    @IBInspectable public var iconActiveTintColor: UIColor = EDTSColor.white {
        didSet {
            updateState(animated: false)
        }
    }
    
    @IBInspectable public var iconSize: CGFloat = 16 {
        didSet {
            indicatorSize = iconSize
            updateSizing()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            isCornerRadiusExplicit = true
            vTrack.layer.cornerRadius = cornerRadius
            vIndicator.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = 0.0 {
        didSet {
            vTrack.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize.zero {
        didSet {
            vTrack.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0.0 {
        didSet {
            vTrack.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? = UIColor.black {
        didSet {
            vTrack.layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    @IBInspectable public var isActive: Bool = false {
        didSet {
            isOn = isActive
            updateState(animated: true)
        }
    }
    
    // MARK: - Public Variables
    
    public weak var delegate: EDTSToggleDelegate?
    
    // MARK: - Private Variables
    
    private static let trackToIndicatorRatio: CGFloat = 44.0 / 16.0
    private var isTrackWidthExplicit: Bool = false
    private var isUpdatingTrackWidthInternally: Bool = false
    private var isCornerRadiusExplicit: Bool = false
    private var isOn: Bool = false
    private var toggleIcon: UIImage? = nil
    private var toggleIconActive: UIImage? = nil
 
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
        if let nib = bundle.loadNibNamed("EDTSToggle", owner: self, options: nil),
           let view = nib.first as? UIView {
 
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
 
            setupUI()
        }
    }
 
    private func setupUI() {
        setupTrack()
        setupIndicator()
        setupLabel()
        updateState(animated: false)
    }
    
    private func setupTrack() {
        vTrack.layer.cornerRadius = vTrack.bounds.height / 2
        
        vTrack.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleToggleTap))
        vTrack.addGestureRecognizer(tapGesture)
    }
    
    private func setupIndicator() {
        vIndicator.layer.cornerRadius = vIndicator.bounds.height / 2
        
        vIndicator.layer.shadowOpacity = 0.15
        vIndicator.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        vIndicator.layer.shadowRadius = 3.0
        vIndicator.layer.shadowColor = EDTSColor.grey50.cgColor
    }
    
    private func setupLabel() {
        lblTitle.font = EDTSFont.B2.Medium.font
        lblTitle.textColor = EDTSColor.grey70
        
        lblDesc.font = EDTSFont.B3.Regular.font
        lblDesc.textColor = EDTSColor.grey60
        
        if title?.isEmpty == false || desc?.isEmpty == false {
            vTrackTopConstraint?.isActive = false
            vTrackBottomConstraint?.isActive = false
            vStackViewLeadingConstraint?.constant = 8
        }
        
        if title?.isEmpty == true && desc?.isEmpty == true {
            vStackViewLeadingConstraint?.constant = 0
            vStackViewTopConstraint?.isActive = false
            vStackViewBottomConstraint?.isActive = false
            vStackView.isHidden = true
        }
        
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
    
    // MARK: - Sizing
 
    private func updateSizing() {
        guard vIndicatorWidthConstraint != nil,
              vIndicatorHeightConstraint != nil,
              vContainerWidthConstraint != nil,
              vContainerHeightConstraint != nil else { return }
 
        vIndicatorWidthConstraint.constant = indicatorSize
        vIndicatorHeightConstraint.constant = indicatorSize
        vContainerWidthConstraint.constant = trackWidth
        vContainerHeightConstraint.constant = indicatorSize + (indicatorPadding * 2)
        ivIconWidthConstraint.constant = indicatorSize
        ivIconHeightConstraint.constant = indicatorSize
        
        if !isCornerRadiusExplicit {
            vTrack.layer.cornerRadius = indicatorSize / 2
            vIndicator.layer.cornerRadius = indicatorSize / 2
        }
 
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    // MARK: - State
    
    private func updateState(animated: Bool) {
        guard vTrack != nil, vIndicator != nil, vIndicatorLeadingConstraint != nil else { return }
 
        layoutIfNeeded()
 
        let actualTrackWidth = vTrack.bounds.width
        let indicatorWidth = vIndicator.bounds.width
        let onOffset = max(actualTrackWidth - indicatorWidth - indicatorPadding, indicatorPadding)
 
        vIndicatorLeadingConstraint.constant = isOn ? onOffset : indicatorPadding
 
        let currentIcon = isOn ? toggleIconActive : toggleIcon
 
        let applyColor = {
            self.vTrack.backgroundColor = self.isOn ? self.trackActiveTintColor : self.trackTintColor
            self.vIndicator.backgroundColor = self.isOn ? self.indicatorActiveTintColor : self.indicatorTintColor
            self.ivIcon.tintColor = self.isOn ? self.iconActiveTintColor : self.iconTintColor
            self.ivIcon?.image = currentIcon?.withRenderingMode(.alwaysTemplate)
            self.ivIcon?.isHidden = (currentIcon == nil)
        }
 
        guard animated else {
            applyColor()
            layoutIfNeeded()
            return
        }
 
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.4,
            options: [.curveEaseInOut],
            animations: {
                applyColor()
                self.layoutIfNeeded()
            }
        )
    }
 
    // MARK: - Toggle Logic
 
    @objc private func handleToggleTap() {
        isOn = !isOn
        updateState(animated: true)
        
        delegate?.didTapToggle(active: isOn, self)
    }
}

@MainActor
public protocol EDTSToggleDelegate: AnyObject {
    func didTapToggle(active isActive: Bool, _ alertbox: EDTSToggle)
}
