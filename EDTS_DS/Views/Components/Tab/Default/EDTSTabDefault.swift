//
//  TabDefault.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 04/03/25.
//

import UIKit

public class TabDefault: UIView {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Public Variables
    
    public var data: [EDTSTabDefaultModelProtocol] = [] {
        didSet {
            reloadData()
        }
    }
    
    public var bgColor: UIColor? = UIColor.white {
        didSet {
            containerView.backgroundColor = bgColor
        }
    }
    
    public var isScrollable: Bool? {
        didSet {
            collectionView.isScrollEnabled = isScrollable ?? true
        }
    }
    
    public var isSkeleton: Bool = false {
        didSet {
            updateSkeletonState()
        }
    }
    
    public var skeletonItemTotal: Int = 0 {
        didSet {
            setupSkeletonView()
        }
    }
    
    public weak var delegate: EDTSTabDefaultDelegate?
    public var cellConfiguration: ((UICollectionViewCell, EDTSTabDefaultModelProtocol, Bool, Int) -> Void)?
    
    //MARK: - Private Variables
    
    private var cellIdentifier: String = ""
    private var cellType: AnyClass = EDTSTabDefaultCell.self
    private var currentlySelectedId: String?
    private var previousSelectedIndex: Int = 0
    
    private var layoutConfig = LayoutConfig()
    private var sizingConfig = SizingConfig()
    
    private var skeletonContainerView: UIView?
    private var skeletonStackView: UIStackView?
    
    //MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }
    
    
    //MARK: - Public Functions
    
    public func registerCellType<T: UICollectionViewCell>(_ cellClass: T.Type, withIdentifier identifier: String) {
        cellType = cellClass
        cellIdentifier = identifier
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func setSize(width: CGFloat, height: CGFloat, horizontalPadding: CGFloat = 0) {
        sizingConfig.width = width
        sizingConfig.height = height
        sizingConfig.horizontalPadding = horizontalPadding
    }
    
    public func setItemPadding(
        topPadding: CGFloat = 0,
        leadingPadding: CGFloat = 16,
        bottomPadding: CGFloat = 0,
        trailingPadding: CGFloat = 16,
        itemSpacing: CGFloat = 12
    ) {
        layoutConfig.update(
            top: topPadding,
            leading: leadingPadding,
            bottom: bottomPadding,
            trailing: trailingPadding,
            spacing: itemSpacing
        )
        setupUI()
    }
    
    public func setDynamicWidth(
        enabled: Bool,
        minWidth: CGFloat = 60,
        maxWidth: CGFloat = 200,
        horizontalPadding: CGFloat = 16
    ) {
        sizingConfig.useDynamicWidth = enabled
        sizingConfig.minWidth = minWidth
        sizingConfig.maxWidth = maxWidth
        sizingConfig.horizontalPadding = horizontalPadding
        setupUI()
    }
    
    public func selectCell(at indexPath: IndexPath) {
        deselectAllCells()
        if let cell = collectionView.cellForItem(at: indexPath) as? EDTSTabDefaultCellProtocol {
            cell.isSelectedState = true
        }
    }
    
    public func selectDefaultTab() {
        guard !data.isEmpty else { return }
        
        let firstIndexPath = IndexPath(item: 0, section: 0)
        currentlySelectedId = data[0].id
        previousSelectedIndex = 0 
        
        selectCell(at: firstIndexPath)
        scrollToItem(at: firstIndexPath, animated: false)
    }
    
    //MARK: - Private Functions
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        guard let views = bundle.loadNibNamed("TabDefault", owner: self, options: nil),
              let tab = views.first as? UIView else {
            assertionFailure("Failed to load TabDefault XIB from bundle: \(bundle)")
            return
        }
        
        containerView = tab
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(containerView)
        
        DispatchQueue.main.async { [weak self] in
            self?.setupUI()
        }
    }
    
