//
//  Coachmark.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 26/02/25.
//

import UIKit

public enum CoachmarkType: String {
    case single = "single"
    case multiple = "multiple"
}

public enum CoachmarkStepType: String {
    case slash = "step1"
    case from = "step2"
    case custom = "step3"
}
                                       
public enum CoachmarkPosition {
    case left
    case center
    case right
}

public enum CoachmarkArrowPosition {
    case top
    case bottom
}

@IBDesignable
public class EDTSCoachmark: UIView {
    
    @IBOutlet weak var vLabelContainer: UIStackView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblTotalStep: UILabel!
    @IBOutlet var btnSkip: EDTSButton!
    @IBOutlet var btnNext: EDTSButton!
    @IBOutlet weak var vIconBackground: UIView!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var vDivider: UIView!
    
    // MARK: - Public Properties

    public var coachmarkType: String = CoachmarkType.multiple.rawValue {
        didSet {
            updateCoachmarkType()
        }
    }
    
    public var stepConjunction: String = "dari" {
        didSet {
            setupStepConjunction()
        }
    }
    
    public var titleFontName: String = "" {
        didSet {
            setupTitleFont()
        }
    }
    
    public var titleFontSize: CGFloat = 18 {
        didSet {
            setupTitleFont()
        }
    }
    
    public var titleFontWeight: String = FontWeight.regular.rawValue {
        didSet {
            setupTitleFont()
        }
    }
    
    public var descFontName: String = "" {
        didSet {
            setupDescriptionFont()
        }
    }
    
    public var descFontSize: CGFloat = 14 {
        didSet {
            setupDescriptionFont()
        }
    }
    
    public var descFontWeight: String = FontWeight.regular.rawValue {
        didSet {
            setupDescriptionFont()
        }
    }
    
    public var stepFontName: String = "" {
        didSet {
            setupStepFont()
        }
    }
    
    public var stepFontSize: CGFloat = 14 {
        didSet {
            setupStepFont()
        }
    }
    
    public var stepFontWeight: String = FontWeight.regular.rawValue {
        didSet {
            setupStepFont()
        }
    }
    
    public var iconTint: UIColor? {
        didSet {
            setupIcon()
        }
    }
    
    public var iconBgColor: UIColor? {
        didSet {
            setupIcon()
        }
    }
    
    public var isIconShow: Bool = false {
        didSet {
            setupIcon()
        }
    }
    
    public var btnOutlinedTint: UIColor? {
        didSet {
           setupButtonColor()
        }
    }
    
    public var btnFilledTint: UIColor? {
        didSet {
            setupButtonColor()
        }
    }
    
    public var onDismiss: (() -> Void)?

    // MARK: - Private Properties

