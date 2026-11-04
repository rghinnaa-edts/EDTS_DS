//
//  EDTSCardPromoProductCell.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 22/10/26.
//

import UIKit

public class EDTSCardPromoProductCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var discount: EDTSBadge!
    @IBOutlet weak var lblRealPrice: UILabel!
    
    // MARK: - Public Variables

    public static let identifier = "EDTSCardPromoProductCell"
    public static let itemWidth: CGFloat = 216

    // MARK: - Private Variables
    
    private static let cornerRadius: CGFloat = 6
    private static let borderWidth: CGFloat = 1
    private static let checkSize: CGFloat = 32

    private let checkBackgroundLayer = CAShapeLayer()

    private static let sizingCell: EDTSCardPromoProductCell = {
        let cell = EDTSCardPromoProductCell(frame: .zero)
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        return cell
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }

    public override var isSelected: Bool {
        didSet { updateSelectionState() }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        ivProduct.image = nil
        contentView.applyGrayscale(false)
        isSelected = false
    }

    // MARK: - Configure

    public func configure(
        isAvailable: Bool,
        image: UIImage,
        title: String,
        price: String,
        realPrice: String,
        discountPercent: String
    ) {
        contentView.applyGrayscale(!isAvailable)

        ivProduct.image = image
        lblTitle.text = title
        lblPrice.text = price
        lblRealPrice.attributedText = realPrice.strikethrough()

        discount.label = discountPercent + "%"
    }

    static func height(
        image: UIImage,
        title: String,
        price: String,
        realPrice: String,
        discountPercent: String,
        width: CGFloat = itemWidth
    ) -> CGFloat {
        let cell = sizingCell

        cell.configure(isAvailable: true, image: image, title: title, price: price, realPrice: realPrice, discountPercent: discountPercent)

        let widthConstraint = cell.contentView.widthAnchor.constraint(equalToConstant: width)
        widthConstraint.isActive = true
        defer { widthConstraint.isActive = false }

        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        let size = cell.contentView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return ceil(size.height)
    }

    private func setupImageInsets() {
        ivProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ivProduct.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 12),
            containerView.bottomAnchor.constraint(greaterThanOrEqualTo: ivProduct.bottomAnchor, constant: 12)
        ])
    }

    // MARK: - Setup

    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("EDTSCardPromoProductCell", owner: self, options: nil),
           let view = nib.first as? UIView {

            containerView = view
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = .clear
            contentView.addSubview(containerView)

            let fixedWidth = containerView.widthAnchor.constraint(equalToConstant: Self.itemWidth)
            fixedWidth.priority = UILayoutPriority(999)

            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                fixedWidth
            ])
        }

        setupUI()
    }

    private func setupUI() {
        setupImageInsets()
        setupTitle()
        setupPrice()
        setupBorder()
        setupBadge()
        updateSelectionState()
    }

    private func setupBorder() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = Self.cornerRadius
        containerView.layer.borderWidth = Self.borderWidth
        containerView.layer.masksToBounds = true
    }

    private func setupTitle() {
        lblTitle.font = EDTSFont.B3.Regular.font
        lblTitle.textColor = EDTSColor.grey70
        lblTitle.numberOfLines = 1
    }

    private func setupPrice() {
        lblPrice.font = EDTSFont.B3.Medium.font
        lblPrice.textColor = EDTSColor.red30

        lblRealPrice.font = EDTSFont.B4.Regular.font
        lblRealPrice.textColor = EDTSColor.grey40
    }

    private func setupBadge() {
        discount.labelColor = EDTSColor.red30
        discount.labelFont = EDTSFont.B4.Bold.font
        discount.bgColor = EDTSColor.red10
        discount.cornerRadius = 4
    }

    private func updateSelectionState() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        containerView?.animateCardSelected(
            isSelected: isSelected,
            tintColor: EDTSColor.blue50,
            unselectedBorderColor: EDTSColor.grey30,
            icon: UIImage(named: "ic_check", in: .edtsDS, compatibleWith: nil),
            iconTintColor: EDTSColor.white,
            durationAnimation: 0.25,
            animated: true)

        CATransaction.commit()
    }
}
