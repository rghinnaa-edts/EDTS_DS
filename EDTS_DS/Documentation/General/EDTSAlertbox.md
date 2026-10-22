# EDTSAlertbox

The `EDTSAlertbox` component is a flexible, context-aware notification banner built for UIKit. It supports five contextual states, theme-aware typography and layout, an embedded action button that can sit below the text or on the right side, and a ribbon presentation mode.

## Features

- Five built-in states: `default`, `success`, `error`, `warning`, `info`
- Automatic typography and layout adaptation based on the active `EDTSColorTheme` (`klikIDM`, `poinku`, and others)
- Configurable inline primary action button via `EDTSButton`
- Action button position: below the text (default) or on the right side (`isBtnAtRightSide`)
- `isRibbonStyle` presentation mode: flat, edge-to-edge strip with solid state fill
- `IBDesignable` / `IBInspectable` support for Interface Builder assembly
- Proper `intrinsicContentSize` tracking for use inside `UIStackView` and self-sizing cells

---

## Preview

### By State

| State | Preview |
|---|---|
| `default` | ![Default Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1780632392/WhatsApp_Image_2026-06-05_at_11.03.53_aoqzio.jpg) |
| `info` | ![Info Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1780632393/WhatsApp_Image_2026-06-05_at_11.04.22_mgxitu.jpg) |
| `success` | ![Success Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1780632392/WhatsApp_Image_2026-06-05_at_11.04.37_df3yke.jpg) |
| `error` | ![Error Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1780632392/WhatsApp_Image_2026-06-05_at_11.04.51_cdnoax.jpg) |
| `warning` | ![Warning Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_100/v1780632419/WhatsApp_Image_2026-06-05_at_11.05.17_ai8f1c.jpg) |

### Ribbon Style

| Type | Preview |
|---|---|
| `ribbon` | ![Ribbon Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,h_60/v1780640993/Screenshot_2026-06-05_at_13.29.44_pmhntt.png) |

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

### Attributed Text

```swift
alertBox.labelAttributed = attributedMessage
```

### With Action Button (below the text)

```swift
alertBox.label = "Transaction successfully processed."
alertBox.state = EDTSAlertboxState.success.rawValue
alertBox.isBtnHide = false
alertBox.btnLabel = "View Details"

alertBox.configureButton { button in
    button.addTarget(self, action: #selector(handleActionTap), for: .touchUpInside)
}
```

You can also use the delegate (`didTapButtonAlertbox`) instead of adding a target.

### With Action Button on the Right Side

