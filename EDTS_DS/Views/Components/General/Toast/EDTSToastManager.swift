//
//  ToastManager.swift
//  KlikIDM_DS
//
//  Created by Yovita Handayiani on 18/02/26.
//

import UIKit

public enum EDTSToastAnimation: String {
    case fade = "fade"
    case slide = "slide"
}

public enum EDTSToastDuration {
    case short
    case long
    case indefinite
    case custom(TimeInterval)
    
    var timeInterval: TimeInterval? {
        switch self {
        case .short:
            return 1.5
        case .long:
            return 2.75
        case .indefinite:
            return nil
        case .custom(let value):
            return value
        }
    }
}

public enum EDTSToastSwipeDirection: String {
    case horizontal = "horizontal"
    case vertical = "vertical"
    
    var allowedDirections: (x: Bool, y: Bool) {
        switch self {
        case .horizontal: return (x: true, y: false)
        case .vertical:   return (x: false, y: true)
        }
    }
    
    func dismissDirection(offsetY: EDTSToastOffsetDirection) -> UISwipeGestureRecognizer.Direction {
        switch self {
        case .horizontal:
            return .right
        case .vertical:
            switch offsetY {
            case .bottom: return .down
            case .top:    return .up
            }
        }
    }
}


public enum EDTSToastOffsetDirection {
    case top(CGFloat)
    case bottom(CGFloat)
    
    var offsetDirection: CGFloat {
        switch self {
        case .top(let value):
            return value
        case .bottom(let value):
            return -value
        }
    }
}

public class EDTSToastManager: EDTSToastDelegate {
    // MARK: - Singleton
    public static let toast = EDTSToastManager()
    private init() {}
        
    // MARK: - Private Variable
    private var currentToast: EDTSToast?
    private var currentAnimation: EDTSToastAnimation = .fade
    private var currentOffsetY: EDTSToastOffsetDirection = .bottom(60.0)
    private var currentSwipeDirection: EDTSToastSwipeDirection = .horizontal
    private var currentDismissTimer: Timer?
    private var onButtonTap: (() -> Void)?
    
    // MARK: - Show
    public func show(
        rootView view: UIView,
        duration: EDTSToastDuration = .long,
        horizontalPadding: CGFloat = 16.0,
        offsetY: EDTSToastOffsetDirection = .bottom(60.0),
        animation: EDTSToastAnimation = .fade,
        swipeDirection: EDTSToastSwipeDirection = .horizontal,
        onButtonTap: (() -> Void)? = nil,
        configure: ((EDTSToast) -> Void)? = nil
    ) {
        dismiss(animated: false)
        
        let toast = EDTSToast()
        configure?(toast)
        toast.delegate = self
        self.onButtonTap = onButtonTap
        toast.setupDrag(swipeDirection: swipeDirection, offsetY: offsetY)
        toast.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toast)
        currentToast = toast
        currentAnimation = animation
        currentOffsetY = offsetY
        currentSwipeDirection = swipeDirection
        
        let verticalConstraint: NSLayoutConstraint

        switch offsetY {
        case .bottom:
            verticalConstraint = toast.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: offsetY.offsetDirection
            )
        case .top:
            verticalConstraint = toast.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: offsetY.offsetDirection
            )
        }
        
        NSLayoutConstraint.activate([
            toast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            toast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            verticalConstraint
        ])
        
        view.layoutIfNeeded()
        animateIn(toast: toast, animation: animation)
        
        if let timeInterval = duration.timeInterval {
            currentDismissTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
                self?.dismiss(animated: true)
            }
        }

    }
    
    // MARK: - Dismiss
    public func dismiss(animated: Bool = true) {
        currentDismissTimer?.invalidate()
        currentDismissTimer = nil
        
        guard let toast = currentToast else { return }
        currentToast = nil
        
        if animated {
            animateOut(toast: toast, animation: currentAnimation) {
                toast.removeFromSuperview()
            }
        } else {
            toast.removeFromSuperview()
        }
        self.onButtonTap = nil
    }
    
    public func dismissSwipe(direction: UISwipeGestureRecognizer.Direction) {
        currentDismissTimer?.invalidate()
        currentDismissTimer = nil
        guard let toast = currentToast else { return }
        currentToast = nil

        animateSwipeOut(toast: toast, direction: direction) {
            toast.removeFromSuperview()
        }
        self.onButtonTap = nil
    }
    
    // MARK: - Animation In
    private func animateIn(toast: EDTSToast, animation: EDTSToastAnimation) {
        switch animation {
        case .fade:
            toast.alpha = 0
            toast.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear) {
                toast.alpha = 1
            }
            
            let linearOutSlowIn = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.0, y: 0.0),
                                                controlPoint2: CGPoint(x: 0.2, y: 1.0))

            let animator = UIViewPropertyAnimator(duration: 0.15, timingParameters: linearOutSlowIn)
            animator.addAnimations {
                toast.transform = .identity
            }
            animator.startAnimation()
           
        case .slide:
            let screenHeight = UIScreen.main.bounds.height
            
            switch currentOffsetY {
            case .bottom:
                toast.transform = CGAffineTransform(translationX: 0, y: screenHeight)
            case .top:
                toast.transform = CGAffineTransform(translationX: 0, y: -screenHeight)
            }
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                toast.transform = .identity
            }
        }
    }
    
    // MARK: - Animation Out
    private func animateOut(toast: EDTSToast, animation: EDTSToastAnimation, completion: @escaping () -> Void) {
        switch animation {
        case .fade:
            UIView.animate(withDuration: 0.075, delay: 0, options: .curveLinear, animations: {
                toast.alpha = 0
            }, completion: { _ in completion() })
            
        case .slide:
            let screenHeight = UIScreen.main.bounds.height
            var transform = CGAffineTransform.identity
            
            switch currentOffsetY {
            case .top:
                transform = CGAffineTransform(translationX: 0, y: -screenHeight)
            case .bottom:
                transform = CGAffineTransform(translationX: 0, y: screenHeight)
            }
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                toast.transform = transform
            }, completion: { _ in completion() })
        }
    }
    
    private func animateSwipeOut(toast: EDTSToast, direction: UISwipeGestureRecognizer.Direction, completion: @escaping () -> Void) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        var transform = CGAffineTransform.identity

        switch direction {
        case .right: transform = CGAffineTransform(translationX: screenWidth, y: 0)
        case .up:    transform = CGAffineTransform(translationX: 0, y: -screenHeight)
        case .down:  transform = CGAffineTransform(translationX: 0, y: screenHeight)
        default:     break
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            toast.transform = transform
        }, completion: { _ in completion() })
    }
    
    // MARK: - Delegate
    public func didSelectButton(_ toast: EDTSToast) {
        onButtonTap?()
    }
    
    public func didSwipeToast(_ toast: EDTSToast, direction: UISwipeGestureRecognizer.Direction) {
        dismissSwipe(direction: direction)
    }
}
