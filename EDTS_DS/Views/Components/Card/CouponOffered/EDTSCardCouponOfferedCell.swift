//
//  CardOfferedCouponCell.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 18/12/25.
//

import UIKit

public class EDTSCardCouponOfferedCell: UICollectionViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet var containerView: UIView!
    @IBOutlet public weak var cardCouponOffered: EDTSCardCouponOffered!
    
    
    //MARK: - Inspectables
    
    @IBInspectable public var periodeTextColor: UIColor? = nil {
        didSet {
            cardCouponOffered.periodeTextColor = periodeTextColor
        }
    }
    
    @IBInspectable public var bgColor: UIColor = EDTSColor.white {
        didSet {
            cardCouponOffered.bgColor = bgColor
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 12.0 {
        didSet {
            cardCouponOffered.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = 0.0 {
        didSet {
            cardCouponOffered.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize.zero {
        didSet {
            cardCouponOffered.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0.0 {
        didSet {
            cardCouponOffered.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.black {
        didSet {
            cardCouponOffered.shadowColor = shadowColor
        }
    }
    
    @IBInspectable public var shadowActiveColor: UIColor = UIColor.black {
        didSet {
            cardCouponOffered.shadowActiveColor = shadowActiveColor
        }
    }
    
    @IBInspectable public var isSkeleton: Bool = false {
        didSet {
            cardCouponOffered.isSkeleton = isSkeleton
        }
    }
    
    //MARK: - Public Variables
    
    public weak var delegate: CardCouponOfferedCellDelegate?
    public var index: Int = 0
    
    //MARK: - Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    //MARK: - Public Functions
    
    public func loadData(data: CardCouponOfferedModel) {
        cardCouponOffered.delegate = self
        
        cardCouponOffered.image = data.image
        cardCouponOffered.title = data.title
        cardCouponOffered.isFairGeneral = data.isFairGeneral
        cardCouponOffered.fairGeneralType = data.fairGeneralType
        cardCouponOffered.minimumTransaction = data.mininumTransaction
        cardCouponOffered.service = data.service
        cardCouponOffered.couponCode = data.couponCode
        cardCouponOffered.disableInfoDescription = data.disableInfo
        cardCouponOffered.isEnabled = data.isEnabled
        cardCouponOffered.isNewUser = data.isNewUser
        cardCouponOffered.isExchanged = data.isExchanged
        cardCouponOffered.isCanExchange = data.isCanExchange
        
        if data.periode <= "1" {
            cardCouponOffered.periode = "59 Menit Lagi"
            cardCouponOffered.periodeTextColor = EDTSColor.red30
        } else {
            cardCouponOffered.periode = data.periode
            cardCouponOffered.periodeTextColor = EDTSColor.grey60
        }
    }
    
    public func calculateHeight(for width: CGFloat) -> CGFloat {
        cardCouponOffered.calculateHeight(forWidth: width)
    }
    
    //MARK: - Private Functions
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("CardCouponOfferedCell", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(containerView)
        }
    }
}

//MARK: - Delegate

@MainActor
public protocol CardCouponOfferedCellDelegate: AnyObject {
    func didSelectButtonDetail(at index: Int)
    func didSelectButtonExchange(at index: Int, isCanExchange: Bool, isExchanged: Bool)
}

extension EDTSCardCouponOfferedCell: EDTSCardCouponOfferedDelegate {
    public func didSelectButtonDetail() {
        delegate?.didSelectButtonDetail(at: index)
    }
    
    public func didSelectButtonExchange(isCanExchange: Bool, isExchanged: Bool) {
        delegate?.didSelectButtonExchange(at: index, isCanExchange: isCanExchange, isExchanged: isExchanged)
    }
}

//MARK: - Model

public struct CardCouponOfferedModel {
    public var id: String
    public var image: UIImage?
    public var title: String
    public var filterType: String
    public var isFairGeneral: Bool
    public var fairGeneralType: String
    public var mininumTransaction: Int
    public var service: String
    public var periode: String
    public var couponCode: String
    public var disableInfo: String
    public var isEnabled: Bool
    public var isNewUser: Bool
    public var isExchanged: Bool
    public var isCanExchange: Bool
    
    public init(id: String, image: UIImage?, title: String, filterType: String, isFairGeneral: Bool = false, fairGeneralType: String = FairGeneralType.general.rawValue, mininumTransaction: Int, service: String, periode: String, couponCode: String, disableInfo: String, isEnabled: Bool, isNewUser: Bool, isExchanged: Bool, isCanExchange: Bool) {
        
        self.id = id
        self.image = image
        self.title = title
        self.filterType = filterType
        self.isFairGeneral = isFairGeneral
        self.fairGeneralType = fairGeneralType
        self.mininumTransaction = mininumTransaction
        self.service = service
        self.periode = periode
        self.couponCode = couponCode
        self.disableInfo = disableInfo
        self.isEnabled = isEnabled
        self.isNewUser = isNewUser
        self.isExchanged = isExchanged
        self.isCanExchange = isCanExchange
    }
}
