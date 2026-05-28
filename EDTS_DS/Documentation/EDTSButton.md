# EDTSButton

`EDTSButton` is a customizable button component that supports multiple types (primary, secondary, tertiary), states (default, focus, danger, disabled), and sizes (small, medium, large). The component features optional leading and trailing icons, and gradient backgrounds.

## Preview

| Feature / Variation | Preview | Default | Danger | Disabled |
| ------------------- | ------- | ---- | ------ | -------- |
| **Primary Button** |![Primary Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103311/primary_large_rest_irpbww.gif)|![Primary Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103311/primary_large_rest_irpbww.gif)|![Primary Danger Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103309/primary_large_danger_qi2nbs.gif)|![Primary Disabled Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103310/primary_large_disabled_u9tweb.png)|
| **Secondary Button** |![Secondary Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103310/secondary_medium_rest_mhvaea.gif)|![Secondary Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103310/secondary_medium_rest_mhvaea.gif)|![Secondary Danger Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103310/secondary_medium_danger_tlesov.gif)|![Secondary Disabled Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103308/secondary_medium_disabled_hcpoxe.png)|
| **Tertiary Button** |![Tertiary Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103309/tertiary_small_rest_cjjdcw.gif)|![Tertiary Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103309/tertiary_small_rest_cjjdcw.gif)|![Tertiary Danger Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103308/tertiary_small_danger_u5r1ow.gif)|![Tertiary Disabled Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103311/tertiary_small_disabled_h0cfee.png)|
| **Default** |![Default Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103309/default_rjnsvq.gif)| | | |
| **Gradient Background** |![Button With Gradient Background](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103308/gradient_background_mmt7ab.gif)| | | |
| **Text Button** |![Text Button](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1770103310/text_button_v79hxo.gif)| | | |

## Basic Usage

### 1. Add to Layout

**Swift (Storyboard/XIB):**
```swift
// Add UIButton from Interface Builder
// Set Custom Class to EDTSButton in Identity Inspector
```

**Swift (Programmatic):**
```swift
let button = EDTSButton(frame: .zero)
view.addSubview(button)
```

### 2. Initialize in Code

```swift
// Configure the button
button.label = "Submit"
button.btnType = "primary"
button.btnSize = "large"
button.btnState = "default"

// Add target action
button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)

@objc func handleButtonTap() {
    print("Button tapped")
}
```

## Button Types

| Type Name | Value | Description |
| --------- | ----- | ----------- |
| `Primary` | `"primary"` | Filled button with brand color |
| `Secondary` | `"secondary"` | White background with colored border |
| `Tertiary` | `"tertiary"` | Subtle button with grey tones |


## Button States

| State Name | Value | Description |
| ---------- | ----- | ----------- |
| `Default` | `"default"` | Default idle state |
| `Focus` | `"focus"` | Focus state |
| `Danger` | `"danger"` | Destructive action state |
| `Disabled` | `"disabled"` | Non-interactive state |

## Button Sizes

| Size Name | Value | Icon Size | Font Size | Padding (V) | Padding (H) | Corner Radius | Spacing |
| --------- | ----- | --------- | --------- | ----------- | ----------- | ------------- | ------- |
| `Small` | `"small"` | 16pt | 12pt | 6pt | 12pt | 4pt | 8pt |
| `Medium` | `"medium"` | 16pt | 14pt | 8pt | 12pt | 4pt | 8pt |
| `Large` | `"large"` | 24pt | 14pt | 8pt | 12pt | 4pt | 8pt |

## Properties Reference

### General Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `btnType` | `String?` | `"primary"` | Button type (primary, secondary, tertiary) |
| `btnState` | `String?` | `"default"` | Button state (default, focus, danger, disabled) |
| `btnSize` | `String?` | `"large"` | Button size (small, medium, large) |
| `label` | `String?` | `"Button"` | Text displayed on the button |
| `labelAttributed` | `NSAttributedString?` | `nil` | Attributed text for the button (overrides `label`) |
| `cornerRadius` | `CGFloat` | `4pt` (Size-dependent) | Corner radius of the button |

