# EDTSCardMyCoupon

`EDTSCardMyCoupon` is a customizable card component designed to display coupon information with support for icons, badges, and optional liquid glass effect. The component features a leading icon with gradient background, title, description, badge indicator, and trailing chevron icon with press animation feedback.

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Default Card** |![Card with leading icon, title, description, badge, and trailing chevron](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1768880622/default_card_e2tql3.gif)|
| **Liquid Glass Effect iOS 26** |![Card with iOS 26+ glass container effect or custom glass background](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1768880622/liquid_glass_effect_nlcqlt.gif)|
| **Liquid Glass Effect below iOS 26** |![Card with below iOS 26 glass container effect or custom glass background](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1770104549/liquid_glass_effect_below26_xtbx1h.gif)|

## Basic Usage

### 1. Add to Layout

**Swift (Storyboard/XIB):**
```swift
// Add UIView from Interface Builder
// Set Custom Class to EDTSCardMyCoupon in Identity Inspector
```

**Swift (Programmatic):**
```swift
let cardMyCoupon = EDTSCardMyCoupon(frame: .zero)
view.addSubview(cardMyCoupon)
```

### 2. Initialize in Code
```swift
// Configure the card
cardMyCoupon.title = "My Coupons"
cardMyCoupon.desc = "Collection of your available coupons"
cardMyCoupon.delegate = self

// Implement delegate
extension ViewController: EDTSCardMyCouponDelegate {
    func didSelectCard(_ card: EDTSCardMyCoupon) {
        print("Card tapped")
        // Handle card selection
    }
}
```

## Properties Reference

### Text Properties
| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `title` | `String?` | `"Card Title"` | Main title text |
| `titleAttributed` | `NSAttributedString?` | `nil` | Attributed title text. Overrides `title` when set. |
| `titleFontName` | `String` | `""` | Custom font name for title text |
| `titleFontSize` | `CGFloat` | `0` | Custom font size for title text |
| `titleFontWeight` | `String` | `""` | Font weight for title text (`ultralight`, `thin`, `light`, `regular`, `medium`, `semibold`, `bold`, `heavy`, `black`) |
| `titleColor` | `UIColor?` | `EDTSColor.white` | Title text color |
| `desc` | `String?` | `"Card Description"` | Description text |
| `descAttributed` | `NSAttributedString?` | `nil` | Attributed description text. Overrides `desc` when set. |
| `descFontName` | `String` | `""` | Custom font name for description text |
| `descFontSize` | `CGFloat` | `0` | Custom font size for description text |
| `descFontWeight` | `String` | `""` | Font weight for description text (`ultralight`, `thin`, `light`, `regular`, `medium`, `semibold`, `bold`, `heavy`, `black`) |
| `descColor` | `UIColor?` | `EDTSColor.grey30` | Description text color |

### Icon Properties
| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `iconLeading` | `UIImage?` | `nil` | Leading icon image |
| `iconTintColorLeading` | `UIColor?` | `EDTSColor.white` | Tint color for leading icon (uses template rendering mode) |
| `iconBgColorLeading` | `UIColor?` | `EDTSColor.white` | Background color for leading icon radial gradient |
| `iconTrailing` | `UIImage?` | `nil` | Trailing icon image |
| `iconTintColorTrailing` | `UIColor?` | `EDTSColor.white` | Tint color for trailing icon |

### Appearance Properties
| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `isLiquidGlassBg` | `Bool` | `true` | Enables liquid glass effect background (iOS 26+ uses UIGlassContainerEffect, earlier versions use custom LiquidGlassBackgroundView) |
| `bgColor` | `UIColor?` | `nil` | Card background color (only used when `isLiquidGlassBg` is false) |
| `cornerRadius` | `CGFloat` | `8.0` | Corner radius for card container |

### Badge Properties

The badge is configured via the `configureBadge(_:)` method. Calling it automatically shows the [`EDTSBadge`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSBadge.md).

```swift
cardMyCoupon.configureBadge { badge in
    badge.label = "5"
    badge.bgColor = .red
    badge.borderColor = .white
    badge.borderWidth = 1
}
```

## Delegate Protocol

```swift
@MainActor
public protocol EDTSCardMyCouponDelegate: AnyObject {
    func didSelectCard(_ card: EDTSCardMyCoupon)
}
```

## Animation Details

| Animation Type | Duration | Interpolator | Description |
| -------------- | -------- | ------------ | ----------- |
| `Scale Down` | `100ms` | `EaseInOut` | Scales card to 97% on touch down |
| `Scale Up` | `100ms` | `EaseInOut` | Returns card to original size on touch up/cancel |

## Liquid Glass Effect Implementation

The card implements two different liquid glass effects based on iOS version:

### iOS 26.0+
Uses native `UIGlassContainerEffect` and `UIGlassEffect`

### Below iOS 26.0
Uses custom `LiquidGlassBackgroundView`. The implementation automatically detects iOS version and applies the appropriate effect.

## Notes

- The liquid glass effect uses `UIGlassContainerEffect` and `UIGlassEffect` on iOS 26+ devices, falling back to custom `LiquidGlassBackgroundView` on earlier versions
- When `isLiquidGlassBg` is true, the `bgColor` property is ignored and background is set to `.clear`

*For further customization, you can ask UX Engineer or inherit `EDTSCardMyCoupon` and override its methods, or add additional functionality as required.*