    private func setupUI() {
        configureCollectionView()
        selectDefaultTab()
    }
    
    private func configureCollectionView() {
        let flowLayout = createFlowLayout()
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.decelerationRate = .normal
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = layoutConfig.itemSpacing
        layout.sectionInset = layoutConfig.edgeInsets
        
        if sizingConfig.useDynamicWidth {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        return layout
    }
    
    private func reloadData() {
        UIView.performWithoutAnimation { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func calculateDynamicWidth(
        for text: String,
        font: UIFont = .systemFont(ofSize: 14)
    ) -> CGFloat {
        let textSize = text.size(withAttributes: [.font: font])
        let calculatedWidth = textSize.width + sizingConfig.horizontalPadding
        
        return sizingConfig.setWidth(calculatedWidth)
    }
    
    private func deselectAllCells() {
        for index in data.indices {
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? EDTSTabDefaultCellProtocol {
                cell.isSelectedState = false
            }
        }
    }
    
    //MARK: - Skeleton
    
    private func updateSkeletonState() {
        setupSkeletonView()
        
        if isSkeleton {
            showSkeleton()
        } else {
            hideSkeleton()
        }
    }
    
    private func setupSkeletonView() {
        skeletonContainerView?.removeFromSuperview()
        
        let container = UIView()
        container.backgroundColor = bgColor ?? .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.isUserInteractionEnabled = false
        containerView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: collectionView.topAnchor),
            container.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = layoutConfig.itemSpacing
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: layoutConfig.topPadding),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: layoutConfig.leadingPadding),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -layoutConfig.bottomPadding)
        ])
        
        let skeletonWidth = sizingConfig.width > 0 ? sizingConfig.width : 57
        let skeletonHeight = sizingConfig.height > 0 ? sizingConfig.height : 24
        
        for _ in 0..<skeletonItemTotal {
            let skeletonView = EDTSSkeleton()
            skeletonView.translatesAutoresizingMaskIntoConstraints = false
            skeletonView.cornerRadius = 12.0
            
            NSLayoutConstraint.activate([
                skeletonView.widthAnchor.constraint(equalToConstant: skeletonWidth),
                skeletonView.heightAnchor.constraint(equalToConstant: skeletonHeight)
            ])
            
            stackView.addArrangedSubview(skeletonView)
            skeletonView.startShimmer()
        }
        
        skeletonContainerView = container
        skeletonStackView = stackView
    }
    
    private func showSkeleton() {
        collectionView.isHidden = true
        skeletonContainerView?.isHidden = false
        
        self.skeletonContainerView?.alpha = 1
        
        if let stackView = skeletonStackView {
            for case let skeleton as EDTSSkeleton in stackView.arrangedSubviews {
                skeleton.startShimmer()
            }
        }
    }
    
    private func hideSkeleton() {
        collectionView.isHidden = false
        
        if let stackView = skeletonStackView {
            for case let skeleton as EDTSSkeleton in stackView.arrangedSubviews {
                skeleton.stopShimmer()
            }
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.skeletonContainerView?.alpha = 0
        }) { _ in
            self.skeletonContainerView?.isHidden = true
        }
    }
    
    
    //MARK: - Animation
    
    private func scrollToItem(at indexPath: IndexPath, animated: Bool) {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let cellFrame = flowLayout.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
        let contentOffsetX = calculateCenteredOffset(for: cellFrame)
        
        collectionView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: animated)
    }
    
    private func calculateCenteredOffset(for cellFrame: CGRect) -> CGFloat {
        let targetOffset = cellFrame.midX - (collectionView.bounds.width / 2)
        let maxOffset = collectionView.contentSize.width - collectionView.bounds.width
        return max(0, min(targetOffset, maxOffset))
    }
}


//MARK: - Collection View

