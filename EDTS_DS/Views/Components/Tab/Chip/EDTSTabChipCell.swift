//
//  TabChip.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 06/01/26.
//

import UIKit

public class TabChipCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var chip: KlikIDM_DSChip!
    
    public var imageTint: UIColor? =  nil {
        didSet {
//            chip.imageTint = imageTint
        }
    }
    
    public var titleColor: UIColor? {
        didSet {
            updateState()
        }
    }
    
    public var titleActiveColor: UIColor? {
        didSet {
            updateState()
        }
    }
    
    public var titleFontSize: CGFloat = 0.0 {
        didSet {
            chip.fontSize = titleFontSize
        }
    }
    
    public var titleFontWeight: String = "" {
        didSet {
            chip.fontWeight = titleFontWeight
        }
    }
    
    public var tabBgColor: UIColor? {
        didSet {
            updateState()
        }
    }
    
    public var tabBgActiveColor: UIColor? {
        didSet {
            updateState()
        }
    }
    
    public var tabCornerRadius: CGFloat = 0.0 {
        didSet {
            chip.cornerRadius = tabCornerRadius
        }
    }
    
    public var tabCornerActiveRadius: CGFloat? {
        didSet {
            updateState()
        }
    }
    
    public var tabBorderWidth: CGFloat = 0.0 {
        didSet {
            updateState()
        }
    }
    
    public var tabBorderActiveWidth: CGFloat? = 0.0 {
        didSet {
            updateState()
        }
    }
    
    public var tabBorderColor: UIColor? {
        didSet {
            updateState()
        }
    }
    
    public var tabBorderActiveColor: UIColor? = UIColor.blue30 {
        didSet {
            updateState()
        }
    }
    
    public var tabShadowOpacity: Float = 0.0 {
        didSet {
//            chip.shadowOpacity = tabShadowOpacity
        }
    }
    
    public var tabShadowOffset: CGSize = CGSize.zero {
        didSet {
//            chip.shadowOffset = tabShadowOffset
        }
    }
    
    public var tabShadowRadius: CGFloat = 0.0 {
        didSet {
//            chip.shadowRadius = tabShadowRadius
        }
    }
    
    public var tabShadowColor: UIColor? = UIColor.black {
        didSet {
            updateState()
        }
    }
    
    public var tabShadowActiveColor: UIColor? = UIColor.black {
        didSet {
            updateState()
        }
    }
    
    public var tabPaddingTop: CGFloat = 1.0 {
        didSet {
            chip.paddingTop = tabPaddingTop
        }
    }
    
    public var tabPaddingBottom: CGFloat = 1.0 {
        didSet {
            chip.paddingBottom = tabPaddingBottom
        }
    }
    
    public var tabPaddingLeading: CGFloat = 4.0 {
        didSet {
            chip.paddingLeading = tabPaddingLeading
        }
    }
    
    public var tabPaddingTrailing: CGFloat = 4.0 {
        didSet {
            chip.paddingTrailing = tabPaddingTrailing
        }
    }
    
    public var tabIconPadding: CGFloat = 2.0 {
        didSet {
            chip.iconSpacing = tabIconPadding
        }
    }
    
    public var isSelectedState: Bool = false {
        didSet {
            updateAppearance()
            chip.isChipActive = isSelectedState
        }
    }
    
    public var isUserTapped: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    public func loadData(_ data: TabDefaultModel) {
        chip.label = data.title
    }
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        guard let nib = bundle.loadNibNamed("TabChipCell", owner: self, options: nil),
              let view = nib.first as? UIView else {
            print("Failed to load TabChipCell nib")
            return
        }
        
        containerView = view
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(containerView)
        
        setupUI()
    }
    
    private func setupUI() {
    }
    
    private func updateAppearance() {
        updateState()
    }
    
    private func updateState() {
        chip.labelColorActive = titleActiveColor
        chip.labelColor = titleColor
        chip.bgColorActive = tabBgActiveColor
        chip.bgColor = tabBgColor
    }
}

extension TabChipCell: TabDefaultCellProtocol {
    public func loadData(item: TabDefaultModelProtocol) {
        if let data = item as? TabDefaultModel {
            loadData(data)
        } else {
            let data = TabDefaultModel(
                id: item.id,
                title: ""
            )
            loadData(data)
        }
    }
}
