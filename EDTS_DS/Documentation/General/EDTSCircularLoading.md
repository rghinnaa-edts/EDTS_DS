# EDTSCircularLoading

`EDTSCircularLoading` is an `@IBDesignable` circular progress ring built on `CAShapeLayer` track/fill layers with `strokeEnd`-based `CABasicAnimation` for progress changes. It supports solid or gradient track/fill colors, inner and drop shadows, and an indeterminate "intermittent" mode with three animation styles (`stretch`, `fixed`, `doubleArc`).

## Preview

| Feature / Variation | Preview |
| -------------------- | ------- |
| **Loading** | ![Loading](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1786505153/loading_ny8iez.gif) |
| **Intermittent — Stretch** | ![Intermittent — Stretch](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1786505152/intermittent_stretch_egbqxc.gif) |
| **Intermittent — Fixed** | ![Intermittent — Fixed](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1786505152/intermittent_fixed_wcmjed.gif) |
| **Intermittent — Double Arc** | ![Intermittent — Double Arc](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1786505152/intermittent_double_arc_hap1mq.gif) |

## Basic Usage

### 1. Add to Layout

**Swift (Storyboard/XIB):**
```swift
// Add a UIView from Interface Builder
// Set Custom Class to EDTSCircularLoading in Identity Inspector
```

**Swift (Programmatic):**
```swift
let loading = EDTSCircularLoading(frame: .zero)
view.addSubview(loading)
```

### 2. Determinate Progress

```swift
loading.maxValue = 100
loading.value = 40          // animates the fill from its current position to 40%
loading.trackTintColor = .systemGray5
loading.trackFillTintColor = .systemBlue
```

### 3. Indeterminate ("Intermittent") Progress

```swift
loading.isIntermittentState = true
loading.intermittentAnimationType = "stretch" // or "fixed", "doubleArc"
```

## Properties Reference

### Progress Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `value` | `CGFloat` | `0.0` | Current progress value; clamped to `maxValue` on set |
| `maxValue` | `CGFloat` | `100.0` | Upper bound for `value` |
| `trackSize` | `CGFloat` | `50.0` | Outer diameter of the ring |
| `trackThickness` | `CGFloat` | `-1.0` | Stroke width of the ring; any negative value resolves to a default of `6` |
| `lineCapStyle` | `String` | `"round"` | Stroke line cap: `"round"`, `"square"`, or `"butt"` (unrecognized values fall back to `"round"`) |
| `trackPaddingTop` | `CGFloat` | `0.0` | Inset applied to the fill ring's outer edge relative to the track |
| `trackPaddingBottom` | `CGFloat` | `0.0` | Inset applied to the fill ring's inner edge relative to the track |

### Track Color Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackTintColor` | `UIColor?` | `EDTSColor.grey20` | Solid track color, used when no gradient start/end is set |
| `trackTintColorStart` | `UIColor?` | `nil` | Gradient start color for the track; setting either start or end switches the track to a gradient |
| `trackTintColorEnd` | `UIColor?` | `nil` | Gradient end color for the track; setting either start or end switches the track to a gradient |
| `trackColorOrientation` | `String?` | `"horizontal"` | Gradient direction (case-insensitive): `"horizontal"`, `"vertical"`, `"diagonalup"`, or `"diagonaldown"` |

### Fill Color Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackFillTintColor` | `UIColor?` | `nil` | Solid fill color, used when no gradient start/end is set |
| `trackFillTintColorStart` | `UIColor?` | `nil` | Gradient start color for the fill; setting either start or end switches the fill to a gradient |
| `trackFillTintColorEnd` | `UIColor?` | `nil` | Gradient end color for the fill; setting either start or end switches the fill to a gradient |
| `trackFillColorOrientation` | `String?` | `"horizontal"` | Gradient direction for the fill (case-insensitive): `"horizontal"`, `"vertical"`, `"diagonalup"`, or `"diagonaldown"` |

> **Note:** `"diagonalUp"` produces a gradient rising left-to-right (like `/`); `"diagonalDown"` produces a gradient falling left-to-right (like `\`). Unrecognized orientation strings fall back to `"horizontal"`.

### Track Shadow Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackShadowOpacity` | `Float` | `0` | Drop shadow opacity applied to the track |
| `trackShadowRadius` | `CGFloat` | `0` | Drop shadow blur radius |
| `trackShadowOffset` | `CGSize` | `.zero` | Drop shadow offset |
| `trackShadowColor` | `UIColor?` | `nil` | Drop shadow color |

### Track Inner Shadow Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackInnerShadowOpacity` | `Float` | `0.10` | Inner shadow opacity, rendered via the shared `InnerShadow` helper view |
| `trackInnerShadowRadius` | `CGFloat` | `2` | Inner shadow blur radius |
| `trackInnerShadowOffset` | `CGSize` | `.zero` | Inner shadow offset |
| `trackInnerShadowColor` | `UIColor?` | `EDTSColor.black` | Inner shadow color |

### Intermittent Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `isIntermittentState` | `Bool` | `false` | Enables/disables indeterminate looping animation |
| `intermittentAnimationType` | `String` | `"stretch"` |  Animation type for intermittent loading state; `"stretch"`, `"fixed"`, `"doubleArc"` (unrecognized values fall back to `"stretch"`) |
| `doubleArcGap` | `CGFloat` | `4.0` | Radial gap between the outer fill ring and the inner double-arc ring, used only in `"doubleArc"` mode |

## Intermittent Animation Types

| Type | Behavior |
| ---- | -------- |
| `stretch` | The fill ring rotates continuously (`2.4s`/revolution) while its `strokeStart`/`strokeEnd` animate through a 4-keyframe stretch-and-catch-up cycle (`1.33s` loop) |
| `fixed` | The fill ring rotates continuously (`1.0s`/revolution) holding a fixed arc length (`strokeEnd = 0.25`) |
| `doubleArc` | Track is hidden. Two arcs — the outer fill ring and a separate inner ring offset by `doubleArcGap` — each hold a fixed arc length (`strokeEnd = 0.75`) and counter-rotate at `1.4s`/revolution (outer clockwise, inner counter-clockwise) |

## Animation Details

| Aspect | Value |
| ------ | ----- |
| Determinate fill change | `CABasicAnimation` on `strokeEnd`, `1.0s`, ease-in-ease-out, reading the current `presentation()` value so retargeting mid-animation doesn't jump |
| Fill-to-zero cleanup | On completion of an animation to `0`, the active fill layer's line cap is forced to `.butt` to avoid a residual dot artifact from `.round` caps at `strokeEnd == strokeStart == 0`; it reverts to the configured `lineCapStyle` once `value > 0` again |
| Intermittent rotation | `CABasicAnimation` on `transform.rotation.z`, `repeatCount = .infinity`, not removed on completion |

*For further customization, you can ask UX Engineer or inherit `EDTSCircularLoading` and override its methods, or add additional functionality as required.*
