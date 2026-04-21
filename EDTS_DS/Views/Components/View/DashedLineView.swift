//
//  DashedLineView.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 18/12/25.
//

import UIKit

@IBDesignable
class DashedLineView: UIView {
    
    private let shapeLayer = CAShapeLayer()
    
    @IBInspectable
    public var dashColor: UIColor = .lightGray {
        didSet { shapeLayer.strokeColor = dashColor.cgColor }
    }
    
    @IBInspectable
    public var dashWidth: CGFloat = 1 {
        didSet { shapeLayer.lineWidth = dashWidth }
    }
    
    @IBInspectable
    public var dashPattern: [NSNumber] = [4, 4] {
        didSet { shapeLayer.lineDashPattern = dashPattern }
    }
    
    @IBInspectable
    public var isVertical: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    private func setupLayer() {
        shapeLayer.strokeColor = dashColor.cgColor
        shapeLayer.lineWidth = dashWidth
        shapeLayer.lineDashPattern = dashPattern
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = CGMutablePath()
        if isVertical {
            path.move(to: CGPoint(x: bounds.width / 2, y: 0))
            path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height))
        } else {
            path.move(to: CGPoint(x: 0, y: bounds.height / 2))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height / 2))
        }
        
        shapeLayer.path = path
    }
}
