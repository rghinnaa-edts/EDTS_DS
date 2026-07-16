//
//  RadioGroup.swift
//  KlikIDM_DS
//
//  Created by Yovita Handayiani on 09/03/26.
//

import UIKit

public enum ItemDisplayMode {
    case vertical
    case horizontal
    case spanGrid(Int)
    
    var numberOfColumns: Int {
        switch self {
        case .vertical:
            return 1
        case .horizontal:
            return 1
        case .spanGrid(let value):
            return value
        }
    }
}

@IBDesignable
public class EDTSRadioGroup: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EDTSRadioButtonDelegate {
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    public var data: [[String]] = [] {
        didSet {
            guard !data.isEmpty else { return }
            dataAttributed = []
            invalidateCellHeight()
            collectionView.reloadData()
            invalidateIntrinsicContentSize()
        }
    }
    
    public var dataAttributed: [[NSAttributedString]] = [] {
        didSet {
            guard !dataAttributed.isEmpty else { return }
            data = []
            invalidateCellHeight()
            collectionView.reloadData()
            invalidateIntrinsicContentSize()
        }
    }
    
    public var selectedIndex: Int {
        get { _selectedIndex }
        set {
            guard _selectedIndex != newValue else { return }
            let oldValue = _selectedIndex
            _selectedIndex = newValue
            
            var toReload: [IndexPath] = []
            if oldValue >= 0 { toReload.append(IndexPath(row: oldValue, section: 0)) }
            if newValue >= 0 { toReload.append(IndexPath(row: newValue, section: 0)) }
            collectionView.reloadItems(at: toReload)
        }
    }
    