### Text Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `labelColor` | `UIColor?` | `Type-dependent` | Title text color for default state |
| `labelFocusColor` | `UIColor?` | `Type-dependent` | Title text color for focus state |
| `labelDangerColor` | `UIColor?` | `Type-dependent` | Title text color for danger state |
| `labelDisabledColor` | `UIColor?` | `Type-dependent` | Title text color for disabled state |
| `fontName` | `String` | `System font` | Custom font name (falls back to system font if not found) |
| `fontSize` | `CGFloat` | `Size-dependent` | Font size for title text |
| `fontWeight` | `String?` | `Size-dependent` | Font weight (ultralight, thin, light, regular, medium, semibold, bold, heavy, black) |

### Icon Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `iconLeading` | `UIImage?` | `nil` | Leading icon image (shows icon when set, hides when nil) |
| `iconTintColorLeading` | `UIColor?` | `Type-dependent` | Leading icon tint color for default state |
| `iconFocusTintColorLeading` | `UIColor?` | `Type-dependent` | Leading icon tint color for focus state |
| `iconDangerTintColorLeading` | `UIColor?` | `Type-dependent` | Leading icon tint color for danger state |
| `iconDisabledTintColorLeading` | `UIColor?` | `Type-dependent` | Leading icon tint color for disabled state |
| `iconTrailing` | `UIImage?` | `nil` | Trailing icon image (shows icon when set, hides when nil) |
| `iconTintColorTrailing` | `UIColor?` | `Type-dependent` | Trailing icon tint color for default state |
| `iconFocusTintColorTrailing` | `UIColor?` | `Type-dependent` | Trailing icon tint color for focus state |
| `iconDangerTintColorTrailing` | `UIColor?` | `Type-dependent` | Trailing icon tint color for danger state |
| `iconDisabledTintColorTrailing` | `UIColor?` | `Type-dependent` | Trailing icon tint color for disabled state |
| `iconSize` | `CGFloat` | `Size-dependent` | Size for both leading and trailing icons |
| `iconSpacing` | `CGFloat` | `Size-dependent` | Spacing between icon and title elements |

### Background Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `bgColor` | `UIColor?` | `Type/state-dependent` | Button background color for default state (ignored if gradient is set) |
| `bgFocusColor` | `UIColor?` | `Type-dependent` | Background color for focus state (ignored if gradient is set) |
| `bgDangerColor` | `UIColor?` | `Type-dependent` | Background color for danger state (ignored if gradient is set) |
| `bgDisabledColor` | `UIColor?` | `Type-dependent` | Background color for disabled state |
| `bgColorStart` | `UIColor?` | `nil` | Start color for gradient background |
| `bgColorEnd` | `UIColor?` | `nil` | End color for gradient background |
| `bgColorOrientation` | `String?` | `"vertical"` | Gradient direction: `"horizontal"` or `"vertical"` |
| `rippleColor` | `UIColor?` | `nil` | Custom ripple color. Defaults to iconTintColor or grey70 at 12% opacity based on background |

### Border Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `borderWidth` | `CGFloat` | `Type/state-dependent` | Border width |
| `borderColor` | `UIColor?` | `Type/state-dependent` | Border color for default state |
| `borderFocusColor` | `UIColor?` | `Type-dependent` | Border color for focus state |
| `borderDangerColor` | `UIColor?` | `Type-dependent` | Border color for danger state |
| `borderDisabledColor` | `UIColor?` | `Type-dependent` | Border color for disabled state |

### Padding Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `paddingTop` | `CGFloat` | `Size-dependent` | Top padding inside button |
| `paddingBottom` | `CGFloat` | `Size-dependent` | Bottom padding inside button |
| `paddingLeading` | `CGFloat` | `Size-dependent` | Leading padding inside button |
| `paddingTrailing` | `CGFloat` | `Size-dependent` | Trailing padding inside button |

