# EDTSCardPromo
The `EDTSCardPromo` component is a scrollable list of promo cards with a tab bar on top. Each card shows a title, a banner, a horizontal list of selectable products and an infobox using `EDTSAlertbox`. Scrolling the list updates the active tab, and selecting a tab scrolls the list to the matching card.

## Preview
| Type | Preview |
|------|---------|
| `Default` | ![Default](https://res.cloudinary.com/dr6cm6n5f/image/upload/w_250,c_scale/v1793085219/card-default_l5upwv.gif) |
| `Loading (skeleton)` | ![Skeleton](https://res.cloudinary.com/dr6cm6n5f/image/upload/w_250,c_scale/v1793085215/card-skeleton_l2dwle.gif) |
| `Tab hidden` | ![Tab Hidden](https://res.cloudinary.com/dr6cm6n5f/image/upload/w_250,c_scale/v1793086070/WhatsApp_GIF_2026-10-27_at_14.03.06_e8nzlf.gif) |

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS/Klik/CardPromo'
```

Then import it wherever you use the component:

```swift
import EDTS_DS
```

## Usage
1. If you're using a view in storyboard, set the class of the view to `EDTSCardPromo`.
2. Add an `IBOutlet` of type `EDTSCardPromo`.
3. Set the delegate and call `configure(cards:)`.

```swift
@IBOutlet weak var cardPromo: EDTSCardPromo!

override func viewDidLoad() {
    super.viewDidLoad()

    cardPromo.delegate = self

    let cards = [
        EDTSCardPromoModel(
            title: "Promo Ramadan",
            banner: UIImage(named: "banner_ramadan"),
            products: products,
            info: EDTSCardPromoInfo(
                state: .info,
                description: NSAttributedString(string: "Minimum purchase 3 items"),
                buttonText: "Detail"
            )
        ),
        EDTSCardPromoModel(
            title: "Promo Akhir Tahun",
            banner: UIImage(named: "banner_year_end"),
            isAvailable: false,
            products: otherProducts
        )
    ]

    cardPromo.configure(cards: cards)
}
```

#### Info box
The info box is configured through `EDTSCardPromoInfo`. Use `accentColor` and `backgroundColor` to match the promo.

```swift
EDTSCardPromoInfo(
    state: .success,
    icon: UIImage(named: "ic_promo"),
    description: attributedText,
    buttonText: "Lihat",
    accentColor: EDTSColor.green50,
    backgroundColor: EDTSColor.green10
)
```

#### Loading state
```swift
cardPromo.setLoading(true)
fetchPromos { cards in
    self.cardPromo.configure(cards: cards)
    self.cardPromo.setLoading(false)
}
```

#### Hide the tab bar
```swift
cardPromo.setTabHidden(true, animated: true)
// or in Interface Builder: isTabHidden = On
```

#### Scroll to a card
```swift
cardPromo.scrollToCard(at: 2, animated: true)
```

#### Update data without resetting the scroll position
```swift
cardPromo.updateCards(newCards)
```

## Properties

### EDTSCardPromo
| Parameters | Description | Data Type | Default Value |
|------------|-------------|-----------|---------------|
| `tabBackgroundColor` | Background color of the tab bar (`@IBInspectable`) | UIColor? | `nil` |
| `isTabHidden` | Hide the tab bar (`@IBInspectable`) | Bool | `false` |
| `tabHeight` | Height of the tab bar when it is visible (`@IBInspectable`) | CGFloat | `48` |
| `delegate` | Delegate for card and product actions | EDTSCardPromoDelegate? | `nil` |
| `cards` | Cards currently displayed | [EDTSCardPromoModel] | `[]` |
| `isSkeleton` | Whether the skeleton state is shown (read only, use `setLoading`) | Bool | `false` |
| `skeletonCardCount` | Number of skeleton cards shown while loading | Int | `3` |
| `collectionView` | The underlying card list | UICollectionView | - |
| `identifier` | Static reuse identifier of the component | String | `"EDTSCardPromo"` |

### Public Functions
| Function | Description |
|----------|-------------|
| `configure(cards:)` | Set the cards, rebuild the tabs, reset the scroll position to the top and select the first tab |
| `updateCards(_:)` | Replace the cards and reload the list without resetting the tabs or the scroll position |
| `setLoading(_:)` | Show or hide the skeleton state. The tab bar is hidden and scrolling is disabled while loading |
| `scrollToCard(at:animated:)` | Scroll to the card at the given index and select its tab. Ignored while loading or when the index is out of range |
| `setTabHidden(_:animated:)` | Show or hide the tab bar, optionally animated |

### EDTSCardPromoModel
| Parameters | Description | Data Type | Default Value |
|------------|-------------|-----------|---------------|
| `id` | Identifier of the card, also used as the tab id (read only after init) | String | same as `title` |
| `title` | Card title, also used as the tab title | String | required |
| `banner` | Banner image | UIImage? | `nil` |
| `isAvailable` | Whether the promo is available. When `false` the banner and all products are greyed out | Bool | `true` |
| `isProductAvailable` | Whether the products can be used. When `false` all products are greyed out | Bool | `true` |
| `products` | Products shown in the horizontal list | [EDTSCardPromoProductModel] | required |
| `info` | Content and style of the card's info box | EDTSCardPromoInfo | `EDTSCardPromoInfo()` |

### EDTSCardPromoInfo
| Parameters | Description | Data Type | Default Value |
|------------|-------------|-----------|---------------|
| `state` | Info box state (`default`, `info`, `success`, `error`, `warning`) | EDTSAlertboxState | `.default` |
| `icon` | Custom icon. When `nil` the icon of the state is used | UIImage? | `nil` |
| `description` | Info box text | NSAttributedString | empty string |
| `buttonText` | Label of the button on the right side | String | `""` |
| `accentColor` | Tint of the icon and of the button label and arrow. When `nil` the state color is used | UIColor? | `nil` |
| `backgroundColor` | Background color of the info box. When `nil` the state color is used | UIColor? | `nil` |

The info box always has its button on the right side, no close button and no border.

### EDTSCardPromoProductModel
Each product provides the following values to the product cell.

| Parameters | Description | Data Type | Default Value |
|------------|-------------|-----------|---------------|
| `image` | Product image | UIImage | required |
| `title` | Product name (single line) | String | required |
| `price` | Price after discount | String | required |
| `realPrice` | Original price, shown with a strikethrough | String | required |
| `discountPercent` | Discount value without the `%` sign, the badge adds it | String | required |
| `isAvailable` | Whether the product is available. When `false` it is greyed out | Bool | `true` |
| `isSelected` | Whether the product is selected | Bool | `false` |

### Cells
These are used internally by `EDTSCardPromo`. They are public so you can reuse or measure them.

| Class | Member | Description |
|-------|--------|-------------|
| `EDTSCardPromoCell` | `identifier` | Reuse identifier |
| | `configure(with:)` | Configure the cell from an `EDTSCardPromoModel` |
| | `configure(products:)` | Replace only the product list |
| | `onTap` | Called when the card, the product list or the info box button is tapped |
| | `onProductsChanged` | Called with the updated products when product selection changes |
| | `height(for:width:)` | Height of a card for the given model and card width |
| | `productListHeight(for:)` | Height of the product list (at least 80pt) |
| | `titleHeight(for:cardWidth:)` | Height of the title for the given card width |
| `EDTSCardPromoProductCell` | `identifier`, `itemWidth` | Reuse identifier and fixed item width (`216`) |
| | `configure(isAvailable:image:title:price:realPrice:discountPercent:)` | Configure the product cell |
| `EDTSCardPromoSkeletonCell` | `identifier`, `height` | Reuse identifier and the skeleton card height |

## Delegate Protocol
```swift
public protocol EDTSCardPromoDelegate: AnyObject {
    func cardPromo(_ cardPromo: EDTSCardPromo, didSelectCardAt index: Int)
    func cardPromo(_ cardPromo: EDTSCardPromo, didSelectProductAt productIndex: Int, inCardAt cardIndex: Int)
}
```

All delegate methods are optional (default empty implementations are provided).

| Delegate | Description |
|----------|-------------|
| `didSelectCardAt` | Called when the card is tapped, when its product list is tapped, or when the button in its info box is tapped |
| `didSelectProductAt` | Reserved for product taps. It is not called by the current implementation, because product selection state is written back to `cards` instead |

## Behavior
- **Tab and scroll sync:** scrolling the list by hand selects the tab of the card nearest the top. Selecting a tab scrolls to that card. The last tab is selected when the list is scrolled to the bottom.
- **Tabs:** tabs use dynamic width and are built from the cards, with the card `id` as the tab id and the card `title` as the tab title.
- **Layout:** cards have 12pt padding on the left, right, top and bottom, and 12pt spacing between cards. Card width is the list width minus 24pt.
- **Card height:** calculated from the content (title, banner, tallest product and info box) with `EDTSCardPromoCell.height(for:width:)` and cached per card. The cache is cleared when the cards or the list width change.
- **Banner:** the banner keeps a 312:112 ratio of the card content width.
- **Product list:** products have a fixed width of 216pt and a shared height, taken from the tallest product (at least 80pt). The list scrolls horizontally and is reset to the start when the products change.
- **Product selection:** products support multiple selection and a selected product shows a blue border with a check mark. Taps on products do not toggle selection by themselves. The selection state comes from `isSelected` on each product model, and any change is written back to `cards`.
- **Availability:** a product is greyed out when its own `isAvailable` is `false`, or when the card's `isAvailable` or `isProductAvailable` is `false`. The banner is greyed out when the card's `isAvailable` is `false`.
- **Info box:** configured from `info` of each card. Tapping its button calls `didSelectCardAt`.
- **Loading:** while `isSkeleton` is `true` skeleton cells are shown, the tab bar is hidden, and scrolling and touches are disabled. When loading ends the first tab is selected again.

### Notes
- `title` is used as both the card title and the tab title, so keep it short.
- If `id` is not provided it falls back to `title`, so give cards with the same title different ids.
- Use `updateCards(_:)` instead of `configure(cards:)` when you only change the data and do not want the scroll position to reset.
- Pass an `icon` in `EDTSCardPromoInfo` only when you need a custom one. Leaving it `nil` keeps the icon of the state.

---

*For further customization, inherit `EDTSCardPromo` or contact the UX Engineering team.*
