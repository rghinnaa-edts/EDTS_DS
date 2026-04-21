//
//  TabSquareRoundCell.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 09/05/25.
//

import UIKit

public class TabSquareRoundCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var vChip: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var vIndicator: UIView!
    
    public var isSelectedState: Bool = false {
        didSet {
            setupBackground(isEnable: isEnable)
        }
    }
    
   private var isEnable: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChipPromo()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupChipPromo()
    }
    
    private func setupChipPromo() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("TabSquareRoundCell", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        } else {
            print("Failed to load TabSquareRoundCell nib")
        }
        
        setupUI()
    }
    
    private func setupUI() {
        vChip.layer.cornerRadius = 6
        vIndicator.layer.cornerRadius = 2
    }
    
    private func setupBackground(isEnable: Bool) {
        vIndicator.isHidden = !isSelectedState
        
        if isEnable {
            if isSelectedState {
                vChip.backgroundColor = EDTSColor.blue50
                lblTitle.textColor = EDTSColor.white
            } else {
                vChip.backgroundColor = EDTSColor.blue20
                lblTitle.textColor = EDTSColor.grey50
            }
        } else {
            vChip.backgroundColor = EDTSColor.grey30
            lblTitle.textColor = EDTSColor.white
        }
    }
    
    func loadData(data: TabSquareRoundModel) {
        lblTitle.text = data.title
        
        setupBackground(isEnable: isEnable)
    }
    
}
