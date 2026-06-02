# EDTSAlertbox
The `EDTSAlertbox` component is a flexible, context-aware notification banner built for UIKit. It supports multiple contextual states, custom UI themes (including structural overrides for apps like Klik Indomaret), action buttons, and a specialized ribbon display style.

## Features
- Five built-in contextual states: `default`, `success`, `error`, `warning`, and `info`
- Automatic typography and layout constraint adaptation based on global brand configurations (`klikIDM` vs. alternative platforms)
- Highly configurable inline primary action button powered by `EDTSButton`
- Optional `isRibbonStyle` presentation mode (edge-to-edge layout, flat styling, hidden auxiliary controls)
- Fully `IBDesignable` and `IBInspectable` compliance for direct visual assembly in Interface Builder
- Intrinsic content size tracking for seamless structural alignment inside stack views

## Preview

### Preview by State

| State             | Preview                 |
|-------------------|-------------------------|
| `Default`         | *(Placeholder for Image Asset)* |
| `Info`            | *(Placeholder for Image Asset)* |
| `Success`         | *(Placeholder for Image Asset)* |
| `Error`           | *(Placeholder for Image Asset)* |
| `Warning`         | *(Placeholder for Image Asset)* |

### Preview if type is Ribbon

| Type             | Preview                 |
|------------------|-------------------------|
| `Ribbon`         | *(Placeholder for Image Asset)* |

## Installation
Add the following files into your project:
- `EDTSAlertbox.swift`
- `EDTSAlertbox.xib`

## Usage
Initialize and configure the component programmatically.

### Basic Example
```swift
alertBox.label = "Your session is about to expire."
alertBox.state = EDTSAlertboxState.warning.rawValue
```

### With Action Button Customization
```swift
alertBox.label = "Transaction successfully processed."
alertBox.state = EDTSAlertboxState.success.rawValue
alertBox.isButtonHide = false
alertBox.btnLabel = "View Details"

alertBox.configureButton { button in
    button.addTarget(self, action: #selector(handleActionTap), for: .touchUpInside)
}
```

### Ribbon Presentation Style
```swift
alertBox.label = "No internet connection. Retrying..."
alertBox.state = EDTSAlertboxState.error.rawValue
alertBox.isRibbonStyle = true
```

### State Enum
```swift
public enum EDTSAlertboxState: String {
    case `default` = "default"
    case success = "success"
    case error = "error"
    case warning = "warning"
    case info = "info"
}
```

### Content & Labels

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String?` | `nil` | Primary informational message text |
| `btnLabel` | `String?` | `"Button"` | Text rendered within the embedded action button |
| `icon` | `UIImage?` | `nil` | Custom replacement graphic asset |

### Component Styling

| Parameter | Type | Default | Description |
|---|---|---|---|
| `state` | `String` | `"default"` | Active banner type string mapped to `EDTSAlertboxState` |
| `bgColor` | `UIColor?` | `nil` | Base background color |
| `labelColor` | `UIColor?` | `nil` | Custom color applied to the primary text |
| `iconTintColor` | `UIColor?` | `nil` | Template tint applied to the leading graphic |
| `btnCloseTintColor` | `UIColor?` | `nil` | Direct tint color adjustment for the close icon |
| `borderWidth` | `CGFloat` | `1.0` | Outer framework stroke thickness |
| `borderColor` | `UIColor?` | `nil` | Container edge outline overlay stroke hue |
| `cornerRadius` | `CGFloat` | `1.0` | Corner roundness mapping metric |

### Flags & Architecture Layout

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isButtonHide` | `Bool` | `false` | Controls whether the internal action button is hidden |
| `isRibbonStyle` | `Bool` | `false` | Flattens borders/corners and converts layout to a flat strip |

*For further customization, you can ask UX Engineer or inherit `EDTSAlertbox` and override its methods, or add additional functionality as required.*
