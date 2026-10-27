//
//  EDTSCardPromoCell.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 22/10/26.
//

import UIKit

// MARK: - Cell

public class EDTSCardPromoCell: UICollectionViewCell {

    public static let identifier = "EDTSCardPromoCell"

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivBanner: UIImageView!
    @IBOutlet weak var collectionProduct: UICollectionView!
    @IBOutlet weak var infoBox: EDTSAlertbox!

    // MARK: - Private Variable

    private static let cornerRadius: CGFloat = 8
    private static let horizontalInset: CGFloat = 12
    private static let productSpacing: CGFloat = 8
    private static let minProductListHeight: CGFloat = 80
    private var arePromoProductsAvailable = true
    private var productItemHeight: CGFloat = EDTSCardPromoCell.minProductListHeight

    // MARK: - Public Variable

    public private(set) var products: [EDTSCardPromoProductModel] = []
    public var onProductsChanged: (([EDTSCardPromoProductModel]) -> Void)?
    public var onTap: (() -> Void)?

    // MARK: - Dynamic height

    public static func productListHeight(for products: [EDTSCardPromoProductModel]) -> CGFloat {
        let heights = products.map {
            EDTSCardPromoProductCell.height(
                image: $0.image,
                title: $0.title,
                price: $0.price,
                realPrice: $0.realPrice,
                discountPercent: $0.discountPercent
            )
        }
        return max(heights.max() ?? 0, minProductListHeight)
    }

    public static func titleHeight(for title: String, cardWidth: CGFloat) -> CGFloat {
        let availableWidth = max(cardWidth - 24, 0)

        let boundingBox = (title as NSString).boundingRect(
            with: CGSize(width: availableWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: EDTSFont.H2.font],
            context: nil
        )
        return ceil(boundingBox.height)
    }

    public static func height(for card: EDTSCardPromoModel, width: CGFloat) -> CGFloat {
        let titleHeight = titleHeight(for: card.title, cardWidth: width)
        let bannerHeight = (width - 24) * 112 / 312
        let productListHeight = productListHeight(for: card.products)

        let alertbox = EDTSAlertbox()
        alertbox.paddingTop = 12
        alertbox.paddingBottom = 12
        alertbox.isBtnAtRightSide = true
        alertbox.isBtnCloseHide = true
        alertbox.state = card.info.state.rawValue
        alertbox.labelAttributed = card.info.description
        alertbox.btnLabel = card.info.buttonText

        let alertboxHeight = alertbox.fittingHeightAlertbox(for: width - 24)

        let staticCellPadding: CGFloat = 60

        return ceil(staticCellPadding + titleHeight + bannerHeight + productListHeight + alertboxHeight)
    }

    // MARK: - Configure

    public func configure(with card: EDTSCardPromoModel) {
        let info = card.info
        configure(
            isAvailable: card.isAvailable,
            isProductAvailable: card.isProductAvailable,
            title: card.title,
            banner: card.banner,
            infoState: info.state,
            infoIcon: info.icon,
            infoDescription: info.description,
            infoButtonText: info.buttonText,
            infoAccentColor: info.accentColor,
            infoBackgroundColor: info.backgroundColor,
            products: card.products
        )
    }

    public func configure(
        isAvailable: Bool,
        isProductAvailable: Bool,
        title: String,
        banner: UIImage?,
        infoState: EDTSAlertboxState,
        infoIcon: UIImage?,
        infoDescription: NSAttributedString,
        infoButtonText: String,
        infoAccentColor: UIColor? = nil,
        infoBackgroundColor: UIColor? = nil,
        products: [EDTSCardPromoProductModel]
    ) {
        ivBanner.applyGrayscale(!isAvailable)
        arePromoProductsAvailable = isAvailable && isProductAvailable

        lblTitle.text = title
        ivBanner.image = banner

        infoBox.state = infoState.rawValue
        if infoIcon != nil {
            infoBox.icon = infoIcon
        }
        infoBox.labelAttributed = infoDescription
        infoBox.btnLabel = infoButtonText
        if let background = infoBackgroundColor {
            infoBox.bgColor = background
        }
        if let accent = infoAccentColor {
            infoBox.iconTintColor = accent
            infoBox.configureButton {
                $0.labelColor = accent
                $0.labelFocusColor = accent
                $0.iconTintColorTrailing = accent
                $0.iconFocusTintColorTrailing = accent
            }
        }

        configure(products: products)
    }

