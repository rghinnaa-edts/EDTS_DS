# EDTSCardShoppingType

The `EDTSCardShoppingType` component is a two-sided, card-style selector built for UIKit

## Features

- Two selectable shopping type panes (`first` / `second`) with a spring-animated sliding indicator
- Independent icon, title, and description for each side, with plain-text or attributed-text variants
- Configurable fonts (name, size, weight) for the title and description labels
- Configurable indicator color, icon tint, and "active" tint per side
- Configurable card background color, corner radius, and drop shadow
- Tap gesture recognizers on each half that switch the selection with animation
- `IBDesignable` / `IBInspectable` support for Interface Builder assembly
- Proper `intrinsicContentSize` tracking for use inside `UIStackView`

---

## Preview

![Card Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_80/v1783415936/WhatsApp_GIF_2026-07-07_at_16.17.27_luzrq5.gif)

---

## Installation

Add to your project:
- `EDTSCardShoppingType.swift`
- `EDTSCardShoppingType.xib`

---

## Usage

### Basic

```swift
card.titleFirst = "Xpress"
card.descFirst = "Same-day delivery"
card.titleSecond = "Xtra"
card.descSecond = "Extra careful handling"
```

### With Icons

```swift
card.iconFirst = UIImage(named: "ic_xpress")
card.iconSecond = UIImage(named: "ic_xtra")
card.iconTintColor = EDTSColor.grey60
card.activeTintColor = EDTSColor.white
```

### Setting Selection Programmatically

```swift
card.setSelectedType(.second, animated: true)
```

### Custom Colors per Side

```swift
card.firstIndicatorColor = EDTSColor.xpress
card.secondIndicatorColor = EDTSColor.xtra
card.bgColor = EDTSColor.grey20
card.titleColor = EDTSColor.grey60
card.descColor = EDTSColor.grey40
```

### Custom Fonts

```swift
card.titleFontName = "Poppins-SemiBold"
card.titleFontSize = 14
card.titleFontWeight = "semibold"
card.descFontName = "Poppins-Regular"
card.descFontSize = 12
card.descFontWeight = "regular"
```

### With Attributed Text

```swift
card.titleAttributedFirst = NSAttributedString(string: "Xpress", attributes: [...])
card.descAttributedSecond = NSAttributedString(string: "Extra careful handling", attributes: [...])
```

---

## Public Interface

### Content

| Property | Type | Description |
|---|---|---|
| `titleFirst` | `String?` | Title text for the first pane; setting this clears `titleAttributedFirst` |
| `titleAttributedFirst` | `NSAttributedString?` | Attributed variant of `titleFirst`; setting this clears `titleFirst` |
| `descFirst` | `String?` | Description text for the first pane; setting this clears `descAttributedFirst` |
| `descAttributedFirst` | `NSAttributedString?` | Attributed variant of `descFirst`; setting this clears `descFirst` |
| `titleSecond` | `String?` | Title text for the second pane; setting this clears `titleAttributedSecond` |
| `titleAttributedSecond` | `NSAttributedString?` | Attributed variant of `titleSecond`; setting this clears `titleSecond` |
| `descSecond` | `String?` | Description text for the second pane; setting this clears `descAttributedSecond` |
| `descAttributedSecond` | `NSAttributedString?` | Attributed variant of `descSecond`; setting this clears `descSecond` |
| `iconFirst` | `UIImage?` | Icon for the first pane, rendered with `.alwaysTemplate` so it can be tinted |
| `iconSecond` | `UIImage?` | Icon for the second pane, rendered with `.alwaysTemplate` so it can be tinted |

### State

| Property / Method | Type | Default | Description |
|---|---|---|---|
| `setSelectedType(_:animated:)` | `(ShoppingType, Bool) -> Void` | — | Changes the current selection. No-ops if the requested type is already selected |
| `ShoppingType` | `enum { .first, .second }` | — | Identifies which pane is selected |

### Colors

