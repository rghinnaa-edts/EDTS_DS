//
//  CardMyCoupon.swift
//  KlikIDM_DS
//
//  Created by Yovita Handayiani on 22/12/25.
//

import UIKit

@IBDesignable
public class CardMyCoupon: UIView {
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var ivLeadingIcon: UIImageView!
    @IBOutlet weak var ivLeadingIconBG: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cvBadge: Badge!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var ivTrailingIcon: UIImageView!
    
    // MARK: - Inspectables
    @IBInspectable public var title: String?{
        didSet{
            lblTitle.text = title
        }
    }
    
    @IBInspectable public var titleColor: UIColor?{
        didSet{
            lblTitle.textColor = titleColor
        }
    }
    
    @IBInspectable public var desc: String?{
        didSet{
            lblDesc.text = desc
        }
    }
    
    @IBInspectable public var descColor: UIColor?{
        didSet{
            lblDesc.textColor = descColor
        }
    }
    
    @IBInspectable public var isLiquidGlassBg: Bool = true {
        didSet {
            setupBackground()
        }
    }
    
    @IBInspectable public var bgColor: UIColor?{
        didSet {
            setupBackground()
        }
    }
    
    @IBInspectable public var iconLeading: UIImage?{
        didSet{
            ivLeadingIcon.image = iconLeading
        }
    }
    
    @IBInspectable public var iconTintLeading: UIColor?{
        didSet{
            ivLeadingIcon.image = ivLeadingIcon.image?.withRenderingMode(.alwaysTemplate)
            ivLeadingIcon.tintColor = iconTintLeading
        }
    }
    
    @IBInspectable public var iconBgTintLeading: UIColor?{
        didSet {
            setupLeadingIconBG(iconBgTintLeading)
        }
    }
    
    @IBInspectable public var iconTrailing: UIImage?{
        didSet{
            ivTrailingIcon.image = iconTrailing
        }
    }
    
    @IBInspectable public var iconTintTrailing: UIColor?{
        didSet{
            ivTrailingIcon.image = ivTrailingIcon.image?.withRenderingMode(.alwaysTemplate)
            ivTrailingIcon.tintColor = iconTintTrailing
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = CGFloat.zero {
        didSet {
            containerView.layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Public Variable
    public weak var delegate: CardMyCouponDelegate?
    
    // MARK: - Private Variable
    private let gradientLayer = CAGradientLayer()
    
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
        
        layer.cornerRadius = 8
        containerView.clipsToBounds = false
        ivLeadingIconBG.applyCircular()
        ivLeadingIconBG.clipsToBounds = true
    }
    
    // MARK: - Setup & Styling
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("CardMyCoupon", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        setupUI()
    }
    
    private func setupUI(){
        containerView.isUserInteractionEnabled = true
        isUserInteractionEnabled = true
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = false
        
        setupDefaultState()
        setupBackground()
        setupPressGesture()
    }
    
    private func setupBackground() {
        containerView.subviews
            .filter { $0 is UIVisualEffectView || $0 is LiquidGlassBackgroundView }
            .forEach { $0.removeFromSuperview() }
        
        if isLiquidGlassBg {
            containerView.backgroundColor = .clear
            setupLiquidGlass()
        } else {
            containerView.backgroundColor = bgColor ?? .clear
        }
    }
    
    private func setupLiquidGlass(){
        if #available(iOS 26.0, *) {
            let glassContainerEffect = UIGlassContainerEffect()
            glassContainerEffect.spacing = 16
            
            let glassContainerView = UIVisualEffectView(effect: glassContainerEffect)
            glassContainerView.translatesAutoresizingMaskIntoConstraints = false
            glassContainerView.backgroundColor = .clear
            glassContainerView.layer.cornerRadius = 8
            
            let glassEffect = UIGlassEffect(style: .clear)
            let glassView = UIVisualEffectView(effect: glassEffect)
            glassView.translatesAutoresizingMaskIntoConstraints = false
            glassView.layer.cornerRadius = 8
            containerView.insertSubview(glassContainerView, at: 0)
            glassContainerView.contentView.addSubview(glassView)
            
            NSLayoutConstraint.activate([
                glassContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                glassContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                glassContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
                glassContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                
                glassView.leadingAnchor.constraint(equalTo: glassContainerView.contentView.leadingAnchor),
                glassView.trailingAnchor.constraint(equalTo: glassContainerView.contentView.trailingAnchor),
                glassView.topAnchor.constraint(equalTo: glassContainerView.contentView.topAnchor),
                glassView.bottomAnchor.constraint(equalTo: glassContainerView.contentView.bottomAnchor)
            ])
        } else {
            let glassBackground = LiquidGlassBackgroundView()
            glassBackground.translatesAutoresizingMaskIntoConstraints = false
            containerView.insertSubview(glassBackground, at: 0)
            
            NSLayoutConstraint.activate([
                glassBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                glassBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                glassBackground.topAnchor.constraint(equalTo: containerView.topAnchor),
                glassBackground.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
    }
    
    private func setupLeadingIconBG(_ BGColor : UIColor?){
        gradientLayer.type = .radial
        gradientLayer.colors = [
            BGColor?.withAlphaComponent(0.5).cgColor ?? UIColor.blue.withAlphaComponent(0.5).cgColor,
            BGColor?.withAlphaComponent(1.0).cgColor ?? UIColor.blue.withAlphaComponent(1.0).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = ivLeadingIconBG.bounds
        gradientLayer.opacity = 0.3
        
        ivLeadingIconBG.backgroundColor = .clear
        ivLeadingIconBG.layer.insertSublayer(gradientLayer, at: 0)
        ivLeadingIconBG.frame = ivLeadingIconBG.bounds
    }
    
    private func setupBadge(){
        cvBadge.labelColor = UIColor.white
        cvBadge.bgColor = UIColor.red30
        cvBadge.cornerRadius = cvBadge.bounds.height / 2
        cvBadge.borderColor = UIColor.white
        cvBadge.borderWidth = 1
    }
    
    private func setupDefaultState(){
        titleColor = UIColor.white
        descColor = UIColor.grey30
        iconLeading = UIImage(named: "ic-my-coupon")
        setupLeadingIconBG(UIColor.white)
        iconTrailing = UIImage(named: "ic-chevron-right")
        ivTrailingIcon.image = ivTrailingIcon.image?.withRenderingMode(.alwaysTemplate)
        iconTintTrailing = UIColor.white
        setupBadge()
    }
    
    public func configureBadge(_ instance: (Badge) -> Void) {
        guard cvBadge != nil else { return }
        cvBadge.isHidden = false
        instance(cvBadge)
    }
    
    // MARK: - Animation
    private func animateScaleDown() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            }
        )
    }
    
    private func animateScaleUp() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.transform = .identity
            }
        )
    }

    private func setupPressGesture() {
        let pressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handlePress(_:))
        )
        pressGesture.minimumPressDuration = 0
        pressGesture.cancelsTouchesInView = false
        addGestureRecognizer(pressGesture)
    }
    
    @objc private func handlePress(_ gesture: UILongPressGestureRecognizer) {
        guard !cvBadge.isSkeleton else { return }
        
        switch gesture.state {
        case .began:
            animateScaleDown()
        case .ended, .cancelled, .failed:
            animateScaleUp()
            delegate?.didSelectCard(self)
        default:
            break
        }
    }
}


@MainActor
public protocol CardMyCouponDelegate: AnyObject {
    func didSelectCard(_ card: CardMyCoupon)
}