    private var contentView: UIView?
    private var targetView: UIView?
    private var endTargetView: UIView?
    private var targetFrame: CGRect = .zero
    private var endTargetFrame: CGRect = .zero
    private var spotlightRadius: CGFloat = 10
    private let dimColor = EDTSColor.black.withAlphaComponent(0.7)
    private var currentStep = 0
    private var totalSteps = 0
    private var spotlightLayer: CAShapeLayer?
    private var spotlightFrame: CGRect = .zero
    private var triangleView: UIView?
    private let triangleHeight: CGFloat = 8
    private let triangleWidth: CGFloat = 12
    private let triangleTopRadius: CGFloat = 1
    private var stepConfigurations: [CoachmarkStepConfig] = []
    private let contentViewWidth: CGFloat = 320
    private var offsetMargin: CGFloat = 16
    private var contentMargin: CGFloat = 24
    private var arrowPosition: CoachmarkArrowPosition = .top

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }

    // MARK: - Public Methods

    public func configureSteps(steps: [CoachmarkStepConfig]) {
        stepConfigurations = steps
        totalSteps = steps.count
        if !steps.isEmpty {
            currentStep = 1
            updateCurrentStepUI()
        }
    }

    public func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }

        frame = window.bounds
        if animated { alpha = 0 }
        window.addSubview(self)

        if let tv = targetView {
            targetFrame = tv.convert(tv.bounds, to: window)
            spotlightFrame = CGRect(x: targetFrame.midX - 1, y: targetFrame.midY - 1, width: 2, height: 2)
        }
        if let etv = endTargetView {
            endTargetFrame = etv.convert(etv.bounds, to: window)
        }

        updateContentViewPosition()
        createSpotlight()
        createTriangleArrow()
        updateTrianglePosition()

        contentView?.alpha = 0
        triangleView?.alpha = 0

        DispatchQueue.main.async {
            if animated {
                UIView.animate(withDuration: 0.1) { self.alpha = 1 }
                self.animateSpotlight {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.contentView?.alpha = 1
                        self.triangleView?.alpha = 1
                    }, completion: { _ in completion?() })
                }
            } else {
                self.alpha = 1
                self.contentView?.alpha = 1
                self.triangleView?.alpha = 1
                completion?()
            }
        }
    }

    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard animated else {
            removeFromSuperview()
            onDismiss?()
            completion?()
            return
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView?.alpha = 0
            self.triangleView?.alpha = 0
        }, completion: { _ in
            self.animateSpotlightClose {
                self.removeFromSuperview()
                self.onDismiss?()
                completion?()
            }
        })
    }

    // MARK: - Setup

    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        view.frame = CGRect(x: 0, y: 0, width: contentViewWidth, height: 0)
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = EDTSColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = []

        contentView = view
        addSubview(view)
        setupUI()
    }

    private func setupUI() {
        updateCoachmarkType()
        vIconBackground.applyCircular()
        vIconBackground.backgroundColor = EDTSColor.grey20
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:))))
    }

    private func updateCoachmarkType() {
        if coachmarkType == CoachmarkType.single.rawValue {
            setupButtonConstraintsSingle()
            setupIconConstraintsSingle()
            setupDividerConstraintsSingle()
        }
    }

    // MARK: - Step UI

    private func getCurrentStep() -> CoachmarkStepConfig? {
        guard currentStep > 0, currentStep <= stepConfigurations.count else { return nil }
        return stepConfigurations[currentStep - 1]
    }

    private func updateCurrentStepUI() {
        guard let stepConfig = getCurrentStep() else { return }

        let oldTargetView = targetView
        let oldEndTargetView = endTargetView
        
        targetView = stepConfig.targetView
        endTargetView = stepConfig.endTargetView
        spotlightRadius = stepConfig.spotlightRadius
        contentMargin = stepConfig.contentMargin
        offsetMargin = stepConfig.offsetMargin

        setupTitle(stepConfig)
        setupDescription(stepConfig)
        setupStepConjunction()
        setupButton(btnSkip, label: stepConfig.btnOutlinedText, type: .tertiary, hidden: stepConfig.isBtnOutlinedHide)
        setupButton(btnNext, label: stepConfig.btnFilledText, type: .primary, hidden: stepConfig.isBtnFilledHide)

        if !stepConfig.isBtnOutlinedHide && !stepConfig.isBtnFilledHide {
            btnSkip.isHidden = (currentStep == totalSteps)
        }
        
        if currentStep == totalSteps {
            btnNext.label = "Mengerti"
        }

        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let tv = targetView {
            targetFrame = tv.convert(tv.bounds, to: window)
            if let etv = endTargetView {
                endTargetFrame = etv.convert(etv.bounds, to: window)
            }
            if alpha == 1 {
                updateSpotlight(previousTarget: oldTargetView, previousEndTarget: oldEndTargetView)
                updateContentViewPosition()
                updateTrianglePosition()
            }
        }
        setupCoachmarkSize()
    }

    private func moveToNextStep() {
        if currentStep < totalSteps {
            currentStep += 1
            updateCurrentStepUI()
        } else {
            dismiss(animated: true)
        }
    }

    // MARK: - Content Setup

    private func setupTitle(_ config: CoachmarkStepConfig) {
        if config.title == nil, let attributed = config.titleAttributted {
            lblTitle.attributedText = attributed
        } else {
            lblTitle.text = config.title ?? ""
        }
    }
    
    private func setupTitleFont() {
        let size = titleFontSize
        let weight = setupFontWeight(from: titleFontWeight)
        
        if let customFont = UIFont(name: titleFontName, size: size) {
            lblTitle.font = customFont
        } else {
            lblTitle.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
    }

    private func setupDescription(_ config: CoachmarkStepConfig) {
        if config.description == nil, let attributed = config.descriptionAttributted {
            let mutable = NSMutableAttributedString(attributedString: attributed)
            let fullRange = NSRange(location: 0, length: mutable.length)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = 16
            paragraphStyle.maximumLineHeight = 16
            mutable.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)

            mutable.enumerateAttribute(.font, in: fullRange) { value, range, _ in
                guard let oldFont = value as? UIFont else { return }
                let isBold = oldFont.fontDescriptor.symbolicTraits.contains(.traitBold)
                let newFont: UIFont = isBold ? .systemFont(ofSize: 12, weight: .semibold) : .systemFont(ofSize: 12, weight: .regular)
                mutable.addAttribute(.font, value: newFont, range: range)
                mutable.addAttribute(.foregroundColor, value: EDTSColor.grey60, range: range)
            }
            lblDescription.attributedText = mutable
        } else {
            lblDescription.text = config.description
        }
    }
    
    private func setupDescriptionFont() {
        let size = descFontSize
        let weight = setupFontWeight(from: descFontWeight)
        
        if let customFont = UIFont(name: titleFontName, size: size) {
            lblDescription.font = customFont
        } else {
            lblDescription.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    private func setupStepConjunction() {
        lblTotalStep.text = "\(currentStep) \(stepConjunction) \(totalSteps)"
    }
    
    private func setupStepFont() {
        let size = stepFontSize
        let weight = setupFontWeight(from: stepFontWeight)
        
        if let customFont = UIFont(name: titleFontName, size: size) {
            lblTotalStep.font = customFont
        } else {
            lblTotalStep.font = UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
    
    private func setupIcon() {
        if let iconTint = iconTint {
            ivIcon.tintColor = iconTint
        }
        
        if let iconBgColor = iconBgColor {
            vIconBackground.backgroundColor = iconBgColor
        }
    }
    
    private func setupButton(_ button: EDTSButton, label: String?, type: BtnType, hidden: Bool) {
        button.isHidden = hidden
        button.label = label
        button.btnType = type.rawValue
        button.fontSize = 12
        button.fontWeight = "semibold"
    }
    
    private func setupButtonColor() {
        if let btnOutlinedTint = btnOutlinedTint {
            btnSkip.borderColor = btnOutlinedTint
            btnSkip.labelColor = btnOutlinedTint
        }
        
        if let btnFilledTint = btnFilledTint {
            btnNext.bgColor = btnFilledTint
        }
    }
    
    public func setupFontWeight(from value: String) -> UIFont.Weight {
        let lowercased = value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        let weight = FontWeight(rawValue: lowercased) ?? .regular
        
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

    // MARK: - Constraint Setup

    private func setupButtonConstraintsSingle() {
        DispatchQueue.main.async {
            self.lblTotalStep.isHidden = true
            self.btnSkip.isHidden = true
        }
        btnNext.constraints.filter { $0.firstAttribute == .width }.forEach { $0.isActive = false }
        contentView?.constraints
            .filter { ($0.firstItem as? UIView) == btnNext && $0.firstAttribute == .leading }
            .forEach { $0.isActive = false }

        btnNext.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnNext.leadingAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }

    private func setupIconConstraintsSingle() {
        guard let contentView = contentView else { return }

        vIconBackground.isHidden = false
        ivIcon.isHidden = true

        vIconBackground.constraints.filter { $0.firstAttribute == .width }.forEach { $0.isActive = false }
        contentView.constraints
            .filter { ($0.firstItem as? UIView) == vIconBackground && $0.firstAttribute == .leading }
            .forEach { $0.isActive = false }
        contentView.constraints
            .filter { ($0.firstItem as? UIView) == vLabelContainer && $0.firstAttribute == .leading }
            .forEach { $0.isActive = false }

        vIconBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vIconBackground.widthAnchor.constraint(equalToConstant: 0),
            vLabelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }

    private func setupDividerConstraintsSingle() {
        guard let contentView = contentView else { return }

        vDivider.isHidden = true
        contentView.constraints
            .filter { ($0.firstItem as? UIView) == vDivider && $0.firstAttribute == .top }
            .forEach { $0.isActive = false }

        vDivider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vDivider.topAnchor.constraint(equalTo: vLabelContainer.bottomAnchor, constant: 0)
        ])
    }

    // MARK: - Layout

    private func setupCoachmarkHeight() {
        guard let contentView = contentView else { return }
        contentView.layoutIfNeeded()

        var totalHeight: CGFloat = 16
        totalHeight += max(vIconBackground.isHidden ? 0 : vIconBackground.frame.height,
                           vLabelContainer.isHidden ? 0 : vLabelContainer.frame.height)
        totalHeight += 16

        if !vDivider.isHidden {
            totalHeight += vDivider.frame.height + 16
        }

        let bottomHeight = [btnNext, btnSkip, lblTotalStep]
            .compactMap { $0 }
            .filter { !$0.isHidden }
            .map { $0.frame.height }
            .max() ?? 0

        totalHeight += bottomHeight + 16
        totalHeight = max(totalHeight, 100)

        var frame = contentView.frame
        frame.size.height = totalHeight
        contentView.frame = frame
    }

    private func setupCoachmarkSize() {
        setupCoachmarkHeight()
        guard let contentView = contentView else { return }
        let desiredWidth = max(contentViewWidth, bounds.width - (contentMargin*2))
        if contentView.frame.width != desiredWidth {
            var frame = contentView.frame
            frame.size.width = desiredWidth
            contentView.frame = frame
        }
    }

    private func updateContentViewPosition() {
        guard let contentView = contentView else { return }
        setupCoachmarkSize()

        let referenceFrame = endTargetView != nil ? spotlightRectForUnified() : createListSpotlight()
        let spaceBelow = bounds.height - referenceFrame.maxY - 12 - contentView.frame.height - triangleHeight - 8

        if spaceBelow < 0 {
            arrowPosition = .bottom
            contentView.frame.origin.y = referenceFrame.minY - contentView.frame.height - 8 - triangleHeight
        } else {
            arrowPosition = .top
            contentView.frame.origin.y = referenceFrame.maxY + triangleHeight + 8
        }

        contentView.frame.origin.x = offsetMargin != -1 ? offsetMargin : contentMargin
        bringSubviewToFront(contentView)
    }

    // MARK: - Spotlight Frames

    private func spotlightRectForUnified(padding: CGFloat? = nil) -> CGRect {
        let p = padding ?? (16)
        let unified = targetFrame.union(endTargetFrame)
        return CGRect(x: unified.minX - p, y: unified.minY - p,
                      width: unified.width + p * 2, height: unified.height + p * 2)
    }

    private func createListSpotlight() -> CGRect {
        guard let config = getCurrentStep(), config.isTargetAList else {
            return targetFrame.insetBy(dx: -spotlightRadius, dy: -spotlightRadius)
        }
        let left = config.spotlightPaddingLeft ?? config.spotlightPadding
        let right = config.spotlightPaddingRight ?? config.spotlightPadding
        let verticalSpacing = config.spotlightPadding
        return CGRect(x: targetFrame.minX + left, y: targetFrame.minY - verticalSpacing,
                      width: targetFrame.width - (left + right), height: targetFrame.height + (verticalSpacing * 2))
    }

    private func spotlightPath(for rect: CGRect, outerRect: CGRect? = nil) -> UIBezierPath {
        let path = UIBezierPath(rect: outerRect ?? bounds)
        path.append(UIBezierPath(roundedRect: rect, cornerRadius: spotlightRadius))
        path.usesEvenOddFillRule = true
        return path
    }

    private func currentSpotlightRect() -> CGRect {
        return endTargetView != nil ? spotlightRectForUnified() : createListSpotlight()
    }

    private func tinyRect(centeredIn rect: CGRect) -> CGRect {
        CGRect(x: rect.midX - 1, y: rect.midY - 1, width: 2, height: 2)
    }

    // MARK: - Spotlight Creation
    
    private func createSpotlight() {
        spotlightLayer?.removeFromSuperlayer()

        guard let config = getCurrentStep(), !config.isHideSpotlight else { return }

        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        spotlightLayer = layer

        if spotlightFrame == .zero, targetFrame != .zero {
            spotlightFrame = tinyRect(centeredIn: targetFrame)
        }

        let path = UIBezierPath(rect: bounds)
        let initialRect = endTargetView != nil ? spotlightRectForUnified() : spotlightFrame
        path.append(UIBezierPath(ovalIn: initialRect))
        path.usesEvenOddFillRule = true

        layer.path = path.cgPath
        layer.fillRule = .evenOdd
        layer.fillColor = dimColor.cgColor
        layer.frame = bounds
    }
    
    private func updateSpotlight(previousTarget: UIView?, previousEndTarget: UIView?) {
        if let config = getCurrentStep(), config.isHideSpotlight {
            spotlightLayer?.removeFromSuperlayer()
            self.spotlightLayer = nil
            UIView.animate(withDuration: 0.3) {
                self.updateContentViewPosition()
                self.updateTrianglePosition()
            }
            return
        }

        guard let spotlightLayer = spotlightLayer else {
            createSpotlight()
            animateSpotlight {
                UIView.animate(withDuration: 0.3) {
                    self.updateContentViewPosition()
                    self.updateTrianglePosition()
                }
            }
            return
        }

        let targetsChanged = (previousTarget != nil && previousTarget !== targetView) ||
                             (previousEndTarget != nil && previousEndTarget !== endTargetView)
        guard targetsChanged else { return }

        let fromPath = spotlightLayer.presentation()?.path ?? spotlightLayer.path
        let finalPath = spotlightPath(for: currentSpotlightRect())

        spotlightLayer.removeAnimation(forKey: "pathAnimation")
        spotlightLayer.removeAnimation(forKey: "pathUpdateAnimation")
        spotlightLayer.path = finalPath.cgPath

        let animation = makePathAnimation(from: fromPath, to: finalPath.cgPath, duration: 0.3,
                                          timing: CAMediaTimingFunction(name: .easeInEaseOut))
        spotlightLayer.add(animation, forKey: "pathUpdateAnimation")

        UIView.animate(withDuration: 0.3) {
            self.updateContentViewPosition()
            self.updateTrianglePosition()
        }
    }

    private func updateSpotlightPosition() {
        guard let tv = targetView, let spotlightLayer = spotlightLayer else { return }

        if let window = self.window {
            targetFrame = tv.convert(tv.bounds, to: window)
            if let etv = endTargetView { endTargetFrame = etv.convert(etv.bounds, to: window) }
        }

        guard spotlightLayer.animation(forKey: "pathAnimation") == nil,
              spotlightLayer.animation(forKey: "closePathAnimation") == nil else { return }

        let path = spotlightPath(for: currentSpotlightRect())
        spotlightLayer.path = path.cgPath
        spotlightLayer.frame = bounds
    }

    // MARK: - Triangle

    private func createTriangleArrow() {
        triangleView?.removeFromSuperview()

        let view = UIView(frame: CGRect(x: 0, y: 0, width: triangleWidth, height: triangleHeight))
        view.backgroundColor = .clear
        view.alpha = 0
        triangleView = view
        addSubview(view)

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: triangleWidth, y: 0))
        let rightControl = CGPoint(x: triangleWidth / 2 + triangleTopRadius, y: triangleHeight - triangleTopRadius / 2)
        let leftControl = CGPoint(x: triangleWidth / 2 - triangleTopRadius, y: triangleHeight - triangleTopRadius / 2)
        path.addLine(to: rightControl)
        path.addQuadCurve(to: leftControl, controlPoint: CGPoint(x: triangleWidth / 2, y: triangleHeight))
        path.close()

        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = EDTSColor.white.cgColor
        view.layer.addSublayer(layer)
    }

    private func updateTriangleForArrowPosition() {
        guard let triangleView = triangleView else { return }
        triangleView.transform = arrowPosition == .top ? CGAffineTransform(rotationAngle: .pi) : .identity
        bringSubviewToFront(triangleView)
    }

    private func updateTrianglePosition() {
        guard let contentView = contentView, let triangleView = triangleView else { return }

        let targetCenterX: CGFloat
        if endTargetView != nil {
            targetCenterX = targetFrame.union(endTargetFrame).midX
        } else if let config = getCurrentStep(), config.isTargetAList {
            targetCenterX = createListSpotlight().midX
        } else {
            targetCenterX = targetFrame.midX
        }

        let leftThreshold = contentView.frame.width * 0.25
        let rightThreshold = contentView.frame.width * 0.25

        var triangleX: CGFloat
        if targetCenterX < contentView.frame.minX + leftThreshold {
            triangleX = contentView.frame.minX + contentView.frame.width * 0.15 - triangleWidth / 2
        } else if targetCenterX > contentView.frame.maxX - rightThreshold {
            triangleX = contentView.frame.minX + contentView.frame.width * 0.85 - triangleWidth / 2
        } else {
            triangleX = targetCenterX - triangleWidth / 2
        }

        triangleX = max(contentView.frame.minX + triangleWidth / 2,
                        min(triangleX, contentView.frame.maxX - triangleWidth * 1.5))

        let triangleY = arrowPosition == .top ? contentView.frame.minY - triangleHeight : contentView.frame.maxY
        triangleView.frame = CGRect(x: triangleX, y: triangleY, width: triangleWidth, height: triangleHeight)
        updateTriangleForArrowPosition()
        bringSubviewToFront(triangleView)
    }

    // MARK: - Animations

    private func makePathAnimation(from: CGPath?, to: CGPath, duration: CFTimeInterval, timing: CAMediaTimingFunction) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.timingFunction = timing
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }

    private func animateSpotlight(completion: (() -> Void)? = nil) {
        let spotRect = currentSpotlightRect()
        let initialPath = spotlightPath(for: tinyRect(centeredIn: spotRect))
        let finalPath = spotlightPath(for: spotRect)

        spotlightLayer?.path = initialPath.cgPath

        CATransaction.begin()
        CATransaction.setCompletionBlock { completion?() }

        let animation = makePathAnimation(from: initialPath.cgPath, to: finalPath.cgPath, duration: 0.5,
                                          timing: CAMediaTimingFunction(controlPoints: 0.215, 0.610, 0.355, 1.000))
        spotlightLayer?.path = finalPath.cgPath
        spotlightLayer?.add(animation, forKey: "pathAnimation")
        CATransaction.commit()
    }

    private func animateSpotlightClose(completion: (() -> Void)? = nil) {
        guard let currentPath = spotlightLayer?.presentation()?.path ?? spotlightLayer?.path else {
            completion?()
            return
        }

        let center = endTargetView != nil ? targetFrame.union(endTargetFrame).center : targetFrame.center
        let finalPath = spotlightPath(for: tinyRect(centeredIn: CGRect(origin: center, size: .zero)))

        spotlightLayer?.path = finalPath.cgPath

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.spotlightLayer?.isHidden = true
            completion?()
        }

        let animation = makePathAnimation(from: currentPath, to: finalPath.cgPath, duration: 0.4,
                                          timing: CAMediaTimingFunction(controlPoints: 0.550, 0.055, 0.675, 0.190))
        spotlightLayer?.add(animation, forKey: "closePathAnimation")
        CATransaction.commit()
    }

    // MARK: - Gesture

    @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let spotRect = endTargetView != nil ? spotlightRectForUnified() : createListSpotlight()
        if !spotRect.contains(location) {
            // Tapped outside spotlight
        }
    }

    // MARK: - Actions

    @IBAction func skipButtonTapped(_ sender: UIButton) { dismiss(animated: true) }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if currentStep == totalSteps { dismiss(animated: true) } else { moveToNextStep() }
    }
}

