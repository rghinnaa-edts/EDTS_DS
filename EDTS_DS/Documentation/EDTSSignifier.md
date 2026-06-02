# EDTSSignifier

`EDTSSignifier` is a customizable badge/notification indicator component that displays a count label or a dot-style indicator. It supports full styling control including background color, border, shadow, corner radius, label font, and padding. It can be attached to any `UIView` via the `show(to:)` method and supports a skeleton loading state.

---

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Signifier — Label (Default)** | ![Default](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1779764955/badge_wdszhr.png) |
| **Signifier — Indicator** | ![Indicator](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1779764955/indicator_zfa8qv.png) |
| **Signifier — Skeleton** | ![Skeleton](https://res.cloudinary.com/dacnnk5j4/image/upload/w_100,c_scale,q_auto,f_auto/v1779764956/skeleton_vzc0hd.gif) |

---

## Basic Usage

### Signifier

**Swift (Storyboard/XIB):**
```swift
// Add UIView from Interface Builder
// Set Custom Class to EDTSSignifier in Identity Inspector
```

**Swift (Programmatic):**
```swift
let signifier = EDTSSignifier(frame: .zero)
view.addSubview(signifier)

signifier.label = "5"
signifier.bgColor = EDTSColor.red30
signifier.labelColor = EDTSColor.white
```

**Attach to Another View:**
```swift
// Positions the signifier at the top-trailing corner of a target view
signifier.show(to: targetButton)

// Customize offset from the anchor point
signifier.topOffset = 4
signifier.trailingOffset = 4
```

**Dot Indicator (no label):**
```swift
signifier.isIndicator = true
```

**Attributed Label:**
```swift
let attributed = NSAttributedString(string: "NEW", attributes: [
    .foregroundColor: UIColor.white,
    .font: UIFont.boldSystemFont(ofSize: 10)
])
signifier.labelAttributed = attributed
```

---

## Properties Reference

### General Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `isIndicator` | `Bool` | `false` | When `true`, hides the label and renders as a small circular dot indicator |
| `isSkeleton` | `Bool` | `false` | When `true`, shows an animated skeleton placeholder and hides content |

### Label Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `label` | `String?` | `"0"` | Text content of the badge label |
| `labelAttributed` | `NSAttributedString?` | `nil` | Attributed text for the label (overrides `label`) |
| `labelColor` | `UIColor?` | `EDTSColor.white` | Text color of the label |
| `labelFontName` | `String` | `""` (system font) | Custom font name for the label (falls back to system font if not found) |
| `labelFontSize` | `CGFloat` | `0.0` | Font size for the label |
| `labelFontWeight` | `String` | `""` | Font weight for the label (`ultralight`, `thin`, `light`, `regular`, `medium`, `semibold`, `bold`, `heavy`, `black`) |

### Background & Border Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `bgColor` | `UIColor?` | `EDTSColor.red30` | Background color of the signifier container |
| `cornerRadius` | `CGFloat` | `0.0` | Corner radius of the container. When `0`, a fully circular shape is applied automatically |
| `borderWidth` | `CGFloat` | `0.0` | Width of the border around the container |
| `borderColor` | `UIColor?` | `nil` | Color of the border |

### Shadow Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `shadowOpacity` | `Float` | `0.0` | Opacity of the drop shadow |
| `shadowOffset` | `CGSize` | `.zero` | Offset of the drop shadow |
| `shadowRadius` | `CGFloat` | `0.0` | Blur radius of the drop shadow |
| `shadowColor` | `UIColor?` | `nil` | Color of the drop shadow |

### Padding Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `paddingTop` | `CGFloat` | `0.0` (Poinku) / `1.0` (default) | Top inset inside the signifier container |
| `paddingBottom` | `CGFloat` | `0.0` (Poinku) / `1.0` (default) | Bottom inset inside the signifier container |
| `paddingLeading` | `CGFloat` | `2.0` | Leading inset inside the signifier container |
| `paddingTrailing` | `CGFloat` | `2.0` | Trailing inset inside the signifier container |

### Positioning Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `topOffset` | `CGFloat` | `0.0` | Vertical offset from the top anchor of the target view when using `show(to:)` |
| `trailingOffset` | `CGFloat` | `0.0` | Horizontal offset from the trailing anchor of the target view when using `show(to:)` |

---

## Methods

### `show(to:)`

Attaches the signifier to a target view, positioning it at the top-trailing corner with optional offset control.

```swift
public func show(to view: UIView)
```

**Parameters:**

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| `view` | `UIView` | The target view to attach the signifier to |

---

## Theme Behaviour

`EDTSSignifier` automatically adapts its default styling based on the active `EDTSColor.theme`.

| Property | Poinku Theme | Default Theme |
| -------- | ------------ | ------------- |
| `signifierHeight` (label) | `12pt` | `16pt` |
| `signifierHeight` (indicator dot) | `12pt` | `8pt` |
| `paddingTop` / `paddingBottom` | `0.0` | `1.0` |
| Label font | `EDTSFont.B5.Medium` | `EDTSFont.B4.Semibold` |

---

## Notes

- Setting `labelAttributed` overrides `label`; setting `label` clears `labelAttributed` — only one text source is active at a time

*For further customization, you can ask a UX Engineer or inherit `EDTSSignifier` and override its methods, or add additional functionality as required.*
