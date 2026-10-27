//
//  EDTSCardPromoSkeletonCell.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 14/10/26.
//

import UIKit

class EDTSCardPromoSkeletonCell: UICollectionViewCell {

    static let identifier = "EDTSCardPromoSkeletonCell"

    private static let cornerRadius: CGFloat = 12
    private static let padding: CGFloat = 12
    private static let spacing: CGFloat = 12
    private static let titleHeight: CGFloat = 16
    private static let bannerHeight: CGFloat = 112
    private static let productWidth: CGFloat = 216
    private static let productHeight: CGFloat = 80
    private static let productSpacing: CGFloat = 8
    private static let infoboxHeight: CGFloat = 40

    static let height: CGFloat =
        padding * 2 + spacing * 3 + titleHeight + bannerHeight + productHeight + infoboxHeight

    private let skeletonTitle = EDTSSkeleton()
    private let skeletonBanner = EDTSSkeleton()
    private let skeletonProduct1 = EDTSSkeleton()
    private let skeletonProduct2 = EDTSSkeleton()
    private let skeletonInfobox = EDTSSkeleton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Self.cornerRadius).cgPath
    }

    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.size = CGSize(width: layoutAttributes.size.width, height: Self.height)
        return attributes
    }

    private func setupUI() {
        setupCardAppearance()
        setupLayout()
    }

    private func setupCardAppearance() {
        backgroundColor = .clear
        clipsToBounds = false

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Self.cornerRadius
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6
        layer.masksToBounds = false
    }

    private func setupLayout() {
        [skeletonTitle, skeletonBanner, skeletonProduct1, skeletonProduct2, skeletonInfobox].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
            $0.cornerRadius = 4
        }

        let padding = Self.padding
        let spacing = Self.spacing

        NSLayoutConstraint.activate([
            skeletonTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            skeletonTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            skeletonTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            skeletonTitle.heightAnchor.constraint(equalToConstant: Self.titleHeight),

            skeletonBanner.topAnchor.constraint(equalTo: skeletonTitle.bottomAnchor, constant: spacing),
            skeletonBanner.leadingAnchor.constraint(equalTo: skeletonTitle.leadingAnchor),
            skeletonBanner.trailingAnchor.constraint(equalTo: skeletonTitle.trailingAnchor),
            skeletonBanner.heightAnchor.constraint(equalToConstant: Self.bannerHeight),

            skeletonProduct1.topAnchor.constraint(equalTo: skeletonBanner.bottomAnchor, constant: spacing),
            skeletonProduct1.leadingAnchor.constraint(equalTo: skeletonTitle.leadingAnchor),
            skeletonProduct1.widthAnchor.constraint(equalToConstant: Self.productWidth),
            skeletonProduct1.heightAnchor.constraint(equalToConstant: Self.productHeight),

            skeletonProduct2.topAnchor.constraint(equalTo: skeletonProduct1.topAnchor),
            skeletonProduct2.leadingAnchor.constraint(equalTo: skeletonProduct1.trailingAnchor, constant: Self.productSpacing),
            skeletonProduct2.widthAnchor.constraint(equalToConstant: Self.productWidth),
            skeletonProduct2.heightAnchor.constraint(equalToConstant: Self.productHeight),

            skeletonInfobox.topAnchor.constraint(equalTo: skeletonProduct1.bottomAnchor, constant: spacing),
            skeletonInfobox.leadingAnchor.constraint(equalTo: skeletonTitle.leadingAnchor),
            skeletonInfobox.trailingAnchor.constraint(equalTo: skeletonTitle.trailingAnchor),
            skeletonInfobox.heightAnchor.constraint(equalToConstant: Self.infoboxHeight),
            skeletonInfobox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}
