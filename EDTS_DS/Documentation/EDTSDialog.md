# EDTSDialog

The `EDTSDialog` component is a modal dialog/alert view built for UIKit. It supports an optional header image, fully customizable title/description/support text, two configurable action buttons (vertical or horizontal layout), and a built-in "dialog image" showcase mode for illustrated, centered dialogs. It ships with `show(in:)` / `dismiss()` helpers that handle overlay dimming and entrance/exit animation for you.

## Features

- Self-contained modal presentation via `show(in:)` and `dismiss()` — dims the host view controller, centers the dialog, and animates in/out
- Optional tap-outside-to-dismiss behavior via `isDismissOnTapOutside`
- Optional header image with configurable size, or a built-in placeholder for showcase dialogs
- Title, description, and support text labels, each independently configurable via plain or attributed strings, with custom font name/size/weight/alignment and color
- Two `EDTSButton` slots (primary/secondary) that can be shown, hidden, or stacked vertically/horizontally, each reporting taps back through `EDTSDialogDelegate`
- Adjustable button-stack position relative to the title label (`isBtnPositionAtTopLabel`)
- Built-in "dialog image" showcase mode (`isDialogImage`) that centers content, hides the close button, and falls back to placeholder artwork/copy
- Automatic height calculation via `systemLayoutSizeFitting`, so the dialog sizes itself to its content
- `IBDesignable` / `IBInspectable` support for Interface Builder assembly

---

## Preview

### Ribbon Style

