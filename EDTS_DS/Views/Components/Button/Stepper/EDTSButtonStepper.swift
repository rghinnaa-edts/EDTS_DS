//
//  ButtonStepper.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 09/12/25.
//

import UIKit

public enum StepperVariant: String {
    case blue = "blue"
    case white = "white"
}

public enum StepperType: String {
    case stepper = "stepper"
    case icon = "icon"
    case number = "number"
    case collapsible = "collapsible"
}

@IBDesignable
public class EDTSButtonStepper: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var containerBackground: UIView!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var btnSingle: UIView!
    @IBOutlet weak var vStepper: UIStackView!
    
    @IBInspectable public var stepperVariant: String = StepperVariant.blue.rawValue {
        didSet {
            setupStepperUI()
        }
    }
    
    @IBInspectable public var stepperType: String = StepperType.stepper.rawValue {
        didSet {
            setupStepperUI()
        }
    }
    
    @IBInspectable public var textQuantity: Int = 0 {
        didSet {
            lblQty.text = "\(textQuantity)"
        }
    }
    
    @IBInspectable public var textQuantityMultiple: Int = 1 {
        didSet {
            qtyMultipe = textQuantityMultiple
        }
    }
    
    @IBInspectable public var textQuantityColor: UIColor? {
        didSet {
            updateTextQuantityColor()
        }
    }
    
    @IBInspectable public var bgColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }
    
    @IBInspectable public var btnMinusColor: UIColor? {
        didSet {
            updateMinusColor()
        }
    }
    
    @IBInspectable public var btnMinusBackgroundColor: UIColor? {
        didSet {
            updateMinusBackgroundColor()
        }
    }
    
    @IBInspectable public var btnPlusColor: UIColor? {
        didSet {
            updatePlusColor()
        }
    }
    
    @IBInspectable public var btnPlusBackgroundColor: UIColor? {
        didSet {
            updatePlusBackgroundColor()
        }
    }
    
    @IBInspectable public var btnIconColor: UIColor? {
        didSet {
            ivIcon.image?.withRenderingMode(.alwaysTemplate)
            updateIconColor()
        }
    }
    
    @IBInspectable public var btnIconBackgroundColor: UIColor? {
        didSet {
            updateIconBackgroundColor()
        }
    }
    
    @IBInspectable public var btnNumberColor: UIColor? {
        didSet {
            updateNumberColor()
        }
    }
    
    @IBInspectable public var btnNumberBackgroundColor: UIColor? {
        didSet {
            updateNumberBackgroundColor()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = -1.0 {
        didSet {
            updateBorderWidth()
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            updateBorderColor()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = -1.0 {
        didSet {
            containerBackground.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var isDisabled: Bool = false {
        didSet {
            setupStepperUI()
        }
    }
  
    public weak var delegate: EDTSButtonStepperDelegate?
        
    private var quantity: Int = 0
    private var qtyMultipe: Int = 1
    private var defaultFloatValue: CGFloat = -1.0
    private var isExpanded: Bool = false
    private var isAnimating: Bool = false
    private var collapsedWidth: CGFloat = 0
    private var expandedWidth: CGFloat = 0
    private var widthConstraint: NSLayoutConstraint?
    
    private var btnTextQtyColor: UIColor? = UIColor.white
    private var btnBackground: UIColor? = UIColor.white
    private var btnBorderWidth: CGFloat = 0.0
    private var btnBorderSingleWidth: CGFloat = 0.0
    private var btnBorderColor: UIColor? = UIColor.white
    private var minusBgColor: UIColor? = UIColor.white
    private var minusColor: UIColor? = UIColor.white
    private var plusBgColor: UIColor? = UIColor.white
    private var plusColor: UIColor? = UIColor.white
    private var singleBgColor: UIColor? = UIColor.white
    private var iconColor: UIColor? = UIColor.white
    private var numberColor: UIColor? = UIColor.white
    
    private var containerBackgroundWidthConstraint: NSLayoutConstraint?
    private var vStepperWidthConstraint: NSLayoutConstraint?
    
    //MARK: Initializers
    
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
        
        var width = 90.0
        var height = UIView.layoutFittingCompressedSize.height
        
        if stepperType == StepperType.number.rawValue || stepperType == StepperType.icon.rawValue {
            width = 32.0
            height = 32.0
        }
        
        return CGSize(
            width: width,
            height: height
        )
    }
    
    //MARK: - Private Functions
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("ButtonStepper", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            setupUI()
        }
    }
    
    private func setupUI() {
        setupButton()
        setupBackgroundRadius()
        setupStepperUI()
    }
    
    private func setupButton() {
        lblQty.text = "\(quantity)"
    
        btnMinus.setTitle("", for: .normal)
        btnPlus.setTitle("", for: .normal)
        
        btnSingle.layer.cornerRadius = (btnSingle.frame.height - 32) / 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(btnShowTapped))
        btnSingle.addGestureRecognizer(tapGesture)
        btnSingle.isUserInteractionEnabled = true
    }
    
    private func setupBackgroundRadius() {
        containerBackground.layer.cornerRadius = containerView.frame.height / 2
        
        btnPlus.layer.cornerRadius = btnPlus.frame.height / 2
        btnMinus.layer.cornerRadius = btnMinus.frame.height / 2
    }
    
    private func setupStepperCollapsibleType() {
        if stepperType == StepperType.collapsible.rawValue {
            btnSingle.isHidden = false
            btnMinus.isHidden = true
            lblQty.isHidden = true
            btnPlus.isHidden = true
            lblNumber.isHidden = true
            isExpanded = false
            
            DispatchQueue.main.async {
                self.collapsedWidth = self.btnSingle.frame.width
                self.expandedWidth = self.containerView.frame.width
                
                self.containerBackground.translatesAutoresizingMaskIntoConstraints = true
                self.containerBackground.frame = CGRect(
                    x: self.containerBackground.frame.maxX-self.collapsedWidth,
                    y: self.containerBackground.frame.minY,
                    width: self.collapsedWidth,
                    height: self.containerBackground.frame.height)
            }
        }
    }
    
    private func setupStepperSingleType() {
        let isSingleType = stepperType == StepperType.icon.rawValue || stepperType == StepperType.number.rawValue
        
        vStepper.isHidden = isSingleType
        btnSingle.isHidden = !isSingleType
        
        if containerBackgroundWidthConstraint == nil {
            containerBackgroundWidthConstraint = containerBackground.widthAnchor.constraint(equalToConstant: 32)
        }
        
        containerBackgroundWidthConstraint?.isActive = isSingleType
        
        ivIcon.isHidden = stepperType == StepperType.number.rawValue
        lblNumber.isHidden = stepperType == StepperType.icon.rawValue
    }
    
    private func setupStepperUI() {
        setupStepperSingleType()
        setupStepperCollapsibleType()
        updateTextQuantityColor()
        updateBackgroundColor()
        updateMinusBackgroundColor()
        updatePlusBackgroundColor()
        updateMinusColor()
        updatePlusColor()
        updateIconBackgroundColor()
        updateIconColor()
        updateNumberBackgroundColor()
        updateNumberColor()
        updateBorderWidth()
        updateBorderColor()
    }
    
    private func updateTextQuantityColor() {
        if isDisabled {
            btnTextQtyColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.white : EDTSColor.grey30
        } else if let custom = textQuantityColor {
            btnTextQtyColor = custom
        } else {
            btnTextQtyColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.white : EDTSColor.grey70
        }
        lblQty.textColor = btnTextQtyColor
    }
    
    private func updateBackgroundColor() {
        if isDisabled {
            btnBackground = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.disabled : EDTSColor.white
        } else if let custom = bgColor {
            btnBackground = custom
        } else {
            btnBackground = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.blue50 : EDTSColor.white
        }
        containerBackground.backgroundColor = btnBackground
    }
    
    private func updateMinusBackgroundColor() {
        if isDisabled {
            minusBgColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.disabled : EDTSColor.white
        } else if let custom = btnMinusBackgroundColor {
            minusBgColor = custom
        } else {
            minusBgColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.blue50 : EDTSColor.white
        }
        btnMinus.backgroundColor = minusBgColor
    }
    
    private func updateMinusColor() {
        if isDisabled {
            minusColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.white : EDTSColor.disabled
        } else if let custom = btnMinusColor {
            minusColor = custom
        } else if textQuantity == 0 {
            minusColor = EDTSColor.disabled
        } else {
            minusColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.white : EDTSColor.grey60
        }
        btnMinus.tintColor = minusColor
    }
    
    private func updatePlusBackgroundColor() {
        if isDisabled {
            plusBgColor = EDTSColor.disabled
        } else if let custom = btnPlusBackgroundColor {
            plusBgColor = custom
        } else {
            plusBgColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.white : EDTSColor.blue50
        }
        btnPlus.backgroundColor = plusBgColor
    }
    
    private func updatePlusColor() {
        if isDisabled {
            plusColor = EDTSColor.white
        } else if let custom = btnPlusColor {
            plusColor = custom
        } else {
            plusColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.blue50 : EDTSColor.white
        }
        btnPlus.tintColor = plusColor
    }
    
    private func updateIconBackgroundColor() {
        if isDisabled {
            singleBgColor = EDTSColor.disabled
        } else if let custom = btnIconBackgroundColor {
            singleBgColor = custom
        } else {
            singleBgColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.blue50 : EDTSColor.white
        }
        btnSingle.backgroundColor = singleBgColor
    }
    
    private func updateIconColor() {
        if isDisabled {
            iconColor = EDTSColor.white
        } else if let custom = btnIconColor {
            iconColor = custom
        } else {
            iconColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.white : EDTSColor.blue50
        }
        ivIcon.tintColor = iconColor
    }
    
    private func updateNumberBackgroundColor() {
        if isDisabled {
            singleBgColor = EDTSColor.disabled
        } else if let custom = btnNumberBackgroundColor {
            singleBgColor = custom
        } else {
            singleBgColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.blue50 : EDTSColor.white
        }
        btnSingle.backgroundColor = singleBgColor
    }
    
    private func updateNumberColor() {
        if isDisabled {
            numberColor = EDTSColor.white
        } else if let custom = btnNumberColor {
            numberColor = custom
        } else {
            numberColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.white : EDTSColor.blue50
        }
        lblNumber.textColor = numberColor
    }
    
    private func updateBorderWidth() {
        if isDisabled {
            if stepperType == StepperType.icon.rawValue || stepperType == StepperType.number.rawValue {
                btnBorderWidth = 0
            }
        } else if borderWidth != defaultFloatValue {
            btnBorderWidth = borderWidth
        } else {
            btnBorderWidth = stepperVariant == StepperVariant.blue.rawValue ? 0.0 : 1.0
        }
        
        btnSingle.layer.borderWidth = btnBorderWidth
        containerBackground.layer.borderWidth = btnBorderWidth
    }
    
    private func updateBorderColor() {
        if let custom = borderColor {
            btnBorderColor = custom
        } else {
            btnBorderColor = stepperVariant == StepperVariant.blue.rawValue ? EDTSColor.blue50 : EDTSColor.grey30
            btnBorderColor = (stepperType == StepperType.icon.rawValue || stepperType == StepperType.number.rawValue) ? EDTSColor.blue50 : btnBorderColor
            if stepperType == StepperType.collapsible.rawValue && stepperVariant == StepperVariant.white.rawValue {
                btnSingle.layer.borderColor = EDTSColor.blue50.cgColor
            }
        }
        btnSingle.layer.borderColor = btnBorderColor?.cgColor
        containerBackground.layer.borderColor = btnBorderColor?.cgColor
    }
    
    //MARK: - Animation
    
    private func showStepperAnimation() {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn], animations: {
            self.containerBackground.frame = CGRect(x: self.containerBackground.frame.maxX, y: self.containerBackground.frame.minY, width: -self.expandedWidth, height: self.containerBackground.frame.height)
        }) { _ in
            self.btnMinus.isHidden = false
            self.lblQty.isHidden = false
            self.btnPlus.isHidden = false
            self.btnMinus.alpha = 0
            self.lblQty.alpha = 0
            self.btnPlus.alpha = 0
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.btnSingle.isHidden = true
                self.btnSingle.alpha = 0
                
                self.btnMinus.alpha = 1
                self.lblQty.alpha = 1
                self.btnPlus.alpha = 1
            }) { _ in
                self.isExpanded = true
            }
        }
    }
    
    private func hideStepperAnimation() {
        btnSingle.isHidden = false
        btnSingle.alpha = 0
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
            self.btnMinus.alpha = 0
            self.lblQty.alpha = 0
            self.btnPlus.alpha = 0
            self.btnSingle.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.containerBackground.frame = CGRect(x: self.containerBackground.frame.maxX-self.collapsedWidth, y: self.containerBackground.frame.minY, width: self.collapsedWidth, height: self.containerBackground.frame.height)
            }) { _ in
                self.btnMinus.isHidden = true
                self.lblQty.isHidden = true
                self.btnPlus.isHidden = true
                self.isExpanded = false
            }
        }
    }
    
    //MARK: - Action
    
    @objc private func btnShowTapped() {
        if stepperType == StepperType.collapsible.rawValue {
            if !isExpanded {
                showStepperAnimation()
                textQuantity = 1
                lblQty.text = "\(textQuantity)"
                delegate?.didSelectButtonCollapsible(show: true)
                updateMinusColor()
            } else {
                hideStepperAnimation()
                delegate?.didSelectButtonCollapsible(show: false)
            }
        }
    }
    
    @IBAction func btnMinus(_ sender: Any) {
        let qty = Int(lblQty.text ?? "") ?? 0
        if qty > 0 {
            textQuantity = qty - qtyMultipe
            lblQty.text = "\(textQuantity)"
            
            delegate?.didSelectButtonMinus(qty: textQuantity)
        }
        
        if qty <= 1 {
            updateMinusColor()
        }
        
        if stepperType == StepperType.collapsible.rawValue && qty <= 1 {
            hideStepperAnimation()
        }
    }
    
    @IBAction func btnPlus(_ sender: Any) {
        let qty = Int(lblQty.text ?? "") ?? 0
        textQuantity = qty + qtyMultipe
        lblQty.text = "\(textQuantity)"
        updateMinusColor()
        
        delegate?.didSelectButtonPlus(qty: textQuantity)
    }
}

//MARK: - Delegate

@MainActor
public protocol EDTSButtonStepperDelegate: AnyObject {
    func didSelectButtonCollapsible(show isShow: Bool)
    func didSelectButtonMinus(qty quantity: Int)
    func didSelectButtonPlus(qty quantity: Int)
}
