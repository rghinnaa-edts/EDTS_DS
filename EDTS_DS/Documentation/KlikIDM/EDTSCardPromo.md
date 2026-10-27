# EDTSCardPromo
The `EDTSCardPromo` component is a scrollable list of promo cards with a tab bar on top. Each card shows a title, a banner, a horizontal list of selectable products and an info box (`EDTSAlertbox`). Scrolling the list updates the active tab, and selecting a tab scrolls the list to the matching card.

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
            configureInfoBox: { alertbox in
                alertbox.state = EDTSAlertboxState.info.rawValue
                alertbox.labelAttributed = NSAttributedString(string: "Minimum purchase 3 items")
                alertbox.btnLabel = "Detail"
            }
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

## Properties

### EDTSCardPromo
| Parameters | Description | Data Type | Default Value |
|------------|-------------|-----------|---------------|
| `tabBackgroundColor` | Background color of the tab bar (`@IBInspectable`) | UIColor? | `nil` |
| `isTabHidden` | Hide the tab bar (`@IBInspectable`) | Bool | `false` |
| `tabHeightWhenVisible` | Height of the tab bar when it is visible (`@IBInspectable`) | CGFloat | `48` (taken from the XIB) |
| `delegate` | Delegate for card and product actions | EDTSCardPromoDelegate? | `nil` |
| `cards` | Cards currently displayed | [EDTSCardPromoModel] | `[]` |
| `isLoading` | Whether the skeleton state is shown (read only, use `setLoading`) | Bool | `false` |
| `skeletonCardCount` | Number of skeleton cards shown while loading | Int | `3` |
| `collectionView` | The underlying card list | UICollectionView | - |

### Public Functions
| Function | Description |
|----------|-------------|
| `configure(cards:)` | Set the cards, rebuild the tabs, reset the scroll position and select the first tab |
| `updateCards(_:)` | Replace the cards and reload the list without resetting tabs or scroll position |
| `setLoading(_:)` | Show or hide the skeleton state. The tab bar is hidden and scrolling is disabled while loading |
| `scrollToCard(at:animated:)` | Scroll to the card at the given index and select its tab. Ignored while loading |
| `setTabHidden(_:animated:)` | Show or hide the tab bar, optionally animated |

### EDTSCardPromoModel
| Parameters | Description | Data Type | Default Value |
|------------|-------------|-----------|---------------|
| `id` | Identifier of the card, also used as the tab id | String | same as `title` |
| `title` | Card title, also used as the tab title | String | required |
| `banner` | Banner image | UIImage? | `nil` |
| `isAvailable` | Whether the promo is available. When `false` the banner and all products are greyed out | Bool | `true` |
| `isProductAvailable` | Whether the products can be used. When `false` all products are greyed out | Bool | `true` |
| `products` | Products shown in the horizontal list | [EDTSCardPromoProductModel] | required |
| `configureInfoBox` | Closure to configure the card's `EDTSAlertbox` (state, icon, text, button, colors) | ((EDTSAlertbox) -> Void)? | `nil` |

### EDTSCardPromoProductModel
Each product provides the following values to the product cell.

| Parameters | Description | Data Type |
|------------|-------------|-----------|
| `image` | Product image | UIImage |
| `title` | Product name (single line) | String |
| `price` | Price after discount | String |
| `realPrice` | Original price, shown with a strikethrough | String |
| `discountPercent` | Discount value without the `%` sign, the badge adds it | String |
| `isAvailable` | Whether the product is available. When `false` it is greyed out | Bool |
| `isSelected` | Whether the product is selected | Bool |

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
- **Layout:** cards have 12pt padding on the left, right, top and bottom, and 12pt spacing between cards. Card width is the list width minus 24pt.
- **Card height:** calculated from the content (title, banner, tallest product and info box) with `EDTSCardPromoCell.height(for:width:)` and cached per card. The cache is cleared when the cards or the list width change.
- **Product selection:** products support multiple selection. Taps on products do not toggle selection by themselves. The selection state comes from `isSelected` on each product model, and any change is written back to `cards`.
- **Availability:** a product is greyed out when its own `isAvailable` is `false`, or when the card's `isAvailable` or `isProductAvailable` is `false`.
- **Loading:** while `isLoading` is `true` skeleton cells are shown, the tab bar is hidden, and scrolling and touches are disabled.

### Notes
- `title` is used as both the card title and the tab title, so keep it short.
- If `id` is not provided it falls back to `title`, so give cards with the same title different ids.
- Use `updateCards(_:)` instead of `configure(cards:)` when you only change the data and do not want the scroll position to reset.

---

*For further customization, inherit `EDTSCardPromo` or contact the UX Engineering team.*