| Type | Preview |
|---|---|
| `default` | ![Default Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_100/v1782372942/WhatsApp_GIF_2026-06-25_at_14.27.13_mveimy.gif) |
| `dialog image` | ![Dialog Image Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_100/v1782372942/WhatsApp_GIF_2026-06-25_at_14.28.34_bi31lb.gif |

---

## Installation

Add to your project:
- `EDTSDialog.swift`
- `EDTSDialog.xib`

---

## Usage

### Basic

```swift
let dialog = EDTSDialog()
dialog.title = "Delete item?"
dialog.desc = "This action cannot be undone."
dialog.show(in: self)
```

### With Header Image

```swift
dialog.image = UIImage(named: "ic_warning")
dialog.imageSize = 80
dialog.title = "Connection lost"
dialog.desc = "Please check your internet connection and try again."
dialog.show(in: self)
```

### With Action Buttons

```swift
dialog.title = "Log out?"
dialog.desc = "You will need to sign in again to continue."
dialog.btnOrientation = Orientation.horizontal.rawValue

dialog.configureButtonPrimary { button in
    button.btnLabel = "Log Out"
    button.addTarget(self, action: #selector(handleLogoutTap), for: .touchUpInside)
}
dialog.configureButtonSecondary { button in
    button.btnLabel = "Cancel"
    button.addTarget(self, action: #selector(handleCancelTap), for: .touchUpInside)
}

dialog.show(in: self)
```

### Dismiss on Tap Outside

```swift
dialog.isDismissOnTapOutside = true
dialog.show(in: self)
```

When enabled, a tap gesture is attached to the dimming overlay. Tapping anywhere outside the dialog's bounds notifies the delegate via `didSelectCloseDialog(_:)` and triggers an animated `dismiss()`, exactly as if the close icon had been tapped. Default is `false`.

### Dialog Image Showcase Mode

```swift
dialog.isDialogImage = true
dialog.title = "Welcome!"
dialog.show(in: self)
```

Enabling `isDialogImage` centers the title/description/support text, switches the title to the `EDTSFont.D4` style, hides the close button, moves the button stack directly beneath the title, and — if `image` or `support` weren't explicitly set — falls back to a built-in placeholder graphic and default explanatory copy.

### Dismissing

```swift
dialog.dismiss()
```

Triggered automatically when the close icon is tapped, or when tapping outside the dialog if `isDismissOnTapOutside` is enabled (both notify the delegate first). Can also be called manually, e.g. from a button's target action.

### Delegate

```swift
dialog.delegate = self

extension MyViewController: EDTSDialogDelegate {
    func didSelectCloseDialog(_ dialog: EDTSDialog) { /* ... */ }
    func didSelectButtonPrimaryDialog(_ dialog: EDTSDialog) { /* ... */ }
    func didSelectButtonSecondaryDialog(_ dialog: EDTSDialog) { /* ... */ }
}
```

---

## Public Interface

### Content & Labels

| Property | Type | Default | Description |
|---|---|---|---|
| `title` | `String?` | `nil` | Title text. Setting this clears `titleAttributed` |
| `titleAttributed` | `NSAttributedString?` | `nil` | Attributed title text. Setting this clears `title` |
| `titleColor` | `UIColor?` | `nil` | Title label text color |
| `titleAlignment` | `NSTextAlignment` | `.left` | Title label text alignment |
| `desc` | `String?` | `nil` | Description text. Setting this clears `descAttributed` |
| `descAttributed` | `NSAttributedString?` | `nil` | Attributed description text. Setting this clears `desc` |
| `descColor` | `UIColor?` | `nil` | Description label text color |
| `descAlignment` | `NSTextAlignment` | `.left` | Description label text alignment |
| `support` | `String?` | `nil` | Support/footnote text. Setting this clears `supportAttributed` **and unhides** the support label |
| `supportAttributed` | `NSAttributedString?` | `nil` | Attributed support text. Setting this clears `support` **and unhides** the support label |
| `supportColor` | `UIColor?` | `nil` | Support label text color |
| `supportAlignment` | `NSTextAlignment` | `.left` | Support label text alignment |
| `image` | `UIImage?` | `nil` | Header image shown above the title |
| `imageSize` | `CGFloat` | `0.0` | Width/height of the header image in points (internal default once set is `256`) |

### Typography

| Property | Type | Default | Description |
|---|---|---|---|
| `titleFontName` | `String` | `""` | Custom font name for the title. Falls back to system font if unresolved. Requires `titleFontSize > 0` to take effect |
| `titleFontSize` | `CGFloat` | `0` | Title font size in points. `0` keeps the theme default (`EDTSFont.H1`) |
| `titleFontWeight` | `String?` | `nil` | System font weight when no `titleFontName` is set |
| `descFontName` | `String` | `""` | Custom font name for the description. Requires `descFontSize > 0` |
| `descFontSize` | `CGFloat` | `0` | Description font size in points. `0` keeps the theme default (`EDTSFont.P1.Regular`) |
| `descFontWeight` | `String?` | `nil` | System font weight when no `descFontName` is set |
| `supportFontName` | `String` | `""` | Custom font name for the support label. Requires `supportFontSize > 0` |
| `supportFontSize` | `CGFloat` | `0` | Support font size in points. `0` keeps the theme default (`EDTSFont.P2.Regular`) |
| `supportFontWeight` | `String?` | `nil` | System font weight when no `supportFontName` is set |

Accepted `*FontWeight` values: `ultraLight`, `thin`, `light`, `regular`, `medium`, `semibold`, `bold`, `heavy`, `black`.

### Appearance & Buttons

| Property | Type | Default | Description |
|---|---|---|---|
| `btnCloseSize` | `CGFloat` | `16.0` | Width/height of the close icon in points. No effect when `isHasBtnClose` is `false` |
| `btnOrientation` | `String` | `Orientation.vertical.rawValue` | Stack axis for the two buttons. `vertical` stacks primary above secondary; `horizontal` places secondary (leading) and primary (trailing) side by side |
| `cornerRadius` | `CGFloat` | `12.0` | Corner radius of the dialog's container view |
| `isHasBtnClose` | `Bool` | `true` | Shows/hides the close icon and collapses its reserved width/height when `false` |
| `isHasBtnPrimary` | `Bool` | `true` | Shows/hides the primary button (and collapses the stack if both buttons are hidden) |
| `isHasBtnSecondary` | `Bool` | `true` | Shows/hides the secondary button (and collapses the stack if both buttons are hidden) |
| `isBtnPositionAtTopLabel` | `Bool` | `false` | Repositions the button stack directly beneath the title/image instead of beneath the support text — see Behavior Details |
| `isDialogImage` | `Bool` | `false` | Enables the centered "showcase" presentation described above. Only takes effect when set to `true` (setting it back to `false` does not revert the layout) |
| `isDismissOnTapOutside` | `Bool` | `false` | When `true`, tapping the dimming overlay outside the dialog's bounds dismisses it and notifies the delegate |

---

## Methods

```swift
public func configureButtonPrimary(_ instance: (EDTSButton) -> Void)
public func configureButtonSecondary(_ instance: (EDTSButton) -> Void)
```
Provide direct access to the primary/secondary `EDTSButton` instances to set labels, styles, or attach `UIControl` targets. Both guard against a `nil` button reference and are safe to call after the view has loaded.

```swift
public func show(in viewController: UIViewController, animated: Bool = true)
```
Builds a dimmed overlay (`50%` black) sized to `viewController.view.bounds`, sets the dialog's width to the host view's width minus `48pt`, measures the required height via `systemLayoutSizeFitting`, centers the dialog in the overlay, and adds the overlay to the view controller's view. If `isDismissOnTapOutside` is `true`, a tap gesture recognizer is attached to the overlay. When `animated` is `true`, the overlay fades in and the dialog scales from `0.8x` to `1.0x` over `0.25s` with `curveEaseOut`.

```swift
public func dismiss(animated: Bool = true)
```
Removes the dialog's overlay (its `superview`) from the hierarchy. When `animated` is `true`, the dismiss animation now starts after a fixed **`0.2s` delay**, then fades the overlay out and scales the dialog down to `0.8x` over `0.2s` before removing it from the hierarchy. When `animated` is `false`, removal is immediate with no delay.

> **Note:** The `0.2s` delay before the animated dismiss is currently hardcoded inside `dismiss(animated:)` and is not exposed as a parameter. If you need a configurable delay, consider adding a `delay: TimeInterval` parameter to the method signature.

---

## Delegate

```swift
@MainActor
public protocol EDTSDialogDelegate: AnyObject {
    func didSelectCloseDialog(_ dialog: EDTSDialog)
    func didSelectButtonPrimaryDialog(_ dialog: EDTSDialog)
    func didSelectButtonSecondaryDialog(_ dialog: EDTSDialog)
}
```

Assign `dialog.delegate` to receive callbacks:

- `didSelectCloseDialog` is invoked automatically — followed by an animated `dismiss()` — whenever the close icon is tapped, or whenever the overlay is tapped outside the dialog's bounds with `isDismissOnTapOutside` enabled.
- `didSelectButtonPrimaryDialog` is invoked whenever `btnPrimary` is tapped, via the internal `btnPrimaryAction(_:)` action.
- `didSelectButtonSecondaryDialog` is invoked whenever `btnSecondary` is tapped, via the internal `btnSecondaryAction(_:)` action.

The close icon and tap-outside gesture are wired in code (a long-press-with-zero-duration gesture for the close icon, a tap gesture for the overlay). The primary/secondary taps are plain `@IBAction`s — they depend on `btnPrimary` / `btnSecondary`'s *Touch Up Inside* event being connected to `btnPrimaryAction(_:)` / `btnSecondaryAction(_:)` inside `EDTSDialog.xib`. Neither button action calls `dismiss()` automatically — if the dialog should close on tap, call `dismiss()` yourself inside the delegate method (or inside a target added via `configureButtonPrimary` / `configureButtonSecondary`).

---

## Behavior Details

### Button Orientation

Setting `btnOrientation` rebuilds the internal `UIStackView` from scratch (removing and re-adding both buttons):

| Orientation | Axis | Arranged Order |
|---|---|---|
| `vertical` (default) | `.vertical` | Primary, then Secondary |
| `horizontal` | `.horizontal` | Secondary, then Primary |

The stack uses `8pt` spacing, `.fillEqually` distribution, and is pinned `16pt` from the container's leading/trailing edges.

### Button Position

`isBtnPositionAtTopLabel` controls where the button stack sits and which view anchors the bottom of the dialog:

| `isBtnPositionAtTopLabel` | Stack Top Anchor | Title Top Anchor | Dialog Bottom Anchor |
|---|---|---|---|
| `false` (default) | `32pt` below `lblSupport` | `0pt` below image if no image is set, otherwise `16pt` below the image | `16pt` below the button stack |
| `true` | `16pt` below the image | `24pt` below the button stack | `16pt` below `lblSupport` (or `lblDesc` if support is hidden) |

This is the mechanism the showcase mode (`isDialogImage`) uses to move the buttons directly under the title.

### Dialog Image Showcase Mode

Enabling `isDialogImage` performs a one-time setup pass:
- Switches `lblTitle`'s font to `EDTSFont.D4`
- Centers `title`, `desc`, and `support` text alignment
- Forces `lblSupport` visible
- Sets `isHasBtnClose = false` and `isBtnPositionAtTopLabel = true`
- If `image` is `nil`, loads a bundled `ic_placeholder` image at `dialogImageSize`
- If `support` is `nil`, fills in a default explanatory line of placeholder copy

### Tap Outside to Dismiss

When `isDismissOnTapOutside` is `true`, `show(in:)` attaches a `UITapGestureRecognizer` to the dimming overlay. On tap, the gesture handler checks whether the tap location falls outside the dialog's own `frame`; if so, it calls `didSelectCloseDialog(_:)` on the delegate and then `dismiss()`.

### Show / Dismiss Animation

| Action | Property | Value | Delay | Duration | Curve |
|---|---|---|---|---|---|
| Show | Overlay alpha | `0` → `1` | `0s` | `0.25s` | `curveEaseOut` |
| Show | Dialog transform | `scale 0.8` → `identity` | `0s` | `0.25s` | `curveEaseOut` |
| Dismiss | Overlay alpha | `1` → `0` | `0.2s` | `0.2s` | default |
| Dismiss | Dialog transform | `identity` → `scale 0.8` | `0.2s` | `0.2s` | default |

When `dismiss(animated: false)` is called, the overlay is removed immediately with no delay and no animation.

---

*For further customization, inherit `EDTSDialog` and override its setup methods, or contact the UX Engineering team.*
