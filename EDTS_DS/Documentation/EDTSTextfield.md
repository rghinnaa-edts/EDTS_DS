# EDTSTextField
The `EDTSTextField` component is a fully customizable UIKit text field with built-in support for multiple states, icons, character counter, support messages, password toggle, and per-state theming.
 
## Features
- Four built-in states: `default`, `focus`, `error`, `disabled`
- Per-state color theming for label, placeholder, value, icons, background, border, support message, and counter
- Leading and trailing icon support
- Built-in password toggle with show/hide icon
- Character counter with max limit enforcement
- Required field indicator (`*`)
- Support/helper message below the field
- Clearable mode with animated clear button
- Delegate callbacks for icon interactions
- Fully `IBDesignable` & `IBInspectable` — configurable in Interface Builder
- Configurable keyboard type and return key type
- Intrinsic content size support

## Preview
![Text Field Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1779176347/WhatsApp_GIF_2026-05-19_at_14.35.04_x3phsr.gif)
| State             | Preview                 |
|-------------------|-------------------------|
| `Default`         | ![Default Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_80/v1779176325/Screenshot_2026-05-19_at_14.38.38_mdbmmu.png) |
| `Focus`           | ![Focus Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_80/v1779177171/Screenshot_2026-05-19_at_14.52.46_byq8hv.png) |
| `Error`           | ![Error Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_80/v1779177095/Screenshot_2026-05-19_at_14.51.30_sayl05.png) |
| `Disabled`        | ![Disabled Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_80/v1779177130/Screenshot_2026-05-19_at_14.52.06_bsa40r.png) |

## Installation
Add the following files into your project:
- `EDTSTextField.swift`
- `EDTSTextField.xib`

## Usage
Initialize and configure the component programmatically.

### Basic Example
```swift
let textField = EDTSTextField(frame: .zero)
textField.label = "Full name"
textField.placeholder = "Enter your name"
textField.isRequired = true
textField.supportMessage = "As shown on your ID"
textField.onTextChanged = { text in
    print("Changed: \(text)")
}
```

### With Icons and Counter
```swift
let textField = EDTSTextField(frame: .zero)
textField.label = "Email"
textField.placeholder = "you@example.com"
textField.iconLeading = UIImage(systemName: "envelope")
textField.iconTrailing = UIImage(systemName: "checkmark.circle")
textField.keyboardType = .emailAddress
textField.counterMax = 100
```

### Password Field
```swift
let textField = EDTSTextField(frame: .zero)
textField.label = "Password"
textField.placeholder = "Enter password"
textField.isPassword = true          // enables secure entry + eye toggle
// textField.isPasswordToggleHide = true  // hides the eye button
```

### Clearable Field
```swift
let textField = EDTSTextField(frame: .zero)
textField.label = "Search"
textField.placeholder = "Type to search..."
textField.isClearable = true  // shows animated clear (✕) button when text is present
```

### Clickable Icons with Delegate
```swift
class MyVC: UIViewController, EDTSTextFieldDelegate {
    let textField = EDTSTextField(frame: .zero)
 
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.iconLeading = UIImage(systemName: "magnifyingglass")
        textField.isIconLeadingClickable = true
        textField.setDelegate(self)
    }
 
    func didSelectTextFieldIconLeading(_ textField: EDTSTextField) {
        print("Leading icon tapped")
    }
 
    func didSelectTextFieldIconTrailing(_ textField: EDTSTextField) {
        print("Trailing icon tapped")
    }
}
```

### Triggering Error State
```swift
// Set error state manually
textField.isStateError = true
textField.supportMessage = "This field is required"

// Reset back to default
textField.isStateDefault = true
textField.supportMessage = nil
```

---

## State Enum

```swift
public enum EDTSTextFieldState: String {
    case `default` = "default"
    case focus    = "focus"
    case error    = "error"
    case disabled = "disabled"
}
```

> `focus` and `default` states transition automatically on `editingDidBegin` / `editingDidEnd`.
> Set `isStateError` or `isStateDisabled` manually to override.

---

## Parameters

### Text & Label

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | `nil` | Label text displayed above the field |
| `labelAttributed` | `String` | `nil` | Label Attributed text displayed above the field |
| `isLabelHide` | `Bool` | `false` | Hides label and adjusts layout spacing |
| `isRequired` | `Bool` | `false` | Shows a red asterisk (`*`) next to the label |
| `placeholder` | `String` | `nil` | Placeholder text inside the text field |
| `value` | `String` | `nil` | Sets the text field value programmatically |
| `supportMessage` | `String` | `nil` | Helper or error text shown below the field |
| `counterMax` | `Int` | `-1` | Enables character counter; `-1` = disabled |
| `isCounterHide` | `Bool` | `false` | Hides counter even when `counterMax` is set |

### Icons & Interaction

| Parameter | Type | Default | Description |
|---|---|---|---|
| `iconLeading` | `UIImage?` | `nil` | Icon displayed on the left side of the field |
| `iconTrailing` | `UIImage?` | `nil` | Icon on the right; hidden when `isPassword` is `true` |
| `isIconLeadingClickable` | `Bool` | `false` | Enables user interaction on the leading icon |
| `isIconTrailingClickable` | `Bool` | `false` | Enables user interaction on the trailing icon |
| `isPassword` | `Bool` | `false` | Enables secure text entry with eye toggle button |
| `isPasswordToggleHide` | `Bool` | `false` | Hides the eye button when in password mode |
| `isClearable` | `Bool` | `false` | Shows an animated clear (✕) button when the field has text; overrides `iconTrailing` |
| `isEditable` | `Bool` | `false` | When `true`, disables text input (field becomes read-only) |
| `isStateDisabled` | `Bool` | `false` | Sets the field to `disabled` state and disables text input |
| `keyboardType` | `UIKeyboardType` | `.alphabet` | Keyboard type for the input |
| `returnKeyType` | `UIReturnKeyType` | `.done` | Return key label on the keyboard |

