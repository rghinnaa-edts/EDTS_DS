//
//  Chip.swift
//  KlikIDM_DS
//
//  Created by Yovita Handayiani on 11/01/26.
//

import UIKit

@IBDesignable
public class EDTSChip: UIView {
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var hStackContainer: UIStackView!
    @IBOutlet weak var ivLeadingIconBG: UIView!
    @IBOutlet weak var ivLeadingIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivTrailingIconBG: UIView!
    @IBOutlet weak var ivTrailingIcon: UIImageView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leadingIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingIconHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Inspectables
    @IBInspectable public var label: String?{
        didSet{
            lblTitle.attributedText = nil
            lblTitle.text = label ?? "Chip"
        }
    }
    
    public var labelAttributed: NSAttributedString? {
        didSet {
            lblTitle.text = nil
            lblTitle.attributedText = labelAttributed
        }
    }
    
    @IBInspectable public var fontName: String = "" {
        didSet {
            setupFont()
        }
    }
    
    @IBInspectable public var fontSize: CGFloat = CGFloat.zero {
        didSet {
            setupFont()
        }
    }
    
    @IBInspectable public var fontWeight: String = "" {
        didSet {
            setupFont()
        }
    }
    
    @IBInspectable public var labelColor: UIColor?{
        didSet{
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var labelColorActive: UIColor?{
        didSet{
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var bgColor: UIColor?{
        didSet{
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var bgColorActive: UIColor?{
        didSet{
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var iconLeading: UIImage?{
        didSet{
            setupIcon()
        }
    }
    
    @IBInspectable public var iconTintLeading: UIColor?{
        didSet{
            ivLeadingIcon.image = ivLeadingIcon.image?.withRenderingMode(.alwaysTemplate)
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var iconTintLeadingActive: UIColor?{
        didSet{
            ivLeadingIcon.image = ivLeadingIcon.image?.withRenderingMode(.alwaysTemplate)
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var iconBGColorLeading: UIColor?{
        didSet{
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var iconBGColorLeadingActive: UIColor?{
        didSet{
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var iconTrailing: UIImage?{
        didSet{
            setupIcon()
        }
    }
    
    @IBInspectable public var iconTintTrailing: UIColor?{
        didSet{
            ivTrailingIcon.image = ivTrailingIcon.image?.withRenderingMode(.alwaysTemplate)
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var iconTintTrailingActive: UIColor?{
        didSet{
            ivTrailingIcon.image = ivTrailingIcon.image?.withRenderingMode(.alwaysTemplate)
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var iconBGColorTrailing: UIColor?{
        didSet{
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var iconBGColorTrailingActive: UIColor?{
        didSet{
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var iconSize: CGFloat = CGFloat.zero {
        didSet {
            setupIconConstraint()
        }
    }
    
    @IBInspectable public var iconSpacing: CGFloat = CGFloat.zero {
        didSet {
            hStackContainer.spacing = iconSpacing
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = CGFloat.zero {
        didSet {
            containerView.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = CGFloat.zero {
        didSet{
            containerView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor?{
        didSet{
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var borderColorActive: UIColor?{
        didSet{
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = Float.zero {
        didSet {
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var shadowOpacityActive: Float = Float.zero {
        didSet {
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = CGFloat.zero {
        didSet {
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var shadowRadiusActive: CGFloat = CGFloat.zero {
        didSet {
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize.zero {
        didSet {
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var shadowOffsetActive: CGSize = CGSize.zero {
        didSet {
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? {
        didSet {
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var shadowColorActive: UIColor? {
        didSet {
            let state: ChipState = isChipActive ? .active : .inactive
            animateChip(state, animated: false)
        }
    }
    
    @IBInspectable public var paddingTop: CGFloat = CGFloat.zero {
        didSet {
            topConstraint?.constant = paddingTop
        }
    }
    
    @IBInspectable public var paddingBottom: CGFloat = CGFloat.zero {
        didSet {
            bottomConstraint?.constant = paddingBottom
        }
    }
    
    @IBInspectable public var paddingLeading: CGFloat = CGFloat.zero {
        didSet {
            leadingConstraint?.constant = paddingLeading
        }
    }
    
    @IBInspectable public var paddingTrailing: CGFloat = CGFloat.zero {
        didSet {
            trailingConstraint?.constant = paddingTrailing
        }
    }
    
    @IBInspectable public var isChipActive: Bool = false {
        didSet{
            let isActive = isChipActive ? ChipState.active : ChipState.inactive
            animateChip(isActive, animated: true)
        }
    }
    
    // MARK: - Public Variable
    public weak var delegate: EDTSChipDelegate?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius != CGFloat.zero ? containerView.layer.cornerRadius = cornerRadius : containerView.applyCircular()
        ivLeadingIconBG.applyCircular()
        ivTrailingIconBG.applyCircular()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        showRipple(from: touches.first?.location(in: self) ?? CGPoint(x: bounds.midX, y: bounds.midY), cornerRadius: containerView.bounds.height / 2)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        hideRipple()
        delegate?.didSelectChip(self)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        hideRipple()
    }
    
    // MARK: - Setup & Styling
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("KlikIDM_DSChip", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        setupUI()
    }
    
    private func setupUI(){
        setupFont()
        setupIcon()
        setupIconConstraint()
        setupIconGestures()
        
        fontSize = 12
        fontWeight = "Semibold"
        iconSize = 20
        iconSpacing = 4
        paddingTop = 4
        paddingBottom = 4
        paddingLeading = 8
        paddingTrailing = 8
    }
    
    private func setupIcon() {
        if let icon = iconLeading {
            ivLeadingIconBG.isHidden = false
            ivLeadingIcon.image = icon.withRenderingMode(.alwaysTemplate)
        } else {
            ivLeadingIconBG.isHidden = true
            ivLeadingIcon.image = nil
        }
        
        if let icon = iconTrailing {
            ivTrailingIconBG.isHidden = false
            ivTrailingIcon.image = icon.withRenderingMode(.alwaysTemplate)
        } else {
            ivTrailingIconBG.isHidden = true
            ivTrailingIcon.image = nil
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
    
    private func setupFont() {
        let size = fontSize
        let weight = setupFontWeight(from: fontWeight)
        
        if !fontName.isEmpty {
            lblTitle.font = UIFont(name: fontName, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            lblTitle.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    private func setupIconConstraint(){
        leadingIconWidthConstraint?.constant = iconSize
        leadingIconHeightConstraint?.constant = iconSize
        trailingIconWidthConstraint?.constant = iconSize
        trailingIconHeightConstraint?.constant = iconSize
    }
    
    // MARK: - Animation
    private func animateChip(_ newState: ChipState, animated: Bool) {
        let changes = {
            switch newState {
            case .inactive:
                self.ivLeadingIcon.tintColor = self.iconTintLeading ?? EDTSColor.blue50
                self.ivLeadingIconBG.backgroundColor = self.iconBGColorLeading ?? .white
                self.lblTitle.textColor = self.labelColor ?? EDTSColor.blue50
                self.ivTrailingIcon.tintColor = self.iconTintTrailing ?? EDTSColor.blue50
                self.ivTrailingIconBG.backgroundColor = self.iconBGColorTrailing ?? .white
                self.containerView.backgroundColor = self.bgColor ?? EDTSColor.grey20
                self.containerView.layer.borderColor = self.borderColor?.cgColor ?? UIColor.clear.cgColor
                self.containerView.layer.shadowOpacity = self.shadowOpacity != Float.zero ? self.shadowOpacity : Float.zero
                self.containerView.layer.shadowRadius = self.shadowRadius != CGFloat.zero ? self.shadowRadius : CGFloat.zero
                self.containerView.layer.shadowOffset = self.shadowOffset != CGSize.zero ? self.shadowOffset : CGSize.zero
                self.containerView.layer.shadowColor = self.shadowColor?.cgColor ?? UIColor.clear.cgColor
                
            case .active:
                self.ivLeadingIcon.tintColor = self.iconTintLeadingActive ?? (self.iconTintLeading ?? EDTSColor.blue50)
                self.ivLeadingIconBG.backgroundColor = self.iconBGColorLeadingActive ?? (self.iconBGColorLeading ?? UIColor.white)
                self.lblTitle.textColor = self.labelColorActive ?? (self.labelColor ?? EDTSColor.white)
                self.ivTrailingIcon.tintColor = self.iconTintTrailingActive ?? (self.iconTintTrailing ?? EDTSColor.blue50)
                self.ivTrailingIconBG.backgroundColor = self.iconBGColorTrailingActive ?? (self.iconBGColorTrailing ?? UIColor.white)
                self.containerView.backgroundColor = self.bgColorActive ?? (self.bgColor ?? EDTSColor.blue50)
                self.containerView.layer.borderColor = self.borderColorActive?.cgColor ?? (self.borderColor?.cgColor ?? UIColor.clear.cgColor)
                self.containerView.layer.shadowOpacity = self.shadowOpacityActive != Float.zero ? self.shadowOpacityActive : (self.shadowOpacity != Float.zero ? self.shadowOpacity : Float.zero)
                self.containerView.layer.shadowRadius = self.shadowRadiusActive != CGFloat.zero ? self.shadowRadiusActive : (self.shadowRadius != CGFloat.zero ? self.shadowRadius : CGFloat.zero)
                self.containerView.layer.shadowOffset = self.shadowOffsetActive != CGSize.zero ? self.shadowOffsetActive : (self.shadowOffset != CGSize.zero ? self.shadowOffset : CGSize.zero)
                self.containerView.layer.shadowColor = self.shadowColorActive?.cgColor ?? (self.shadowColor?.cgColor ?? UIColor.clear.cgColor)
            }
        }
        
        if animated {
            UIView.animate(
                withDuration: 0.1,
                delay: 0,
                options: [.curveEaseInOut],
                animations: changes,
                completion: nil
            )
        } else {
            changes()
        }
    }
    
    // MARK: - Action Function
    private func setupIconGestures() {
        ivLeadingIcon.isUserInteractionEnabled = true
        ivTrailingIcon.isUserInteractionEnabled = true
        
        let leadingPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(onLongPressLeadingIcon(_:))
        )
        leadingPress.minimumPressDuration = 0
        ivLeadingIcon.addGestureRecognizer(leadingPress)
        
        let trailingPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(onLongPressTrailingIcon(_:))
        )
        trailingPress.minimumPressDuration = 0
        ivTrailingIcon.addGestureRecognizer(trailingPress)
    }
    
    @objc private func onLongPressLeadingIcon(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            ivLeadingIcon.showIconRipple(size: ivLeadingIcon.bounds.width + 8)
            
        case .ended:
            delegate?.didSelectChipIconLeading(self)
            ivLeadingIcon.hideIconRipple()
            
        case .cancelled, .failed:
            ivLeadingIcon.hideIconRipple()
            
        default:
            break
        }
    }
    
    @objc private func onLongPressTrailingIcon(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            ivTrailingIcon.showIconRipple(size: ivTrailingIcon.bounds.width + 8)
            
        case .ended:
            delegate?.didSelectChipIconTrailing(self)
            ivTrailingIcon.hideIconRipple()
            
        case .cancelled, .failed:
            ivTrailingIcon.hideIconRipple()
            
        default:
            break
        }
    }
}

@MainActor
public protocol EDTSChipDelegate: AnyObject {
    func didSelectChip(_ chip: EDTSChip)
    func didSelectChipIconLeading(_ chip: EDTSChip)
    func didSelectChipIconTrailing(_ chip: EDTSChip)
}

public enum ChipState: String {
    case inactive = "inactive"
    case active = "active"
}
