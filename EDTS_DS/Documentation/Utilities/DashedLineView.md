# DashedLineView

`DashedLineView` is a lightweight, `@IBDesignable` view that draws a single dashed (or dotted) line, styled via `CAShapeLayer`. It supports horizontal or vertical orientation, configurable dash color, line width, and dash pattern, and is fully configurable from Interface Builder.

## Preview

| Feature / Variation | Preview |
| -------------------- | ------- |
| **Horizontal Dashed Line** | ![Horizontal Dashed Line](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1784621077/dashed_line_view_horizontal_eyiw6z.png) |
| **Vertical Dashed Line** | ![Vertical Dashed Line](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1784621076/dashed_line_view_vertical_qx5i8q.png) |

## Basic Usage

### 1. Add to Layout

**Swift (Storyboard/XIB):**
```swift
// Add UIView from Interface Builder
// Set Custom Class to DashedLineView in Identity Inspector
```

**Swift (Programmatic):**
```swift
let dashedLine = DashedLineView(frame: .zero)
view.addSubview(dashedLine)
```

### 2. Initialize in Code

```swift
// Configure the dashed line
dashedLine.dashColor = .lightGray
dashedLine.dashWidth = 1
dashedLine.dashPattern = [4, 4]
dashedLine.isVertical = false
```

## Orientation

| Orientation | Value | Description |
| ----------- | ----- | ----------- |
| `Horizontal` | `false` | Draws the dashed line across the horizontal midline of the view's bounds (default) |
| `Vertical` | `true` | Draws the dashed line along the vertical midline of the view's bounds |

## Properties Reference

### General Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `dashColor` | `UIColor` | `.lightGray` | Stroke color of the dashed line |
| `dashWidth` | `CGFloat` | `1` | Stroke (line) width of the dashed line |
| `dashPattern` | `[NSNumber]` | `[4, 4]` | Dash pattern describing alternating stroke and gap lengths, in points |
| `isVertical` | `Bool` | `false` | Determines whether the line is drawn vertically (`true`) or horizontally (`false`) |

### Example:
```swift
dashedLine.isVertical = true   // Path recalculated on next layout pass
dashedLine.setNeedsLayout()
dashedLine.layoutIfNeeded()    // Forces immediate path update
```

---

*For further customization, you can ask UX Engineer or inherit `DashedLineView` and override its methods, or add additional functionality as required.*
