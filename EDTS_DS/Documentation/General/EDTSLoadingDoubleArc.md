# EDTSLoadingDoubleArc

`EDTSLoadingDoubleArc` is an `@IBDesignable` loading indicator that renders two concentric arcs rotating continuously in opposite directions, driven by a `CADisplayLink`. It is built entirely with a single `CAShapeLayer` (no nested subviews) and exposes its geometry, color, and speed as Interface Builder–inspectable properties.

## Preview

| Feature / Variation | Preview |
| -------------------- | ------- |
| **Double Arc Spinner** | ![Double Arc Spinner](https://res.cloudinary.com/dacnnk5j4/image/upload/w_200,c_scale,q_auto,f_auto/v1785135689/loading_double_arc_sqiivs.gif) |

## Basic Usage

### 1. Add to Layout

**Swift (Storyboard/XIB):**
```swift
// Add a UIView from Interface Builder
// Set Custom Class to EDTSLoadingDoubleArc in Identity Inspector
```

**Swift (Programmatic):**
```swift
let loader = EDTSLoadingDoubleArc(frame: .zero)
view.addSubview(loader)
```

### 2. Configure in Code

```swift
loader.progressColor = .systemBlue
loader.progressSize = 50
loader.progressThickness = 5
loader.innerArcPadding = 8
loader.arcSweepAngle = 270
loader.rotateSpeed = 6
```

The view starts animating as soon as it's initialized (`setupView()` calls `startAnimation()`), so no explicit "start" call is required. Animation automatically stops when the view is removed from its window and resumes when it's re-added, via `didMoveToWindow()`.

## Properties Reference

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `progressColor` | `UIColor` | `.systemBlue` | Stroke color for both arcs |
| `innerArcPadding` | `CGFloat` | `8` | Padding used to derive the outer and inner arc radii from the view's size |
| `progressThickness` | `CGFloat` | `5` | Stroke line width for both arcs |
| `progressSize` | `CGFloat` | `50` | Width/height reported via `intrinsicContentSize` |
| `rotateSpeed` | `CGFloat` | `6` | Degrees the arcs advance per animation frame |
| `arcSweepAngle` | `CGFloat` | `270` | Angular sweep (in degrees) of each arc |

## Animation Details

| Aspect | Value |
| ------ | ----- |
| Driver | `CADisplayLink`, `preferredFramesPerSecond = 60` |
| Per-frame update | `startAngleOuter` increases by `rotateSpeed`; `startAngleInner` decreases by `rotateSpeed` (opposite directions), both wrapped with `truncatingRemainder(dividingBy: 360)` |
| Path rebuild | `updatePath()` is called every frame after angles update |
| Lifecycle | Started in `setupView()` (on init) and in `didMoveToWindow()` when added to a window; stopped in `didMoveToWindow()` when removed from its window |

---

*For further customization, you can ask UX Engineer or inherit `EDTSLoadingDoubleArc` and override its methods, or add additional functionality as required.*
