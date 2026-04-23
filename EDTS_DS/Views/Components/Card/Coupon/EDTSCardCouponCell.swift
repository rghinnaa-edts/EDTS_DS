//
//  CouponCardCell.swift
//  Poinku-DS-SB
//
//  Created by Rizka Ghinna Auliya on 10/02/25.
//

import UIKit

public class EDTSCardCouponCell: UICollectionViewCell {
    
    @IBOutlet var couponCard: UIView!
    @IBOutlet var ivCouponCard: UIImageView!
    @IBOutlet var vAvailable: UIView!
    @IBOutlet var lblAvailable: UILabel!
    @IBOutlet var ivAvailable: UIImageView!
    @IBOutlet var lblCouponCard: UILabel!
    @IBOutlet var vIKupon: UIView!
    @IBOutlet var ivIKupon: UIImageView!
    @IBOutlet var lblIKupon: UILabel!
    @IBOutlet var btnExchange: UIButton!
    
    public var id: String = ""
    public var title: String = ""
    public var imageURL: String = ""
    public var coupon: Int = 0
    public var stampCount: Int = 0
    public var price: Int = 0
    public var isNew: Bool = false
    public var isHotProduct: Bool = false
    public var isDiscount: Bool = false
    public var discountImp: Int = 0
    public var size: Size = .fullSize
    
    public enum Size {
        case fullSize
        case rewardWidget
        case stampPage
    }
    
    public struct Product {
        let id: String
        let title: String
        let imageURL: String
        let coupon: Int
        let stampCount: Int
        let price: Int
        let isNew: Bool
        let isHotProduct: Bool
        let isDiscount: Bool
        let discountImp: Int
        let Size: Size
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupCouponCard()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCouponCard()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    public func configure(with product: Product) {
        id = product.id
        title = product.title
        imageURL = product.imageURL
        coupon = product.coupon
        stampCount = product.stampCount
        price = product.price
        isNew = product.isNew
        isHotProduct = product.isHotProduct
        isDiscount = product.isDiscount
        discountImp = product.discountImp
        size = product.Size
    }
    
    public func calculateHeight(for width: CGFloat) -> CGFloat {
        let widthConstraint = couponCard.widthAnchor.constraint(equalToConstant: width)
        widthConstraint.isActive = true
        
        let size = couponCard.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        widthConstraint.isActive = false
        
        return size.height
    }

    private func setupCouponCard() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSCouponCardCell", owner: self, options: nil),
           let view = nib.first as? UIView {
            couponCard = view
            couponCard.frame = bounds
            couponCard.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(couponCard)
            
            setupUI()
        } else {
            print("Failed to load CouponCardCell XIB")
        }
    }
    
    private func setupUI() {
        UIStampCard()
        UIAvailable()
        UIikupon()
        UIRibbonHotProduct()
    }
    
    private func UIStampCard() {
        couponCard.layer.cornerRadius = 8
        couponCard.layer.masksToBounds = true
        
        couponCard.backgroundColor = .white
        couponCard.layer.shadowColor = UIColor.black.cgColor
        couponCard.layer.shadowOpacity = 0.15
        couponCard.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        couponCard.layer.shadowRadius = 3.0
        couponCard.layer.masksToBounds = false
        
        lblCouponCard.textColor = EDTSColor.grey70
        lblCouponCard.font = EDTSFont.B3.Regular.font
        
        btnExchange.backgroundColor = EDTSColor.blue30
        btnExchange.layer.cornerRadius = 4
        btnExchange.titleLabel?.textColor = .white
        btnExchange.titleLabel?.font = EDTSFont.Button.Small.font
        
        lblCouponCard.text = "Diskon Rp2.000 Lifebuoy Red Fresh"
    }
    
    private func UIAvailable() {
        if coupon > 10 && coupon < 0 {
            ivAvailable.image = UIImage(named: "product-empty")
        }
        ivAvailable.image = ivAvailable.image?.withRenderingMode(.alwaysTemplate)
        
        ivAvailable.tintColor = if coupon < 10 && coupon > 0 {
            EDTSColor.warningStrong
        } else {
            EDTSColor.errorStrong
        }
        
        vAvailable.backgroundColor = if coupon < 10 && coupon > 0 {
            EDTSColor.warningWeak
        } else {
            EDTSColor.errorWeak
        }
        
        lblAvailable.textColor = if coupon < 10 && coupon > 0 {
            EDTSColor.warningStrong
        } else {
            EDTSColor.errorStrong
        }
        
        lblAvailable.text = if coupon < 10 && coupon > 0 {
            "Kupon Mau Habis"
        } else {
            "Kupon Habis"
        }
        lblAvailable.font = EDTSFont.B4.Regular.font
    }
    
    private func UIikupon() {
        ivIKupon.image = ivIKupon.image?.withRenderingMode(.alwaysTemplate)
        ivIKupon.tintColor = EDTSColor.primaryStrong
        
        vIKupon.backgroundColor = EDTSColor.primaryStrong
        vIKupon.layer.cornerRadius = 8
        vIKupon.layer.borderWidth = 1
        vIKupon.layer.borderColor = EDTSColor.primaryStrong.cgColor
        
        lblIKupon.textColor = EDTSColor.primaryStrong
        lblIKupon.font = EDTSFont.B4.Regular.font
        lblIKupon.text = "i-Kupon"
    }
    
    private func UIRibbonHotProduct() {
        let ribbonView = EDTSRibbon()
        ribbonView.ribbonText = "Hot Product!"
        ribbonView.triangleColor = EDTSColor.red50
        ribbonView.containerStartColor = EDTSColor.red20
        ribbonView.containerEndColor = EDTSColor.red50
        ribbonView.textColor = EDTSColor.white
        ribbonView.gravity = .start

        ribbonView.anchorToView(
            rootParent: couponCard,
            targetView: couponCard
        )
    }
}
