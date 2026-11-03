# EDTSTray

`EDTSTray` is a bottom tray built as a `UIPresentationController` subclass that works on iOS 13+ (`UISheetPresentationController` requires iOS 15). It supports three height modes (`fullScreen`, `wrapContent`, `custom`), an optional drag handle, an optional dimmed overlay (with a shadow fallback when the overlay is off), swipe-down and tap-outside dismissal, and a dismiss guard for blocking or intercepting dismissal.

---

## Preview

| Feature / Variation | Preview |
| -------------------- | ------- |
| **Full Screen Tray** | ![Full Screen Tray](https://res.cloudinary.com/dacnnk5j4/image/upload/w_250,c_scale,q_auto,f_auto/v1793094402/full_yi1iba.gif) |
| **Wrap Content Tray** | ![Wrap Content Tray](https://res.cloudinary.com/dacnnk5j4/image/upload/w_250,c_scale,q_auto,f_auto/v1793094406/wrap_o5upsz.gif) |
| **Custom Height Tray** | ![Custom Height Tray](https://res.cloudinary.com/dacnnk5j4/image/upload/w_250,c_scale,q_auto,f_auto/v1793094405/custom_gbsy4j.gif) |

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS/Tray'
```

Then import it wherever you use the component:

```swift
import EDTS_DS
```

This relies on the design token types already available in the pod (`EDTSColor`).

---

## Basic Usage

`EDTSTray` is not a `UIView`, so it is not added to a layout. It is returned as the presentation controller of the view controller you want to show as a tray.

There are two ways to present a tray: the `presentTray` helper (recommended), or a manual `UIViewControllerTransitioningDelegate`.

### 1. Present with the `presentTray` Helper (Recommended)

`presentTray` is a `UIViewController` extension that sets `modalPresentationStyle`, creates the transitioning delegate, keeps it alive for you, and presents the content.

**Swift (Programmatic):**
```swift
let contentVC = MyTrayContentViewController()

presentTray(contentVC, heightMode: .wrapContent) { tray in
    tray.isHasDragHandle = true
    tray.isHasOverlay = true
}
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `content` | `UIViewController` | — | The view controller to show inside the tray |
| `heightMode` | `TrayHeightMode` | `.wrapContent` | Height behavior of the tray |
| `configure` | `((EDTSTray) -> Void)?` | `nil` | Closure to configure the tray. Runs after `heightMode` is applied, so it can override it |
| `animated` | `Bool` | `true` | Whether the presentation is animated |
| `completion` | `(() -> Void)?` | `nil` | Called after the presentation finishes |

> `presentTray` stores the transitioning delegate on the content view controller using an associated object, so you do not need to keep a strong reference to it yourself.

### 2. Present Manually with a Transitioning Delegate

**Using `EDTSTrayTransitioningDelegate`:**
```swift
let contentVC = MyTrayContentViewController()
let trayDelegate = EDTSTrayTransitioningDelegate(heightMode: .custom(400))
// or: EDTSTrayTransitioningDelegate { tray in tray.isHasOverlay = false }

contentVC.modalPresentationStyle = .custom
contentVC.transitioningDelegate = trayDelegate
present(contentVC, animated: true)
```

> **Important:** `transitioningDelegate` is a weak reference. Keep `trayDelegate` in a property (or use `presentTray`), otherwise it is deallocated and the tray will not be used.

**Using your own `UIViewControllerTransitioningDelegate`:**
```swift
let contentVC = MyTrayContentViewController()
contentVC.modalPresentationStyle = .custom
contentVC.transitioningDelegate = self
present(contentVC, animated: true)

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        let tray = EDTSTray(presentedViewController: presented, presenting: presenting)
        tray.heightMode = .wrapContent
        tray.isHasDragHandle = true
        tray.isHasOverlay = true
        return tray
    }
}
```

### 3. Intercept or Block Dismissal

```swift
presentTray(contentVC) { [weak self] tray in
    // Block dismissal while the form has unsaved changes
    tray.canDismiss = {
        return self?.hasUnsavedChanges == false
    }

    // Called when the user tries to dismiss (tap outside / swipe down) but canDismiss returns false
    tray.onDismissAttempt = {
        self?.showDiscardChangesAlert()
    }
}
```

> **Note:** Configure all properties before the tray is presented. Style properties are applied when the presentation transition begins.

> **Note:** `canDismiss` only guards the tap-outside and swipe-down gestures. Calling `dismiss(animated:)` in code is not guarded.

### `TrayHeightMode` Enum

```swift
public enum TrayHeightMode {
    case fullScreen
    case wrapContent
    case custom(CGFloat)
}
```

| Mode | Description |
| ---- | ----------- |
| `.fullScreen` | Tray fills the container below the top safe area |
| `.wrapContent` | Tray height fits the presented view's content using Auto Layout (default). If Auto Layout returns no height, `preferredContentSize.height` is used. The result is clamped to the maximum allowed height |
| `.custom(CGFloat)` | Fixed tray height, clamped to the maximum allowed height |

> The maximum allowed height is the container height minus the container's top safe area inset.

---

## Properties Reference

### General Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `heightMode` | `TrayHeightMode` | `.wrapContent` | Height behavior of the tray (`fullScreen`, `wrapContent`, `custom`) |
| `sheetBackgroundColor` | `UIColor` | `.white` | Background color of the tray |
| `cornerRadius` | `CGFloat` | `16` | Corner radius of the tray (applied to the top-left and top-right corners only) |

### Drag Handle Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `isHasDragHandle` | `Bool` | `true` | Shows/hides the drag handle at the top of the tray |
| `dragHandleColor` | `UIColor` | `EDTSColor.grey30` | Drag handle color |

### Overlay Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `isHasOverlay` | `Bool` | `true` | Shows/hides the dimmed overlay behind the tray |
| `overlayColor` | `UIColor` | `UIColor.black.withAlphaComponent(0.75)` | Overlay color. If its alpha is `0`, the overlay is treated as not visible and the shadow is shown instead |

### Shadow Properties

The shadow is only rendered when the overlay is **not** visible (`isHasOverlay = false` or `overlayColor` alpha is `0`).

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `shadowColor` | `UIColor` | `.black` | Shadow color |
| `shadowOpacity` | `Float` | `0.2` | Shadow opacity |
| `shadowRadius` | `CGFloat` | `12` | Shadow blur radius |
| `shadowOffset` | `CGSize` | `CGSize(width: 0, height: -2)` | Shadow offset |

### Dismiss Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `canDismiss` | `() -> Bool` | `{ true }` | Dismiss guard. Return `false` to prevent dismissal via tap-outside or swipe-down |
| `onDismissAttempt` | `(() -> Void)?` | `nil` | Called when a dismissal was attempted but blocked by `canDismiss` |

---

## Drag Handle Specification

| Aspect | Value |
| ------ | ----- |
| Size | `36pt` × `4pt` |
| Top offset | `8pt` |
| Corner radius | `2pt` |
| Horizontal alignment | Centered in the tray |
| Drag area height | `56pt` (measured from the top of the tray) |

> The `56pt` drag area is always active for swipe-down, even when `isHasDragHandle` is `false`.

---

## Dismiss Behavior

| Gesture | Behavior |
| ------- | -------- |
| **Tap outside** | Tapping the area behind the tray dismisses it (subject to `canDismiss`). If blocked, `onDismissAttempt` is called immediately |
| **Swipe down** | Dragging the tray down follows the finger (it cannot be dragged above its resting position). Only drags that start within the top `56pt` (drag area) are recognized |
| **Dismiss threshold** | On release, the tray dismisses if it was dragged more than `30%` of its height **or** the release velocity is greater than `900 pt/s` |
| **Below threshold** | The tray springs back to its original position. `canDismiss` and `onDismissAttempt` are not called |
| **Blocked by `canDismiss`** | Checked only after the threshold is passed. The tray springs back to its original position and `onDismissAttempt` is called |

---

## Animation Details

| Animation Type | Duration | Description |
| -------------- | -------- | ----------- |
| `Presentation` | Matches the presentation transition | The overlay fades in. The shadow slides up together with the tray (it does not fade) |
| `Dismissal` | Matches the dismissal transition | The overlay fades out. The shadow slides down together with the tray |
| `Drag Dismiss` | `200ms` | Slides the tray (and shadow) off-screen and fades out the overlay when a swipe passes the dismiss threshold |
| `Drag Reset` | `250ms` | Returns the tray (and shadow) to its original position when a swipe does not dismiss |

---

## Notes

- Tapping outside the tray triggers dismissal (subject to `canDismiss`) even when `isHasOverlay` is `false`, because an invisible dimming view is still placed behind the tray
- The shadow is shown only when the overlay is not visible, and its path uses `cornerRadius` on all corners
- `EDTSTray` does not use a delegate protocol. Dismissal is customized through the `canDismiss` and `onDismissAttempt` closures

---

*For further customization, you can ask UX Engineer or inherit `EDTSTray` and override its methods, or add additional functionality as required.*
