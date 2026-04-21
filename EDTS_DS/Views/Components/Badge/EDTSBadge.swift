//
//  Badge.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 09/12/25.
//

import UIKit

@IBDesignable
public class EDTSBadge: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var containerBackgroundView: UIView!
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var ivBadge: UIImageView!
    
    @IBOutlet weak var ivBadgeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivBadgeLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblBadgeLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblBadgeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblBadgeBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblBadgeTrailingConstraint: NSLayoutConstraint!
    
    @IBInspectable public var label: String? {
        didSet {
            lblBadge.attributedText = nil
            lblBadge.text = label
        }
    }
    
    @IBInspectable public var labelAttributed: NSAttributedString? {
        didSet {
            if let attributedTitle = labelAttributed {
                lblBadge.text = nil
                lblBadge.attributedText = attributedTitle
            }
        }
    }
    
    @IBInspectable public var labelColor: UIColor? {
        didSet {
            lblBadge.textColor = labelColor
        }
    }
    
    @IBInspectable public var labelFont: UIFont? = UIFont.systemFont(ofSize: 10, weight: .regular) {
        didSet {
            lblBadge.font = labelFont
        }
    }
    
    @IBInspectable public var icon: UIImage? = nil {
        didSet {
            updateIconVisibility()
        }
    }
    
    @IBInspectable public var iconTint: UIColor? =  nil {
        didSet {
            ivBadge.tintColor = iconTint
        }
    }
    
    @IBInspectable public var iconPadding: CGFloat = 2.0 {
        didSet {
            lblBadgeLeadingConstraint?.constant = iconPadding
        }
    }
    
    @IBInspectable public var bgColor: UIColor? {
        didSet {
            containerBackgroundView.backgroundColor = bgColor
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            containerBackgroundView.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            containerBackgroundView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            containerBackgroundView.layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = 0.0 {
        didSet {
            containerBackgroundView.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize.zero {
        didSet {
            containerBackgroundView.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0.0 {
        didSet {
            containerBackgroundView.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? = UIColor.black {
        didSet {
            containerBackgroundView.layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    @IBInspectable public var paddingTop: CGFloat = 1.0 {
        didSet {
            lblBadgeTopConstraint?.constant = paddingTop
        }
    }
    
    @IBInspectable public var paddingBottom: CGFloat = 1.0 {
        didSet {
            lblBadgeBottomConstraint?.constant = paddingBottom
        }
    }
    
    @IBInspectable public var paddingLeading: CGFloat = 4.0 {
        didSet {
            updateIconVisibility()
        }
    }
    
    @IBInspectable public var paddingTrailing: CGFloat = 4.0 {
        didSet {
            lblBadgeTrailingConstraint?.constant = paddingTrailing
        }
    }
    
    @IBInspectable public var isSkeleton: Bool = false {
        didSet {
            updateSkeleton()
        }
    }
    
    //MARK: - Private Variables
    
    private var textFontWeight: String = "regular"
    private var textFontSize: CGFloat = 10.0
    private var skeletonView: EDTSSkeleton?
    
    
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
    
    //MARK: - Private Functions
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("Badge", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            setupUI()
        }
    }
    
    private func setupUI() {
        setupMinimumSize()
        updateIconVisibility()
    }
    
    private func updateIconVisibility() {
        if let icon = icon {
            ivBadge.isHidden = false
            ivBadge.image = icon
            ivBadgeWidthConstraint?.constant = 12
            ivBadgeLeadingConstraint?.constant = paddingLeading
            lblBadgeLeadingConstraint?.constant = 2
        } else {
            ivBadge.isHidden = true
            ivBadge.image = nil
            ivBadgeWidthConstraint?.constant = 0
            ivBadgeLeadingConstraint?.constant = 0
            lblBadgeLeadingConstraint?.constant = paddingLeading
        }
        
        layoutIfNeeded()
    }
    
    private func setupMinimumSize() {
        let minWidthConstraint = containerBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: 18.0)
        minWidthConstraint.isActive = true
        lblBadgeTrailingConstraint?.constant = paddingTrailing
        
        let minHeightConstraint = containerBackgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 18.0)
        minHeightConstraint.isActive = true
    }
    
    //MARK: - Skeleton
    
    private func createSkeletonUI() {
        skeletonView?.removeFromSuperview()
        
        let skeleton = EDTSSkeleton()
        skeleton.translatesAutoresizingMaskIntoConstraints = false
        containerBackgroundView.addSubview(skeleton)
        
        NSLayoutConstraint.activate([
            skeleton.leadingAnchor.constraint(equalTo: containerBackgroundView.leadingAnchor),
            skeleton.trailingAnchor.constraint(equalTo: containerBackgroundView.trailingAnchor),
            skeleton.topAnchor.constraint(equalTo: containerBackgroundView.topAnchor),
            skeleton.bottomAnchor.constraint(equalTo: containerBackgroundView.bottomAnchor)
        ])
        
        skeletonView = skeleton
    }
    
    private func updateSkeletonFrame() {
        guard let skeletonView = skeletonView else { return }
        skeletonView.frame = containerBackgroundView.bounds
    }
    
    private func updateSkeleton() {
        if isSkeleton {
            createSkeletonUI()
            lblBadge.isHidden = true
            ivBadge.isHidden = true
        } else {
            skeletonView?.removeFromSuperview()
            skeletonView = nil
            lblBadge.isHidden = false
            updateIconVisibility()
        }
    }
}