// MARK: - CGRect Extension

private extension CGRect {
    var center: CGPoint { CGPoint(x: midX, y: midY) }
}

// MARK: - CoachmarkStepConfig

public struct CoachmarkStepConfig {
    let title: String?
    let titleAttributted: NSAttributedString?
    let description: String?
    let descriptionAttributted: NSAttributedString?
    let targetView: UIView?
    let endTargetView: UIView?
    let btnOutlinedText: String?
    let btnFilledText: String?
    let isBtnOutlinedHide: Bool
    let isBtnFilledHide: Bool
    let contentMargin: CGFloat
    let offsetMargin: CGFloat
    let spotlightRadius: CGFloat
    let spotlightPadding: CGFloat
    let spotlightPaddingLeft: CGFloat?
    let spotlightPaddingRight: CGFloat?
    let isTargetAList: Bool
    let isHideSpotlight: Bool

    public init(
        title: String? = nil,
        titleAttributted: NSAttributedString? = nil,
        description: String? = nil,
        descriptionAttributted: NSAttributedString? = nil,
        targetView: UIView? = nil,
        endTargetView: UIView? = nil,
        btnOutlinedText: String? = "Tutup",
        btnFilledText: String? = "Berikutnya",
        isBtnOutlinedHide: Bool = false,
        isBtnFilledHide: Bool = false,
        contentMargin: CGFloat = 24,
        offsetMargin: CGFloat = -1,
        spotlightRadius: CGFloat = 4,
        spotlightPadding: CGFloat = 8,
        spotlightPaddingLeft: CGFloat? = nil,
        spotlightPaddingRight: CGFloat? = nil,
        isTargetAList: Bool = false,
        isHideSpotlight: Bool = false
    ) {
        self.title = title
        self.titleAttributted = titleAttributted
        self.description = description
        self.descriptionAttributted = descriptionAttributted
        self.targetView = targetView
        self.endTargetView = endTargetView
        self.btnOutlinedText = btnOutlinedText
        self.btnFilledText = btnFilledText
        self.isBtnOutlinedHide = isBtnOutlinedHide
        self.isBtnFilledHide = isBtnFilledHide
        self.contentMargin = contentMargin
        self.offsetMargin = offsetMargin
        self.spotlightRadius = spotlightRadius
        self.spotlightPadding = spotlightPadding
        self.spotlightPaddingLeft = spotlightPaddingLeft
        self.spotlightPaddingRight = spotlightPaddingRight
        self.isTargetAList = isTargetAList
        self.isHideSpotlight = isHideSpotlight
    }
}