```swift
alertBox.label = "Complete your profile to unlock all features."
alertBox.state = EDTSAlertboxState.info.rawValue
alertBox.isBtnHide = false
alertBox.isBtnAtRightSide = true
alertBox.btnLabel = "Complete"
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
| `label` | `String?` | `nil` | Primary informational message displayed in the banner. Clears `labelAttributed` |
| `labelAttributed` | `NSAttributedString?` | `nil` | Primary message as attributed text. Clears `label` |
| `btnLabel` | `String?` | `nil` | Text rendered inside the embedded action button |
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
| `iconTintColor` | `UIColor?` | `nil` | Template tint applied to the leading icon. Also switches the image rendering mode to `.alwaysTemplate` and updates the right-side button color |
| `iconSize` | `CGFloat` | `24.0` | Width and height of the leading icon in points |
| `btnCloseTintColor` | `UIColor?` | `nil` | Tint color applied to the close button icon |
| `btnCloseSize` | `CGFloat` | `16.0` | Width and height of the close button icon in points. No effect when `isBtnCloseHide` is `true` |
| `borderWidth` | `CGFloat` | `1.0` | Container border stroke thickness |
| `borderColor` | `UIColor?` | `nil` | Overrides the automatic state border color |
| `cornerRadius` | `CGFloat` | `1.0` | Corner rounding of the container view (internal state default is `8pt`) |

### Shadow

| Property | Type | Default | Description |
|---|---|---|---|
| `shadowOpacity` | `Float` | `0.0` | Opacity of the container drop shadow |
| `shadowOffset` | `CGSize` | `.zero` | Offset of the container drop shadow |
| `shadowRadius` | `CGFloat` | `0.0` | Blur radius of the container drop shadow |
| `shadowColor` | `UIColor?` | `.black` | Color of the container drop shadow |

### Padding

| Property | Type | Default | Description |
|---|---|---|---|
| `paddingTop` | `CGFloat` | `-1.0` | Top inset for icon, label, and close button. `-1.0` means the theme default applies (`8pt` for poinku, `12pt` for all others) |
| `paddingBottom` | `CGFloat` | `-1.0` | Bottom inset. Used as the action button's bottom offset, and as the bottom inset of the right-side layout (falls back to the top padding when `-1.0`). `-1.0` means the theme default applies |
| `paddingLeading` | `CGFloat` | `-1.0` | Leading inset for icon and action button. `-1.0` means the theme default applies |
| `paddingTrailing` | `CGFloat` | `-1.0` | Trailing inset for close button and action button. `-1.0` means the theme default applies |

### Flags & Layout

| Property | Type | Default | Description |
|---|---|---|---|
| `isBtnHide` | `Bool` | `false` | Hides the action button and collapses its layout space. Automatically forced to `true` on the `poinku` theme and in ribbon style |
| `isBtnAtRightSide` | `Bool` | `false` | Places the action button on the right side of the banner. Only applies while `isBtnHide` is `false` |
| `isBtnCloseHide` | `Bool` | `false` | Hides the close button and collapses its reserved width/height constraints |
| `isRibbonStyle` | `Bool` | `false` | Enables flat full-width strip layout: removes border and corner radius, applies solid state fill, forces white text and icon, hides the close and action buttons |

### Methods

```swift
public func configureButton(_ instance: (EDTSButton) -> Void)
```

Provides direct access to the internal `EDTSButton` to attach targets, configure style, or set accessibility properties. The method guards against a nil button reference and is safe to call after the view has loaded.

```swift
public func fittingHeightAlertbox(for width: CGFloat) -> CGFloat
```

Returns the height the alertbox needs at the given width. Use it in a self-sizing list (for example `UICollectionView` or `UITableView` cells) to compute the height before the view is laid out. `intrinsicContentSize` already uses it once the view has a width.

---

## Right-Side Button Layout

When `isBtnAtRightSide` is `true` and `isBtnHide` is `false`, the layout changes:

- The label is pinned to the top and bottom padding, and the icon and the action button are vertically centered against it.
- The close button is hidden.
- The action button is restyled as a text link: transparent background, trailing chevron icon (`ic_chevron_right`), icon spacing `4`, size `small`, and all its inner paddings set to `0`.
- Button label and chevron color: `blue50` for the `default` state, and the state color (`iconTintColor` if set) for the other states.
- The height is `top padding + max(text height, icon height) + bottom padding`. The bottom padding comes from `paddingBottom` when it is set, otherwise from the top padding.

When `isBtnAtRightSide` is switched back to `false`, the button style set above is reset to the standard `EDTSButton` appearance.

---

## Delegate

```swift
@MainActor
public protocol EDTSAlertboxDelegate: AnyObject {
    func didTapCloseAlertbox(_ alertbox: EDTSAlertbox)
    func didTapButtonAlertbox(_ alertbox: EDTSAlertbox)
}
```

Assign `alertBox.delegate` to receive close and action button tap callbacks. Tapping the close button also triggers a built-in dismiss animation (fade out and slight upward translation over `0.3s`, then the height collapses to `0`).

---

## Theme Behavior

### poinku

| Property | Default | poinku Override | Notes |
|---|---|---|---|
| `isBtnHide` | `false` | `true` | Action button is always hidden; forced on state setup |
| Padding (all sides) | `12pt` | `8pt` | Applies to top, bottom, leading, and trailing |
| Font | `B3.Regular` | `B3.Regular` | Same as default; explicitly set on state setup |

### klikIDM

| Property | Default | klikIDM Override | Notes |
|---|---|---|---|
| Label color | Varies by state | Always `grey60` | Ignores state color; applies to all five states |
| Font | `B3.Regular` | `P2.Regular` | Different type scale from other themes |
| Icon, `error` state | `ic_attention` | `ic_error` | Different icon asset |
| Icon, `warning` state | `ic_notice` | `ic_attention` | Different icon asset |
| Bottom padding (button visible) | `0pt` | `0pt` | No difference |
| Bottom padding (button hidden) | `0pt` | `4pt` | Extra spacing added when the action button is not shown |

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

## Icon Assets

| State | Default Theme | klikIDM Theme |
|---|---|---|
| `default` | `ic_information` | `ic_information` |
| `info` | `ic_information` | `ic_information` |
| `success` | `ic_success` | `ic_success` |
| `error` | `ic_attention` | `ic_error` |
| `warning` | `ic_notice` | `ic_attention` |

The close button always uses `ic_close` with a default tint of `grey50`. The right-side action button uses `ic_chevron_right`.

---

## Ribbon Style Behavior

| Property | Value |
|---|---|
| Background | Solid state fill (see the Ribbon Fill column above) |
| Text and icon color | `white` |
| Border width / corner radius | `0` / `0` |
| Close button | Hidden (size `0`) |
| Action button | Hidden (`isBtnHide` is forced to `true`) |
| Padding | top `8`, leading `8`, bottom `0`, trailing `0` |

State changes are not re-applied while `isRibbonStyle` is `true`.

---

## Animation

Triggered automatically when the user taps the close button.

| Property | Value | Notes |
|---|---|---|
| Duration | `0.3s` | Applied to both fade and translate |
| Curve | `curveEaseInOut` | UIKit easing curve |
| Alpha | `1.0` → `0.0` | Fade out |
| Transform | `y: 0` → `y: -8pt` | Slight upward translation |
| Height | Collapses to `0` | A fixed height constraint is added at the start and set to `0` when the animation finishes |

---

*For further customization, inherit `EDTSAlertbox` and override its setup methods, or contact the UX Engineering team.*
