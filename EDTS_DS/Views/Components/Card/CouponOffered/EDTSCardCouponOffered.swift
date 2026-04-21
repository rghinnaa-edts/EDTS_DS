//
//  CouponOffered.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 22/12/25.
//

import UIKit

//MARK: - Enum
public enum FairGeneralType: String {
    case exclusive = "Exclusive"
    case general = "General"
}

@IBDesignable
public class CardCouponOffered: UIView {
    
    //MARK: - Outlets
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var containerBackground: UIView!
    @IBOutlet weak var ivCoupon: UIImageView!
    @IBOutlet weak var lblCoupon: UILabel!
    @IBOutlet weak var lblMinimumTransaction: UILabel!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var lblPeriode: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var badgeFairGeneral: Badge!
    @IBOutlet weak var badgeCoupon: Badge!
    @IBOutlet weak var badgeCouponCode: Badge!
    @IBOutlet weak var badgeMinimumTransaction: Badge!
    @IBOutlet weak var badgeService: Badge!
    @IBOutlet weak var badgePeriode: Badge!
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var btnExchange: KlikIDM_DSButton!
    @IBOutlet weak var vInformation: UIView!
    @IBOutlet weak var vDivider: UIView!
    @IBOutlet weak var vSkeletonTop: UIView!
    @IBOutlet weak var vSkeletonBottom: UIView!
    
    @IBOutlet weak var badgeFairGeneralWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgeCouponLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnExchangedBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var vInformationBottomConstraint: NSLayoutConstraint?
    
    
    //MARK: - Inspectables
    
    @IBInspectable public var image: UIImage? = nil {
        didSet {
            ivCoupon.image = image
        }
    }
    
    @IBInspectable public var title: String? = nil {
        didSet {
            lblCoupon.text = title
        }
    }
    
    @IBInspectable public var minimumTransaction: Int = 0 {
        didSet {
            lblMinimumTransaction.text = minimumTransaction.formatRupiah()
        }
    }
    
    @IBInspectable public var service: String? = nil {
        didSet {
            lblService.text = service
        }
    }
    
    @IBInspectable public var periode: String? = nil {
        didSet {
            lblPeriode.text = periode
        }
    }
    
    @IBInspectable public var periodeTextColor: UIColor? = UIColor.grey40 {
        didSet {
            lblPeriode.textColor = periodeTextColor
        }
    }
    
    @IBInspectable public var isFairGeneral: Bool = false {
        didSet {
            updateBadgeFairGeneral()
        }
    }
    
    @IBInspectable public var fairGeneralType: String = FairGeneralType.exclusive.rawValue {
        didSet {
            updateBadgeFairGeneral()
        }
    }
    
    @IBInspectable public var isCoupon: Bool = true {
        didSet {
            badgeCoupon.isHidden = !isCoupon
        }
    }
    
    @IBInspectable public var couponCode: String? = nil {
        didSet {
            setupBadgeCouponCode()
        }
    }
    
    @IBInspectable public var disableInfoDescription: String? = nil {
        didSet {
            lblInfo.text = disableInfoDescription
        }
    }
    