extension TabDefault: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return data.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        )
        
        if let tabCell = cell as? EDTSTabDefaultCellProtocol {
            let tabData = data[indexPath.item]
            let isSelected = (tabData.id == currentlySelectedId)
            
            tabCell.loadData(item: tabData)
            tabCell.isSelectedState = isSelected
            
            cellConfiguration?(cell, tabData, isSelected, indexPath.row)
        }
        
        return cell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard indexPath.item != previousSelectedIndex else { return }
        
        let isMovingRight = indexPath.item > previousSelectedIndex
        let isUsingTabDefaultCell = collectionView.cellForItem(at: indexPath) is TabDefaultCell
        
        if isUsingTabDefaultCell {
            if let cellOld = collectionView.cellForItem(at: IndexPath(item: previousSelectedIndex, section: 0)) as? EDTSTabDefaultCell {
                cellOld.isSelectedAfterItem = isMovingRight
                cellOld.isSelectedState = false
            }
            
            if let cellNew = collectionView.cellForItem(at: indexPath) as? EDTSTabDefaultCell {
                cellNew.isSelectedAfterItem = isMovingRight
                cellNew.isSelectedState = true
            }
            
            for index in data.indices where index != indexPath.item && index != previousSelectedIndex {
                let cellIndexPath = IndexPath(item: index, section: 0)
                if let cell = collectionView.cellForItem(at: cellIndexPath) as? EDTSTabDefaultCell {
                    cell.isSelectedState = false
                }
            }
        } else {
            deselectAllCells()
            selectCell(at: indexPath)
        }
        
        let selectedData = data[indexPath.item]
        currentlySelectedId = selectedData.id
        previousSelectedIndex = indexPath.item
        
        scrollToItem(at: indexPath, animated: true)
        delegate?.didSelectTabDefault(at: indexPath.item, withId: selectedData.id, cellIdentifier: cellIdentifier)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat
        
        if sizingConfig.useDynamicWidth {
            if cellIdentifier == "TabChipCell" {
                if indexPath.row == 0 {
                    width = 50
                } else if indexPath.row == 1 {
                    width = 34
                } else {
                    width = 54
                }
            } else {
                let displayText = data[indexPath.item].title
                width = calculateDynamicWidth(for: displayText)
            }
        } else {
            width = sizingConfig.width
        }
        
        return CGSize(width: width, height: sizingConfig.height)
    }
}

//MARK: - Models

private struct LayoutConfig {
    var itemSpacing: CGFloat = 12
    var topPadding: CGFloat = 0
    var leadingPadding: CGFloat = 16
    var bottomPadding: CGFloat = 0
    var trailingPadding: CGFloat = 16
    
    var edgeInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: topPadding,
            left: leadingPadding,
            bottom: bottomPadding,
            right: trailingPadding
        )
    }
    
    mutating func update(
        top: CGFloat,
        leading: CGFloat,
        bottom: CGFloat,
        trailing: CGFloat,
        spacing: CGFloat
    ) {
        self.topPadding = top
        self.leadingPadding = leading
        self.bottomPadding = bottom
        self.trailingPadding = trailing
        self.itemSpacing = spacing
    }
}

private struct SizingConfig {
    var width: CGFloat = 0
    var height: CGFloat = 0
    var useDynamicWidth: Bool = false
    var minWidth: CGFloat = 20
    var maxWidth: CGFloat = 200
    var horizontalPadding: CGFloat = 16
    
    func setWidth(_ width: CGFloat) -> CGFloat {
        max(minWidth, min(maxWidth, width))
    }
}

//MARK: - Protocols

@MainActor
public protocol EDTSTabDefaultDelegate: AnyObject {
    func didSelectTabDefault(at index: Int, withId id: String, cellIdentifier: String)
}

public protocol EDTSTabDefaultModelProtocol {
    var id: String { get }
    var title: String { get }
}

public protocol EDTSTabDefaultCellProtocol: UICollectionViewCell {
    func loadData(item: EDTSTabDefaultModelProtocol)
    var isSelectedState: Bool { get set }
}


