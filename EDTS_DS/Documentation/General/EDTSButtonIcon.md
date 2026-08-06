# EDTSButtonIcon

`EDTSButtonIcon` is a fully customizable UIButton subclass that displays a single icon with configurable type, size, and state styling. It supports gradient backgrounds and badge overlays.

## Preview

| Feature / Variation | Preview | Default | Disabled |
| ------------------- | ------- | ---- | -------- |
| **Primary Button** |![Primary Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077890/button_icon_primary_default_qhigjm.gif)|![Primary Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077890/button_icon_primary_default_qhigjm.gif)|![Primary Disabled Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077886/button_icon_primary_disabled_qr4rqj.png)|
| **Secondary Button** |![Secondary Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077894/button_icon_secondary_default_ud96d1.gif)|![Secondary Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077894/button_icon_secondary_default_ud96d1.gif)|![Secondary Disabled Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077896/button_icon_secondary_disabled_zjo8sa.png)|
| **Tertiary Button** |![Tertiary Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077887/button_icon_tertiary_default_nhboaj.gif)|![Tertiary Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077887/button_icon_tertiary_default_nhboaj.gif)|![Tertiary Disabled Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077883/button_icon_tertiary_disabled_mbwpnk.png)|
| **Default** |![Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077890/button_icon_primary_default_qhigjm.gif)| | | |
| **Gradient Background and With Badge** |![Button With Gradient Background And Badge](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077897/button_icon_gradient_badge_ky0axx.gif)| | | |
| **Icon Only** |![Icon Only Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1781077895/button_icon_only_hvdepa.gif)| | | |

## Basic Usage

### 1. Add to Layout (Storyboard / XIB)

```swift
// Add UIButton from Interface Builder
// Set Custom Class to EDTSButtonIcon in Identity Inspector
```

### 2. Initialize in Code

```swift
let iconButton = EDTSButtonIcon()

// Configure type, size, and icon
iconButton.btnType = "primary"
iconButton.btnSize = "large"
iconButton.btnState = "default"
iconButton.icon = UIImage(systemName: "star.fill")
```

## Button Types

| Type | Value | Description |
| ---- | ----- | ----------- |
| `primary` | `"primary"` | Filled button with brand color |
| `secondary` | `"secondary"` | White background with colored border |
| `tertiary` | `"tertiary"` | Subtle button with grey tones |

## Button States

| State | Value | Description |
| ----- | ----- | ----------- |
| `Default` | `"default"` | Default idle state |
| `focus` | `"focus"` | Focus state |
| `disabled` | `"disabled"` |  Non-interactive state |

## Button Sizes

| Size | Value | Icon Size | Corner Radius | Padding |
| ---- | ----- | --------- | ------------- | ------- |
| `small` | `"small"` | `16pt` | `4pt` | `4pt` |
| `medium` | `"medium"` | `16pt` | `4pt` | `8pt` |
| `large` | `"large"` | `24pt` | `4pt` | `8pt` |

## Properties Reference

### General Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `btnType` | `String?` | `"primary"` | Button type (`primary`, `secondary`, `tertiary`) |
| `btnState` | `String?` | `"default"` | Button state (`default`, `focus`, `disabled`) |
| `btnSize` | `String?` | `"large"` | Button size (`small`, `medium`, `large`) |
| `cornerRadius` | `CGFloat` | `4pt` (size-dependent) | Corner radius of the button |

### Icon Properties
| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `icon` | `UIImage?` | `ic_placeholder` | The icon image rendered as a template (tintable) |
| `iconTintColor` | `UIColor?` | Type-dependent | icon tint color |
| `iconFocusTintColor` | `UIColor?` | Type-dependent | Icon tint color on focus state |
| `iconDisabledTintColor` | `UIColor?` | Type-dependent | Icon tint color on disabled state |
| `iconSize` | `CGFloat` | Size-dependent | icon width and height |

### Background Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `bgColor` | `UIColor?` | Type/state-dependent | Button background color (ignored if gradient is set) |
| `bgFocusColor` | `UIColor?` | Type/state-dependent | Background color on focus state (ignored if gradient is set) |
| `bgDisabledColor` | `UIColor?` | Type/state-dependent | Background color on disabled state (ignored if gradient is set) |
| `bgColorStart` | `UIColor?` | `nil` | Start color for gradient background |
| `bgColorEnd` | `UIColor?` | `nil` | End color for gradient background |
| `bgColorOrientation` | `String?` | `"vertical"` | Gradient direction: `"horizontal"` or `"vertical"` |
| `rippleColor` | `UIColor?` | `nil` | Custom ripple color. Defaults to iconTintColor or grey70 at 12% opacity based on background |

### Border Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `borderWidth` | `CGFloat` | Type/state-dependent | Border width |
| `borderColor` | `UIColor?` | Type/state-dependent | Border color |
| `borderFocusColor` | `UIColor?` | Type/state-dependent | Border color on focus state |
| `borderDisabledColor` | `UIColor?` | Type/state-dependent | Border color on disabled state |

