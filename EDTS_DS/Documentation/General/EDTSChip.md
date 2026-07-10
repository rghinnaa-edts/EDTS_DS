# EDTSChip

`EDTSChip` is a customizable chip component that supports active/inactive states, optional leading and trailing icons, and extensive styling options. The component features ripple animations on tap and individual icon interaction support.

## Preview

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Basic Chip** |![Default Chip](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1781077809/chip_default_active_nps4ik.gif)|
| **Chip With Icon** |![Chip With iconLeading, iconTrailing, iconBgColorLeading and iconBgColorTrailing](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770101059/chip_with_icon_njdzk1.png)|

## Basic Usage

### 1. Add to Layout

**Swift (Storyboard/XIB):**
```swift
// Add UIView from Interface Builder
// Set Custom Class to EDTSChip in Identity Inspector
```

**Swift (Programmatic):**
```swift
let chip = EDTSChip(frame: .zero)
view.addSubview(chip)
```

### 2. Initialize in Code

```swift
// Configure the chip
chip.label = "Category"
chip.iconLeading = UIImage(systemName: "tag.fill")
chip.isActive = false
chip.delegate = self

// Implement delegate
extension ViewController: ChipDelegate {
    func didSelectChip(_ chip: EDTSChip) {
        print("Chip tapped")
        chip.isActive.toggle()
    }
    
    func didSelectChipIconLeading(_ chip: EDTSChip) {
        print("Leading icon tapped")
    }
    
    func didSelectChipIconTrailing(_ chip: EDTSChip) {
        print("Trailing icon tapped")
    }
}
```

## Display States

| State Name | Property | Description |
| ---------- | -------- | ----------- |
| `Inactive` | `isActive = false` | Default unselected state |
| `Active` | `isActive = true` | Selected/highlighted state |

## Properties Reference

### General Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `label` | `String?` | `"Label"` | Text displayed on the chip |
| `labelAttributed` | `String?` | `nil` | Attributed text for the chip (overrides `label`) |
| `cornerRadius` | `CGFloat` | `.applyCircular()` | Corner radius |
| `borderWidth` | `CGFloat` | `0.0` | Border width for the chip container |

### Text Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `fontName` | `String` | `System font` | Custom font name (falls back to system font if not found) |
| `fontSize` | `CGFloat` | `12.0` | Font size for title text |
| `fontWeight` | `String` | `"Semibold"` | Font weight (ultralight, thin, light, regular, medium, semibold, bold, heavy, black) |
| `labelColor` | `UIColor?` | `.blue50` | Title text color when inactive |
| `labelColorActive` | `UIColor?` | `EDTSColor.white` | Title text color when active |

### Icon Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `iconLeading` | `UIImage?` | `nil` | Leading icon image (shows icon when set, hides when nil) |
| `iconTrailing` | `UIImage?` | `nil` | Trailing icon image (shows icon when set, hides when nil) |
| `iconSize` | `CGFloat` | `20.0` | Size for both leading and trailing icons |
| `iconSpacing` | `CGFloat` | `4.0` | Spacing between icon and title elements |

### Padding Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `paddingTop` | `CGFloat` | `4.0` | Top padding inside chip |
| `paddingBottom` | `CGFloat` | `4.0` | Bottom padding inside chip |
| `paddingLeading` | `CGFloat` | `8.0` | Leading padding inside chip |
| `paddingTrailing` | `CGFloat` | `8.0` | Trailing padding inside chip |

### Inactive State Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `iconTintColorLeading` | `UIColor?` | `.blue50` | Leading icon tint color when inactive |
| `iconBgColorLeading` | `UIColor?` | `.white` | Leading icon background color when inactive |
| `iconTintColorTrailing` | `UIColor?` | `.blue50` | Trailing icon tint color when inactive |
| `iconBgColorTrailing` | `UIColor?` | `.white` | Trailing icon background color when inactive |
| `bgColor` | `UIColor?` | `.grey20` | Chip background color when inactive |
| `borderColor` | `UIColor?` | `UIColor.clear.cgColor` | Chip border color when inactive |
| `shadowOpacity` | `Float` | `Float.zero` | Shadow opacity when inactive |
| `shadowRadius` | `CGFloat` | `CGFloat.zero` | Shadow blur radius when inactive |
| `shadowOffset` | `CGSize` | `CGSize.zero` | Shadow offset when inactive |
| `shadowColor` | `UIColor?` | `UIColor.clear.cgColor` | Shadow color when inactive |