    @IBInspectable public var bgColor: UIColor? = nil {
        didSet {
            cardBgColor = bgColor
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 12.0 {
        didSet {
            DispatchQueue.main.async {
                self.setupCouponShape()
            }
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = 0.0 {
        didSet {
            cardShadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize.zero {
        didSet {
            cardShadowOffset = shadowOffset
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0.0 {
        didSet {
            cardShadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? = UIColor.black {
        didSet {
            cardShadowColor = shadowColor
        }
    }
    
    @IBInspectable public var shadowActiveColor: UIColor? = UIColor.black {
        didSet {
            cardShadowActiveColor = shadowActiveColor
        }
    }
    
    @IBInspectable public var isNewUser: Bool = true {
        didSet {
            updateRibbon()
        }
    }
    
    @IBInspectable public var isExchanged: Bool = true {
        didSet {
            updateButtonExchange()
            updatePeriodeText()
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable public var isCanExchange: Bool = true {
        didSet {
            updateButtonExchange()
            updatePeriodeText()
        }
    }
    
    @IBInspectable public var isEnabled: Bool = true {
        didSet {
            updateEnabledCard()
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable public var isSkeleton: Bool = false {
        didSet {
            updateSkeleton()
            invalidateIntrinsicContentSize()
        }
    }
    
    //MARK: - Public Variables
    public weak var delegate: CardCouponOfferedDelegate?
    
    //MARK: - Private Variables
    
    private var cardBgColor = UIColor.white
    private var cardShadowOpacity: Float = 0.0
    private var cardShadowOffset = CGSize.zero
    private var cardShadowRadius = 0.0
    private var cardShadowColor = UIColor.black
    private var cardShadowActiveColor = UIColor.black
    private var ribbonView: RibbonView?
    
    
    //MARK: - Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    override public var intrinsicContentSize: CGSize {
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
        
        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        
        let size = containerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return size
    }
    
    //MARK: - Public Functions
    
    public func calculateHeight(forWidth width: CGFloat) -> CGFloat {
        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        
        let size = containerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return 200
    }
    
    public func startFloatingAnimation() {
        let icon = UIImage(named: "ic-voucher")
        
        DispatchQueue.main.async {
            self.showFloatingAnimation(
                from: self.btnExchange,
                icon: icon,
                text: "+1",
                duration: 1,
                floatDistance: 100)
        }
    }
    
    //MARK: - Private Functions
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("CardCouponOffered", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.backgroundColor = .grey10
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            setupUI()
        }
    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            self.setupCouponShape()
        }
        setupBadgeCoupon()
        setupBadgeMinimumTransaction()
        setupBadgeService()
        setupBadgePeriode()
        setupBadgeCouponCode()
        
        updateBadgeFairGeneral()
    }
    
    private func setupCouponShape() {
        let dashedLineY = vDivider.frame.origin.y - 25
        
        containerBackground.clipsToBounds = true
        containerBackground.applyCouponBackground(
            notchRadius: 4,
            notchPosition: dashedLineY,
            cornerRadius: cornerRadius
        )
        
        let couponPath = containerView.createCouponPath(
            in: containerBackground.bounds,
            notchRadius: 4,
            notchPosition: dashedLineY,
            cornerRadius: cornerRadius
        )
        
        containerView.backgroundColor = .clear
        containerView.layer.shadowColor = shadowColor?.cgColor ?? UIColor.black?.cgColor
        containerView.layer.shadowOpacity = shadowOpacity
        containerView.layer.shadowOffset = shadowOffset
        containerView.layer.shadowRadius = shadowRadius
        containerView.layer.masksToBounds = false
        containerView.layer.shadowPath = couponPath.cgPath
    }
    
    private func setupBadgeGeneralFair() {
        badgeFairGeneral.label = FairGeneralType.general.rawValue
        badgeFairGeneral.labelColor = UIColor.white
        badgeFairGeneral.bgColor = UIColor.green50
        badgeFairGeneral.cornerRadius = 4
    }
    
    private func setupBadgeExclusiveFair() {
        badgeFairGeneral.label = FairGeneralType.exclusive.rawValue
        badgeFairGeneral.labelColor = UIColor.white
        badgeFairGeneral.bgColor = UIColor.yellow50
        badgeFairGeneral.cornerRadius = 4
    }
    
    private func setupBadgeCoupon() {
        badgeCoupon.label = "i-Kupon"
        badgeCoupon.bgColor = UIColor.blue20
        badgeCoupon.labelColor = UIColor.blue50
        badgeCoupon.cornerRadius = 4
        badgeCoupon.labelFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
    }
    
    private func setupBadgeCouponCode() {
        let code = couponCode ?? ""
        let fullText = "Kode: \(code)"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let regularFont = UIFont.systemFont(ofSize: 10, weight: .regular)
        let regularRange = (fullText as NSString).range(of: "Kode: ")
        attributedString.addAttribute(.font, value: regularFont, range: regularRange)
        
        let semiboldFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
        let codeRange = (fullText as NSString).range(of: code)
        attributedString.addAttribute(.font, value: semiboldFont, range: codeRange)
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.grey50 ?? UIColor.gray, range: NSRange(location: 0, length: fullText.count))
        
        badgeCouponCode.labelAttributed = attributedString
        badgeCouponCode.bgColor = UIColor.grey20
        badgeCouponCode.labelColor = UIColor.grey50
        badgeCouponCode.cornerRadius = 4
    }
    
    private func setupBadgeMinimumTransaction() {
        badgeMinimumTransaction.label = "Minimum Transaksi"
        badgeMinimumTransaction.bgColor = UIColor.clear
        badgeMinimumTransaction.labelColor = UIColor.grey40
        badgeMinimumTransaction.icon = UIImage(named: "ic-bag")
        badgeMinimumTransaction.iconTint = UIColor.grey40
        badgeMinimumTransaction.paddingLeading = 0
    }
    
    private func setupBadgeService() {
        badgeService.label = "Service"
        badgeService.bgColor = UIColor.clear
        badgeService.labelColor = UIColor.grey40
        badgeService.icon = UIImage(named: "ic-cart")
        badgeService.iconTint = UIColor.grey40
        badgeService.paddingLeading = 0
    }
    
    private func setupBadgePeriode() {
        badgePeriode.label = "Periode"
        badgePeriode.bgColor = UIColor.clear
        badgePeriode.labelColor = UIColor.grey40
        badgePeriode.icon = UIImage(named: "ic-clock")
        badgePeriode.iconTint = UIColor.grey40
        badgePeriode.paddingLeading = 0
    }
    
    private func updateBadgeFairGeneral() {
        badgeFairGeneral.isHidden = !isFairGeneral
        
        if isFairGeneral {
            badgeFairGeneral.isHidden = false
            badgeCouponLeadingConstraint?.constant = 4
            
            if fairGeneralType == FairGeneralType.exclusive.rawValue {
                setupBadgeExclusiveFair()
            } else {
                setupBadgeGeneralFair()
            }
        } else {
            badgeFairGeneral.isHidden = true
            badgeFairGeneralWidthConstraint?.constant = 0
            badgeCouponLeadingConstraint?.constant = 0
        }
    }
    
    private func updateEnabledCard() {
        if !isSkeleton {
            if isEnabled {
                containerBackground.applyGrayscale(false)
                
                badgeCouponCode.isHidden = false
                vDivider.isHidden = false
                btnDetail.isHidden = false
                btnExchange.isHidden = false
                vInformation.isHidden = true
                
                btnExchangedBottomConstraint?.priority = .defaultHigh
                vInformationBottomConstraint?.priority = .defaultLow
            } else {
                badgeCouponCode.isHidden = true
                vDivider.isHidden = true
                btnDetail.isHidden = true
                btnExchange.isHidden = true
                vInformation.isHidden = false
                
                btnExchangedBottomConstraint?.priority = .defaultLow
                vInformationBottomConstraint?.priority = .defaultHigh
                
                containerBackground.applyGrayscale(true)
            }
        }
    }
    
    private func updatePeriodeText() {
        badgePeriode.label = isExchanged ? "Berlaku Hingga" : "Periode"
    }
    
    private func updateButtonExchange() {
        if isExchanged {
            btnExchange.btnType = "tertiary"
            btnExchange.btnState = "rest"
            btnExchange.btnSize = "custom"
            btnExchange.fontSize = 12
            btnExchange.fontWeight = "semibold"
            btnExchange.label = "Lihat"
            btnExchange.bgColorStart = nil
            btnExchange.bgColorEnd = nil
        } else {
            btnExchange.btnType = "custom"
            btnExchange.btnSize = "custom"
            btnExchange.label = "Tukar"
            btnExchange.fontSize = 12
            btnExchange.fontWeight = "semibold"
            btnExchange.bgColorStart = UIColor.leadingSkyblue
            btnExchange.bgColorEnd = UIColor.trailingSkyblue
            btnExchange.bgColorOrientation = "horizontal"
        }
    }
    
    private func updateSkeleton() {
        if isSkeleton {
            vSkeletonTop.isHidden = false
            vSkeletonBottom.isHidden = false
            
            containerBackground.applyGrayscale(false)
            ribbonView?.removeFromSuperview()
            ribbonView = nil
        } else {
            vSkeletonTop.isHidden = true
            vSkeletonBottom.isHidden = true
        }
    }
    
    //MARK: - Ribbon
    
    private func updateRibbon() {
        if isNewUser {
            DispatchQueue.main.async {
                self.setupRibbon()
            }
        } else {
            ribbonView?.removeFromSuperview()
            ribbonView = nil
        }
    }
    
    private func setupRibbon() {
        ribbonView?.removeFromSuperview()
        
        let newRibbonView = RibbonView()
        
        newRibbonView.ribbonText = "Pengguna Baru"
        newRibbonView.triangleColor = UIColor.orange50 ?? .orange
        newRibbonView.containerStartColor = UIColor.yellow30 ?? .yellow
        newRibbonView.containerEndColor = UIColor.orange30 ?? .orange
        newRibbonView.textColor = UIColor.white ?? .systemYellow
        newRibbonView.gravity = .end

        newRibbonView.anchorToView(
            rootParent: containerView,
            targetView: containerView,
            offsetX: 0,
            offsetY: 4
        )
        
        ribbonView = newRibbonView
    }
    
    //MARK: - Animations
    
    private func showFloatingAnimation(
        from anchor: UIView,
        icon: UIImage? = nil,
        text: String = "+1",
        duration: TimeInterval = 1.5,
        floatDistance: CGFloat = 200
    ) {
        guard let window = anchor.window else { return }
        let helper = AnimationHelper()
        
        let floatingView = createFloatingView(icon: icon, text: text)
        let anchorCenter = anchor.convert(CGPoint(x: anchor.bounds.midX, y: anchor.bounds.midY), to: window)
        
        floatingView.center = CGPoint(
            x: anchorCenter.x,
            y: anchorCenter.y - 16
        )
        
        window.addSubview(floatingView)
        
        helper.animateFloating(
            view: floatingView,
            distance: floatDistance,
            duration: duration
        ) {
            floatingView.removeFromSuperview()
        }
    }
    
    private func createFloatingView(icon: UIImage?, text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        if let icon = icon {
            let iconView = UIImageView(image: icon)
            iconView.contentMode = .scaleAspectFit
            iconView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                iconView.widthAnchor.constraint(equalToConstant: 16),
                iconView.heightAnchor.constraint(equalToConstant: 16)
            ])
            
            stackView.addArrangedSubview(iconView)
        }
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.blue50
        
        stackView.addArrangedSubview(label)
        
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
        
        container.sizeToFit()
        container.frame.size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        container.frame.size.width += 32
        container.frame.size.height += 32
        
        return container
    }
    
    @IBAction func btnDetail(_ sender: Any) {
        delegate?.didSelectButtonDetail()
    }
    
    @IBAction func btnExchange(_ sender: Any) {
        delegate?.didSelectButtonExchange(isCanExchange: isCanExchange, isExchanged: isExchanged)
    }
}

@MainActor
public protocol CardCouponOfferedDelegate: AnyObject {
    func didSelectButtonDetail()
    func didSelectButtonExchange(isCanExchange: Bool, isExchanged: Bool)
}
