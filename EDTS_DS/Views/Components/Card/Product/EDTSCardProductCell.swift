//
//  ProductCardCell.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 10/02/25.
//

import UIKit

public class CardProductCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerBackgroundView: UIView!
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var ivBadgeGift: UIImageView!
    @IBOutlet weak var lblBadgeGift: UILabel!
    @IBOutlet weak var badgeGift: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var vDiscount: UIView!
    @IBOutlet weak var badgeDiscount: Badge!
    @IBOutlet weak var lblRealPrice: UILabel!
    @IBOutlet weak var badgePromo2: Badge!
    @IBOutlet weak var badgePromo3: Badge!
    @IBOutlet weak var vPointStamp: UIView!
    @IBOutlet weak var ivPoint: UIImageView!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var ivStamp: UIImageView!
    @IBOutlet weak var lblStamp: UILabel!
    @IBOutlet weak var btnStepper: ButtonStepper!
    
    public var badgeGiftColor: UIColor? {
        didSet {
            badgeGift.backgroundColor = badgeGiftColor
        }
    }
    
    public var currentQuantity: Int {
        return productQty
    }
    
    public weak var delegate: CardProductCellDelegate?
    
    private var productQty = 0
    
    private var discountConstraint: NSLayoutConstraint!
    private var realPriceConstraint: NSLayoutConstraint!
    private var badgePromo2Constraint: NSLayoutConstraint!
    private var badgePromo3Constraint: NSLayoutConstraint!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }
    
    public func loadData(data: CardProductModel) {
        ivProduct.image = data.image
        ivBadgeGift.image = data.iconGiftBadge
        lblBadgeGift.text = data.nameGiftBadge
        badgeGift.backgroundColor = data.bgGiftBadge
        lblName.text = data.name
        lblPrice.text = data.price.formatRupiah()
        lblRealPrice.attributedText = data.realPrice.formatRupiah().strikethrough()

        discountConstraint = badgeDiscount.heightAnchor.constraint(equalToConstant: 14)
        discountConstraint.isActive = true
        discountConstraint.constant = (data.discount == 0) ? 0 : 14
        
        realPriceConstraint = lblRealPrice.heightAnchor.constraint(equalToConstant: 14)
        realPriceConstraint.isActive = true
        realPriceConstraint.constant = (data.discount == 0) ? 0 : 14
        
        badgeDiscount.bgColor = UIColor.red10
        badgeDiscount.labelColor = UIColor.red30
        badgeDiscount.label = "\(data.discount)%"
        
        badgePromo2Constraint = badgePromo2.heightAnchor.constraint(equalToConstant: 14)
        badgePromo2Constraint.isActive = true
        badgePromo2Constraint.constant = !data.badgePromo2 ? 0 : 14
        
        badgePromo3Constraint = badgePromo3.heightAnchor.constraint(equalToConstant: 14)
        badgePromo3Constraint.isActive = true
        badgePromo3Constraint.constant = !data.badgePromo3 ? 0 : 14
        
        vPointStamp.isHidden = data.point == 0 || data.stamp == 0
        var point = "\(data.point)"
        if data.point >= 100 {
            point = "+99"
        }
        var stamp = "\(data.stamp)"
        if data.stamp >= 100 {
            stamp = "+99"
        }
        lblPoint.text = point
        lblStamp.text = stamp
    }
    
    public func calculateHeight(for width: CGFloat) -> CGFloat {
        let widthConstraint = containerView.widthAnchor.constraint(equalToConstant: width)
        widthConstraint.isActive = true
        
        let size = containerView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        widthConstraint.isActive = false
        
        return size.height
    }
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("CardProductCell", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(containerView)
            
            setupUI()
        } else {
            print("Failed to load CardProductCell XIB")
        }
    }
    
    private func setupUI() {
        setupCard()
        setupBadgePromo2()
        setupBadgePromo3()
        setupButtonStepper()
    }
    
    private func setupCard() {
        containerView.backgroundColor = UIColor.red
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.grey30?.cgColor
    }
    
    private func setupBadgePromo2() {
        badgePromo2.bgColor = UIColor.red10
        badgePromo2.labelColor = UIColor.red30
        badgePromo2.label = "Banyak Lebih Hemat"
    }
    
    private func setupBadgePromo3() {
        badgePromo3.bgColor = UIColor.warningWeak
        badgePromo3.labelColor = UIColor.warningStrong
        badgePromo3.label = "Paket Bundling"
    }
    
    private func setupButtonStepper() {
        btnStepper.delegate = self
        
        btnStepper.stepperType = StepperType.collapsible.rawValue
        btnStepper.stepperVariant = StepperVariant.blue.rawValue
        btnStepper.textQuantity = productQty
        btnStepper.textQuantityMultiple = 1
    }
    
}

@MainActor
public protocol CardProductCellDelegate: AnyObject {
    func didSelectButtonCollapsible(show isShow: Bool)
}

public struct CardProductModel {
    var id: String
    var image: UIImage?
    var iconGiftBadge: UIImage?
    var nameGiftBadge: String
    var bgGiftBadge: UIColor?
    var name: String
    var price: Int
    var discount: Int
    var realPrice: Int
    var badgePromo2: Bool
    var badgePromo3: Bool
    var point: Int
    var stamp: Int

    public init(
    id: String,
    image: UIImage?,
    iconGiftBadge: UIImage?,
    nameGiftBadge: String,
    bgGiftBadge: UIColor?,
    name: String,
    price: Int,
    discount: Int,
    realPrice: Int,
    badgePromo2: Bool,
    badgePromo3: Bool,
    point: Int,
    stamp: Int) {
        self.id = id
        self.image = image
        self.iconGiftBadge = iconGiftBadge
        self.nameGiftBadge = nameGiftBadge
        self.bgGiftBadge = bgGiftBadge
        self.name = name
        self.price = price
        self.badgePromo2 = badgePromo2
        self.badgePromo3 = badgePromo3
        self.discount = discount
        self.realPrice = realPrice
        self.point = point
        self.stamp = stamp
    }

}

extension CardProductCell: ButtonStepperDelegate {
    public func didSelectButtonCollapsible(show isShow: Bool) {
        productQty = 1
        delegate?.didSelectButtonCollapsible(show: isShow)
    }
    
    public func didSelectButtonMinus(qty quantity: Int) {
        productQty = quantity
    }
    
    public func didSelectButtonPlus(qty quantity: Int) {
        productQty = quantity
    }
}