### Active State Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `iconTintColorLeadingActive` | `UIColor?` | `.blue50` | Leading icon tint color when active |
| `iconBgColorLeadingActive` | `UIColor?` | `.white` | Leading icon background color when active |
| `iconTintColorTrailingActive` | `UIColor?` | `.blue50` | Trailing icon tint color when active |
| `iconBgColorTrailingActive` | `UIColor?` | `.white` | Trailing icon background color when active |
| `bgColorActive` | `UIColor?` | `.blue50` | Chip background color when active |
| `borderColorActive` | `UIColor?` | `UIColor.clear.cgColor` | Chip border color when active |
| `shadowOpacityActive` | `Float` | `Float.zero` | Shadow opacity when active |
| `shadowRadiusActive` | `CGFloat` | `CGFloat.zero` | Shadow blur radius when active |
| `shadowOffsetActive` | `CGSize` | `CGSize.zero` | Shadow offset when active |
| `shadowColorActive` | `UIColor?` | `UIColor.clear.cgColor` | Shadow color when active |

## Delegate Protocol

```swift
@MainActor
public protocol ChipDelegate: AnyObject {
    func didSelectChip(_ chip: EDTSChip)
    func didSelectChipIconLeading(_ chip: EDTSChip)
    func didSelectChipIconTrailing(_ chip: EDTSChip)
}
```

## Animation Details

| Animation Type | Duration | Interpolator | Description |
| -------------- | -------- | ------------ | ----------- |
| `Color Transition` | `250ms` | `EaseInOut` | Animates colors, borders, and backgrounds when toggling between active/inactive |
| `Ripple Effect` | `400ms expand + 220ms fade out` | `EaseOut` | Supports two ripple variants: full-component ripple from touch point on tap, and circular ripple effect expanding behind the icon container on tap |

### Animation Behavior

- **Chip Tap**: Full ripple effect across the entire chip surface
- **Icon Tap**: Circular ripple constrained to icon area
- **State Change**: Smooth color transitions for all visual elements

## Property Resolution Behavior

The chip uses a **multi-level fallback system** for active state properties:

### Inactive State
When `isActive = false`, inactive properties use their values with single-level fallback to hardcoded defaults:
- If property is set → use property value
- If property is nil/zero → use hardcoded default

**Example:**
```swift
chip.labelColor = .red         // Uses .red
chip.labelColor = nil          // Uses .blue50 (hardcoded default)
```

### Active State
When `isActive = true`, active properties use a **two-level fallback chain**:
- If active property is set → use active property value
- If active property is nil/zero → fall back to inactive property value
- If inactive property is also nil/zero → use hardcoded default

**Example:**
```swift
chip.labelColor = .red              // Inactive: .red
chip.labelColorActive = .green      // Active: .green (uses active value)

chip.labelColor = .red              // Inactive: .red
chip.labelColorActive = nil         // Active: .red (falls back to inactive)

chip.labelColor = nil               // Inactive: .blue50 (hardcoded default)
chip.labelColorActive = nil         // Active: .white (falls back to inactive → default chain)
```

## Notes

- Icons are automatically shown/hidden based on whether `iconLeading` or `iconTrailing` are set to non-nil values
- When `cornerRadius` is not equal to 0, it applies the specified corner radius; when it equals 0, it applies a circular shape using `applyCircular()`
- The fallback system ensures that active state can inherit from inactive state, providing flexible customization
- Shadow properties default to zero values when not set

*For further customization, you can ask UX Engineer or inherit `EDTSChip` and override its methods, or add additional functionality as required.*