    public var displayMode: ItemDisplayMode = .vertical {
        didSet {
            invalidateCellHeight()
            setupLayout()
            collectionView.reloadData()
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable public var horizontalSpacing: Int = 8 {
        didSet{
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            layout.minimumInteritemSpacing = CGFloat(horizontalSpacing)
            invalidateCellHeight()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    @IBInspectable public var verticalSpacing: Int = 8 {
        didSet{
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            layout.minimumLineSpacing = CGFloat(verticalSpacing)
            invalidateCellHeight()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    @IBInspectable public var paddingTop: CGFloat = CGFloat.zero {
        didSet {
            setupLayout()
        }
    }
    
    @IBInspectable public var paddingBottom: CGFloat = CGFloat.zero {
        didSet {
            setupLayout()
        }
    }
    
    @IBInspectable public var paddingLeading: CGFloat = CGFloat.zero {
        didSet {
            setupLayout()
        }
    }
    
    @IBInspectable public var paddingTrailing: CGFloat = CGFloat.zero {
        didSet {
            setupLayout()
        }
    }
    
    // MARK: - Private Variable
    private lazy var sizingCell: EDTSRadioButtonCell = EDTSRadioButtonCell.instantiateForSizing()
    private var radioButtonConfigurator: ((EDTSRadioButton) -> Void)?
    private var _selectedIndex: Int = -1
    
    private var tempMaxItemHeight: CGFloat?
    private var tempItemHeights: [CGFloat]?
    private var tempRowHeights: [CGFloat]?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }

    public override var intrinsicContentSize: CGSize {
        switch displayMode {
        case .horizontal:
            guard !data.isEmpty || !dataAttributed.isEmpty else {
                return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
            }
            let height = maxItemHeight(forWidth: UIScreen.main.bounds.width)
            return CGSize(width: UIView.noIntrinsicMetric, height: height + paddingTop + paddingBottom)

        case .vertical:
            guard !data.isEmpty || !dataAttributed.isEmpty else {
                return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
            }
            let count = dataAttributed.isEmpty ? data.count : dataAttributed.count
            let itemWidth = bounds.width - paddingLeading - paddingTrailing
            guard itemWidth > 0, count > 0 else {
                return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
            }
            let heights = itemHeights(forWidth: itemWidth)
            let totalItemHeight = heights.reduce(0, +)
            let totalSpacing = CGFloat(verticalSpacing) * CGFloat(count - 1)
            let totalHeight = totalItemHeight + totalSpacing + paddingTop + paddingBottom
            return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)

        case .spanGrid(let columns):
            guard !data.isEmpty || !dataAttributed.isEmpty else {
                return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
            }
            let count = dataAttributed.isEmpty ? data.count : dataAttributed.count
            let cols = max(1, columns)
            let totalHSpacing = CGFloat(horizontalSpacing) * CGFloat(cols - 1)
            let itemWidth = floor((bounds.width - paddingLeading - paddingTrailing - totalHSpacing) / CGFloat(cols))
            guard itemWidth > 0, count > 0 else {
                return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
            }
            let heights = rowHeights(forWidth: itemWidth, columns: cols)
            let totalItemHeight = heights.reduce(0, +)
            let totalSpacing = CGFloat(verticalSpacing) * CGFloat(max(heights.count - 1, 0))
            let totalHeight = totalItemHeight + totalSpacing + paddingTop + paddingBottom
            return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
        }
    }
    
    // MARK: - Public Function
    public func configureRadioButton(_ instance: @escaping (EDTSRadioButton) -> Void) {
        radioButtonConfigurator = instance
        invalidateCellHeight()
        collectionView.reloadData()
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    // MARK: - Setup & Styling
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSRadioGroup", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        
        setupUI()
    }
    
    private func setupUI() {
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delaysContentTouches = false
        collectionView.canCancelContentTouches = true
        collectionView.isScrollEnabled = true
        
        let nib = UINib(nibName: "EDTSRadioButtonCell", bundle: Bundle(for: EDTSRadioButtonCell.self))
        collectionView.register(nib, forCellWithReuseIdentifier: "EDTSRadioButtonCell")
        
        setupLayout()
    }
    
    private func setupLayout() {
        let layout: UICollectionViewFlowLayout = {
               switch displayMode {
               case .vertical:
                   let leftLayout = LeftAlignedFlowLayout()
                   leftLayout.mode = .vertical
                   return leftLayout
               case .horizontal:
                   return UICollectionViewFlowLayout()
               case .spanGrid(let columns):
                   let gridLayout = LeftAlignedFlowLayout()
                   gridLayout.mode = .grid(columns: columns)
                   return gridLayout
               }
           }()
        layout.minimumInteritemSpacing = CGFloat(horizontalSpacing)
        layout.minimumLineSpacing = CGFloat(verticalSpacing)
        layout.sectionInset = .init(top: paddingTop, left: paddingLeading, bottom: paddingBottom, right: paddingTrailing)
        layout.estimatedItemSize = .zero

        switch displayMode {
        case .vertical:
            layout.scrollDirection = .vertical

        case .horizontal:
            layout.scrollDirection = .horizontal

        case .spanGrid:
            layout.scrollDirection = .vertical
        }
        
        collectionView.collectionViewLayout = layout
        invalidateIntrinsicContentSize()
    }

    private func setupCellSize(for indexPath: IndexPath, width: CGFloat, isHorizontal: Bool = false) -> CGSize {
        if !dataAttributed.isEmpty {
            sizingCell.setDataAttribute(
                title: dataAttributed[indexPath.row][0],
                description: dataAttributed[indexPath.row][1]
            )
        } else {
            sizingCell.setData(
                title: data[indexPath.row][0],
                description: data[indexPath.row][1]
            )
        }
        
        if let configurator = radioButtonConfigurator {
            configurator(sizingCell.radioButtonItem)
        }
        
        sizingCell.radioButtonItem.setNeedsLayout()
        sizingCell.radioButtonItem.layoutIfNeeded()
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let fittedSize = sizingCell.contentView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: isHorizontal ? .fittingSizeLevel : .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return CGSize(width: ceil(fittedSize.width), height: ceil(fittedSize.height))
    }
    
    private func invalidateCellHeight() {
        tempMaxItemHeight = nil
        tempItemHeights = nil
        tempRowHeights = nil
    }

    private func isItemEmpty(at indexPath: IndexPath) -> Bool {
        if !dataAttributed.isEmpty {
            let title = dataAttributed[indexPath.row][0].string
            let desc = dataAttributed[indexPath.row][1].string
            return title.isEmpty && desc.isEmpty
        } else if !data.isEmpty {
            let title = data[indexPath.row][0]
            let desc = data[indexPath.row][1]
            return title.isEmpty && desc.isEmpty
        }
        return false
    }

    private func maxItemHeight(forWidth width: CGFloat) -> CGFloat {
        if let temp = tempMaxItemHeight { return temp }
        let count = dataAttributed.isEmpty ? data.count : dataAttributed.count
        guard count > 0 else { return 0 }
        var maxHeight: CGFloat = 0
        for row in 0..<count {
            let size = setupCellSize(for: IndexPath(row: row, section: 0), width: width, isHorizontal: true)
            maxHeight = max(maxHeight, size.height)
        }
        tempMaxItemHeight = maxHeight
        return maxHeight
    }

    private func itemHeights(forWidth width: CGFloat) -> [CGFloat] {
        if let temp = tempItemHeights { return temp }
        let count = dataAttributed.isEmpty ? data.count : dataAttributed.count
        guard count > 0 else { return [] }
        var heights: [CGFloat] = []
        heights.reserveCapacity(count)
        for row in 0..<count {
            let indexPath = IndexPath(row: row, section: 0)
            let size = isItemEmpty(at: indexPath)
                ? setupCellSize(for: indexPath, width: width, isHorizontal: true)
                : setupCellSize(for: indexPath, width: width)
            heights.append(size.height)
        }
        tempItemHeights = heights
        return heights
    }

    private func rowHeights(forWidth itemWidth: CGFloat, columns: Int) -> [CGFloat] {
        if let temp = tempRowHeights { return temp }
        let count = dataAttributed.isEmpty ? data.count : dataAttributed.count
        guard count > 0 else { return [] }
        let cols = max(1, columns)
        var heights: [CGFloat] = []
        var index = 0
        while index < count {
            let end = min(index + cols, count)
            var rowMax: CGFloat = 0
            for row in index..<end {
                let indexPath = IndexPath(row: row, section: 0)
                let size = isItemEmpty(at: indexPath)
                    ? setupCellSize(for: indexPath, width: itemWidth, isHorizontal: true)
                    : setupCellSize(for: indexPath, width: itemWidth)
                rowMax = max(rowMax, size.height)
            }
            heights.append(rowMax)
            index = end
        }
        tempRowHeights = heights
        return heights
    }
    
    // MARK: - Radio Button Protocol
    public func didSelectRadioButton(_ radioButton: EDTSRadioButton) {
        guard !radioButton.isActive else { return }
        
        for cell in collectionView.visibleCells.compactMap({ $0 as? EDTSRadioButtonCell }) {
            if cell.radioButtonItem === radioButton,
               let indexPath = collectionView.indexPath(for: cell) {
                                
                if _selectedIndex >= 0,
                   let previousCell = collectionView.cellForItem(
                       at: IndexPath(row: _selectedIndex, section: 0)
                   ) as? EDTSRadioButtonCell {
                    previousCell.radioButtonItem.isActive = false
                }
                
                cell.radioButtonItem.isActive = true
                _selectedIndex = indexPath.row
            }
        }
    }
    
    // MARK: - Collection View Protocol
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataAttributed.isEmpty ? data.count : dataAttributed.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "EDTSRadioButtonCell",
            for: indexPath
        ) as? EDTSRadioButtonCell else {
            return UICollectionViewCell()
        }
        
        if !dataAttributed.isEmpty {
            cell.setDataAttribute(
                title: dataAttributed[indexPath.row][0],
                description: dataAttributed[indexPath.row][1]
            )
        } else {
            cell.setData(
                title: data[indexPath.row][0],
                description: data[indexPath.row][1]
            )
        }
        
        cell.setDelegate(self)
        cell.radioButtonItem.isActive = (indexPath.row == selectedIndex)
        
        if let configurator = radioButtonConfigurator {
            configurator(cell.radioButtonItem)
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let insets = flowLayout.sectionInset
        
        switch displayMode {
        case .vertical:
            let rowWidth = collectionView.bounds.width - insets.left - insets.right
            let heights = itemHeights(forWidth: rowWidth)
            let width = isItemEmpty(at: indexPath)
                ? setupCellSize(for: indexPath, width: rowWidth, isHorizontal: true).width
                : rowWidth
            return CGSize(width: width, height: heights[indexPath.row])
            
        case .horizontal:
            let size = setupCellSize(for: indexPath, width: UIScreen.main.bounds.width, isHorizontal: true)
            return CGSize(width: size.width, height: maxItemHeight(forWidth: UIScreen.main.bounds.width))
            
        case .spanGrid(let columns):
            let cols = max(1, columns)
            let totalSpacing = flowLayout.minimumInteritemSpacing * CGFloat(cols - 1)
            let colWidth = floor((collectionView.bounds.width - insets.left - insets.right - totalSpacing) / CGFloat(cols))
            let heights = rowHeights(forWidth: colWidth, columns: cols)
            let rowIndex = indexPath.row / cols
            let width = isItemEmpty(at: indexPath)
                ? setupCellSize(for: indexPath, width: colWidth, isHorizontal: true).width
                : colWidth
            return CGSize(width: width, height: heights[rowIndex])
        }
    }
}
