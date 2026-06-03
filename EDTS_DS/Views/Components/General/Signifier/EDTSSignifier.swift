//
//  EDTSSignifier.swift
//  EDTS_DS
//
//  Created by Yovita Handayiani on 22/05/26.
//

import UIKit

@IBDesignable
public class EDTSSignifier: UIView {
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var hStackContainer: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    // MARK: - Inspectables
    @IBInspectable public var label: String?{
        didSet{
            lblTitle.attributedText = nil
            lblTitle.text = label
            setupLabelVisibility()
        }
    }
    
    public var labelAttributed: NSAttributedString? {
        didSet {
            lblTitle.text = nil
            lblTitle.attributedText = labelAttributed
        }
    }
    
    @IBInspectable public var labelFontName: String = "" {
        didSet {
            setupLabelFont()
        }
    }
    
    @IBInspectable public var labelFontSize: CGFloat = CGFloat.zero {
        didSet {
            setupLabelFont()
        }
    }
    
    @IBInspectable public var labelFontWeight: String = "" {
        didSet {
            setupLabelFont()
        }
    }
    
    @IBInspectable public var labelColor: UIColor? {
        didSet{
            lblTitle.textColor = labelColor
        }
    }
    
    @IBInspectable public var bgColor: UIColor? {
        didSet{
            containerView.backgroundColor = bgColor
        }
    }
    
    
    @IBInspectable public var cornerRadius: CGFloat = CGFloat.zero {
        didSet {
            containerView.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = CGFloat.zero {
        didSet{
            containerView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet{
            containerView.layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = Float.zero {
        didSet {
            containerView.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize.zero {
        didSet {
            containerView.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = CGFloat.zero {
        didSet {
            containerView.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? {
        didSet {
            containerView.layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    @IBInspectable public var paddingTop: CGFloat = CGFloat.zero {
        didSet {
            setupConstraint()
        }
    }
    
    @IBInspectable public var paddingBottom: CGFloat = CGFloat.zero {
        didSet {
            setupConstraint()
        }
    }
    
    @IBInspectable public var paddingLeading: CGFloat = CGFloat.zero {
        didSet {
            setupConstraint()
        }
    }
    
    @IBInspectable public var paddingTrailing: CGFloat = CGFloat.zero {
        didSet {
            setupConstraint()
        }
    }
    
    @IBInspectable public var topOffset: CGFloat = CGFloat.zero {
        didSet { updateShowPosition() }
    }

    @IBInspectable public var trailingOffset: CGFloat = CGFloat.zero {
        didSet { updateShowPosition() }
    }
    
    @IBInspectable public var isSkeleton: Bool = false {
        didSet {
            updateSkeleton()
        }
    }
    
    @IBInspectable public var isIndicator: Bool = false {
        didSet {
            setupLabelVisibility()
        }
    }
    
    //MARK: - Private Variables
    private var skeletonView: EDTSSkeleton?
    private var signifierHeight: CGFloat = 16
    private var targetView: UIView?
    private var topOffsetConstraint: NSLayoutConstraint?
    private var trailingOffsetConstraint: NSLayoutConstraint?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius != CGFloat.zero ? containerView.layer.cornerRadius = cornerRadius : containerView.applyCircular()
    }
    
    public override var intrinsicContentSize: CGSize {
        if isIndicator {
            return CGSize(width: signifierHeight, height: signifierHeight)
        }
        
        guard let stack = hStackContainer else {
            return super.intrinsicContentSize
        }
        
        stack.setNeedsLayout()
        stack.layoutIfNeeded()
        
        let stackSize = stack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let totalWidth = paddingLeading + stackSize.width + paddingTrailing
        let finalWidth = max(totalWidth, signifierHeight)
        
        let totalHeight = paddingTop + stackSize.height + paddingBottom
        let finalHeight = max(totalHeight, signifierHeight)
        
        return CGSize(width: finalWidth, height: finalHeight)
    }
    
    // MARK: - Setup & Styling
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSSignifier", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        
        setupUI()
    }
    
    private func setupUI() {
        setupConstraint()
        setupSignifierSize()
        setupLabelFont()
        setupDefaultStyle()
    }
    
    private func setupDefaultStyle() {
        if EDTSColor.theme == .poinku {
            paddingLeading = 2
            paddingTrailing = 2
            paddingTop = 0
            paddingBottom = 0
            labelColor = EDTSColor.white
            bgColor = EDTSColor.red30
            borderWidth = 0
            borderColor = nil
            lblTitle.font = EDTSFont.B5.Medium.font
        } else {
            paddingLeading = 2
            paddingTrailing = 2
            paddingTop = 1
            paddingBottom = 1
            labelColor = EDTSColor.white
            bgColor = EDTSColor.red30
            borderWidth = 0
            borderColor = nil
            lblTitle.font = EDTSFont.B4.Semibold.font
        }
        label = "0"
        
        invalidateIntrinsicContentSize()
    }
    
    private func setupSignifierSize() {
        if isIndicator {
            signifierHeight = EDTSColor.theme == .poinku ? 12 : 8
        } else {
            signifierHeight = EDTSColor.theme == .poinku ? 12 : 16
        }
        invalidateIntrinsicContentSize()
    }
    
    private func setupLabelVisibility() {
        if isIndicator {
            lblTitle.isHidden = true
            setupSignifierSize()
            containerView.layer.cornerRadius = signifierHeight / 2
        } else {
            lblTitle.isHidden = false
        }
        
        invalidateIntrinsicContentSize()
    }
    
    private func setupFontWeight(from value: String) -> UIFont.Weight {
        let normalized = value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        let weight = FontWeight(rawValue: normalized) ?? .semibold
        
        switch weight {
        case .ultralight: return .ultraLight
        case .thin:       return .thin
        case .light:      return .light
        case .regular:    return .regular
        case .medium:     return .medium
        case .semibold:   return .semibold
        case .bold:       return .bold
        case .heavy:      return .heavy
        case .black:      return .black
        }
    }
    
    private func setupLabelFont() {
        let size = labelFontSize
        let weight = setupFontWeight(from: labelFontWeight)
        
        if !labelFontName.isEmpty {
            lblTitle.font = UIFont(name: labelFontName, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: weight)
        } else {
            lblTitle.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    private func setupConstraint() {
        topConstraint?.constant = paddingTop
        bottomConstraint?.constant = paddingBottom
        leadingConstraint?.constant = paddingLeading
        trailingConstraint?.constant = paddingTrailing
        invalidateIntrinsicContentSize()
    }
    
    public func showSignifier(to view: UIView) {
        self.targetView = view

        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        view.bringSubviewToFront(self)

        let top = topAnchor.constraint(equalTo: view.topAnchor, constant: -topOffset)
        let trailing = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingOffset)

        topOffsetConstraint = top
        trailingOffsetConstraint = trailing

        NSLayoutConstraint.activate([top, trailing])
    }
    
    private func updateShowPosition() {
        topOffsetConstraint?.constant = -topOffset
        trailingOffsetConstraint?.constant = trailingOffset
    }
    
    
    //MARK: - Skeleton
    private func createSkeletonUI() {
        skeletonView?.removeFromSuperview()
        
        let skeleton = EDTSSkeleton()
        skeleton.cornerRadius = signifierHeight / 2
        skeleton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(skeleton)
        
        NSLayoutConstraint.activate([
            skeleton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            skeleton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            skeleton.topAnchor.constraint(equalTo: containerView.topAnchor),
            skeleton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            skeleton.widthAnchor.constraint(equalToConstant: signifierHeight),
            skeleton.heightAnchor.constraint(equalToConstant: signifierHeight)
        ])
        
        skeletonView = skeleton
    }
    
    private func updateSkeletonFrame() {
        guard let skeletonView = skeletonView else { return }
        skeletonView.frame = containerView.bounds
    }
    
    private func updateSkeleton() {
        if isSkeleton {
            setupLabelVisibility()
            containerView.backgroundColor = .clear
            containerView.layer.borderColor = nil
            createSkeletonUI()
        } else {
            skeletonView?.removeFromSuperview()
            skeletonView = nil
            setupLabelVisibility()
            containerView.backgroundColor = bgColor
            containerView.layer.borderColor = borderColor?.cgColor
        }
    }
}
