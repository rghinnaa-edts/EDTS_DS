# EDTSRadioButton

`EDTSRadioButton` is a customizable single radio button component featuring a bullet indicator (or custom icon), title, and description text with full active/inactive state styling support. `EDTSRadioGroup` is a collection-based container that manages a list of `EDTSRadioButton` items with support for vertical, horizontal, and grid layout modes, handling selection state automatically.

---

## Preview

| Feature / Variation | Preview | 
| ------------------- | ------- |
| **RadioButton — Default (Inactive)** | ![RadioButton Default Inactive](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777342874/radio_button_rest_Inactive_q80akz.png) |
| **RadioButton — Default (Active)** | ![RadioButton Default Active](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777342874/radio_button_rest_active_nsqncr.png) |
| **RadioButton — Disabled (Inactive)** | ![RadioButton Disabled Inactive](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777342874/radio_button_disabled_Inactive_yjv6gt.png) |
| **RadioButton — Disabled (Active)** | ![RadioButton Disabled Active](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777342874/radio_button_disabled_active_k1koev.png) |
| **RadioGroup — Vertical** | ![RadioGroup Vertical](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777343370/radio_group_vertical_pfgwax.gif) |
| **RadioGroup — Horizontal** | ![RadioGroup Horizontal](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777343370/radio_group_horizontal_lukzi3.gif) |
| **RadioGroup — Span Grid** | ![RadioGroup Span Grid](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1777343370/radio_group_span_grid_bdmv8u.gif) |

---

## Basic Usage

### RadioButton

**Swift (Storyboard/XIB):**
```swift
// Add UIView from Interface Builder
// Set Custom Class to EDTSRadioButton in Identity Inspector
```

**Swift (Programmatic):**
```swift
let radioButton = EDTSRadioButton(frame: .zero)
view.addSubview(radioButton)

radioButton.title = "Option A"
radioButton.desc = "This is the description for option A"

radioButton.radioBtnState = "default"
radioButton.isActive = false

radioButton.delegate = self
```

**Implement Delegate:**
```swift
extension ViewController: EDTSRadioButtonDelegate {
    func didSelectRadioButton(_ radioButton: EDTSRadioButton) {
        radioButton.isActive.toggle()
    }
}
```

---

### RadioGroup

**Swift (Storyboard/XIB):**
```swift
// Add UIView from Interface Builder
// Set Custom Class to EDTSRadioGroup in Identity Inspector
```

**Swift (Programmatic):**
```swift
let radioGroup = EDTSRadioGroup(frame: .zero)
view.addSubview(radioGroup)

radioGroup.data = [
    ["Option A", "Description for option A"],
    ["Option B", "Description for option B"],
    ["Option C", "Description for option C"]
]

radioGroup.displayMode = .vertical
radioGroup.selectedIndex = 0
```

**Customize Radio Button Appearance Inside Group:**
```swift
radioGroup.configureRadioButton { radioButton in
    radioButton.titleColorInactive = .black
    radioButton.titleColorActive = .blue
    radioButton.iconBgColorActive = .blue
}
```

---

## RadioButton States

| State Name | Value | Description |
| ---------- | ----- | ----------- |
| `Default` | `"default"` | Default idle state |
| `Disabled` | `"disabled"` | Non-interactive state |

---

## RadioGroup Display Modes

| Mode | Description |
| ---- | ----------- |
| `.vertical` | Single-column vertical list (default) |
| `.horizontal` | Horizontally scrolling single-row list |
| `.spanGrid(Int)` | Multi-column grid with specified number of columns |

**Example:**
```swift
radioGroup.displayMode = .spanGrid(2)  // 2-column grid
```

---

## RadioButton — Properties Reference

### General Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `radioBtnState` | `String?` | `"default"` | Button state |
| `isActive` | `Bool` | `false` | Controls active/inactive selection state |
| `spacing` | `CGFloat` | `8.0` | Spacing between bullet/icon and text stack |
| `labelSpacing` | `CGFloat` | `4.0` | Spacing between title and description labels |

### Title Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `title` | `String?` | `"Title radio button"` | Title text |
| `titleAttributed` | `NSAttributedString?` | `nil` | Attributed title text (overrides `title`) |
| `titleColorInactive` | `UIColor?` | `EDTSColor.grey60` | Title color when inactive |
| `titleColorActive` | `UIColor?` | `EDTSColor.grey60` | Title color when active |
| `titleFontName` | `String` | `System font` | Custom font name for title (falls back to system font if not found) |
| `titleFontSize` | `CGFloat` | `14.0` | Font size for title |
| `titleFontWeight` | `String` | `"Medium"` | Font weight for title (`ultralight`, `thin`, `light`, `regular`, `medium`, `semibold`, `bold`, `heavy`, `black`) |

### Description Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `desc` | `String?` | `"Body text goes here"` | Description text |
| `descAttributed` | `NSAttributedString?` | `nil` | Attributed description text (overrides `desc`) |
| `descColorInactive` | `UIColor?` | `EDTSColor.grey50` | Description color when inactive |
| `descColorActive` | `UIColor?` | `EDTSColor.grey50` | Description color when active |
| `descFontName` | `String` | `System font` | Custom font name for description (falls back to system font if not found) |
| `descFontSize` | `CGFloat` | `12.0` | Font size for description |
| `descFontWeight` | `String` | `"Regular"` | Font weight for description |