### Shadow Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `shadowOpacity` | `Float` | `0.0` | Shadow opacity |
| `shadowRadius` | `CGFloat` | `0.0` | Shadow blur radius |
| `shadowOffset` | `CGSize` | `CGSize.zero` | Shadow offset from button |
| `shadowColor` | `UIColor?` | `nil` | Shadow color for default state |
| `shadowFocusColor` | `UIColor?` | `nil` | Shadow color for focus state |
| `shadowDangerColor` | `UIColor?` | `nil` | Shadow color for danger state |
| `shadowDisabledColor` | `UIColor?` | `nil` | Shadow color for disabled state |

## Type-Specific Styling

### Primary Button States

| State | Background | Text Color | Border | Icon Tint |
| ----- | ---------- | ---------- | ------ | --------- |
| Default | `blueDefault` | `white` | None | `white` |
| Focus | `blueDefault` | `white` | 2pt `blue30` | `white` |
| Danger | `errorStrong` | `white` | None | `white` |
| Disabled | `disabled` | `white` | None | `white` |

### Secondary Button States

| State | Background | Text Color | Border | Icon Tint |
| ----- | ---------- | ---------- | ------ | --------- |
| Default | `white` | `blueDefault` | 1pt `blueDefault` | `blueDefault` |
| Focus | `white` | `blueDefault` | 2pt `blue30` | `blueDefault` |
| Danger | `white` | `errorStrong` | 1pt `errorStrong` | `errorStrong` |
| Disabled | `white` | `disabled` | 1pt `disabled` | `disabled` |

### Tertiary Button States

| State | Background | Text Color | Border | Icon Tint |
| ----- | ---------- | ---------- | ------ | --------- |
| Default | `white` | `greyText` | 1pt `greyDefault` | `greyText` |
| Focus | `grey20` | `greyText` | 2pt `greyPressed` | `greyText` |
| Danger | `white` | `errorStrong` | 1pt `disabled` | `errorStrong` |
| Disabled | `white` | `disabled` | 1pt `disabled` | `disabled` |

## Animation Details

| Animation Type | Duration | Interpolator | Description |
| -------------- | -------- | ------------ | ----------- |
| `Scale Down` | `100ms` | `EaseInOut` | Scales button to 95% on touch down |
| `Scale Up` | `100ms` | `EaseInOut` | Returns button to original size on touch up/cancel |
| `Ripple Effect` | `400ms` | `EaseOut` | Full ripple animation on button tap (unless a gradient background (bgColorStart / bgColorEnd) is set) |

## Property Resolution Behavior

The button uses a **fallback system** where custom property values take precedence over preset defaults:

### Size Preset Resolution
When a size preset is applied (small, medium, large), the button checks each size-related property:
- If the property value is **zero** (default), the button uses the **preset value**
- If the property value is **non-zero**, the button uses the **custom value**

**Example:**
```swift
button.btnSize = "large"      // Preset: iconSize=24, fontSize=14, padding=8/12
button.iconSize = 32          // Custom value overrides preset → uses 32
button.fontSize = 0           // Zero value → uses preset default 14
```

### Type/State Styling Resolution
When a type/state combination is applied, the button checks each styling property:
- If the property value is **nil**, the button uses the **type/state default**
- If the property value is **non-nil**, the button uses the **custom value**

**Example:**
```swift
button.btnType = "primary"    // Preset: bgColor=blueDefault, labelColor=white
button.btnState = "default"
button.bgColor = .red         // Custom value overrides preset → uses red
button.labelColor = nil       // Nil value → uses preset default white
```

## Notes

- Icons are automatically shown/hidden based on whether `iconLeading` or `iconTrailing` are set to non-nil values
- Gradient background is enabled when `bgColorStart` or `bgColorEnd` are set; when enabled, `bgColor` is ignored
- The `disabled` state automatically sets `isUserInteractionEnabled = false`

*For further customization, you can ask UX Engineer or inherit `EDTSButton` and override its methods, or add additional functionality as required.*