    public func configure(products: [EDTSCardPromoProductModel]) {
        self.products = products

        productItemHeight = Self.productListHeight(for: products)
        if let heightConstraint = collectionProduct.constraints.first(where: { $0.firstAttribute == .height && $0.secondItem == nil }) {
            heightConstraint.constant = productItemHeight
        }
        collectionProduct.collectionViewLayout.invalidateLayout()
        collectionProduct.indexPathsForSelectedItems?.forEach {
            collectionProduct.deselectItem(at: $0, animated: false)
        }

        collectionProduct.reloadData()
        collectionProduct.setContentOffset(
            CGPoint(x: -collectionProduct.contentInset.left, y: 0),
            animated: false
        )
        setNeedsLayout()
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

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Self.cornerRadius).cgPath
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        ivBanner.image = nil
        ivBanner.applyGrayscale(false)
        onProductsChanged = nil
        onTap = nil
        arePromoProductsAvailable = true

        collectionProduct.indexPathsForSelectedItems?.forEach {
            collectionProduct.deselectItem(at: $0, animated: false)
        }
        products = []
        collectionProduct.reloadData()
        collectionProduct.setContentOffset(
            CGPoint(x: -collectionProduct.contentInset.left, y: 0),
            animated: false
        )
    }

    // MARK: - Setup

    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSCardPromoCell", owner: self, options: nil),
           let view = nib.first as? UIView {

            containerView = view
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = .clear

            // Add to contentView and pin on all sides so the card's width/height
            // come from the cell, not from a stale frame.
            contentView.addSubview(containerView)
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])

            setupUI()
        }
    }

    private func setupUI() {
        lblTitle.font = EDTSFont.H2.font
        lblTitle.textColor = EDTSColor.grey70
        lblTitle.numberOfLines = 0

        setupCardAppearance()
        setupProductCollection()
        setupInfobox()
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

    private func setupInfobox() {
        infoBox.isBtnCloseHide = true
        infoBox.isBtnAtRightSide = true
        infoBox.borderWidth = 0
        infoBox.delegate = self
    }

    private func setupProductCollection() {
        collectionProduct.register(
            EDTSCardPromoProductCell.self,
            forCellWithReuseIdentifier: EDTSCardPromoProductCell.identifier
        )
        collectionProduct.dataSource = self
        collectionProduct.delegate = self
        collectionProduct.allowsSelection = true
        collectionProduct.allowsMultipleSelection = true
        collectionProduct.showsHorizontalScrollIndicator = false
        collectionProduct.backgroundColor = .clear
        collectionProduct.contentInsetAdjustmentBehavior = .never
        collectionProduct.contentInset = UIEdgeInsets(
            top: 0,
            left: Self.horizontalInset,
            bottom: 0,
            right: Self.horizontalInset
        )

        let tap = UITapGestureRecognizer(target: self, action: #selector(productListTapped))
        tap.cancelsTouchesInView = false
        collectionProduct.addGestureRecognizer(tap)

        if let layout = collectionProduct.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = .zero
            layout.itemSize = CGSize(width: EDTSCardPromoProductCell.itemWidth, height: productItemHeight)
            layout.minimumLineSpacing = Self.productSpacing
            layout.minimumInteritemSpacing = Self.productSpacing
        }
    }

    @objc private func productListTapped() {
        onTap?()
    }
}

// MARK: - UICollectionViewDataSource

extension EDTSCardPromoCell: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EDTSCardPromoProductCell.identifier,
            for: indexPath
        ) as? EDTSCardPromoProductCell else {
            return UICollectionViewCell()
        }

        let product = products[indexPath.item]
        cell.configure(
            isAvailable: product.isAvailable && arePromoProductsAvailable,
            image: product.image,
            title: product.title,
            price: product.price,
            realPrice: product.realPrice,
            discountPercent: product.discountPercent
        )

        if product.isSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        cell.isSelected = product.isSelected

        return cell
    }
}

// MARK: - UICollectionViewDelegate & FlowLayout

extension EDTSCardPromoCell: UICollectionViewDelegateFlowLayout {

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: EDTSCardPromoProductCell.itemWidth, height: productItemHeight)
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool { false }

    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool { false }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        products[indexPath.item].isSelected = true
        onProductsChanged?(products)
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard products.indices.contains(indexPath.item) else { return }
        products[indexPath.item].isSelected = false
        onProductsChanged?(products)
    }
}

// MARK: - EDTSAlertboxDelegate

extension EDTSCardPromoCell: EDTSAlertboxDelegate {

    public func didTapCloseAlertbox(_ alertbox: EDTSAlertbox) {}

    public func didTapButtonAlertbox(_ alertbox: EDTSAlertbox) {
        onTap?()
    }
}
