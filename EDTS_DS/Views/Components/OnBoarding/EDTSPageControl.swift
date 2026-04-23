//
//  CustomPageControl.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 24/04/25.
//

import UIKit

public class EDTSPageControl: UIPageControl {
    
    private var dotLayers: [CALayer] = []
    
    public var scrollProgress: CGFloat = 0 {
        didSet {
            if oldValue != scrollProgress {
                updateDotsForScrollProgress()
            }
        }
    }
    
    public var activeColor: UIColor = .blue {
        didSet { updateDotAppearance() }
    }
    public var inactiveColor: UIColor = .lightGray {
        didSet { updateDotAppearance() }
    }
    public var activeDotSize: CGFloat = 8 {
        didSet { updateDotAppearance() }
    }
    public var inactiveDotSize: CGFloat = 6 {
        didSet { updateDotAppearance() }
    }
    public var dotSpacing: CGFloat = 10 {
        didSet { updateDotAppearance() }
    }
    
    override public var numberOfPages: Int {
        didSet {
            if oldValue != numberOfPages {
                setupDotLayers()
            }
        }
    }
    
    override public var currentPage: Int {
        didSet {
            if !isUpdatingFromScroll {
                scrollProgress = CGFloat(currentPage)
                updateDotsForScrollProgress()
            }
        }
    }
    
    private var isUpdatingFromScroll = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        var totalWidth: CGFloat = 0
        for i in 0..<dotLayers.count {
            let dotSize = dotLayers[i].bounds.width
            totalWidth += dotSize
            
            if i < dotLayers.count - 1 {
                totalWidth += dotSpacing
            }
        }
        
        let startX = (bounds.width - totalWidth) / 2
        let centerY = bounds.height / 2
        
        var currentX = startX
        for i in 0..<dotLayers.count {
            let dotSize = dotLayers[i].bounds.width
            let dotLayer = dotLayers[i]
            
            dotLayer.position = CGPoint(x: currentX + dotSize / 2, y: centerY)
            currentX += dotSize + dotSpacing
        }
    }
    
    private func commonInit() {
        subviews.forEach { $0.isHidden = true }
        
        setupDotLayers()
    }
    
    private func setupDotLayers() {
        dotLayers.forEach { $0.removeFromSuperlayer() }
        dotLayers.removeAll()
        
        for _ in 0..<numberOfPages {
            let dotLayer = CALayer()
            dotLayer.cornerRadius = inactiveDotSize / 2
            dotLayer.backgroundColor = inactiveColor.cgColor
            dotLayer.bounds = CGRect(x: 0, y: 0,
                                    width: inactiveDotSize,
                                    height: inactiveDotSize)
            layer.addSublayer(dotLayer)
            dotLayers.append(dotLayer)
        }
        
        scrollProgress = CGFloat(currentPage)
        updateDotsForScrollProgress()
        setNeedsLayout()
    }
    
    private func updateDotAppearance() {
        updateDotsForScrollProgress()
        setNeedsLayout()
    }
    
    private func updateDotsForScrollProgress() {
        guard !dotLayers.isEmpty else { return }
        
        let newCurrentPage = Int(round(scrollProgress))
        if currentPage != newCurrentPage {
            isUpdatingFromScroll = true
            currentPage = newCurrentPage
            isUpdatingFromScroll = false
        }
        
        for i in 0..<dotLayers.count {
            let dotLayer = dotLayers[i]
            
            let distanceFromScrollPosition = abs(CGFloat(i) - scrollProgress)
            
            let progress = 1.0 - min(distanceFromScrollPosition, 1.0)
            
            let size = inactiveDotSize + (activeDotSize - inactiveDotSize) * progress
            let interpolatedColor = interpolateColor(from: inactiveColor, to: activeColor, with: progress)
            
            dotLayer.backgroundColor = interpolatedColor.cgColor
            dotLayer.bounds = CGRect(x: 0, y: 0, width: size, height: size)
            dotLayer.cornerRadius = size / 2
        }
        
        setNeedsLayout()
    }
    
    private func interpolateColor(from: UIColor, to: UIColor, with progress: CGFloat) -> UIColor {
        var fromR: CGFloat = 0, fromG: CGFloat = 0, fromB: CGFloat = 0, fromA: CGFloat = 0
        var toR: CGFloat = 0, toG: CGFloat = 0, toB: CGFloat = 0, toA: CGFloat = 0
        
        from.getRed(&fromR, green: &fromG, blue: &fromB, alpha: &fromA)
        to.getRed(&toR, green: &toG, blue: &toB, alpha: &toA)
        
        let r = fromR + (toR - fromR) * progress
        let g = fromG + (toG - fromG) * progress
        let b = fromB + (toB - fromB) * progress
        let a = fromA + (toA - fromA) * progress
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension EDTSPageControl {
    
    public func updateScrollProgress(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let offsetX = scrollView.contentOffset.x
        let totalWidth = scrollView.contentSize.width
        let numberOfRealPages = numberOfPages
        
        let rawProgress = offsetX / pageWidth
        
        var adjustedProgress: CGFloat
        
        if rawProgress <= 0 {
            adjustedProgress = CGFloat(numberOfRealPages - 1) + rawProgress
        } else if rawProgress >= CGFloat(numberOfRealPages + 1) {
            adjustedProgress = rawProgress - CGFloat(numberOfRealPages + 1)
        } else {
            adjustedProgress = rawProgress - 1
        }
        
        adjustedProgress = max(0, min(CGFloat(numberOfRealPages - 1), adjustedProgress))
        
        self.scrollProgress = adjustedProgress
    }
}
