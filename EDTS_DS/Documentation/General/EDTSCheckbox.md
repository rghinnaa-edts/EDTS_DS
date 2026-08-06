# EDTSCheckbox

`EDTSCheckbox` is a customizable checkbox component featuring a box indicator with a checkmark or indeterminate icon, title, and description text. It supports two states (`default`, `disabled`), two types (`checked`, `indeterminated`), full active/inactive styling, and ripple feedback on tap.

---

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Default — Inactive (Checked)** | ![Checkbox Default Inactive Checked](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077901/checkbox_active_uncheck_ur62qy.gif) |
| **Default — Active (Checked)** | ![Checkbox Default Active Checked](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077899/checkbox_active_checked_arwqrs.png) |
| **Default — Active (Indeterminate)** | ![Checkbox Default Active Indeterminate](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077900/checkbox_active_indeterminated_osnuut.png) |
| **Disabled — Inactive** | ![Checkbox Disabled Inactive](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077898/checkbox_disabled_uncheck_qimqjb.png) |
| **Disabled — Active (Checked)** | ![Checkbox Disabled Active](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077903/checkbox_disabled_checked_qyyuch.png) |
| **Disabled — Active (Indeterminate)** | ![Checkbox Disabled Active](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077902/checkbox_disabled_indeterminated_ywcvbt.png) |

---

## Basic Usage

### Swift (Programmatic)

```swift
let checkbox = EDTSCheckbox(frame: .zero)
view.addSubview(checkbox)

checkbox.title = "Accept terms and conditions"
checkbox.desc = "By checking this you agree to our terms"
checkbox.checkboxState = "default"
checkbox.checkboxType = "checked"
checkbox.isActive = false
checkbox.delegate = self
```

### Implement Delegate

```swift
extension ViewController: EDTSCheckboxDelegate {
    func didSelectCheckbox(_ checkbox: EDTSCheckbox) {
        checkbox.isActive.toggle()
    }
}
```

### Swift (Storyboard / XIB)

```swift
// Add UIView from Interface Builder
// Set Custom Class to EDTSCheckbox in Identity Inspector
```

---

## Checkbox States

| State Name | Value | Description |
| ---------- | ----- | ----------- |
| `Default` | `"default"` | Default interactive state |
| `Disabled` | `"disabled"` | Non-interactive state |

---

## Checkbox Types

| Type Name | Value | Description |
| --------- | ----- | ----------- |
| `Checked` | `"checked"` | Displays a checkmark icon inside the box when active |
| `Indeterminated` | `"indeterminated"` | Displays a minus icon inside the box when active |

> **Note:** Setting a custom `icon` overrides the type-based icon for both `checked` and `indeterminated` types.

---

## Properties Reference

### General Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `checkboxState` | `String?` | `"default"` | Checkbox state (`default`, `disabled`) |
| `checkboxType` | `String?` | `"checked"` | Checkbox type (`checked`, `indeterminated`) |
| `isActive` | `Bool` | `false` | Controls active/inactive selection state |
| `spacing` | `CGFloat` | `8.0` | Spacing between box and text stack |
| `labelSpacing` | `CGFloat` | `4.0` | Spacing between title and description labels |

### Title Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `title` | `String?` | `"Title checkboxes"` | Title text |
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
| `icon` | `UIImage?` | `nil` | Custom icon image (overrides the type-based checkmark/minus icon when set) |
| `iconTintColorInactive` | `UIColor?` | `EDTSColor.white` | Icon tint color when inactive |
| `iconTintColorActive` | `UIColor?` | `EDTSColor.white` | Icon tint color when active |

### Box Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `boxBgColorInactive` | `UIColor?` | `EDTSColor.white` | Box background color when inactive |
| `boxBgColorActive` | `UIColor?` | `EDTSColor.blue50` | Box background color when active |
| `borderWidth` | `CGFloat` | `1.0` | Border width of the box container |
| `borderColorInactive` | `UIColor?` | `EDTSColor.grey30` | Box border color when inactive |
| `borderColorActive` | `UIColor?` | `UIColor.clear` | Box border color when active |

### Padding Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `paddingTop` | `CGFloat` | `0.0` | Top inset inside the checkbox container |
| `paddingBottom` | `CGFloat` | `0.0` | Bottom inset inside the checkbox container |
| `paddingLeading` | `CGFloat` | `2.0` | Leading inset inside the checkbox container |
| `paddingTrailing` | `CGFloat` | `0.0` | Trailing inset inside the checkbox container |

---

## State-Specific Styling

### Default State

| Sub-state | Title Color | Desc Color | Box BG | Icon Tint | Box Border |
| --------- | ----------- | ---------- | ------ | --------- | ---------- |
| Inactive | `grey60` | `grey50` | `white` | `white` | `grey30` |
| Active | `grey60` | `grey50` | `blue50` | `white` | `clear` |

### Disabled State

| Sub-state | Title Color | Desc Color | Box BG | Icon Tint | Box Border |
| --------- | ----------- | ---------- | ------ | --------- | ---------- |
| Inactive | `grey40` | `grey30` | `grey20` | `grey20` | `grey30` |
| Active | `grey40` | `grey30` | `grey20` | `grey40` | `grey40` |

> **Note:** Setting any color property to a non-nil value overrides the state default for that property.

---

## Delegate Protocol

```swift
@MainActor
public protocol EDTSCheckboxDelegate: AnyObject {
    func didSelectCheckbox(_ checkbox: EDTSCheckbox)
}
```

---

## Enums Reference

### `CheckboxState`

```swift
public enum EDTSCheckboxState: String {
    case default = "default"
    case disabled = "disabled"
}
```

### `CheckboxType`

```swift
public enum EDTSCheckboxType: String {
    case checked = "checked"
    case indeterminated = "indeterminated"
}
```

---

## Animation Details

| Animation Type | Duration | Easing | Description |
| -------------- | -------- | ------ | ----------- |
| Icon fade in | `150ms` | `EaseInOut` | Fades the icon from 50% to full opacity on activation |
| Color transition | `250ms` | `EaseInOut` | Animates box background, border, title, and description color changes on state toggle |
| `Ripple Effect` | `400ms expand + 220ms fade out` | `EaseOut` | Circular ripple effect expanding behind the icon container on tap |

---

## Notes

- When `icon` is set, it replaces the type-based icon (`ic-check` or `ic-minus`) for all states
- Setting `checkboxType` has no effect when a custom `icon` is provided — the custom icon always takes precedence
- The `disabled` state automatically disables user interaction on the box container

---

*For further customization, you can ask UX Engineer or inherit `EDTSCheckbox` and override its methods, or add additional functionality as required.*
