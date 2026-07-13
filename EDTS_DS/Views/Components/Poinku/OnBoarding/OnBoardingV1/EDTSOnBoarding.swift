//
//  OnBoarding.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 25/04/25.
//

import UIKit

public class EDTSOnBoarding: UIView {
    
    //MARK: - Outlets
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: EDTSPageControl!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var vContentContainer: UIView!
    
    //MARK: - Public Variables
    
    public var slides: [EDTSOnBoardingSlide] = [] {
        didSet {
            updateSlideData()
        }
    }
    
    public var currentPage = 0
    
    //MARK: - Private Variables
    
    private var oriSlides: [EDTSOnBoardingSlide] = []
    private var wrapSlides: [EDTSOnBoardingSlide] = []
    private var autoScrollTimer: Timer?
    private var scrollWorkItem: DispatchWorkItem?
    
    private var animationStartTime: CFTimeInterval = 0
    private var animationDuration: CFTimeInterval = 0
    private var animationStartOffset: CGFloat = 0
    private var animationEndOffset: CGFloat = 0
    private var displayLink: CADisplayLink?
    
    private class WeakDisplayLink {
        weak var target: EDTSOnBoarding?
        init(_ target: EDTSOnBoarding) { self.target = target }
        @objc func tick() { target?.updateScroll() }
    }
    
    //MARK: - Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    //MARK: - Public Functions
    
    public func viewWillAppear() {
        startAutoScrollTimer()
        stopDisplayLink()
    }
    
    public func viewWillDisappear() {
        stopAutoScrollTimer()
        stopDisplayLink()
        
        DispatchQueue.main.async { [weak self] in
            self?.wrapSlides.removeAll()
            self?.oriSlides.removeAll()
        }
        
//        wrapSlides.removeAll()
//        oriSlides.removeAll()
    }
    
