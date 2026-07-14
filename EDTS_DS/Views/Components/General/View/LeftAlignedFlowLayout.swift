//
//  Untitled.swift
//  EDTS_DS
//
//  Created by Yovita Handayiani on 14/07/26.
//

import UIKit

public class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
    enum Mode {
        case vertical
        case grid(columns: Int)
    }
    
    var mode: Mode = .vertical
    
    private var tempAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    override public func prepare() {
        super.prepare()
        
        switch mode {
        case .vertical:
            break
        case .grid(let columns):
            computeGridAttributes(columns: columns)
        }
    }
    
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
    
    private func sizeForItem(at indexPath: IndexPath, columnWidth: CGFloat) -> CGSize {
        guard let collectionView = collectionView,
              let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
            return CGSize(width: columnWidth, height: 0)
        }
        return delegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath)
            ?? CGSize(width: columnWidth, height: 0)
    }
    
    override public var collectionViewContentSize: CGSize {
        switch mode {
        case .vertical:
            return super.collectionViewContentSize
        case .grid:
            guard let collectionView = collectionView else { return .zero }
            return CGSize(width: collectionView.bounds.width, height: contentHeight)
        }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        switch mode {
        case .vertical:
            guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
            
            var leftMargin = sectionInset.left
            var maxY: CGFloat = -1.0
            
            for layoutAttribute in attributes where layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
            
            return attributes
        case .grid:
            return tempAttributes.filter { $0.frame.intersects(rect) }
        }
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch mode {
        case .vertical:
            return super.layoutAttributesForItem(at: indexPath)
        case .grid:
            return tempAttributes.first { $0.indexPath == indexPath }
        }
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return newBounds.width != collectionView.bounds.width
    }
}