### Layout & Appearance

| Parameter | Type | Default | Description |
|---|---|---|---|
| `cornerRadius` | `CGFloat` | `4.0` | Corner radius of the text field container |
| `padding` | `CGFloat` | `4.0` | Sets all four padding sides at once |
| `paddingLeading` | `CGFloat` | `12.0` | Leading (left) inner padding |
| `paddingTrailing` | `CGFloat` | `12.0` | Trailing (right) inner padding |
| `paddingTop` | `CGFloat` | `12.0` | Top inner padding |
| `paddingBottom` | `CGFloat` | `12.0` | Bottom inner padding |

### Font Customization

Each text element (label, placeholder, value, support message, counter) supports font customization via:

| Property Pattern | Type | Description |
|---|---|---|
| `*fontName` | `String` | Custom font name |
| `*fontSize` | `CGFloat` | Font size |
| `*fontWeight` | `String` | Font weight (e.g. `"regular"`, `"semibold"`) |

---

## Per-State Colors

Each visual property has four variants — one per state. The component automatically applies the correct color based on the current `EDTSTextFieldState`.

| Property Group | Variants |
|---|---|
| Label color | `labelColor` · `labelFocusColor` · `labelErrorColor` · `labelDisabledColor` |
| Placeholder color | `placeholderColor` · `placeholderFocusColor` · `placeholderErrorColor` · `placeholderDisabledColor` |
| Value (text) color | `valueColor` · `valueFocusColor` · `valueErrorColor` · `valueDisabledColor` |
| Leading icon tint | `iconTintColorLeading` · `iconFocusTintColorLeading` · `iconErrorTintColorLeading` · `iconDisabledTintColorLeading` |
| Trailing icon tint | `iconTintColorTrailing` · `iconFocusTintColorTrailing` · `iconErrorTintColorTrailing` · `iconDisabledTintColorTrailing` |
| Background color | `bgColor` · `bgFocusColor` · `bgErrorColor` · `bgDisabledColor` |
| Border color | `borderColor` · `borderFocusColor` · `borderErrorColor` · `borderDisabledColor` |
| Border width | `borderWidth` · `borderFocusWidth` · `borderErrorWidth` · `borderDisabledWidth` |
| Support message color | `supportMessageColor` · `supportMessageFocusColor` · `supportMessageErrorColor` · `supportMessageDisabledColor` |
| Counter color | `counterColor` · `counterFocusColor` · `counterErrorColor` · `counterDisabledColor` |

### Default Color Values

| Element | Default | Focus | Error | Disabled |
|---|---|---|---|---|
| Label | `EDTSColor.grey60` | `EDTSColor.grey60` | `EDTSColor.grey60` | `EDTSColor.grey60` |
| Placeholder | `EDTSColor.grey50` | `EDTSColor.grey50` | `EDTSColor.grey50` | `EDTSColor.grey50` |
| Value | `EDTSColor.grey80` | `EDTSColor.grey80` | `EDTSColor.grey80` | `EDTSColor.grey60` |
| Background | `EDTSColor.white` | `EDTSColor.white` | `EDTSColor.errorWeak` | `EDTSColor.grey20` |
| Border | `EDTSColor.grey30` | `EDTSColor.blue30` | `EDTSColor.errorStrong` | `EDTSColor.grey30` |
| Support message | `EDTSColor.grey50` | `EDTSColor.grey50` | `EDTSColor.errorStrong` | `EDTSColor.grey50` |
| Counter | `EDTSColor.grey50` | `EDTSColor.grey50` | `EDTSColor.errorStrong` | `EDTSColor.grey50` |

---

## Public Interface

| Member | Type | Description |
|---|---|---|
| `text` | `String?` | Read-only. Returns the current text field value. |
| `currentTextFieldState` | `EDTSTextFieldState` | Read-only. Returns the active state enum value. |
| `onTextChanged` | `((String) -> Void)?` | Closure called on every text change event. |
| `becomeFirstResponder()` | `@discardableResult Bool` | Focuses the internal text field. |
| `resignFirstResponder()` | `@discardableResult Bool` | Dismisses the keyboard. |

---

## Animation Details

| Animation Type | Duration | Easing | Description |
| -------------- | -------- | ------ | ----------- |
| Border Color Transition | `250ms` | `EaseInOut` | Animates border textfield color on state change |
| Background Color transition | `250ms` | `EaseInOut` | Animates background textfield color on state change  |

---

## Delegate
 
Conform to `EDTSTextFieldDelegate` to receive icon tap callbacks. Both methods are required.
 
```swift
@MainActor
public protocol EDTSTextFieldDelegate: AnyObject {
    func didSelectTextFieldIconLeading(_ textField: EDTSTextField)
    func didSelectTextFieldIconTrailing(_ textField: EDTSTextField)
}
```
 
> Icon interactions use a long-press gesture with `minimumPressDuration = 0`, so they respond on touch-down and fire the delegate callback on release.  
> The trailing icon callback is **not** fired when `isClearable = true` — in that case, the field clears instead.
 
---

*For further customization, you can ask UX Engineer or inherit `EDTSTextField` and override its methods, or add additional functionality as required.*
