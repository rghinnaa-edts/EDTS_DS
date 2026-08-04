//
//  Untitled.swift
//  EDTS_DS
//
//  Created by Yovita Handayiani on 14/07/26.
//

import UIKit

public enum Mode {
    case vertical
    case horizontal
    case grid(columns: Int)
}

public class EDTSFlowLayout: UICollectionViewFlowLayout {
    // MARK: - Public Variable
    public var mode: Mode = .vertical {
        didSet {
            switch mode {
            case .vertical, .grid:
                scrollDirection = .vertical
            case .horizontal:
                scrollDirection = .horizontal
            }
            invalidateLayout()
        }
    }
    
    // MARK: - Private Variable
    private var tempAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat = 0
    
    // MARK: - Public Function
    override public func prepare() {
        super.prepare()
        
        switch mode {
        case .vertical:
            computeGridAttributes(columns: 1)
        case .horizontal:
            computeHorizontalAttributes()
        case .grid(let columns):
            computeGridAttributes(columns: columns)
        }
    }
    
    override public var collectionViewContentSize: CGSize {
        switch mode {
        case .vertical, .grid:
            guard let collectionView = collectionView else { return .zero }
            return CGSize(width: collectionView.bounds.width, height: contentHeight)
        case .horizontal:
            guard let collectionView = collectionView else { return .zero }
            return CGSize(width: contentWidth, height: collectionView.bounds.height)
        }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        tempAttributes.filter { $0.frame.intersects(rect) }
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        tempAttributes.first { $0.indexPath == indexPath }
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        switch mode {
        case .horizontal:
            return newBounds.height != collectionView.bounds.height
        case .vertical, .grid:
            return newBounds.width != collectionView.bounds.width
        }
    }
    
    // MARK: - Private Function
    private func computeGridAttributes(columns: Int) {
        guard let collectionView = collectionView else { return }
        
        tempAttributes.removeAll()
        let cols = max(1, columns)
        let insets = sectionInset
        let hSpacing = minimumInteritemSpacing
        let vSpacing = minimumLineSpacing
        let availableWidth = collectionView.bounds.width - insets.left - insets.right
        let totalHSpacing = hSpacing * CGFloat(cols - 1)
        let columnWidth = floor((availableWidth - totalHSpacing) / CGFloat(cols))
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        var rowMaxHeight: CGFloat = 0
        var y: CGFloat = insets.top
        
        for index in 0..<itemCount {
            let indexPath = IndexPath(item: index, section: 0)
            let column = index % cols
            
            if column == 0 && index != 0 {
                y += rowMaxHeight + vSpacing
                rowMaxHeight = 0
            }
            
            let itemSize = sizeForItem(at: indexPath, columnWidth: columnWidth)
            let x = insets.left + CGFloat(column) * (columnWidth + hSpacing)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            tempAttributes.append(attributes)
            
            rowMaxHeight = max(rowMaxHeight, itemSize.height)
        }
        
        contentHeight = y + rowMaxHeight + insets.bottom
    }
    
    private func computeHorizontalAttributes() {
        guard let collectionView = collectionView else { return }
        
        tempAttributes.removeAll()
        let insets = sectionInset
        let itemSpacing = minimumInteritemSpacing
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        var x: CGFloat = insets.left
        
        for index in 0..<itemCount {
            let indexPath = IndexPath(item: index, section: 0)
            let itemSize = sizeForItem(at: indexPath, columnWidth: 0)
            let y = insets.top
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            tempAttributes.append(attributes)
            
            x += itemSize.width + itemSpacing
        }
        
        contentWidth = itemCount > 0 ? (x - itemSpacing + insets.right) : insets.left + insets.right
    }
    
    private func sizeForItem(at indexPath: IndexPath, columnWidth: CGFloat) -> CGSize {
        guard let collectionView = collectionView,
              let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
            return CGSize(width: columnWidth, height: 0)
        }
        return delegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath)
        ?? CGSize(width: columnWidth, height: 0)
    }
}
