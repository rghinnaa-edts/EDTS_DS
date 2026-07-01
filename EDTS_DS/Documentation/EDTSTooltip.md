# EDTSTooltip

The `EDTSTooltip` component is a lightweight, self-positioning tooltip/callout view built for UIKit. It renders a rounded speech-bubble shape with a directional arrow pointing at a target view.

## Features

- Self-positioning callout that calculates its own frame relative to a target view and a container, including edge-clamping so it never renders off-screen
- Four supported directions (`top`, `bottom`, `leading`, `trailing`), each with its own arrow orientation and entrance/exit transform
- Built-in long-press-to-show / release-to-dismiss workflow via `attach(to:)`, or fully manual control via `show(on:)` / `dismiss()`
- Title label independently configurable via plain or attributed strings, with custom font name/size/weight and color
- Configurable background color, corner radius, shadow (color/opacity/offset/radius), and per-edge padding
- Optional auto-dismiss after a fixed duration, on either the manual or long-press flow
- Tap-to-dismiss built in — tapping the tooltip itself dismisses it
- `IBDesignable` / `IBInspectable` support for Interface Builder assembly

---

## Installation

Add to your project:
- `EDTSTooltip.swift`

> **Note:** The source file is currently named `EDTSToggle.swift`, but the type it defines is `EDTSTooltip`. You may want to rename the file to match the type for clarity.

---

## Usage

### Basic (manual show/dismiss)

```swift
let tooltip = EDTSTooltip()
tooltip.label = "Tap here to add a new item"
tooltip.show(on: addButton, direction: .top, in: view)
```

Calling `dismiss()` later (e.g. from a button action, or automatically via tap-to-dismiss) removes it.

### Attach to a Long Press (automatic show/dismiss)

```swift
let tooltip = EDTSTooltip()
tooltip.label = "Drag to rearrange"
tooltip.bgColor = .black
tooltip.attach(
    to: cardView,
    direction: .top,
    in: view,
    minimumPressDuration: 0.35,
    animated: true,
    dismissOnRelease: true
)
```

Once attached, the tooltip appears automatically when the user long-presses `cardView` (after `minimumPressDuration`), and disappears when the press ends, is cancelled, or fails (if `dismissOnRelease` is `true`).

```swift
tooltip.detach(from: cardView)
```

Removes the long-press gesture from the target and clears the internal association between the target and the tooltip.

### Auto-Dismiss After a Duration

```swift
// Manual flow
tooltip.show(on: infoIcon, direction: .trailing, in: view, autoDismissAfter: 2.0)

// Long-press flow
tooltip.attach(to: infoIcon, direction: .trailing, in: view, autoDismissAfter: 2.0)
```

When set, the tooltip schedules its own `dismiss()` call after the given number of seconds. This is cancelled automatically if `dismiss()` is called manually beforehand.

### Dismissing

```swift
tooltip.dismiss()
```

Also triggered automatically:
- When the tooltip itself is tapped
- When a long-press gesture attached via `attach(to:)` ends/cancels/fails, if `dismissOnRelease` is `true`
- When an `autoDismissAfter` timer elapses

### Reacting to Dismissal

```swift
tooltip.onDismiss = {
    print("Tooltip was dismissed")
}
```

---

## Public Interface

### Content & Label

| Property | Type | Default | Description |
|---|---|---|---|
| `label` | `String?` | `nil` | Tooltip text. Setting this clears `labelAttributed` |
| `labelAttributed` | `NSAttributedString?` | `nil` | Attributed tooltip text. Setting this clears `label` |
| `labelColor` | `UIColor` | `.white` | Text color used for plain `label` text |

### Typography

| Property | Type | Default | Description |
|---|---|---|---|
| `fontName` | `String` | `""` | Custom font name. Falls back to system font if unresolved. Has no effect if `fontSize` is `0` |
| `fontSize` | `CGFloat` | `12` | Label font size in points |
| `fontWeight` | `String?` | `nil` | System font weight when no `fontName` is set (used only when resolving the fallback system font) |

### Appearance

| Property | Type | Default | Description |
|---|---|---|---|
| `bgColor` | `UIColor` | `.black` | Fill color of the tooltip bubble and arrow |
| `cornerRadius` | `CGFloat` | `4` | Corner radius of the tooltip bubble (arrow is unaffected) |
| `shadowColor` | `UIColor?` | `EDTSColor.grey30` | Shadow color behind the bubble |
| `shadowOpacity` | `Float` | `0.18` | Shadow opacity |
| `shadowOffset` | `CGSize` | `(0, 4)` | Shadow offset |
| `shadowRadius` | `CGFloat` | `5.0` | Shadow blur radius |

### Layout

| Property | Type | Default | Description |
|---|---|---|---|
| `paddingTop` | `CGFloat` | `8` | Space between the top of the bubble and the label |
| `paddingBottom` | `CGFloat` | `8` | Space between the bottom of the bubble and the label |
| `paddingLeading` | `CGFloat` | `8` | Space between the leading edge of the bubble and the label |
| `paddingTrailing` | `CGFloat` | `8` | Space between the trailing edge of the bubble and the label |
| `spacing` | `CGFloat` | `8` | Gap between the target view's edge and the tip of the arrow |
| `maxWidth` | `CGFloat` | `240` | Maximum width of the bubble; the label wraps to fit, and the bubble's final width is clamped to this value |

