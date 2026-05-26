//
//  ScrollAnimation.swift
//  Poinku-DS-SB
//
//  Created by Rizka Ghinna Auliya on 18/02/25.
//

import UIKit

private var lastContentOffset: CGFloat = 0
private var visibleCellsBeforeScroll: [IndexPath: CGPoint] = [:]

public func animateScale(_ collectionView: UICollectionView, _ scrollView: UIScrollView) {
    let isScrollingDown = scrollView.contentOffset.y > lastContentOffset
    
    let visibleCells = collectionView.visibleCells
    for cell in visibleCells {
        guard let indexPath = collectionView.indexPath(for: cell) else { continue }
        
        if visibleCellsBeforeScroll[indexPath] == nil {
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            let translation = isScrollingDown ? CGAffineTransform(translationX: 0, y: 50) : CGAffineTransform(translationX: 0, y: -50)
            cell.transform = cell.transform.concatenating(translation)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                cell.transform = .identity
            }
        }
        
        visibleCellsBeforeScroll[indexPath] = cell.center
    }
    
    visibleCellsBeforeScroll = visibleCellsBeforeScroll.filter { indexPath, _ in
        collectionView.indexPathsForVisibleItems.contains(indexPath)
    }
    
    lastContentOffset = scrollView.contentOffset.y
}

public func animateFade(_ collectionView: UICollectionView, _ scrollView: UIScrollView) {
    let visibleCells = collectionView.visibleCells
    for cell in visibleCells {
        guard let indexPath = collectionView.indexPath(for: cell) else { continue }
        
        if visibleCellsBeforeScroll[indexPath] == nil {
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                cell.transform = .identity
                cell.alpha = 1
            }
        }
        
        visibleCellsBeforeScroll[indexPath] = cell.center
    }
    
    visibleCellsBeforeScroll = visibleCellsBeforeScroll.filter { indexPath, _ in
        collectionView.indexPathsForVisibleItems.contains(indexPath)
    }
    
    lastContentOffset = scrollView.contentOffset.y
}
