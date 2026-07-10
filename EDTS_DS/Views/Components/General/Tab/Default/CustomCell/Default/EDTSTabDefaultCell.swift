//
//  TabDefaultCell.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 16/05/25.
//

import UIKit

public class EDTSTabDefaultCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblTab: UILabel!
    @IBOutlet weak var vIndicator: UIView!
    
    @IBOutlet weak var lblTabBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTabTopConstraint: NSLayoutConstraint!
    
    public var isSelectedState: Bool = false {
        didSet {
            setupTextColor()
            setupIndicator()
        }
    }
    
    public var tabIndicatorColor: UIColor? = EDTSColor.blue50 {
        didSet {
            vIndicator.backgroundColor = tabIndicatorColor
        }
    }
    
    public var tabTextColor: UIColor? = EDTSColor.blue50 {
        didSet {
            setupTextColor()
        }
    }
    
    public var tabTextActiveColor: UIColor? = EDTSColor.blue50 {
        didSet {
            setupTextColor()
        }
    }
    
    public var tabBackgroundColor: UIColor? = EDTSColor.white {
        didSet {
            containerView.backgroundColor = tabBackgroundColor
        }
    }
    
    public var tabPaddingTop: CGFloat = 6.0 {
        didSet {
            lblTabTopConstraint.constant = tabPaddingTop
        }
    }
    
    public var tabPaddingBottom: CGFloat = 6.0 {
        didSet {
            lblTabBottomConstraint.constant = tabPaddingBottom
        }
    }
    
    public var isSelectedAfterItem: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTab()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTab()
    }
    
    private func setupTab() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSTabDefaultCell", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        } else {
            print("Failed to load TabDefaultCell nib")
        }
        
        setupUI()
    }
    
    private func setupUI() {
        setupTextColor()
        setupIndicator()
    }
    
    private func setupTextColor() {
        UIView.transition(with: lblTab, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.lblTab.textColor = self.isSelectedState ? self.tabTextActiveColor : self.tabTextColor
        })
    }
    
    private func setupIndicator() {
        vIndicator.layer.cornerRadius = 2
        
        if isSelectedState {
            vIndicator.alpha = 1.0
            
            let startX = isSelectedAfterItem ? -bounds.width : bounds.width
            vIndicator.transform = CGAffineTransform(translationX: startX, y: 0)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
                self.vIndicator.transform = .identity
            })
        } else {
            let endX = isSelectedAfterItem ? bounds.width : -bounds.width
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
                self.vIndicator.transform = CGAffineTransform(translationX: endX, y: 0)
                self.vIndicator.alpha = 0.0
            })
        }
    }
    
    func loadData(_ data: EDTSTabDefaultModel) {
        lblTab.text = data.title
    }
}

extension EDTSTabDefaultCell: EDTSTabDefaultCellProtocol {
    public func loadData(item: EDTSTabDefaultModelProtocol) {
        if let data = item as? EDTSTabDefaultModel {
            loadData(data)
        } else {
            let data = EDTSTabDefaultModel(
                id: item.id,
                title: ""
            )
            loadData(data)
        }
    }
}
