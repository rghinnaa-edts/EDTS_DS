# EDTSDialog

The `EDTSDialog` component is a modal dialog/alert view built for UIKit. It supports an optional header image, fully customizable title/description/support text, two configurable action buttons (vertical or horizontal layout), and a built-in "dialog image" showcase mode for illustrated, centered dialogs. It ships with `show(in:)` / `dismiss()` helpers that handle overlay dimming and entrance/exit animation for you.

## Features

- Self-contained modal presentation via `show(in:)` and `dismiss()` — dims the host view controller, centers the dialog, and animates in/out
- Optional header image with configurable size, or a built-in placeholder for showcase dialogs
- Title, description, and support text labels, each independently configurable via plain or attributed strings, with custom font name/size/weight/alignment and color
- Two `EDTSButton` slots (primary/secondary) that can be shown, hidden, or stacked vertically/horizontally, each reporting taps back through `EDTSDialogDelegate`
- Adjustable button-stack position relative to the title label (`isBtnPositionAtTopLabel`)
- Built-in "dialog image" showcase mode (`isDialogImage`) that centers content, hides the close button, and falls back to placeholder artwork/copy
- Automatic height calculation via `systemLayoutSizeFitting`, so the dialog sizes itself to its content
- `IBDesignable` / `IBInspectable` support for Interface Builder assembly

---

## Preview

Add state/layout screenshots here (default, with image header, horizontal buttons, dialog-image showcase mode) once available._

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

### Dialog Image Showcase Mode

```swift
dialog.isDialogImage = true
dialog.title = "Welcome!"
dialog.show(in: self)
```

Enabling `isDialogImage` centers the title/description/support text, hides the close button, moves the button stack directly beneath the title, and — if `image` or `support` weren't explicitly set — falls back to a built-in placeholder graphic and default explanatory copy.

### Dismissing

```swift
dialog.dismiss()
```

Triggered automatically when the close icon is tapped (also notifies the delegate). Can also be called manually, e.g. from a button's target action.

### Delegate

```swift
dialog.delegate = self

extension MyViewController: EDTSDialogDelegate {
    func didTapCloseDialog(_ dialog: EDTSDialog) { /* ... */ }
    func didTapButtonPrimaryDialog(_ dialog: EDTSDialog) { /* ... */ }
    func didTapButtonSecondaryDialog(_ dialog: EDTSDialog) { /* ... */ }
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
| `supportAttributed` | `NSAttributedString?` | `nil` | Attributed support text. Setting this clears `support`. Does **not** unhide the support label on its own — see Known Implementation Notes |
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
| `supportFontName` | `String` | `""` | Custom font name intended for the support label. Requires `supportFontSize > 0`. See Known Implementation Notes |
| `supportFontSize` | `CGFloat` | `0` | Support font size in points. `0` keeps the theme default (`EDTSFont.P2.Regular`) |
| `supportFontWeight` | `String?` | `nil` | System font weight when no `supportFontName` is set |

Accepted `*FontWeight` values: `ultraLight`, `thin`, `light`, `regular`, `medium`, `semibold`, `bold`, `heavy`, `black`.

### Appearance & Buttons

| Property | Type | Default | Description |
|---|---|---|---|
| `btnCloseSize` | `CGFloat` | `16.0` | Width/height of the close icon in points. No effect when `isBtnCloseHide` is `true` |
| `btnOrientation` | `String` | `Orientation.vertical.rawValue` | Stack axis for the two buttons. `vertical` stacks primary above secondary; `horizontal` places secondary (leading) and primary (trailing) side by side |
| `cornerRadius` | `CGFloat` | `12.0` | Corner radius of the dialog's container view |
| `isBtnCloseHide` | `Bool` | `false` | Hides the close icon and collapses its reserved width/height |
| `isBtnPrimaryHide` | `Bool` | `false` | Hides the primary button (and collapses the stack if both buttons are hidden) |
| `isBtnSecondaryHide` | `Bool` | `false` | Hides the secondary button (and collapses the stack if both buttons are hidden) |
| `isBtnPositionAtTopLabel` | `Bool` | `false` | Repositions the button stack directly beneath the title/image instead of beneath the support text — see Behavior Details |
| `isDialogImage` | `Bool` | `false` | Enables the centered "showcase" presentation described above. Only takes effect when set to `true` (setting it back to `false` does not revert the layout) |

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
Builds a dimmed overlay (`50%` black) sized to `viewController.view.bounds`, sets the dialog's width to the host view's width minus `48pt`, measures the required height via `systemLayoutSizeFitting`, centers the dialog in the overlay, and adds the overlay to the view controller's view. When `animated` is `true`, the overlay fades in and the dialog scales from `0.8x` to `1.0x` over `0.25s` with `curveEaseOut`.

```swift
public func dismiss(animated: Bool = true)
```
Removes the dialog's overlay (its `superview`) from the hierarchy. When `animated` is `true`, the overlay fades out and the dialog scales down to `0.8x` over `0.2s` before being removed; otherwise removal is immediate.

---

## Delegate

```swift
@MainActor
public protocol EDTSDialogDelegate: AnyObject {
    func didTapCloseDialog(_ dialog: EDTSDialog)
    func didTapButtonPrimaryDialog(_ dialog: EDTSDialog)
    func didTapButtonSecondaryDialog(_ dialog: EDTSDialog)
}
```

Assign `dialog.delegate` to receive callbacks:

- `didTapCloseDialog` is invoked automatically — followed by an animated `dismiss()` — whenever the close icon is tapped.
- `didTapButtonPrimaryDialog` is invoked whenever `btnPrimary` is tapped, via the internal `btnPrimaryAction(_:)` action.
- `didTapButtonSecondaryDialog` is invoked whenever `btnSecondary` is tapped, via the internal `btnSecondaryAction(_:)` action.

Unlike the close icon (wired in code via a tap gesture recognizer), the primary/secondary taps are plain `@IBAction`s — they depend on `btnPrimary` / `btnSecondary`'s *Touch Up Inside* event being connected to `btnPrimaryAction(_:)` / `btnSecondaryAction(_:)` inside `EDTSDialog.xib`. Neither button action calls `dismiss()` automatically — if the dialog should close on tap, call `dismiss()` yourself inside the delegate method (or inside a target added via `configureButtonPrimary` / `configureButtonSecondary`).

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
- Centers `title`, `desc`, and `support` text alignment
- Forces `lblSupport` visible
- Sets `isBtnCloseHide = true` and `isBtnPositionAtTopLabel = true`
- If `image` is `nil`, loads a bundled `ic_placeholder` image at `dialogImageSize`
- If `support` is `nil`, fills in a default explanatory line of placeholder copy

### Show / Dismiss Animation

| Action | Property | Value | Duration | Curve |
|---|---|---|---|---|
| Show | Overlay alpha | `0` → `1` | `0.25s` | `curveEaseOut` |
| Show | Dialog transform | `scale 0.8` → `identity` | `0.25s` | `curveEaseOut` |
| Dismiss | Overlay alpha | `1` → `0` | `0.2s` | default |
| Dismiss | Dialog transform | `identity` → `scale 0.8` | `0.2s` | default |

---

*For further customization, inherit `EDTSDialog` and override its setup methods, or contact the UX Engineering team.*
