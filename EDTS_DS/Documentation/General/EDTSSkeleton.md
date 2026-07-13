# EDTSSkeleton

The `EDTSSkeleton` component is a shimmering placeholder view built for UIKit.

## Features

- Continuous shimmer animation via an animated `CAGradientLayer`
- Automatically starts/stops the shimmer based on the view's window presence (pauses when off-screen, resumes when visible)
- Configurable corner radius, applied to both the view and its gradient layer
- `IBInspectable` support for Interface Builder assembly
- Manual `startShimmer()` / `stopShimmer()` control

---

## Installation

Add to your project:
- `EDTSSkeleton.swift`

There is no companion XIB — `EDTSSkeleton` is a plain `UIView` subclass.

1. Add a `UIView` above the content it should placeholder, sized/positioned to match the final content's layout.
2. Set its custom class to `EDTSSkeleton` in Interface Builder (or instantiate it programmatically).
3. Optionally configure `cornerRadius` to match the shape being mimicked (e.g. rounded for text lines/avatars, `0` for squared blocks).
4. Hide or remove the skeleton view once the real content has loaded.

---

## Usage

### Basic (Interface Builder)

```swift
@IBOutlet var skeletonAvatar: EDTSSkeleton!
@IBOutlet var skeletonTitle: EDTSSkeleton!

private func setupSkeleton() {
    skeletonAvatar.cornerRadius = 24.0
    skeletonTitle.cornerRadius = 4.0
}
```

### Programmatic

```swift
let skeletonView = EDTSSkeleton(frame: CGRect(x: 0, y: 0, width: 200, height: 16))
skeletonView.cornerRadius = 8.0
view.addSubview(skeletonView)
```

### Manual Shimmer Control

```swift
skeletonView.stopShimmer()  // pause the animation
skeletonView.startShimmer() // resume the animation
```

> Shimmer starts and stops automatically as the view enters/leaves a window (`didMoveToWindow`), so manual calls are only needed for custom pause/resume behavior.

---

## Public Interface

### Appearance

| Property | Type | Default | Description |
|---|---|---|---|
| `cornerRadius` | `CGFloat` | `8.0` | Corner rounding applied to both the view's layer and the internal gradient layer. `IBInspectable` |

### Methods

```swift
public func startShimmer()
```
Adds the shimmer animation to the gradient layer. Called automatically when the view moves to a non-nil window.

```swift
public func stopShimmer()
```
Removes the shimmer animation from the gradient layer. Called automatically when the view moves to a nil window (e.g. removed from the hierarchy).

---

## Animation

| Property | Value | Notes |
|---|---|---|
| Key path | `locations` | Animates the gradient stop positions to create a moving shimmer |
| From | `[-1.0, -0.5, 0.0]` | Starting gradient stop locations |
| To | `[1.0, 1.5, 2.0]` | Ending gradient stop locations |
| Duration | `1.5s` | Per shimmer cycle |
| Repeat | `.infinity` | Loops continuously while active |

### Gradient Colors

| Stop | Color |
|---|---|
| `0.0` | `EDTSColor.grey20` |
| `0.5` | `EDTSColor.grey30` |
| `1.0` | `EDTSColor.grey20` |

---

*For further customization, inherit `EDTSSkeleton` and override its setup methods, or contact the UX Engineering team.*
