//
//  EDTSCardPromo.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 22/10/26.
//

import UIKit

public class EDTSCardPromo: UIView {

    //MARK: - Outlets

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var vTab: EDTSTabDefault!
    @IBOutlet weak var collectionPromo: UICollectionView!
    @IBOutlet weak var tabHeight: NSLayoutConstraint!

    //MARK: - Inspectable

    @IBInspectable public var tabBackgroundColor: UIColor? {
        get { vTab?.backgroundColor }
        set { vTab?.backgroundColor = newValue }
    }

    @IBInspectable public var isTabHidden: Bool = false {
        didSet { applyTabVisibility() }
    }

    @IBInspectable public var tabHeightWhenVisible: CGFloat = 48 {
        didSet { applyTabVisibility() }
    }

    // MARK: - Public Variable

    public static let identifier = "EDTSCardPromo"
    public weak var delegate: EDTSCardPromoDelegate?
    public private(set) var cards: [EDTSCardPromoModel] = []
    public private(set) var isLoading = false
    public var skeletonCardCount = 3
    public var collectionView: UICollectionView { collectionPromo }

    // MARK: - Private Variable

    private static let listInset: CGFloat = 12
    private static let estimatedCardHeight: CGFloat = 380
    private static let tabCellIdentifier = "EDTSTabDefaultCell"
    private static let promoActivationOffset: CGFloat = 24
    private var activeCardIndex = 0
    private var isConfiguring = false
    private var cardHeightCache: [Int: CGFloat] = [:]
    private var lastLayoutWidth: CGFloat = 0

    private static var sectionInset: UIEdgeInsets {
        UIEdgeInsets(top: listInset, left: listInset, bottom: listInset, right: listInset)
    }

    // MARK: - Public Functions

    public func configure(cards: [EDTSCardPromoModel]) {
        isConfiguring = true
        defer { isConfiguring = false }

        self.cards = cards
        cardHeightCache.removeAll()
        activeCardIndex = 0

        vTab.alpha = isLoading ? 0 : 1
        vTab.data = cards.map { EDTSTabDefaultModel(id: $0.id, title: $0.title) }
        vTab.setDynamicWidth(enabled: true)
        vTab.layoutIfNeeded()

        collectionPromo.reloadData()
        collectionPromo.layoutIfNeeded()
        scrollListToTop()

        vTab.selectDefaultTab()
    }

    public func updateCards(_ cards: [EDTSCardPromoModel]) {
        self.cards = cards
        cardHeightCache.removeAll()
        collectionPromo.reloadData()
    }

    public func setLoading(_ loading: Bool) {
        guard isLoading != loading else { return }
        isLoading = loading

        vTab.alpha = loading ? 0 : 1
        vTab.isUserInteractionEnabled = !loading

        collectionPromo.isScrollEnabled = !loading
        collectionPromo.isUserInteractionEnabled = !loading
        collectionPromo.panGestureRecognizer.isEnabled = !loading

        collectionPromo.reloadData()
        collectionPromo.layoutIfNeeded()

        activeCardIndex = 0
        scrollListToTop()

        if !loading, !cards.isEmpty {
            isConfiguring = true
            vTab.selectDefaultTab()
            isConfiguring = false
        }
    }

    public func scrollToCard(at index: Int, animated: Bool = true) {
        guard !isLoading else { return }

        collectionPromo.layoutIfNeeded()
        guard cards.indices.contains(index),
              collectionPromo.numberOfItems(inSection: 0) > index else { return }

        activeCardIndex = index
        vTab.selectTab(at: index)
        collectionPromo.scrollToItem(at: IndexPath(item: index, section: 0), at: .top, animated: animated)
    }

    public func setTabHidden(_ hidden: Bool, animated: Bool) {
        guard hidden != isTabHidden else { return }

        isTabHidden = hidden

        guard animated else { return }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }

    // MARK: - Private Function

    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSCardPromo", owner: self, options: nil),
           let view = nib.first as? UIView {

            containerView = view
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(containerView)

            tabHeightWhenVisible = tabHeight.constant

            setupTab()
            setupCollectionView()
            applyTabVisibility()
        }
    }

    private func applyTabVisibility() {
        guard vTab != nil, tabHeight != nil else { return }

        vTab.isHidden = isTabHidden
        tabHeight.constant = isTabHidden ? 0 : tabHeightWhenVisible
    }

    private func setupTab() {
        vTab.registerCellType(EDTSTabDefaultCell.self, withIdentifier: Self.tabCellIdentifier)
        vTab.delegate = self

        vTab.cellConfiguration = { cell, _, _, _ in
            guard let customCell = cell as? EDTSTabDefaultCell else { return }

            customCell.tabTextColor = EDTSColor.grey40
            customCell.tabTextActiveColor = EDTSColor.blue50
        }

        vTab.bgColor = EDTSColor.white
        vTab.setDynamicWidth(enabled: true)
    }

    private func setupCollectionView() {
        collectionPromo.register(
            EDTSCardPromoCell.self,
            forCellWithReuseIdentifier: EDTSCardPromoCell.identifier
        )
        collectionPromo.register(
            EDTSCardPromoSkeletonCell.self,
            forCellWithReuseIdentifier: EDTSCardPromoSkeletonCell.identifier
        )
        collectionPromo.dataSource = self
        collectionPromo.delegate = self

        collectionPromo.isPagingEnabled = false
        collectionPromo.isScrollEnabled = true
        collectionPromo.showsVerticalScrollIndicator = false
        collectionPromo.backgroundColor = EDTSColor.grey10
    }

    private var cardWidth: CGFloat {
        max(collectionPromo.bounds.width - (Self.listInset * 2), 0)
    }

    private func invalidateLayoutIfWidthChanged() {
        let width = collectionPromo.bounds.width
        guard width > 0, abs(width - lastLayoutWidth) > 0.5 else { return }
        lastLayoutWidth = width
        cardHeightCache.removeAll()
        collectionPromo.collectionViewLayout.invalidateLayout()
    }

    private func scrollListToTop() {
        collectionPromo.setContentOffset(
            CGPoint(x: 0, y: -collectionPromo.adjustedContentInset.top),
            animated: false
        )
    }

    // MARK: - Tab and scroll sync

    private func cardIndexForCurrentScroll() -> Int? {
        let count = collectionPromo.numberOfItems(inSection: 0)
        guard count > 0 else { return nil }

        let maxOffsetY = collectionPromo.contentSize.height
            - collectionPromo.bounds.height
            + collectionPromo.adjustedContentInset.bottom
        if maxOffsetY > 0, collectionPromo.contentOffset.y >= maxOffsetY - 1 {
            return count - 1
        }

        let topY = collectionPromo.contentOffset.y
            + collectionPromo.adjustedContentInset.top
            + Self.promoActivationOffset
        var result = 0
        for item in 0..<count {
            guard let frame = collectionPromo.layoutAttributesForItem(at: IndexPath(item: item, section: 0))?.frame else { continue }
            if frame.minY <= topY { result = item } else { break }
        }
        return result
    }

    private func syncTabWithScroll() {
        guard let index = cardIndexForCurrentScroll(), index != activeCardIndex else { return }
        activeCardIndex = index
        vTab.selectTab(at: index)
    }
}

// MARK: - UICollectionViewDataSource

extension EDTSCardPromo: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isLoading ? skeletonCardCount : cards.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if isLoading {
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: EDTSCardPromoSkeletonCell.identifier,
                for: indexPath
            )
        }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EDTSCardPromoCell.identifier,
            for: indexPath
        ) as? EDTSCardPromoCell else {
            return UICollectionViewCell()
        }

        let card = cards[indexPath.item]
        cell.configure(with: card)

        cell.onProductsChanged = { [weak self, weak cell] products in
            guard let self = self,
                  let cell = cell,
                  let indexPath = self.collectionPromo.indexPath(for: cell),
                  self.cards.indices.contains(indexPath.item) else { return }
            self.cards[indexPath.item].products = products
        }

        cell.onTap = { [weak self, weak cell] in
            guard let self = self,
                  let cell = cell,
                  let indexPath = self.collectionPromo.indexPath(for: cell) else { return }
            self.delegate?.cardPromo(self, didSelectCardAt: indexPath.item)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension EDTSCardPromo: UICollectionViewDelegateFlowLayout {

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        Self.sectionInset
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        Self.listInset
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = cardWidth

        if isLoading || !cards.indices.contains(indexPath.item) {
            return CGSize(width: width, height: Self.estimatedCardHeight)
        }

        if let cached = cardHeightCache[indexPath.item] {
            return CGSize(width: width, height: cached)
        }

        let height = EDTSCardPromoCell.height(for: cards[indexPath.item], width: width)
        cardHeightCache[indexPath.item] = height
        return CGSize(width: width, height: height)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard !isLoading, cards.indices.contains(indexPath.item) else { return }
        delegate?.cardPromo(self, didSelectCardAt: indexPath.item)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === collectionPromo else { return }

        if isLoading {
            let top = -scrollView.adjustedContentInset.top
            if scrollView.contentOffset.y != top { scrollView.contentOffset.y = top }
            return
        }

        guard scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating else { return }
        syncTabWithScroll()
    }
}

// MARK: - EDTSTabDefaultDelegate

extension EDTSCardPromo: EDTSTabDefaultDelegate {

    public func didSelectTabDefault(at index: Int, withId id: String, cellIdentifier: String) {
        guard !isConfiguring, !isLoading else { return }

        guard cards.indices.contains(index),
              collectionPromo.numberOfItems(inSection: 0) > index else { return }

        let userIsScrolling = collectionPromo.isTracking || collectionPromo.isDragging || collectionPromo.isDecelerating
        if userIsScrolling && index == activeCardIndex { return }

        activeCardIndex = index
        collectionPromo.scrollToItem(at: IndexPath(item: index, section: 0), at: .top, animated: true)
    }
}

// MARK: - Delegate

public protocol EDTSCardPromoDelegate: AnyObject {
    func cardPromo(_ cardPromo: EDTSCardPromo, didSelectCardAt index: Int)
    func cardPromo(_ cardPromo: EDTSCardPromo, didSelectProductAt productIndex: Int, inCardAt cardIndex: Int)
}

public extension EDTSCardPromoDelegate {
    func cardPromo(_ cardPromo: EDTSCardPromo, didSelectCardAt index: Int) {}
    func cardPromo(_ cardPromo: EDTSCardPromo, didSelectProductAt productIndex: Int, inCardAt cardIndex: Int) {}
}
