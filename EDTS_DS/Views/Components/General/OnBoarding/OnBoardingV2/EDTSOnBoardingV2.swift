//
//  OnBoarding2.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 23/06/25.
//

import UIKit

public enum OnBoardingMode {
    case defaultMode
    case withBackgroundMode
}

public class EDTSOnBoardingV2: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var collectionView2: UICollectionView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var pageControl: EDTSPageControl!
    @IBOutlet var vContentContainer: UIView!
    
    private var imgBackground2: UIImageView!
    private var isTransitioning = false
    private var animationStartTime: CFTimeInterval = 0
    private var animationDuration: CFTimeInterval = 0
    private var animationStartOffset: CGFloat = 0
    private var animationEndOffset: CGFloat = 0
    private var displayLink: CADisplayLink?
    
    public var mode: OnBoardingMode = .withBackgroundMode {
        didSet {
            setupOnBoardingMode()
        }
    }
    
    public var slides: [EDTSOnBoardingV2Slide] = [] {
        didSet {
            if collectionView2 != nil && !slides.isEmpty {
                setupInfiniteScrollSlides()
                collectionView2.reloadData()
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(item: 1, section: 0)
                    self.collectionView2.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                    self.currentPage = 1
                    self.setupContent(self.wrapSlides[1])
                    self.updateBackgroundImage()
                }
                
                pageControl.numberOfPages = slides.count
                pageControl.currentPage = 0
            }
        }
    }
    
    private var oriSlides: [EDTSOnBoardingV2Slide] = []
    private var wrapSlides: [EDTSOnBoardingV2Slide] = []
    
    public var currentPage = 0
    private var autoScrollTimer: Timer?
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        vContentContainer.layer.sublayers?.forEach {
            if $0 is CAGradientLayer {
                $0.removeFromSuperlayer()
            }
        }
        
        applyGradientToContentContainer()
        
        if currentPage == 1 && collectionView2.contentOffset.x == 0 {
            let indexPath = IndexPath(item: 1, section: 0)
            collectionView2.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupOnBoarding()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupOnBoarding()
    }
    
    public func viewWillAppear() {
       startAutoScrollTimer()
       stopDisplayLink()
    }
   
    public func viewWillDisappear() {
       stopAutoScrollTimer()
    }
    
    private func setupOnBoarding() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSOnBoardingV2", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            collectionView2.delegate = self
            collectionView2.dataSource = self
            
            let nib2 = UINib(nibName: "EDTSOnBoardingV2Cell", bundle: bundle)
            collectionView2.register(nib2, forCellWithReuseIdentifier: EDTSOnBoardingV2Cell.identifier)
            
            setupUI()
            setupOnBoardingMode()
            startAutoScrollTimer()
        } else {
            print("Failed to load OnBoardingV2 XIB")
        }
    }
    
    private func setupUI() {
        lblTitle.font = EDTSFont.H1.font
        lblTitle.textColor = EDTSColor.grey80
        
        lblDesc.font = EDTSFont.P2.Regular.font
        lblDesc.textColor = EDTSColor.grey80
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.activeColor = EDTSColor.blue30
        pageControl.inactiveColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        vContentContainer.backgroundColor = EDTSColor.white
        
        collectionView2.backgroundColor = UIColor.clear
        
        imgBackground.contentMode = .scaleAspectFill
        imgBackground.clipsToBounds = true
        
        setupSecondBackgroundImageView()
        applyGradientToContentContainer()
    }
    
    private func setupOnBoardingMode() {
        switch mode {
        case .defaultMode:
            imgBackground.isHidden = true
            imgBackground2?.isHidden = true
        case .withBackgroundMode:
            imgBackground.isHidden = false
            imgBackground2?.isHidden = false
        }
    }
    
    private func setupInfiniteScrollSlides() {
        oriSlides = slides
        wrapSlides = slides
        
        if !slides.isEmpty {
            let firstSlide = slides[0]
            let lastSlide = slides[slides.count - 1]
            
            wrapSlides.insert(lastSlide, at: 0)
            wrapSlides.append(firstSlide)
        }
    }
    
    private func setupSecondBackgroundImageView() {
        imgBackground2 = UIImageView()
        imgBackground2.contentMode = .scaleAspectFill
        imgBackground2.clipsToBounds = true
        imgBackground2.alpha = 0
        
        if let backgroundIndex = containerView.subviews.firstIndex(of: imgBackground) {
            containerView.insertSubview(imgBackground2, at: backgroundIndex + 1)
        }
        
        imgBackground2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgBackground2.topAnchor.constraint(equalTo: imgBackground.topAnchor),
            imgBackground2.leadingAnchor.constraint(equalTo: imgBackground.leadingAnchor),
            imgBackground2.trailingAnchor.constraint(equalTo: imgBackground.trailingAnchor),
            imgBackground2.bottomAnchor.constraint(equalTo: imgBackground.bottomAnchor)
        ])
    }
    
    private func updateBackgroundImage() {
        guard mode == .withBackgroundMode else { return }
        guard !wrapSlides.isEmpty else { return }
        
        let width = collectionView2.frame.width
        guard width > 0 else { return }
        
        let contentOffsetX = collectionView2.contentOffset.x
        let progress = contentOffsetX / width
        
        let currentIndex = Int(floor(progress))
        let nextIndex = currentIndex + 1
        let transitionProgress = progress - CGFloat(currentIndex)
        
        let safeCurrentIndex = max(0, min(currentIndex, wrapSlides.count - 1))
        let safeNextIndex = max(0, min(nextIndex, wrapSlides.count - 1))
        
        guard safeCurrentIndex != safeNextIndex && transitionProgress > 0 && transitionProgress < 1 else {
                if transitionProgress == 0 {
                    imgBackground.image = wrapSlides[safeCurrentIndex].imageBackground
                    imgBackground2.alpha = 0
                }
                return
            }
        
        let currentImage = wrapSlides[safeCurrentIndex].imageBackground
        
        if imgBackground.image != currentImage {
            imgBackground.image = currentImage
        }
        
        if imgBackground2.image != currentImage {
            imgBackground2.image = currentImage
        }
        
        let fade = min(max(transitionProgress, 0), 1)
        
        imgBackground2.alpha = fade
    }
    
    private func updateBackgroundImageProgressive() {
        guard mode == .withBackgroundMode else { return }
        guard !wrapSlides.isEmpty else { return }
        
        let width = collectionView2.frame.width
        guard width > 0 else { return }
        
        let contentOffsetX = collectionView2.contentOffset.x
        let progress = contentOffsetX / width
        
        let currentIndex = Int(floor(progress))
        let nextIndex = currentIndex + 1
        let transitionProgress = progress - CGFloat(currentIndex)
        
        let safeCurrentIndex = max(0, min(currentIndex, wrapSlides.count - 1))
        let safeNextIndex = max(0, min(nextIndex, wrapSlides.count - 1))
        
        imgBackground.image = wrapSlides[safeCurrentIndex].imageBackground
        
        if safeCurrentIndex != safeNextIndex && transitionProgress > 0 {
            imgBackground2.image = wrapSlides[safeNextIndex].imageBackground
            
            let eased = easeInOutQuad(transitionProgress)
            imgBackground2.alpha = eased
        } else if transitionProgress == 0 {
            imgBackground2.alpha = 0
        }
    }
    
    private func applyGradientToContentContainer() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = vContentContainer.bounds
        
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor
        ]
        
        gradientLayer.locations = [0.85, 1.0]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        vContentContainer.backgroundColor = .clear
        vContentContainer.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupContent(_ onBoardingSlide: EDTSOnBoardingV2Slide) {
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
    
    private func startAutoScrollTimer() {
        stopAutoScrollTimer()
        stopDisplayLink()
        
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            self?.scrollToNextPage()
        }
    }
    
    private func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
     
    @objc private func scrollToNextPage() {
        let nextPage = currentPage + 1
        let width = collectionView2.frame.width
        let nextXOffset = CGFloat(nextPage) * width
        
        let startOffset = collectionView2.contentOffset.x
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateScroll))
        displayLink?.add(to: .current, forMode: .common)
        
        animationStartTime = CACurrentMediaTime()
        animationDuration = 0.5
        animationStartOffset = startOffset
        animationEndOffset = nextXOffset
        
        currentPage = nextPage
        
        if currentPage == wrapSlides.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.1) {
                self.currentPage = 1
                let newOffset = CGFloat(self.currentPage) * width
                self.pageControl.currentPage = 0
                self.collectionView2.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)
                self.pageControl.currentPage = 0
                
                self.setupContent(self.wrapSlides[self.currentPage])
                
                if self.mode == .withBackgroundMode {
                    self.updateBackgroundImage()
                }
            }
        } else {
            let actualPage = (currentPage - 1) % oriSlides.count
            pageControl.currentPage = actualPage
            setupContent(wrapSlides[currentPage])
        }
    }
    
     @objc private func updateScroll() {
         let elapsed = CACurrentMediaTime() - animationStartTime
                  
         if elapsed >= animationDuration {
             stopDisplayLink()
             if mode == .withBackgroundMode {
                 imgBackground2.alpha = 0
             }
             return
         }
         
         let progress = CGFloat(elapsed / animationDuration)
         let easedProgress = easeInOutQuad(progress)
         
         let currentOffset = animationStartOffset + (animationEndOffset - animationStartOffset) * easedProgress
         
         collectionView2.setContentOffset(CGPoint(x: currentOffset, y: 0), animated: false)
         
         if !wrapSlides.isEmpty {
             let width = collectionView2.frame.width
             let normalizedOffset = currentOffset / width - 1
             pageControl.scrollProgress = normalizedOffset
             
             if mode == .withBackgroundMode {
                 updateBackgroundImageProgressive()
             }
         }
     }

     private func easeInOutQuad(_ t: CGFloat) -> CGFloat {
         return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t
     }
     
    private func setBackgroundImage(_ image: UIImage?) {
        guard mode == .withBackgroundMode else { return }
        imgBackground.image = image
        imgBackground2.alpha = 0
    }
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    deinit {
        stopAutoScrollTimer()
        stopDisplayLink()
    }
}

extension EDTSOnBoardingV2: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wrapSlides.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EDTSOnBoardingV2Cell.identifier, for: indexPath) as! EDTSOnBoardingV2Cell
        
        cell.setup(wrapSlides[indexPath.item].imageIllustration)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != collectionView2 {
            return
        }
        
        let width = scrollView.frame.width
        let contentOffsetX = scrollView.contentOffset.x
        let actualPage = contentOffsetX / width
        
        if mode == .withBackgroundMode {
            updateBackgroundImageProgressive()
        }
        
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
        if scrollView != collectionView2 {
            return
        }
        
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        
        if currentPage == 0 {
            currentPage = wrapSlides.count - 2
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView2.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        } else if currentPage == wrapSlides.count - 1 {
            currentPage = 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView2.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
        setupContent(wrapSlides[currentPage])
        
        if mode == .withBackgroundMode {
            setBackgroundImage(wrapSlides[currentPage].imageBackground)
        }
        
        startAutoScrollTimer()
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView != collectionView2 {
            return
        }
        
        stopAutoScrollTimer()
        stopDisplayLink()
    }
}
