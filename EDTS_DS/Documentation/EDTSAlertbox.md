# EDTSAlertbox

The `EDTSAlertbox` component is a flexible, context-aware notification banner built for UIKit. It supports five contextual states, theme-aware typography and layout (including structural overrides for the klikIDM brand), an embedded action button, and a ribbon presentation mode.

## Features

- Five built-in states: `default`, `success`, `error`, `warning`, `info`
- Automatic typography and layout adaptation based on the active `EDTSColorTheme` (`klikIDM` vs. others)
- Configurable inline primary action button via `EDTSButton`
- `isRibbonStyle` presentation mode — flat, edge-to-edge strip with solid state fill
- `IBDesignable` / `IBInspectable` support for Interface Builder assembly
- Proper `intrinsicContentSize` tracking for use inside `UIStackView`

---

## Preview

### By State

| State | Preview |
|---|---|
| `default` | *(image placeholder)* |
| `info` | *(image placeholder)* |
| `success` | *(image placeholder)* |
| `error` | *(image placeholder)* |
| `warning` | *(image placeholder)* |

### Ribbon Style

| Type | Preview |
|---|---|
| `ribbon` | *(image placeholder)* |

---

## Installation

Add to your project:
- `EDTSAlertbox.swift`
- `EDTSAlertbox.xib`

---

## Usage

### Basic

```swift
alertBox.label = "Your session is about to expire."
alertBox.state = EDTSAlertboxState.warning.rawValue
```

### With Action Button

```swift
alertBox.label = "Transaction successfully processed."
alertBox.state = EDTSAlertboxState.success.rawValue
alertBox.isBtnHide = false
alertBox.btnLabel = "View Details"

alertBox.configureButton { button in
    button.addTarget(self, action: #selector(handleActionTap), for: .touchUpInside)
}
```

### Ribbon Style

```swift
alertBox.label = "No internet connection. Retrying…"
alertBox.state = EDTSAlertboxState.error.rawValue
alertBox.isRibbonStyle = true
```

---

## Public Interface

### State Enum

```swift
public enum EDTSAlertboxState: String {
    case `default` = "default"
    case success   = "success"
    case error     = "error"
    case warning   = "warning"
    case info      = "info"
}
```

### Content & Labels

| Property | Type | Default | Description |
|---|---|---|---|
| `label` | `String?` | `nil` | Primary informational message displayed in the banner |
| `btnLabel` | `String?` | `"Button"` | Text rendered inside the embedded action button |
| `icon` | `UIImage?` | `nil` | Custom image asset that replaces the default state icon |

### Typography

| Property | Type | Default | Description |
|---|---|---|---|
| `fontName` | `String` | `""` | Custom font name (e.g. `"Helvetica-Bold"`). Falls back to system font if unresolved. Requires `fontSize > 0` to take effect |
| `fontSize` | `CGFloat` | `0` | Label font size in points. When `0`, the theme default applies (`P2.Regular` for klikIDM, `B3.Regular` otherwise) |
| `fontWeight` | `String?` | `nil` | System font weight when no `fontName` is set. Accepted values: `ultraLight`, `thin`, `light`, `regular`, `medium`, `semibold`, `bold`, `heavy`, `black` |

### Appearance

| Property | Type | Default | Description |
|---|---|---|---|
| `state` | `String` | `"default"` | Active banner state string, mapped to `EDTSAlertboxState` |
| `bgColor` | `UIColor?` | `nil` | Overrides the automatic state background color |
| `labelColor` | `UIColor?` | `nil` | Overrides the automatic state text color |
| `iconTintColor` | `UIColor?` | `nil` | Template tint applied to the leading icon |
| `iconSize` | `CGFloat` | `24.0` | Width and height of the leading icon in points |
| `btnCloseTintColor` | `UIColor?` | `nil` | Tint color applied to the close button icon |
| `btnCloseSize` | `CGFloat` | `16.0` | Width and height of the close button icon in points. No effect when `isBtnCloseHide` is `true` |
| `borderWidth` | `CGFloat` | `1.0` | Container border stroke thickness |
| `borderColor` | `UIColor?` | `nil` | Overrides the automatic state border color |
| `cornerRadius` | `CGFloat` | `1.0` | Corner rounding of the container view (internal state default is `8pt`) |

### Flags & Layout

| Property | Type | Default | Description |
|---|---|---|---|
| `isBtnHide` | `Bool` | `false` | Hides the action button and collapses its layout space. Automatically set to `true` on non-klikIDM themes |
| `isBtnCloseHide` | `Bool` | `false` | Hides the close button and collapses its reserved width/height constraints |
| `isRibbonStyle` | `Bool` | `false` | Enables flat full-width strip layout: removes border and corner radius, applies solid state fill, forces white text and icon, hides the close and action buttons |

### Methods

```swift
public func configureButton(_ instance: (EDTSButton) -> Void)
```

Provides direct access to the internal `EDTSButton` to attach targets, configure style, or set accessibility properties. The method guards against a nil button reference and is safe to call after the view has loaded.

---

## State Color Mapping

| State | Background | Border | Icon & Text | Ribbon Fill |
|---|---|---|---|---|
| `default` | `grey10` | `grey30` | `grey50` (`grey60` text on klikIDM) | `grey50` |
| `info` | `primaryWeak` | `primaryStrong` | `blue50` | `primaryStrong` |
| `success` | `successWeak` | `successStrong` | `successStrong` | `successStrong` |
| `error` | `errorWeak` | `errorStrong` | `errorStrong` | `errorStrong` |
| `warning` | `warningWeak` | `warningStrong` | `warningStrong` | `warningStrong` |

> On the klikIDM theme, label color is always `grey60` regardless of state. Icon asset assignments also differ: `error` uses `ic_error` (not `ic_attention`) and `warning` uses `ic_attention` (not `ic_notice`).

---

*For further customization, inherit `EDTSAlertbox` and override its setup methods, or contact the UX Engineering team.*
