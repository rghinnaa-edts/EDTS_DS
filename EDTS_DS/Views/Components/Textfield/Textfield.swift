//
//  Textfield.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 17/04/25.
//

import UIKit

@IBDesignable
public class Textfield: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var vTextfield: UIView!
    @IBOutlet var textfield: UITextField!
    @IBOutlet var labelText: UILabel!
    @IBOutlet var labelRequired: UILabel!
    @IBOutlet var supportView: UIStackView!
    @IBOutlet var support: UILabel!
    @IBOutlet var counter: UILabel!
    @IBOutlet var iconLeading: UIImageView!
    @IBOutlet var iconTrailing: UIImageView!
    
    @IBInspectable public var label: String? {
        get { return labelText.text }
        set {
            labelText.text = newValue
            labelText.isHidden = newValue == nil || newValue?.isEmpty == true
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable public var text: String? {
        get { return textfield.text }
        set {
            textfield.text = newValue
            textfield.isHidden = newValue == nil || newValue?.isEmpty == true
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable public var placeholder: String? {
        get { return textfield.placeholder }
        set {
            textfield.placeholder = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable public var isRequired: Bool {
        get { return !labelRequired.isHidden }
        set {
            labelRequired.isHidden = !newValue
        }
    }
    
    @IBInspectable public var supportText: String? {
        get { return text }
        set {
            text = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable public var counterText: String? {
        get { return counter.text }
        set {
            counter.text = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable public var errorMessage: String? {
        didSet {
            text = errorMessage
            if errorMessage == nil {
                text = supportText
                isHidden = (supportText == nil || supportText?.isEmpty == true) && (errorMessage == nil || errorMessage?.isEmpty == true)
            }
            updateBorderColor()
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable public var iconStart: UIImage? {
        get { return iconLeading.image }
        set {
            iconLeading.image = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable public var iconEnd: UIImage? {
        get { return iconTrailing.image }
        set {
            iconTrailing.image = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    public var keyboardType: UIKeyboardType {
        get { return textfield.keyboardType }
        set {
            textfield.keyboardType = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    public var returnKeyType: UIReturnKeyType {
        get { return textfield.returnKeyType }
        set {
            textfield.returnKeyType = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    public var autocapitalizationType: UITextAutocapitalizationType {
        get { return textfield.autocapitalizationType }
        set { textfield.autocapitalizationType = newValue }
    }
    
    public var autocorrectionType: UITextAutocorrectionType {
        get { return textfield.autocorrectionType }
        set { textfield.autocorrectionType = newValue }
    }
    
    public var delegate: UITextFieldDelegate? {
        get { return textfield.delegate }
        set { textfield.delegate = newValue }
    }
    
    public enum Style {
        case Default
        case Focus
        case Error
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupTextfield()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextfield()
    }
    
    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        return textfield.becomeFirstResponder()
    }
    
    @discardableResult
    override public func resignFirstResponder() -> Bool {
        return textfield.resignFirstResponder()
    }
    
    @objc private func textFieldDidChange() {
        if errorMessage != nil {
            errorMessage = nil
        }
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: textfield)
    }
    
    @objc private func textFieldDidBeginEditing() {
        vTextfield.layer.borderColor = UIColor.blue30.cgColor
        vTextfield.layer.borderWidth = 1
        vTextfield.layer.cornerRadius = 4
    }
    
    @objc private func textFieldDidEndEditing() {
        updateBorderColor()
        vTextfield.layer.borderWidth = 1
        vTextfield.layer.cornerRadius = 4
    }
    
    private func setupTextfield() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("Textfield", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            setupUI()
            setupActions()
            
            textfield.text = text
            textfield.placeholder = placeholder
            textfield.keyboardType = .emailAddress
            textfield.returnKeyType = .done
        } else {
            print("Failed to load Chip XIB")
        }
    }
    
    private func setupUI() {
        vTextfield.layer.borderWidth = 1
        vTextfield.layer.cornerRadius = 4
        vTextfield.layer.borderColor = UIColor.grey30.cgColor
        
        labelText.font = Font.H3.font
        labelText.textColor = UIColor.grey60
        
        labelRequired.font = Font.H3.font
        labelRequired.textColor = UIColor.red30
        labelRequired.text = "*"
        
        textfield.font = Font.B2.Small.font
        textfield.textColor = UIColor.grey80
        textfield.borderStyle = .none
        
        iconLeading.image = iconLeading.image?.withRenderingMode(.alwaysTemplate)
        iconLeading.tintColor = UIColor.grey60
        if iconStart == nil {
            setIconWidth(icon: iconLeading, to: 0)
            iconLeading.isHidden = true
        } else {
            setIconWidth(icon: iconLeading, to: 24)
            iconLeading.isHidden = false
        }
        
        iconTrailing.image = iconTrailing.image?.withRenderingMode(.alwaysTemplate)
        iconTrailing.tintColor = UIColor.grey60
        if iconEnd == nil {
            setIconWidth(icon: iconTrailing, to: 0)
            iconTrailing.isHidden = true
        } else {
            setIconWidth(icon: iconTrailing, to: 24)
            iconTrailing.isHidden = false
        }
        
        support.font = Font.B4.Small.font
        support.textColor = UIColor.grey60
        support.isHidden = true
        
        counter.font = Font.B4.Small.font
        counter.textColor = UIColor.grey60
        counter.isHidden = true
    }
    
    private func setupActions() {
        textfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }
    
    private func updateBorderColor() {
        if errorMessage != nil {
            vTextfield.layer.borderColor = UIColor.errorStrong.cgColor
        } else if vTextfield.isFirstResponder {
            vTextfield.layer.borderColor = UIColor.blue30.cgColor
        } else {
            vTextfield.layer.borderColor = UIColor.grey30.cgColor
        }
    }
    
    public func setIconWidth(icon image: UIImageView!, to width: CGFloat) {
        image.constraints.forEach { constraint in
            if constraint.firstAttribute == .width && constraint.firstItem === image {
                image.removeConstraint(constraint)
            }
        }
        
        let widthConstraint = image.widthAnchor.constraint(equalToConstant: width)
        widthConstraint.isActive = true
        
        image.isHidden = (width == 0)
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    public func validate(condition: (String?) -> Bool, errorMessage: String) -> Bool {
        let isValid = condition(text)
        self.errorMessage = isValid ? nil : errorMessage
        return isValid
    }
    
    public func clear() {
        text = nil
        errorMessage = nil
    }
    
    public func getTextField() -> UITextField {
        return textfield
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupTextfield()
    }
}
