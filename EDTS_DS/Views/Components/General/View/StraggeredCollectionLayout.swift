//
//  StraggeredLayout.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 14/12/25.
//

import UIKit

public protocol StraggeredCollectionLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat
}

public class StraggeredCollectionLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    public weak var delegate: StraggeredCollectionLayoutDelegate?
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    public override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    private var numberOfColumns: Int = 2
    private var cellPadding: CGFloat = 6
    private var horizontalSpacing: CGFloat?
    private var verticalSpacing: CGFloat?
    
    // MARK: - Configuration
    public func configure(numberOfColumns: Int = 2,
                          cellPadding: CGFloat = 6,
                          horizontalSpacing: CGFloat? = nil,
                          verticalSpacing: CGFloat? = nil) {
        self.numberOfColumns = numberOfColumns
        self.cellPadding = cellPadding
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }
    
    // MARK: - Layout Calculation
    public override func prepare() {
        guard let collectionView = collectionView else { return }
        
        cache.removeAll()
        contentHeight = 0
        
        let inset = cellPadding
        let hGap = horizontalSpacing ?? cellPadding * 2
        let vGap = verticalSpacing ?? cellPadding * 2
        let columnCount = CGFloat(numberOfColumns)
        
        let columnWidth = (contentWidth - inset * 2 - hGap * (columnCount - 1)) / columnCount
        
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(inset + CGFloat(column) * (columnWidth + hGap))
        }
        
        var yOffset: [CGFloat] = .init(repeating: inset, count: numberOfColumns)
        var column = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let itemHeight = delegate?.collectionView(
                collectionView,
                heightForItemAt: indexPath,
                width: columnWidth
            ) ?? 300
            
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: itemHeight)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY + inset)
            yOffset[column] = frame.maxY + vGap
            
            column = yOffset.firstIndex(of: yOffset.min() ?? 0) ?? 0
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.item >= 0, indexPath.item < cache.count else {
            return nil
        }
        return cache[indexPath.item]
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return newBounds.width != collectionView.bounds.width
    }
}
