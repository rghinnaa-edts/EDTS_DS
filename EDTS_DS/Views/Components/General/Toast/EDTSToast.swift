//
//  Toast.swift
//  KlikIDM_DS
//
//  Created by Yovita Handayiani on 26/01/26.
//

import UIKit

public enum EDTSToastState: String {
    case info = "info"
    case danger = "danger"
}

@IBDesignable
public class EDTSToast: UIView {
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var hStackContainer: UIStackView!
    @IBOutlet weak var ivImg: UIImageView!
    @IBOutlet weak var tvTitle: UITextView!
    @IBOutlet weak var btnAction: EDTSButton!
    @IBOutlet weak var btnIconAction: EDTSButtonIcon!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Inspectables
    @IBInspectable public var toastState: String? {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var label: String? {
        didSet{
            tvTitle.attributedText = nil
            tvTitle.text = label
        }
    }
    
    public var labelAttributed: NSAttributedString? {
        didSet {
            tvTitle.text = nil
            tvTitle.attributedText = labelAttributed
        }
    }
    
    @IBInspectable public var fontName: String = "" {
        didSet {
            setupFont()
        }
    }
    
    @IBInspectable public var fontSize: CGFloat = -1.0 {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var fontWeight: String = "" {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var labelColor: UIColor? {
        didSet{
            setupToastState()
        }
    }
    
    @IBInspectable public var bgColor: UIColor? {
        didSet{
            setupToastState()
        }
    }
    
    @IBInspectable public var iconLeading: UIImage? {
        didSet{
            setupIcon()
        }
    }
    
    @IBInspectable public var iconTintColorLeading: UIColor? {
        didSet{
            setupToastState()
        }
    }
    
    @IBInspectable public var iconSize: CGFloat = -1.0 {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var spacing: CGFloat =  -1.0 {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = -1.0 {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = -1.0 {
        didSet{
            containerView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet{
            containerView.layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = -1.0 {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = -1.0 {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize.zero {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var paddingTop: CGFloat = -1.0 {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var paddingBottom: CGFloat = -1.0 {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var paddingLeading: CGFloat = -1.0 {
        didSet {
            setupToastState()
        }
    }
    
    @IBInspectable public var paddingTrailing: CGFloat = -1.0 {
        didSet {
            setupToastState()
        }
    }
    
    // MARK: - Public Variable
    public weak var delegate: EDTSToastDelegate?
    
    // MARK: - Private Variable
    private var tempBgColor: UIColor?
    private var tempFontSize: CGFloat = -1.0
    private var tempFontWeight: String = ""
    private var tempLabelColor: UIColor?
    private var tempIconTintColorLeading: UIColor?
    private var tempIconSize: CGFloat = -1.0
    private var tempSpacing: CGFloat = -1.0
    private var tempCornerRadius: CGFloat = -1.0
    private var tempShadowOpacity: Float = -1.0
    private var tempShadowRadius: CGFloat = -1.0
    private var tempShadowOffset: CGSize = CGSize.zero
    private var tempShadowColor: UIColor?
    private var tempPaddingTop: CGFloat = -1.0
    private var tempPaddingBottom: CGFloat = -1.0
    private var tempPaddingLeading: CGFloat = -1.0
    private var tempPaddingTrailing: CGFloat = -1.0
    private let defaultValue : CGFloat = -1.0
    
    private var panRecognizer: UIPanGestureRecognizer?
    private var originalPosition: CGPoint = .zero
    private var dragDirections: (x: Bool, y: Bool) = (x: true, y: false)
    private var dismissDirection: UISwipeGestureRecognizer.Direction = .right
    
    private var resolvedToastState: EDTSToastState {
        guard let state = toastState else { return .info }
        let normalized = state.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return EDTSToastState(rawValue: normalized) ?? .info
    }
    
    // MARK: - Initializers
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
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = false
    }
    
    // MARK: - Setup & Styling
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSToast", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        
        setupUI()
    }
    
    private func setupUI(){
        tvTitle.textContainerInset = .zero
        tvTitle.textContainer.lineFragmentPadding = 0
        ivImg.image = ivImg.image?.withRenderingMode(.alwaysTemplate)
        ivImg.tintColor = EDTSColor.white
        
        setupIcon()
        btnAction.isHidden = true
        btnIconAction.isHidden = true
        setupToastState()
        setupDefaultButtonStyle()
        setupDefaultButtonIconStyle()
    }
    
    private func setupIcon() {
        if let icon = iconLeading {
            ivImg.isHidden = false
            ivImg.image = icon.withRenderingMode(.alwaysTemplate)
        } else {
            ivImg.isHidden = true
            ivImg.image = nil
        }
    }
    
    private func setupFont() {
        let size = tempFontSize
        let weight = setupFontWeight(from: tempFontWeight.isEmpty ? "Semibold" : tempFontWeight)
        
        if !fontName.isEmpty {
            tvTitle.font = UIFont(name: fontName, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            tvTitle.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    private func setupFontWeight(from value: String) -> UIFont.Weight {
        let normalized = value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        let weight = FontWeight(rawValue: normalized) ?? .regular
        
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
    
    private func setupIconConstraint(){
        iconWidthConstraint?.constant = tempIconSize
        iconHeightConstraint?.constant = tempIconSize
    }

    private func setupToastStyle(){
        setupFont()
        setupIconConstraint()
        
        tvTitle.textColor = tempLabelColor
        containerView.backgroundColor = tempBgColor
        ivImg.image = ivImg.image?.withRenderingMode(.alwaysTemplate)
        ivImg.tintColor = tempIconTintColorLeading
        hStackContainer.spacing = tempSpacing
        containerView.layer.cornerRadius = tempCornerRadius
        containerView.layer.shadowOpacity = tempShadowOpacity
        containerView.layer.shadowRadius = tempShadowRadius
        containerView.layer.shadowOffset = tempShadowOffset
        containerView.layer.shadowColor = tempShadowColor?.cgColor
        topConstraint?.constant = tempPaddingTop
        bottomConstraint?.constant = tempPaddingBottom
        leadingConstraint?.constant = tempPaddingLeading
        trailingConstraint?.constant = tempPaddingTrailing
    }
    
    private func setupToastState() {
        switch resolvedToastState {
        case .info:
            tempBgColor = bgColor ?? EDTSColor.grey60
            
        case .danger:
            tempBgColor = bgColor ?? EDTSColor.errorStrong
        }
        
        tempFontSize = fontSize == defaultValue ? 12 : fontSize
        tempFontWeight = fontWeight.isEmpty == true ? "regular" : fontWeight
        tempLabelColor = labelColor ?? EDTSColor.white
        tempIconTintColorLeading = iconTintColorLeading ?? EDTSColor.white
        tempIconSize = iconSize == defaultValue ? 16 : iconSize
        tempSpacing = spacing == defaultValue ? 8 : spacing
        tempCornerRadius = cornerRadius == defaultValue ? 8 : cornerRadius
        tempShadowOpacity = shadowOpacity == Float(defaultValue) ? 1.0 : shadowOpacity
        tempShadowRadius = shadowRadius == defaultValue ? 4 : shadowRadius
        tempShadowOffset = shadowOffset == CGSize.zero ? CGSize(width: 0, height: 2) : shadowOffset
        tempShadowColor = shadowColor ?? UIColor(red: 112/255, green: 114/255, blue: 125/255, alpha: 0.4)
        tempPaddingTop = paddingTop == defaultValue ? 16 : paddingTop
        tempPaddingBottom = paddingBottom == defaultValue ? 16 : paddingBottom
        tempPaddingLeading = paddingLeading == defaultValue ? 16 : paddingLeading
        tempPaddingTrailing = paddingTrailing == defaultValue ? 16 : paddingTrailing
        
        setupToastStyle()
    }
    
    private func setupDefaultButtonStyle() {
        btnAction.btnType = "Primary"
        btnAction.btnSize = "Small"
        btnAction.btnState = "Default"
        btnAction.labelColor = .white
        btnAction.fontSize = 12
        btnAction.fontWeight = "semibold"
        btnAction.bgColor = .clear
        btnAction.paddingTop = 0
        btnAction.paddingBottom = 0
        btnAction.paddingLeading = 0
        btnAction.paddingTrailing = 0
        btnAction.rippleColor = UIColor.clear
    }
    
    private func setupDefaultButtonIconStyle() {
        btnIconAction.btnType = "Primary"
        btnIconAction.btnSize = "Small"
        btnIconAction.btnState = "Default"
        btnIconAction.bgColor = .clear
        btnIconAction.paddingTop = 0
        btnIconAction.paddingBottom = 0
        btnIconAction.paddingLeading = 0
        btnIconAction.paddingTrailing = 0
        btnIconAction.rippleColor = UIColor.clear
    }
    
    public func configureButton(_ instance: (EDTSButton) -> Void) {
        guard btnAction != nil else { return }
        btnAction.isHidden = false
        instance(btnAction)
    }
    
    public func configureIconButton(_ instance: (EDTSButtonIcon) -> Void) {
        guard btnIconAction != nil else { return }
        btnIconAction.isHidden = false
        instance(btnIconAction)
    }
    
    public func setupDrag(swipeDirection: EDTSToastSwipeDirection, offsetY: EDTSToastOffsetDirection) {
        dragDirections = swipeDirection.allowedDirections
        dismissDirection = swipeDirection.dismissDirection(offsetY: offsetY)
        
        panRecognizer.map { containerView.removeGestureRecognizer($0) }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.cancelsTouchesInView = false
        containerView.addGestureRecognizer(pan)
        panRecognizer = pan
    }
    
    // MARK: - Action
    @IBAction func onButtonTap(_ sender: Any) {
        delegate?.didSelectButton(self)
    }
    
    @IBAction func onButtonIconTap(_ sender: Any) {
        delegate?.didSelectButton(self)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: superview)
        
        var clampedX = dragDirections.x ? translation.x : 0
        var clampedY = dragDirections.y ? translation.y : 0
        
        switch dismissDirection {
        case .right: clampedX = max(0, clampedX)
        case .down:  clampedY = max(0, clampedY)
        case .up:    clampedY = min(0, clampedY)
        default: break
        }

        switch gesture.state {
        case .began:
            break

        case .changed:
            self.transform = CGAffineTransform(translationX: clampedX, y: clampedY)

        case .ended, .cancelled:
            let velocity = gesture.velocity(in: superview)
            
            let axialVelocity: CGFloat
            let axialDistance: CGFloat
            let threshold: CGFloat
            
            switch dismissDirection {
            case .right:
                axialVelocity = velocity.x
                axialDistance = clampedX
                threshold = UIScreen.main.bounds.width * 0.4
            case .down:
                axialVelocity = velocity.y
                axialDistance = clampedY
                threshold = 50
            case .up:
                axialVelocity = -velocity.y
                axialDistance = -clampedY
                threshold = 50
            default:
                axialVelocity = 0
                axialDistance = 0
                threshold = UIScreen.main.bounds.height * 0.9
            }
            
            let isFastSwipe = axialVelocity > 600
            let isFarEnough = axialDistance > threshold

            if isFastSwipe || isFarEnough {
                delegate?.didSwipeToast(self, direction: dismissDirection)
            } else {
                UIView.animate(withDuration: 0.3, delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 0.5) {
                    self.transform = .identity
                }
            }

        default:
            break
        }
    }
}

public protocol EDTSToastDelegate: AnyObject {
    func didSelectButton(_ toast: EDTSToast)
    func didSwipeToast(_ toast: EDTSToast, direction: UISwipeGestureRecognizer.Direction)
}
