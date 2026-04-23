//
//  CouponCardCell.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 10/02/25.
//

import UIKit

public class EDTSCardPointCell: UICollectionViewCell {
    
    @IBOutlet var poinCard: UIView!
    @IBOutlet var ivPoinCard: UIImageView!
    @IBOutlet var vCoupon: UIView!
    @IBOutlet var lblCoupon: UILabel!
    @IBOutlet var ivCoupon: UIImageView!
    @IBOutlet var lblPoinCard: UILabel!
    @IBOutlet var vPoin: UIView!
    @IBOutlet var lblPoin: UILabel!
    @IBOutlet var btnExchange: UIButton!
    @IBOutlet var vIKupon: UIView!
    @IBOutlet var ivIKupon: UIImageView!
    @IBOutlet var lblIKupon: UILabel!
    
    public var id: String = ""
    public var title: String = ""
    public var imageURL: String = ""
    public var coupon: Int = 9
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
        setupPoinCard()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPoinCard()
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
        let widthConstraint = poinCard.widthAnchor.constraint(equalToConstant: width)
        widthConstraint.isActive = true
        
        let size = poinCard.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        widthConstraint.isActive = false
        
        return size.height
    }

    private func setupPoinCard() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSPointCardCell", owner: self, options: nil),
           let view = nib.first as? UIView {
            poinCard = view
            poinCard.frame = bounds
            poinCard.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(poinCard)
            
            setupUI()
        } else {
            print("Failed to load PoinCard XIB")
        }
    }
    
    private func setupUI() {
        UIPoinCard()
        UICoupon()
        UIikupon()
        UIPoin()
        UIRibbonHotProduct()
    }
    
    private func UIPoinCard() {
        poinCard.layer.cornerRadius = 8
        poinCard.layer.masksToBounds = true
        
        poinCard.backgroundColor = .white
        poinCard.layer.shadowColor = UIColor.black.cgColor
        poinCard.layer.shadowOpacity = 0.15
        poinCard.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        poinCard.layer.shadowRadius = 3.0
        poinCard.layer.masksToBounds = false
        
        lblPoinCard.textColor = EDTSColor.grey70
        lblPoinCard.font = EDTSFont.B3.Regular.font
        
        btnExchange.titleLabel?.text = "Tukar Poin"
        btnExchange.backgroundColor = EDTSColor.blue30
        btnExchange.layer.cornerRadius = 4
        btnExchange.titleLabel?.textColor = .white
        btnExchange.titleLabel?.font = EDTSFont.Button.Small.font
        
        lblPoinCard.text = "Diskon Rp5.000 1 Pcs Kellogg’s Frosted Flakes 300gr"
//        ivPoinCard.image = UIImage(named: "product-image")
    }
    
    private func UICoupon() {
        if coupon > 10 && coupon < 0 {
            ivCoupon.image = UIImage(named: "product-empty")
        }
        
        ivCoupon.image = ivCoupon.image?.withRenderingMode(.alwaysTemplate)
        
        ivCoupon.tintColor = if coupon < 10 && coupon > 0 {
            EDTSColor.warningStrong
        } else {
            EDTSColor.errorStrong
        }
        
        vCoupon.backgroundColor = if coupon < 10 && coupon > 0 {
            EDTSColor.warningWeak
        } else {
            EDTSColor.errorWeak
        }
        
        lblCoupon.textColor = if coupon < 10 && coupon > 0 {
            EDTSColor.warningStrong
        } else {
            EDTSColor.errorStrong
        }
        
        lblCoupon.text = if coupon < 10 && coupon > 0 {
            "Kupon Mau Habis"
        } else {
            "Kupon Habis"
        }
        lblCoupon.font = EDTSFont.B4.Regular.font
    }
    
    private func UIikupon() {
        ivIKupon.image = ivIKupon.image?.withRenderingMode(.alwaysTemplate)
        ivIKupon.tintColor = EDTSColor.primaryStrong
        
        vIKupon.backgroundColor = EDTSColor.primaryWeak
        vIKupon.layer.cornerRadius = 8
        vIKupon.layer.borderWidth = 1
        vIKupon.layer.borderColor = EDTSColor.primaryStrong.cgColor
        
        lblIKupon.textColor = EDTSColor.primaryStrong
        lblIKupon.font = EDTSFont.B4.Regular.font
        lblIKupon.text = "i-Kupon"
    }
    
    private func UIPoin() {
        vPoin.backgroundColor = EDTSColor.secondaryWeak
        vPoin.layer.cornerRadius = 8
        vPoin.layer.borderWidth = 1
        vPoin.layer.borderColor = EDTSColor.warningStrong.cgColor
        
        lblPoin.textColor = EDTSColor.warningStrong
        lblPoin.font = EDTSFont.B4.Regular.font
        lblPoin.text = "5.500 Poin"
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
            rootParent: poinCard,
            targetView: poinCard
        )
    }
}
