# EDTSRibbon

The `EDTSRibbon` component is a lightweight, `IBDesignable` UIKit view that renders a rounded label with a small triangular "tail," commonly used as a badge or accent anchored to another view (e.g. product cards, price tags).

## Features

- Solid or gradient container fill
- Two gravity options — `start` and `end` — controlling which side the triangular tail renders on
- Four vertical alignment options for anchoring: `top`, `center`, `bottom`, `defaultV`
- Automatic sizing based on ribbon text, font, and padding
- `IBDesignable` / `IBInspectable` support for Interface Builder assembly
- Built-in drop shadow on the container
- `anchorToView(...)` helper to position the ribbon relative to any target view in a shared parent

---

## Preview

### By Gravity

| Gravity | Preview |
|---|---|
| `start` | ![Start](https://res.cloudinary.com/dr6cm6n5f/image/upload/v1739953935/Poinku-DS-UIKit/ewlyc4vwldfd1ggnprma.png) |
| `end` | ![End](https://res.cloudinary.com/dr6cm6n5f/image/upload/v1739953957/Poinku-DS-UIKit/o16sp9cgheg0l9x51lb8.png) |

---

## Installation

Add `EDTSRibbon.swift` to your project.

---

## Usage

### Solid Color

```swift
let ribbon = EDTSRibbon()
ribbon.ribbonText = "x2"
ribbon.triangleColor = .blue50
ribbon.containerColor = .blue30
ribbon.textColor = .white
ribbon.gravity = .start
```

### Gradient Color

```swift
let ribbon = EDTSRibbon()
ribbon.ribbonText = "Hot Product!"
ribbon.triangleColor = .red50
ribbon.containerStartColor = .red20
ribbon.containerEndColor = .red50
ribbon.textColor = .white
ribbon.gravity = .start
```

### Anchoring to a Target View

```swift
ribbon.anchorToView(
    rootParent: parentView,
    targetView: cardImageView,
    verticalAlignment: .top,
    offsetX: 0,
    offsetY: 0
)
```

`anchorToView` removes the ribbon from any existing superview, adds it to `rootParent`, and positions it relative to `targetView`'s frame (converted into `rootParent`'s coordinate space).

---

## Public Interface

### Gravity Enum

```swift
public enum Gravity {
    case start
    case end
}
```

Controls which side of the container the triangular tail is drawn on, and how `anchorToView` calculates horizontal position.

### VerticalAlignment Enum

```swift
public enum VerticalAlignment {
    case top
    case center
    case bottom
    case defaultV
}
```

Used only by `anchorToView` to determine vertical placement relative to the target view.

### Content

| Property | Type | Default | Description |
|---|---|---|---|
| `ribbonText` | `String?` | `nil` | Text displayed inside the ribbon. Setting this triggers a re-measurement of the container size |

### Appearance

| Property | Type | Default | Description |
|---|---|---|---|
| `triangleColor` | `UIColor` | `EDTSColor.blue50` | Color of the triangular tail |
| `containerColor` | `UIColor` | `EDTSColor.blue30` | Solid fill color of the container, used when no gradient is configured |
| `containerStartColor` | `UIColor` | `.clear` | Gradient start color. Must be paired with a non-`.clear` `containerEndColor` to take effect |
| `containerEndColor` | `UIColor` | `.clear` | Gradient end color. Must be paired with a non-`.clear` `containerStartColor` to take effect |
| `textColor` | `UIColor` | `EDTSColor.white` | Color of the ribbon's text |
| `gravity` | `Gravity` | `.start` | Determines which side the triangular tail renders on, and affects layout in `anchorToView` |
| `cornerRadius` | `CGFloat` | `2` | Declared corner radius property |
| `textVerticalPadding` | `CGFloat` | `2` | Padding above and below the text, contributes to `textContainerHeight` |
| `textHorizontalPadding` | `CGFloat` | `4` | Padding to the left and right of the text, contributes to `textWidth` |

### Shadow

The container shadow is fixed and not currently exposed as configurable properties:

| Property | Value |
|---|---|
| Shadow color | `EDTSColor.black` at `15%` opacity |
| Shadow offset | `(0, 2)` |
| Shadow blur radius | `6` |

### Methods

```swift
public func anchorToView(
    rootParent: UIView,
    targetView: UIView,
    verticalAlignment: VerticalAlignment = .defaultV,
    offsetX: CGFloat = 0,
    offsetY: CGFloat = 0
)
```

Anchors the ribbon to a specific `targetView` and positions it relative to that view.

| Parameter | Description |
|---|---|
| `rootParent` | The `UIView` the ribbon will be added to as a subview |
| `targetView` | The view the ribbon is positioned relative to; its frame is converted into `rootParent`'s coordinate space |
| `verticalAlignment` | Determines vertical placement: `top`, `center`, `bottom`, or `defaultV` |
| `offsetX` | Additional horizontal offset applied after gravity-based positioning |
| `offsetY` | Additional vertical offset applied after alignment-based positioning |

---

*For further customization, inherit `EDTSRibbon` and override its setup or drawing methods, or contact the UX Engineering team.*