### Padding Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `paddingTop` | `CGFloat` | Size-dependent | Top inset between icon and button edge |
| `paddingBottom` | `CGFloat` | Size-dependent | Bottom inset between icon and button edge |
| `paddingLeading` | `CGFloat` | Size-dependent | Leading inset between icon and button edge |
| `paddingTrailing` | `CGFloat` | Size-dependent | Trailing inset between icon and button edge |

### Shadow Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `shadowOpacity` | `Float` | `0.0` | Shadow opacity |
| `shadowRadius` | `CGFloat` | `0.0` | Blur radius of the shadow |
| `shadowOffset` | `CGSize` | `CGSize.zero` | Offset of the shadow |
| `shadowColor` | `UIColor?` | `nil` | Color of the shadow |
| `shadowFocusColor` | `UIColor?` | `nil` | Shadow color on focus state |
| `shadowDisabledColor` | `UIColor?` | `nil` | Shadow color on disabled state |

### Badge Properties

The badge is configured via the `isHasBadge` property and `configureBadge(_:)` method. Set `isHasBadge = true` first to anchor the badge to the icon, then call `configureBadge(_:)` to customize it and make it visible. 

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `isHasBadge` | `Bool` | `false` | Anchors the badge overlay to the icon view. Must be set before calling `configureBadge(_:)` |

```swift
iconButton.isHasBadge = true
iconButton.configureBadge { badge in
    badge.label = "5"
    badge.bgColor = .red
    badge.borderColor = .white
    badge.borderWidth = 1
}
```

## Public Functions

| Function | Description |
| -------- | ----------- |
| `configureBadge(_ instance: (EDTSSignifier) -> Void)` | Shows the badge and exposes the [`EDTSSignifier`](https://github.com/rghinnaa-edts/EDTS_DS/blob/main/EDTS_DS/Documentation/EDTSSignifier.md) instance for customization. Call after setting `isHasBadge = true` |

## Type-Specific Styling

### Primary

| State | Background | Icon Tint | Border |
| ----- | ---------- | --------- | ------ |
| `default` | `blueDefault` | `white` | None |
| `focus` | `blueDefault` | `white` | `blue30`, width `2` |
| `disabled` | `disabled` | `white` | None |

### Secondary

| State | Background | Icon Tint | Border |
| ----- | ---------- | --------- | ------ |
| `default` | `white` | `blueDefault` | `blueDefault`, width `1` |
| `focus` | `white` | `blueDefault` | `blue30`, width `2` |
| `disabled` | `white` | `disabled` | `disabled`, width `1` |

### Tertiary

| State | Background | Icon Tint | Border |
| ----- | ---------- | --------- | ------ |
| `default` | `white` | `greyText` | `greyDefault`, width `1` |
| `focus` | `grey20` | `greyText` | `greyPressed`, width `2` |
| `disabled` | `white` | `disabled` | `disabled`, width `1` |

## Animation Details

| Animation Type | Duration | Interpolator | Description |
| -------------- | -------- | ------------ | ----------- |
| `Scale Down` | `100ms` | `EaseInOut` | Scales button to 95% on touch down |
| `Scale Up` | `100ms` | `EaseInOut` | Returns button to original size on touch up/cancel |
| `Ripple Effect` | `400ms expand + 220ms fade out` | `EaseOut` | Full-component ripple from touch point on tap (unless a gradient background (bgTintColorStart / bgTintColorEnd) is set) |

## Property Resolution Behavior

The button uses a **fallback system** where custom property values take precedence over preset defaults:

### Size Preset Resolution
When a size preset is applied (small, medium, large), the button checks each size-related property:
- If the property value is **minus one** or **zero** (default), the button uses the **preset value**
- If the property value is **non-zero**, the button uses the **custom value**

**Example:**
```swift
button.btnSize = "large"      // Preset: iconSize=24, padding=8
button.iconSize = 32          // Custom value overrides preset → uses 32
```

### Type/State Styling Resolution
When a type/state combination is applied, the button checks each styling property:
- If the property value is **nil**, the button uses the **type/state default**
- If the property value is **non-nil**, the button uses the **custom value**

**Example:**
```swift
button.btnType = "primary"    // Preset: bgTintColor=blueDefault, iconTintColor=white
button.btnState = "default"
button.bgColor = .red             // Custom value overrides preset → uses red
```

## Notes

- Gradient background is enabled when `bgColorStart` or `bgColorEnd` are set; when enabled, `bgColor`, `bgFocusColor`, and `bgDisabledColor` are ignored
- Ripple animation is disabled while gradient mode is active
- The `disabled` state automatically sets `isUserInteractionEnabled = false`

*For further customization, you can ask UX Engineer or inherit `EDTSButtonIcon` and override its methods, or add additional functionality as required.*