### Callbacks

| Property | Type | Default | Description |
|---|---|---|---|
| `onDismiss` | `(() -> Void)?` | `nil` | Called after the tooltip finishes dismissing (animated or not), whether triggered manually, by tap, by long-press release, or by auto-dismiss |

---

## Methods

```swift
public func attach(
    to target: UIView,
    direction: EDTSTooltipDirection = .top,
    in parentView: UIView? = nil,
    minimumPressDuration: TimeInterval = 0.35,
    animated: Bool = true,
    dismissOnRelease: Bool = true,
    autoDismissAfter: TimeInterval? = nil
)
```
Wires up a `UILongPressGestureRecognizer` on `target` (also setting `target.isUserInteractionEnabled = true`) and retains the tooltip instance on the target via `objc_setAssociatedObject`. On `.began`, the tooltip calls `show(on:direction:in:animated:autoDismissAfter:)` internally; on `.ended` / `.cancelled` / `.failed`, it calls `dismiss()` if `dismissOnRelease` is `true`.

```swift
public func detach(from target: UIView)
```
Removes the long-press gesture recognizer created by `attach(to:)` from `target` and clears the associated-object link between the target and the tooltip.

```swift
public func show(
    on target: UIView,
    direction: EDTSTooltipDirection = .bottom,
    in parentView: UIView? = nil,
    animated: Bool = true,
    autoDismissAfter: TimeInterval? = nil
)
```
Presents the tooltip pointing at `target`. Resolves a container to add itself to — `parentView` if provided, otherwise `target.window`. If neither is available yet (e.g. the target isn't in a window), the call is retried asynchronously on the next run loop. Sizes and positions itself via internal layout, then, if `animated` is `true`, fades and slides in from the direction-appropriate offset over `0.15s` with `curveEaseOut`. If `autoDismissAfter` is set, schedules an automatic `dismiss()` after that interval.

```swift
public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil)
```
Cancels any pending auto-dismiss timer, then removes the tooltip. When `animated` is `false`, removal is immediate: the view is removed from its superview and `onDismiss` / `completion` fire right away. When `animated` is `true`, the fade/slide-out animation starts after a fixed **`0.5s` delay**, runs for `0.15s`, and then removes the view from its superview, resets its transform, and calls `onDismiss` / `completion`.

> **Note:** The `0.5s` delay before the animated dismiss is currently hardcoded inside `dismiss(animated:completion:)` and is not exposed as a parameter. If you need a configurable delay, consider adding a `delay: TimeInterval` parameter to the method signature.

```swift
public func updatePosition()
```
Re-runs the internal layout pass (recomputes size, position, arrow tip, and path against the current target/superview frames). Call this after rotation, container resize, or if the target view moves, to keep the tooltip correctly anchored.

---

## Behavior Details

### Direction & Arrow Placement

| Direction | Bubble Position Relative to Target | Arrow Points |
|---|---|---|
| `top` | Above the target, horizontally centered on it | Downward, toward the target |
| `bottom` | Below the target, horizontally centered on it | Upward, toward the target |
| `leading` | To the left of the target, vertically centered on it | Rightward, toward the target |
| `trailing` | To the right of the target, vertically centered on it | Leftward, toward the target |

The bubble is offset from the target's edge by `spacing + arrowSize.height` (arrow is a fixed `12 x 8` triangle), and the arrow tip is clamped so it always stays within the bubble's rounded corners even when the bubble itself has been clamped to stay on-screen. The whole tooltip's position is additionally clamped with an `8pt` margin from the superview's bounds on all sides.

### Sizing

The label is measured with `sizeThatFits`, constrained to `maxWidth` minus horizontal padding, so long text wraps rather than overflowing. The bubble's final size is `label size + padding`, capped at `maxWidth`.

### Show / Dismiss Animation

| Action | Property | Value | Delay | Duration | Curve |
|---|---|---|---|---|---|
| Show | Alpha | `0` → `1` | `0s` | `0.15s` | `curveEaseOut` |
| Show | Transform | direction offset (`±4pt`) → `identity` | `0s` | `0.15s` | `curveEaseOut` |
| Dismiss | Alpha | `1` → `0` | `0.5s` | `0.15s` | default |
| Dismiss | Transform | `identity` → direction offset (`±4pt`) | `0.5s` | `0.15s` | default |

When `dismiss(animated: false)` is called, removal is immediate with no delay and no animation.

### Tap to Dismiss

A `UITapGestureRecognizer` is attached to the tooltip itself during setup — tapping anywhere on the bubble calls `dismiss()`.

### Long-Press Lifecycle (`attach(to:)`)

The long-press gesture recognizer added to the target drives the tooltip directly:

| Gesture State | Tooltip Behavior |
|---|---|
| `.began` | `show(on:direction:in:animated:autoDismissAfter:)` is called with the values passed to `attach(to:)` |
| `.ended`, `.cancelled`, `.failed` | `dismiss()` is called only if `dismissOnRelease` was `true` |

Only one tooltip instance can be associated with a given target at a time (subsequent `attach(to:)` calls on the same target will overwrite the retained association).

---

*For further customization, inherit `EDTSTooltip` and override its private layout methods, or contact the UX Engineering team.*
