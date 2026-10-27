# EDTSTray

`EDTSTray` is a bottom tray built as a `UIPresentationController` subclass that works on iOS 13+ (`UISheetPresentationController` requires iOS 15). It supports three height modes (`fullScreen`, `wrapContent`, `custom`), an optional drag handle, an optional dimmed overlay (with a shadow fallback when the overlay is off), swipe-down and tap-outside dismissal, and a dismiss guard for blocking or intercepting dismissal.

## Preview

| **Tray** | *(add preview)* |

## Basic Usage

`EDTSTray` is not a `UIView`, so it is not added to a layout. It is returned as the presentation controller of the view controller you want to show as a tray.

### 1. Present a View Controller as a Tray

**Swift (Programmatic):**
```swift
let contentVC = MyTrayContentViewController()
contentVC.modalPresentationStyle = .custom
contentVC.transitioningDelegate = self
present(contentVC, animated: true)
```

### 2. Provide the Tray via `UIViewControllerTransitioningDelegate`

```swift
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
let tray = EDTSTray(presentedViewController: presented, presenting: presenting)

// Block dismissal while the form has unsaved changes
tray.canDismiss = { [weak self] in
    return self?.hasUnsavedChanges == false
}

// Called when the user tries to dismiss (tap outside / swipe down) but canDismiss returns false
tray.onDismissAttempt = { [weak self] in
    self?.showDiscardChangesAlert()
}
```

> **Note:** Configure all properties before the tray is presented. Style properties are applied when the presentation transition begins.

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
| `.wrapContent` | Tray height fits the presented view's content (default) |
| `.custom(CGFloat)` | Fixed tray height, clamped to the maximum allowed height |
| `.fullScreen` | Tray fills the container below the top safe area |


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

## Drag Handle Specification

| Aspect | Value |
| ------ | ----- |
| Size | `36pt` × `4pt` |
| Top offset | `8pt` |
| Corner radius | `2pt` |
| Horizontal alignment | Centered in the tray |
| Drag area height | `56pt` (measured from the top of the tray) |

## Dismiss Behavior

| Gesture | Behavior |
| ------- | -------- |
| **Tap outside** | Tapping the dimmed area behind the tray dismisses it (subject to `canDismiss`) |
| **Swipe down** | Dragging the tray down follows the finger. Only drags that start within the top `56pt` (drag area) are recognized |
| **Dismiss threshold** | On release, the tray dismisses if it was dragged more than `30%` of its height **or** the release velocity is greater than `900 pt/s` |
| **Below threshold** | The tray springs back to its original position |
| **Blocked by `canDismiss`** | The tray springs back to its original position and `onDismissAttempt` is called |

## Animation Details

| Animation Type | Duration | Description |
| -------------- | -------- | ----------- |
| `Overlay / Shadow Fade In` | Matches the presentation transition | Fades the overlay (or shadow) in alongside the tray presentation |
| `Overlay / Shadow Fade Out` | Matches the dismissal transition | Fades the overlay (or shadow) out alongside the tray dismissal |
| `Drag Dismiss` | `200ms` | Slides the tray off-screen and fades out the overlay/shadow when a swipe passes the dismiss threshold |
| `Drag Reset` | `250ms` | Returns the tray to its original position when a swipe does not dismiss |

## Notes

- When `isHasOverlay` is `false`, tapping outside the tray still triggers dismissal (subject to `canDismiss`)
- The shadow is shown only when the overlay is not visible, and its path uses `cornerRadius` on all corners
- `EDTSTray` does not use a delegate protocol. Dismissal is customized through the `canDismiss` and `onDismissAttempt` closures

---

*For further customization, you can ask UX Engineer or inherit `EDTSTray` and override its methods, or add additional functionality as required.*