    //MARK: - Private Functions
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSOnBoarding", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            setupCollectionView(bundle)
            setupUI()
        } else {
            print("Failed to load OnBoarding XIB")
        }
    }
    
    private func setupUI() {
        setupPageControl()
        setupDescStyle()
        setupDescGradientBackground()
        
        DispatchQueue.main.async {
            self.startAutoScrollTimer()
        }
    }
    
    private func setupCollectionView(_ bundle: Bundle) {
        let nib = UINib(nibName: "EDTSOnBoardingCell", bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: EDTSOnBoardingCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.activeColor = EDTSColor.blue30
        pageControl.inactiveColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    private func setupDescStyle() {
        lblTitle.font = EDTSFont.H1.font
        lblTitle.textColor = EDTSColor.grey80
        lblDesc.font = EDTSFont.P2.Regular.font
        lblDesc.textColor = EDTSColor.grey80
    }
    
    private func setupDescGradientBackground() {
        vContentContainer.layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        let gradientLayer = CAGradientLayer()
        
        DispatchQueue.main.async {
            gradientLayer.frame = self.vContentContainer.bounds
        }
        
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor
        ]
        
        gradientLayer.locations = [0.85, 1.0]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        vContentContainer.backgroundColor = UIColor.clear
        vContentContainer.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //MARK: - Setup Data
    
    private func setupSlideData() {
        oriSlides = slides
        wrapSlides = slides
        
        if !slides.isEmpty {
            let firstSlide = slides[0]
            let lastSlide = slides[slides.count - 1]
            
            wrapSlides.insert(lastSlide, at: 0)
            wrapSlides.append(firstSlide)
        }
    }
    
    private func setupDescData(_ onBoardingSlide: EDTSOnBoardingSlide) {
        guard !wrapSlides.isEmpty else { return }
        
        lblTitle.text = onBoardingSlide.title
        lblDesc.text = onBoardingSlide.description
        
        lblTitle.alpha = 0
        lblDesc.alpha = 0
        
        lblTitle.transform = CGAffineTransform(translationX: 0, y: 20)
        lblDesc.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.lblTitle.alpha = 1
            self.lblTitle.transform = CGAffineTransform.identity
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.lblDesc.alpha = 1
            self.lblDesc.transform = CGAffineTransform.identity
        })
    }
    
    private func updateSlideData() {
        if !slides.isEmpty {
            setupSlideData()
            collectionView.reloadData()
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                self.currentPage = 1
                self.setupDescData(self.wrapSlides[1])
            }
            
            pageControl.numberOfPages = slides.count
            pageControl.currentPage = 0
        }
    }
    
    private func setupDisplayLink() {
        stopDisplayLink()
        
        displayLink = CADisplayLink(target: WeakDisplayLink(self), selector: #selector(WeakDisplayLink.tick))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    //MARK: - Animations
    
    private func startAutoScrollTimer() {
        stopAutoScrollTimer()
        guard !wrapSlides.isEmpty else { return }

        let item = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.scrollToNextPage()
        }
        scrollWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: item)
    }
    
    private func stopAutoScrollTimer() {
        scrollWorkItem?.cancel()
        scrollWorkItem = nil
        
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    private func easeInOutQuad(_ t: CGFloat) -> CGFloat {
        return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t
    }
    
    @objc private func scrollToNextPage() {
        guard !wrapSlides.isEmpty else { return }
        
        let nextPage = currentPage + 1
        let width = collectionView.frame.width
        guard width > 0 else { return }
        
        guard nextPage < wrapSlides.count else { return }
        guard currentPage < wrapSlides.count else { return }
        
        let nextXOffset = CGFloat(nextPage) * width
        let startOffset = collectionView.contentOffset.x

        animationStartTime = CACurrentMediaTime()
        animationDuration = 0.5
        animationStartOffset = startOffset
        animationEndOffset = nextXOffset
        currentPage = nextPage

        setupDisplayLink()
        
        let isLastPage = currentPage == wrapSlides.count - 1
        if !isLastPage {
            let actualPage = (currentPage - 1) % oriSlides.count
            pageControl.currentPage = actualPage
            setupDescData(wrapSlides[currentPage])
        }
    }
    
    @objc func updateScroll() {
        guard !wrapSlides.isEmpty else {
            stopDisplayLink()
            return
        }

        let elapsed = CACurrentMediaTime() - animationStartTime
        let width = collectionView.frame.width
        guard width > 0 else {
            stopDisplayLink()
            return
        }

        if elapsed >= animationDuration {
            collectionView.setContentOffset(CGPoint(x: animationEndOffset, y: 0), animated: false)
            stopDisplayLink()

            if currentPage == wrapSlides.count - 1 {
                currentPage = 1
                let newOffset = CGFloat(currentPage) * width
                collectionView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)
                pageControl.currentPage = 0
                
                guard currentPage < wrapSlides.count else { return }
                setupDescData(wrapSlides[currentPage])
            }
            
            startAutoScrollTimer()
            return
        }

        let progress = CGFloat(elapsed / animationDuration)
        let easedProgress = easeInOutQuad(progress)
        let currentOffset = animationStartOffset + (animationEndOffset - animationStartOffset) * easedProgress

        collectionView.setContentOffset(CGPoint(x: currentOffset, y: 0), animated: false)

        let normalizedOffset = currentOffset / width - 1
        pageControl.scrollProgress = normalizedOffset
    }
}

//MARK: - Collection View

extension EDTSOnBoarding: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wrapSlides.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EDTSOnBoardingCell.identifier, for: indexPath) as! EDTSOnBoardingCell
        
        cell.setup(wrapSlides[indexPath.item].image)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    //MARK: - ScrollView
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating {
            return
        }
        
        let width = scrollView.frame.width
        let contentOffsetX = scrollView.contentOffset.x
        let actualPage = contentOffsetX / width
        
        if actualPage <= 0 {
            let progressInLastPage = actualPage
            let adjustedProgress = CGFloat(oriSlides.count - 1) + progressInLastPage
            pageControl.scrollProgress = adjustedProgress
        } else if actualPage >= CGFloat(wrapSlides.count - 1) {
            let progressPastLastPage = actualPage - CGFloat(wrapSlides.count - 1)
            pageControl.scrollProgress = progressPastLastPage
        } else {
            pageControl.scrollProgress = actualPage - 1
        }
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        
        if currentPage == 0 {
            currentPage = wrapSlides.count - 2
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        } else if currentPage == wrapSlides.count - 1 {
            currentPage = 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
        setupDescData(wrapSlides[currentPage])
        startAutoScrollTimer()
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScrollTimer()
        stopDisplayLink()
    }
}
