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
    @IBOutlet weak var vIndicator: UIView!
    @IBOutlet weak var ivIcon: UIImageView!
    
    @IBOutlet weak var vContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var vContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vIndicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var vIndicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var vIndicatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivIconHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Inspectables
 
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
 
    @IBInspectable public var indicatorColor: UIColor = EDTSColor.white {
        didSet {
            updateState(animated: false)
        }
    }
    
    @IBInspectable public var indicatorActiveColor: UIColor = EDTSColor.white {
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
            updateSizing()
        }
    }
 
    @IBInspectable public var trackWidth: CGFloat = 44 {
        didSet {
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
    
    @IBInspectable public var shadowOpacity: Float = 0.0 {
        didSet {
            vContainer.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize.zero {
        didSet {
            vContainer.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0.0 {
        didSet {
            vContainer.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? = UIColor.black {
        didSet {
            vContainer.layer.shadowColor = shadowColor?.cgColor
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
    
    private var animateNextStateChange = false
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
            invalidateIntrinsicContentSize()
        }
    }
 
    private func setupUI() {
        setupTrack()
        setupIndicator()
        updateState(animated: false)
    }
    
    private func setupTrack() {
        vContainer.layer.cornerRadius = vContainer.bounds.height / 2
        
        vContainer.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleToggleTap))
        vContainer.addGestureRecognizer(tapGesture)
    }
    
    private func setupIndicator() {
        vIndicator.layer.cornerRadius = vIndicator.bounds.height / 2
        
        vIndicator.layer.shadowOpacity = 0.15
        vIndicator.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        vIndicator.layer.shadowRadius = 3.0
        vIndicator.layer.shadowColor = EDTSColor.grey50.cgColor
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
        ivIconWidthConstraint.constant = indicatorSize
 
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    // MARK: - State
    
    private func updateState(animated: Bool) {
        guard vContainer != nil, vIndicator != nil, vIndicatorLeadingConstraint != nil else { return }
 
        layoutIfNeeded()
 
        let actualTrackWidth = vContainer.bounds.width
        let indicatorWidth = vIndicator.bounds.width
        let onOffset = max(actualTrackWidth - indicatorWidth - indicatorPadding, indicatorPadding)
 
        vIndicatorLeadingConstraint.constant = isOn ? onOffset : indicatorPadding
 
        let currentIcon = isOn ? toggleIconActive : toggleIcon
 
        let applyColor = {
            self.vContainer.backgroundColor = self.isOn ? self.trackActiveTintColor : self.trackTintColor
            self.vIndicator.backgroundColor = self.isOn ? self.indicatorActiveColor : self.indicatorColor
            self.ivIcon?.image = currentIcon
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