| Property | Type | Default | Description |
|---|---|---|---|
| `titleColor` | `UIColor?` | `EDTSColor.grey60` | Text color for both title labels while inactive |
| `descColor` | `UIColor?` | `EDTSColor.grey40` | Text color for both description labels while inactive |
| `iconTintColor` | `UIColor?` | `EDTSColor.grey60` | Tint color applied to both icons while inactive |
| `activeTintColor` | `UIColor?` | `EDTSColor.white` | Color applied to the icon, title, and description of whichever pane is currently selected |
| `firstIndicatorColor` | `UIColor?` | `EDTSColor.xpress` | Indicator background color while the first pane is selected |
| `secondIndicatorColor` | `UIColor?` | `EDTSColor.xtra` | Indicator background color while the second pane is selected |
| `bgColor` | `UIColor?` | `EDTSColor.grey20` | Background color of the card container |

### Fonts

| Property | Type | Default | Description |
|---|---|---|---|
| `titleFontName` | `String` | `""` | Custom font name for both title labels; falls back to system font if the name can't be resolved |
| `titleFontSize` | `CGFloat` | `0` | Point size for both title labels; font changes only apply when this is `> 0` |
| `titleFontWeight` | `String?` | `nil` (treated as `"regular"`) | Weight keyword used to resolve a system font weight when `titleFontName` can't be resolved or is empty |
| `descFontName` | `String` | `""` | Custom font name for both description labels |
| `descFontSize` | `CGFloat` | `0` | Point size for both description labels; font changes only apply when this is `> 0` |
| `descFontWeight` | `String?` | `nil` (treated as `"regular"`) | Weight keyword used to resolve a system font weight for the description labels |

### Sizing & Shadow

| Property | Type | Default | Description |
|---|---|---|---|
| `cornerRadius` | `CGFloat` | `8.0` | Corner radius applied to both the card container and the indicator |
| `shadowOpacity` | `Float` | `0.4` | Opacity of the card container drop shadow |
| `shadowOffset` | `CGSize` | `(0, 1)` | Offset of the card container drop shadow |
| `shadowRadius` | `CGFloat` | `3.0` | Blur radius of the card container drop shadow |
| `shadowColor` | `UIColor?` | `EDTSColor.grey40` | Color of the card container drop shadow |

---

### Default Values
 
Applied by `setupDefaultValue()` at initialization, before any consumer-provided values are set. These are the values the card renders if the corresponding property is left untouched.
 
| Property | Default Value | Notes |
|---|---|---|
| `iconFirst` | `ic_xpress` | Loaded from the component's own bundle |
| `titleFirst` | `"Belanja Xpress"` | Plain text, not attributed |
| `descFirst` | `"1 Jam Sampai"` | Plain text, not attributed |
| `iconSecond` | `ic_xtra` | Loaded from the component's own bundle |
| `titleSecond` | `"Belanja Xtra"` | Plain text, not attributed |
| `descSecond` | `"Tiba 1-3 hari"` | Plain text, not attributed |
| Selected pane | `.first` | Initial `selectedType`; indicator starts aligned to the first pane |

---

## Delegate

```swift
@MainActor
public protocol EDTSCardShoppingTypeDelegate: AnyObject {
    func didSelectShoppingType(isFirstActive: Bool, _ card: EDTSCardShoppingType)
}
```

---

## Animation

Triggered whenever the selection changes (via tap or `setSelectedType(_:animated:)`).

| Aspect | Value | Notes |
|---|---|---|
| Duration | `0.4s` | Spring-based, applies to the indicator's position and color |
| Damping | `0.8` | `usingSpringWithDamping` |
| Initial Velocity | `0.2` | `initialSpringVelocity` |
| Curve | `.curveEaseOut` | Applied to the indicator position/color animation |
| Indicator Position | `0` → `containerView.bounds.width / 2` | Leading constraint slides the indicator to the selected half |
| Indicator Color | `firstIndicatorColor` → `secondIndicatorColor` (or reverse) | Animated alongside the position change |
| Label/Icon Tint | Inactive color → `activeTintColor` (or reverse) | Applied via a separate `0.25s` cross-dissolve transition |

---

## Behavior Notes

- Tapping either pane (`vTypeFirst` / `vTypeSecond`) switches the selection with animation; tapping the already-selected pane is a no-op.
- The indicator's width is always half of the container's width, recalculated on every `layoutSubviews()` call.

---

*For further customization, inherit `EDTSCardShoppingType` and override its setup methods, or contact the UX Engineering team.*