### Icon Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `iconInactive` | `UIImage?` | `nil` | Custom icon image for inactive state |
| `iconActive` | `UIImage?` | `nil` | Custom icon image for active state |
| `iconTintColorInactive` | `UIColor?` | `EDTSColor.white` | Icon tint color when inactive |
| `iconTintColorActive` | `UIColor?` | `EDTSColor.white` | Icon tint color when active |
| `iconBgColorInactive` | `UIColor?` | `EDTSColor.white` | Icon container background color when inactive |
| `iconBgColorActive` | `UIColor?` | `EDTSColor.blue50` | Icon container background color when active |
| `iconPadding` | `CGFloat` | `0.0` | Padding inside the icon container |

### Border Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `borderWidth` | `CGFloat` | `1.0` | Border width of the bullet container |
| `borderColorInactive` | `UIColor?` | `EDTSColor.grey30` | Border color when inactive |
| `borderColorActive` | `UIColor?` | `UIColor.clear` | Border color when active |

### Padding Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `paddingTop` | `CGFloat` | `0.0` | Top inset inside the radio button container |
| `paddingBottom` | `CGFloat` | `0.0` | Bottom inset inside the radio button container |
| `paddingLeading` | `CGFloat` | `2.0` | Leading inset inside the radio button container |
| `paddingTrailing` | `CGFloat` | `0.0` | Trailing inset inside the radio button container |

---

## RadioButton — State-Specific Styling

### Default State

| Sub-state | Title Color | Desc Color | Background | Icon Tint | Border |
| --------- | ----------- | ---------- | ---------- | ---------------- | ------ |
| Inactive | `grey60` | `grey50` | `white` | `white` | `grey30` |
| Active | `grey60` | `grey50` | `blue50` | `white` | `clear` |

### Disabled State

| Sub-state | Title Color | Desc Color | Background | Icon Tint | Border |
| --------- | ----------- | ---------- | ---------- | ---------------- | ------ |
| Inactive | `grey40` | `grey30` | `grey20` | `grey20` | `grey30` |
| Active | `grey40` | `grey30` | `grey20` | `grey40` | `grey40` |

> **Note:** Setting any color property to a non-nil value overrides the state default for that property.

---

## RadioGroup — Properties Reference

### Data Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `data` | `[[String]]` | `[]` | Array of `[title, description]` string pairs for each radio item. Setting this clears `dataAttributed`. |
| `dataAttributed` | `[[NSAttributedString]]` | `[]` | Array of `[title, description]` attributed string pairs. Setting this clears `data`. |
| `selectedIndex` | `Int` | `-1` | Index of the currently selected item. `-1` means no selection. |
| `displayMode` | `ItemDisplayMode` | `.vertical` | Layout mode for the collection (`.vertical`, `.horizontal`, `.spanGrid(Int)`) |

### Spacing Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `horizontalSpacing` | `Int` | `8` | Horizontal spacing between items |
| `verticalSpacing` | `Int` | `8` | Vertical spacing between rows |

### Padding Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `paddingTop` | `CGFloat` | `0.0` | Top section inset of the collection |
| `paddingBottom` | `CGFloat` | `0.0` | Bottom section inset of the collection |
| `paddingLeading` | `CGFloat` | `0.0` | Leading section inset of the collection |
| `paddingTrailing` | `CGFloat` | `0.0` | Trailing section inset of the collection |

---

## Delegate Protocol

### RadioButtonDelegate

```swift
@MainActor
public protocol EDTSRadioButtonDelegate: AnyObject {
    func didSelectRadioButton(_ radioButton: EDTSRadioButton)
}
```

Used by standalone `EDTSRadioButton`. When used inside `EDTSRadioGroup`, delegation is managed internally — `EDTSRadioGroup` conforms to `EDTSRadioButtonDelegate` and handles selection automatically.

---

## Animation Details

| Animation Type | Duration | Easing | Description |
| -------------- | -------- | ------ | ----------- |
| Bullet fade in | `150ms` | `EaseInOut` | Fades the inner bullet from 50% to full opacity on activation |
| Bullet scale in | `200ms` | `EaseInOut` | Scales the inner bullet from 50% to 100% size on activation |
| Color transition | `250ms` | `EaseInOut` | Animates bullet, title, and description color changes on state toggle |
| Ripple Effect | `400ms` | `EaseOut` | Circular ripple effect expanding behind the box container on press |

---

## `ItemDisplayMode` Enum

```swift
public enum ItemDisplayMode {
    case vertical
    case horizontal
    case spanGrid(Int)
}
```

| Case | Scroll Direction | Columns | Description |
| ---- | ---------------- | ------- | ----------- |
| `.vertical` | Vertical | 1 | Single-column stacked list |
| `.horizontal` | Horizontal | 1 | Single-row horizontally scrollable list |
| `.spanGrid(Int)` | Vertical | N | Multi-column grid; pass the desired column count |

---

## Notes

- When `iconInactive` or `iconActive` is set on `EDTSRadioButton`, the bullet indicator is hidden and replaced by the custom icon image rendered as a template (tintable)
- `EDTSRadioGroup` manages `selectedIndex` and active state automatically; manually setting `isActive` on individual cells inside a group is not recommended
- Setting `data` clears `dataAttributed` and vice versa — only one data source is active
- `configureRadioButton(_:)` can be used to customize every radio button instance rendered inside `EDTSRadioGroup`

*For further customization, you can ask UX Engineer or inherit `EDTSRadioButton` and override its methods, or add additional functionality as required.*
