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
            collectionView.reloadData()
            invalidateIntrinsicContentSize()
        }
    }
    
    public var dataAttributed: [[NSAttributedString]] = [] {
        didSet {
            guard !dataAttributed.isEmpty else { return }
            data = []
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
            setupLayout()
            collectionView.reloadData()
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable public var horizontalSpacing: Int = 8 {
        didSet{
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            layout.minimumInteritemSpacing = CGFloat(horizontalSpacing)
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    @IBInspectable public var verticalSpacing: Int = 8 {
        didSet{
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            layout.minimumLineSpacing = CGFloat(verticalSpacing)
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
    private var radioButtonConfigurator: ((EDTSRadioButton) -> Void)?
    private var _selectedIndex: Int = -1
    
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
            let size = setupCellSize(for: IndexPath(row: 0, section: 0), width: UIScreen.main.bounds.width, isHorizontal: true)
            return CGSize(width: UIView.noIntrinsicMetric, height: size.height + paddingTop + paddingBottom)

        case .vertical:
            guard !data.isEmpty || !dataAttributed.isEmpty else {
                return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
            }
            let count = dataAttributed.isEmpty ? data.count : dataAttributed.count
            let itemWidth = bounds.width - paddingLeading - paddingTrailing
            guard itemWidth > 0, count > 0 else {
                return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
            }
            let itemHeight = setupCellSize(for: IndexPath(row: 0, section: 0), width: itemWidth).height
            let totalSpacing = CGFloat(verticalSpacing) * CGFloat(count - 1)
            let totalHeight = (itemHeight * CGFloat(count)) + totalSpacing + paddingTop + paddingBottom
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
            let itemHeight = setupCellSize(for: IndexPath(row: 0, section: 0), width: itemWidth).height
            let rows = Int(ceil(Double(count) / Double(cols)))
            let totalSpacing = CGFloat(verticalSpacing) * CGFloat(rows - 1)
            let totalHeight = (itemHeight * CGFloat(rows)) + totalSpacing + paddingTop + paddingBottom
            return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
        }
    }
    
    // MARK: - Public Function
    public func configureRadioButton(_ instance: @escaping (EDTSRadioButton) -> Void) {
        radioButtonConfigurator = instance
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
        let layout = UICollectionViewFlowLayout()
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
        let sizingCell = EDTSRadioButtonCell.instantiateForSizing()
        
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
        
        let rbIntrinsic = sizingCell.radioButtonItem.intrinsicContentSize
        
        let fittedSize = sizingCell.contentView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: isHorizontal ? .fittingSizeLevel : .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return CGSize(width: ceil(fittedSize.width), height: ceil(fittedSize.height))
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
            let itemWidth = collectionView.bounds.width - insets.left - insets.right
            return setupCellSize(for: indexPath, width: itemWidth)
            
        case .horizontal:
            return setupCellSize(for: indexPath, width: UIScreen.main.bounds.width, isHorizontal: true)
            
        case .spanGrid(let columns):
            let cols = max(1, columns)
            let totalSpacing = flowLayout.minimumInteritemSpacing * CGFloat(cols - 1)
            let itemWidth = floor((collectionView.bounds.width - insets.left - insets.right - totalSpacing) / CGFloat(cols))
            return setupCellSize(for: indexPath, width: itemWidth)
        }
    }
}
