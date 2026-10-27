//
//  EDTSTray.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 13/10/26.
//

import UIKit

public enum TrayHeightMode {
    case fullScreen
    case wrapContent
    case custom(CGFloat)
}

/// Bottom tray that works on iOS 13+ (UISheetPresentationController needs iOS 15).
public class EDTSTray: UIPresentationController, UIGestureRecognizerDelegate {

    // MARK: - Public properties
    public var dragHandleColor: UIColor = EDTSColor.grey30
    public var sheetBackgroundColor: UIColor = .white
    public var cornerRadius: CGFloat = 16
    public var overlayColor: UIColor = UIColor.black.withAlphaComponent(0.75)
    public var heightMode: TrayHeightMode = .wrapContent

    public var shadowColor: UIColor = .black
    public var shadowOpacity: Float = 0.2
    public var shadowRadius: CGFloat = 12
    public var shadowOffset: CGSize = CGSize(width: 0, height: -2)

    public var isHasDragHandle: Bool = true
    public var isHasOverlay: Bool = true

    public var canDismiss: () -> Bool = { true }
    public var onDismissAttempt: (() -> Void)?
    public var onOverlayTap: (() -> Void)?
    public var onDragSheet: ((CGFloat) -> Void)?

    // MARK: - Private properties
    private static let dragAreaHeight: CGFloat = 56

    private let dimmingView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()

    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0
        return view
    }()

    private let grabberView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 8, width: 36, height: 4))
        view.layer.cornerRadius = 2
        view.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        return view
    }()
    
    
    private var isOverlayVisible: Bool {
        isHasOverlay && overlayColor.cgColor.alpha > 0
    }

    private var shouldShowShadow: Bool { !isOverlayVisible }

    // MARK: - Initialize
    public override init(presentedViewController: UIViewController,
                         presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    // MARK: - Frame
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }

        let maxAllowed = container.bounds.height
        let height: CGFloat

        switch heightMode {
        case .fullScreen:
            height = maxAllowed
        case .custom(let value):
            height = min(value, maxAllowed)
        case .wrapContent:
            let fitted = presentedViewController.view.systemLayoutSizeFitting(
                CGSize(width: container.bounds.width, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            ).height
            let content = fitted > 0 ? fitted : presentedViewController.preferredContentSize.height
            height = min(content, maxAllowed)
        }

        return CGRect(x: 0,
                      y: container.bounds.height - height,
                      width: container.bounds.width,
                      height: height)
    }

    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        dimmingView.frame = containerView?.bounds ?? .zero
        if let presented = presentedView, presented.transform == .identity {
            let frame = frameOfPresentedViewInContainerView
            presented.frame = frame
            shadowView.frame = frame
            shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds,
                                                       cornerRadius: cornerRadius).cgPath
            grabberView.center.x = presented.bounds.midX
        }
    }

    // MARK: - Transition
    public override func presentationTransitionWillBegin() {
        guard let container = containerView, let presented = presentedView else { return }

        dimmingView.frame = container.bounds
        dimmingView.backgroundColor = isHasOverlay ? overlayColor : .clear
        container.insertSubview(dimmingView, at: 0)
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingTapped)))

        if shouldShowShadow {
            shadowView.frame = frameOfPresentedViewInContainerView
            shadowView.layer.shadowColor = shadowColor.cgColor
            shadowView.layer.shadowOpacity = shadowOpacity
            shadowView.layer.shadowRadius = shadowRadius
            shadowView.layer.shadowOffset = shadowOffset
            shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds,
                                                       cornerRadius: cornerRadius).cgPath
            container.insertSubview(shadowView, aboveSubview: dimmingView)
        }

        presented.backgroundColor = sheetBackgroundColor
        presented.layer.cornerRadius = cornerRadius
        presented.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presented.layer.masksToBounds = true

        if isHasDragHandle {
            grabberView.backgroundColor = dragHandleColor
            grabberView.center.x = presented.bounds.midX
            presented.addSubview(grabberView)
        }

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        presented.addGestureRecognizer(pan)

        let show = {
            self.dimmingView.alpha = 1
            self.shadowView.alpha = 1
        }
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in show() })
        } else {
            show()
        }
    }

    public override func dismissalTransitionWillBegin() {
        let hide = {
            self.dimmingView.alpha = 0
            self.shadowView.alpha = 0
        }
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in hide() })
        } else {
            hide()
        }
    }

    // MARK: - Dismiss gestures
    @objc private func dimmingTapped() {
        onOverlayTap?()

        guard canDismiss() else {
            onDismissAttempt?()
            return
        }
        presentedViewController.dismiss(animated: true)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let presented = presentedView, let container = containerView else { return }

        let translation = max(gesture.translation(in: container).y, 0)

        switch gesture.state {
        case .changed:
            let t = CGAffineTransform(translationX: 0, y: translation)
            presented.transform = t
            shadowView.transform = t
            onDragSheet?(translation)

        case .ended, .cancelled:
            let velocity = gesture.velocity(in: container).y
            let shouldDismiss = translation > presented.bounds.height * 0.3 || velocity > 900

            let reset = {
                UIView.animate(withDuration: 0.25) {
                    presented.transform = .identity
                    self.shadowView.transform = .identity
                }
            }

            guard shouldDismiss else {
                reset()
                onDragSheet?(0)
                return
            }

            guard canDismiss() else {
                reset()
                onDragSheet?(0)
                onDismissAttempt?()
                return
            }

            let offscreen = CGAffineTransform(translationX: 0, y: presented.bounds.height)
            UIView.animate(withDuration: 0.2, animations: {
                presented.transform = offscreen
                self.shadowView.transform = offscreen
                self.dimmingView.alpha = 0
                self.shadowView.alpha = 0
            }, completion: { _ in
                self.presentedViewController.dismiss(animated: false) {
                    presented.transform = .identity
                    self.shadowView.transform = .identity
                }
            })

        default:
            break
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let presented = presentedView else { return false }
        return touch.location(in: presented).y <= Self.dragAreaHeight
    }
}
