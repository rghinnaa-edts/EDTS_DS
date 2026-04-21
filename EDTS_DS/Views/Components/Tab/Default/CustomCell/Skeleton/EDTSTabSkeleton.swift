//
//  TabSkeleton.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 05/02/26.
//

import UIKit

public class EDTSTabSkeleton: UICollectionViewCell {
    
    private var containerView = UIView()
    private var skeletonView = EDTSSkeleton()
    
    private var containerWidthConstraint: NSLayoutConstraint?
    private var containerHeightConstraint: NSLayoutConstraint?
    
    public var width: CGFloat = 0.0 {
        didSet {
            updateContainerSize()
        }
    }
    
    public var height: CGFloat = 0.0 {
        didSet {
            updateContainerSize()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        createUI()
        setupConstraints()
    }
    
    private func createUI() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        skeletonView.translatesAutoresizingMaskIntoConstraints = false
        skeletonView.cornerRadius = 12.0
        containerView.addSubview(skeletonView)
    }
    
    private func setupConstraints() {
        containerWidthConstraint = containerView.widthAnchor.constraint(equalToConstant: 57)
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 24)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerWidthConstraint!,
            containerHeightConstraint!
        ])
        
        NSLayoutConstraint.activate([
            skeletonView.topAnchor.constraint(equalTo: containerView.topAnchor),
            skeletonView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            skeletonView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            skeletonView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func updateContainerSize() {
        containerWidthConstraint?.constant = width
        containerHeightConstraint?.constant = height
        layoutIfNeeded()
    }
    
    public func showSkeleton() {
        skeletonView.isHidden = false
        skeletonView.startShimmer()
    }
    
    public func hideSkeleton() {
        skeletonView.stopShimmer()
        skeletonView.isHidden = true
    }
}
