//
//  CardMyCouponList.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 21/01/26.
//

import UIKit

public class EDTSCardMyCouponCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var containerBackground: UIView!
    @IBOutlet weak var ivCoupon: UIImageView!
    @IBOutlet weak var vDivider: DashedLineView!
    @IBOutlet weak var vSkeletonTop: UIView!
    @IBOutlet weak var vSkeletonBottom: UIView!
    
    public var isSkeleton: Bool = false {
        didSet {
            setupSkeleton()
        }
    }
    
    private var ribbonView: EDTSRibbon?
    
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
        if let nib = bundle.loadNibNamed("CardMyCouponCell", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(containerView)
            
            setupUI()
        }
    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            self.setupCouponShape()
        }
        ivCoupon.applyCircular()
    }
    
    private func setupCouponShape() {
        let dashedLineY = vDivider.frame.origin.y
        
        containerBackground.clipsToBounds = true
        containerBackground.applyCouponBackground(
            notchRadius: 4,
            notchPosition: dashedLineY,
            cornerRadius: 8
        )
        
        let couponPath = containerView.createCouponPath(
            in: containerBackground.bounds,
            notchRadius: 4,
            notchPosition: dashedLineY,
            cornerRadius: 8
        )
        
        containerView.backgroundColor = .clear
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 3
        containerView.layer.masksToBounds = false
        containerView.layer.shadowPath = couponPath.cgPath
    }
    
    private func ribbonNewUser() {
        ribbonView?.removeFromSuperview()
        
        let newRibbonView = EDTSRibbon()
        
        newRibbonView.ribbonText = "Pengguna Baru"
        newRibbonView.triangleColor = EDTSColor.orange50
        newRibbonView.containerStartColor = EDTSColor.yellow30
        newRibbonView.containerEndColor = EDTSColor.orange30
        newRibbonView.textColor = EDTSColor.white
        newRibbonView.gravity = .end

        newRibbonView.anchorToView(
            rootParent: containerView,
            targetView: containerView,
            offsetX: 0,
            offsetY: 4
        )
        
        ribbonView = newRibbonView
    }
    
    private func ribbonCoupon() {
        ribbonView?.removeFromSuperview()
        
        let newRibbonView = EDTSRibbon()
        
        newRibbonView.ribbonText = "i-Kupon"
        newRibbonView.triangleColor = EDTSColor.blue70
        newRibbonView.containerStartColor = EDTSColor.blue50
        newRibbonView.containerEndColor = EDTSColor.blue50
        newRibbonView.textColor = EDTSColor.white
        newRibbonView.gravity = .end

        newRibbonView.anchorToView(
            rootParent: containerView,
            targetView: containerView,
            offsetX: 0,
            offsetY: -3,
        )
        
        ribbonView = newRibbonView
    }
    
    private func setupSkeleton() {
        if isSkeleton {
            vSkeletonTop.isHidden = false
            vSkeletonBottom.isHidden = false
            
            ribbonView?.removeFromSuperview()
            ribbonView = nil
        } else {
            vSkeletonTop.isHidden = true
            vSkeletonBottom.isHidden = true
            
            DispatchQueue.main.async {
                self.ribbonCoupon()
            }
        }
    }
}
