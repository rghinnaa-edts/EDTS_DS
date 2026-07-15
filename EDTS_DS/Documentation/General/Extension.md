# EDTS_DS Extensions

This document covers the utility extensions available on `UIView`, `Int`, and `String` within `EDTS_DS`. These are lightweight helpers for gradients, ripple effects, grayscale, coupon-shaped backgrounds, currency formatting, and strikethrough text — layered on top of standard UIKit/Foundation types rather than standalone components.

## Table of Contents

- [UIView Extensions](#uiview-extensions)
  - [applyCircular](#applycircular)
  - [showRipple / hideRipple](#showripple--hideripple)
  - [showRippleCircular / hideRippleCircular](#showripplecircular--hideripplecircular)
  - [applyGrayscale / removeGrayscaleEffect](#applygrayscale--removegrayscaleeffect)
  - [createCouponPath / applyCouponBackground](#createcouponpath--applycouponbackground)
  - [enclosingViewController](#enclosingviewcontroller)
- [Int Extensions](#int-extensions)
  - [formatRupiah](#formatrupiah)
  - [formatDecimal](#formatdecimal)
- [String Extensions](#string-extensions)
  - [strikethrough](#strikethrough)

---

##Preview
| Feature / Variation | Preview |
| -------------------- | ------- |
| **Circular Shape** | *(add preview asset)* |
| **Elipse Shape** | *(add preview asset)* |
| **Ripple Effect (Bounded)** | *(add preview asset)* |
| **Ripple Effect (Circular, Behind View)** | *(add preview asset)* |
| **Grayscale Applied** | *(add preview asset)* |
| **Coupon Background** | *(add preview asset)* |
| **Format Rupiah** | *(add preview asset)* |
| **Format Decimal** | *(add preview asset)* |
| **Strikethrough** | *(add preview asset)* |

---

## UIView Extensions

### applyCircular

```swift
func applyCircular()
```

Shapes a view into a circle/ellipse by setting `layer.cornerRadius` to half of its smaller bound dimension (`min(width, height) / 2`). Calls `layoutIfNeeded()` first to ensure `bounds` reflects the current layout.

**Example:**
```swift
avatarImageView.applyCircular()
```

> Note: this only sets `cornerRadius` — `clipsToBounds`/`layer.masksToBounds` must be enabled separately for the circular shape to actually clip content.

---

### showRipple / hideRipple

Adds a Material-style expanding ripple effect, masked to the view's own rounded-rect shape, from an optional touch point.

```swift
func showRipple(
    from touchPoint: CGPoint? = nil,
    cornerRadius: CGFloat? = nil,
    color: UIColor? = EDTSColor.grey30.withAlphaComponent(0.12)
)

func hideRipple()
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `touchPoint` | `CGPoint?` | `nil` | Origin point for the ripple; defaults to the view's center |
| `cornerRadius` | `CGFloat?` | `nil` | Radius used to mask the ripple to a rounded rect; defaults to the view's current `layer.cornerRadius` |
| `color` | `UIColor?` | `EDTSColor.grey30` at 12% opacity | Fill color of the ripple |

**Example:**
```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let point = touches.first?.location(in: self) {
        showRipple(from: point)
    }
}

override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    hideRipple()
}
```

**Behavior notes:**
- The ripple radius expands to cover the farthest corner of the view from the touch point, so the whole view is covered by the time the animation completes
- Animation is a `CAAnimationGroup` combining a `0.40s` path expansion (ease-out) and a `0.10s` opacity fade-in
- `hideRipple()` waits for any remaining time in the expand animation before starting a `0.22s` fade-out, then removes the ripple layer on completion
- Multiple ripple layers can be active at once — `showRipple` appends to an internal array rather than replacing a single ripple

---

### showRippleCircular / hideRippleCircular

A variant ripple effect that renders a small expanding circle **behind** the view (in its superview's layer), rather than clipped inside the view's own bounds — suited to icon-only tap feedback.

```swift
func showRippleCircular(
    size: CGFloat = 32,
    color: UIColor? = EDTSColor.grey30.withAlphaComponent(0.22)
)

func hideRippleCircular()
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `size` | `CGFloat` | `32` | Final diameter of the expanded circle |
| `color` | `UIColor?` | `EDTSColor.grey30` at 22% opacity | Fill color of the circular ripple |

**Example:**
```swift
iconButton.showRippleCircular()
```

**Behavior notes:**
- Requires `superview` to exist — silently does nothing otherwise
- The circle is centered on the view's `frame.midX`/`midY` and inserted into the superview's layer just below the view's own layer
- Same `0.40s` expand + `0.10s` fade-in animation timing as `showRipple`
- `hideRippleCircular()` snapshots the current presentation-layer path/opacity before removing in-flight animations, then fades out over `0.22s`

---

### applyGrayscale / removeGrayscaleEffect

Renders a snapshot of the view, applies a `CIPhotoEffectMono` (grayscale) Core Image filter, and overlays the result as a `CALayer` on top of the view.

```swift
func applyGrayscale(_ isGrayscale: Bool)
func removeGrayscaleEffect()
```

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| `isGrayscale` | `Bool` | `true` renders and overlays a grayscale snapshot; `false` removes it |

**Example:**
```swift
cardView.applyGrayscale(true)   // Apply
cardView.applyGrayscale(false)  // Remove
```

**Behavior notes:**
- `applyGrayscale(true)` defers the actual rendering to the next run loop (`DispatchQueue.main.async`), and re-checks that grayscale is still requested and `bounds` is non-zero before proceeding — guards against races if the flag is toggled quickly
- Rendering flow: `layer.render(in:)` into an image context → wrap as `CIImage` → run `CIPhotoEffectMono` → render output back to a `CGImage` → wrap in a plain `CALayer` added as a sublayer
- `removeGrayscaleEffect()` removes the overlay layer and clears the stored reference; it is called publicly and also internally at the start of every `applyGrayscale(true)` call to avoid stacking overlays
- Since the overlay is a static snapshot, any changes to the view's live content after applying grayscale will not be reflected until grayscale is reapplied

---

### createCouponPath / applyCouponBackground

Builds (and optionally applies as a mask) a coupon/ticket-shaped path with rounded corners and a semi-circular "notch" cut into both the left and right edges.

```swift
func createCouponPath(
    in rect: CGRect,
    notchRadius: CGFloat,
    notchPosition: CGFloat,
    cornerRadius: CGFloat
) -> UIBezierPath

func applyCouponBackground(
    notchRadius: CGFloat = 8,
    notchPosition: CGFloat,
    cornerRadius: CGFloat = 12
)
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `rect` | `CGRect` | — (`createCouponPath` only) | Reference rect for path construction (note: the path itself is built from `bounds`, not this parameter — see notes) |
| `notchRadius` | `CGFloat` | `8` (on `applyCouponBackground`) | Radius of the semi-circular notch cut into the left and right edges |
| `notchPosition` | `CGFloat` | — | Vertical (y) position of the notch center, in the view's own coordinate space |
| `cornerRadius` | `CGFloat` | `12` (on `applyCouponBackground`) | Corner radius for the four outer corners |

**Example:**
```swift
couponView.applyCouponBackground(
    notchRadius: 10,
    notchPosition: couponView.bounds.height / 2,
    cornerRadius: 16
)
```

**Behavior notes:**
- `createCouponPath` returns a `UIBezierPath`; `applyCouponBackground` is the convenience method that builds the path and assigns it as a `CAShapeLayer` mask to `layer.mask`
- `applyCouponBackground` should be called after layout (e.g. in `layoutSubviews()` or after Auto Layout has resolved `bounds`), since the path depends on the view's current `bounds`

---

### enclosingViewController

```swift
func enclosingViewController() -> UIViewController?
```

Walks up the responder chain from the view to find and return its nearest enclosing `UIViewController`, or `nil` if none is found.

**Example:**
```swift
if let vc = someSubview.enclosingViewController() {
    vc.present(detailViewController, animated: true)
}
```

---

## Int Extensions

### formatRupiah

```swift
func formatRupiah() -> String
```

Formats an `Int` as an Indonesian Rupiah currency string, using `formatDecimal()` internally and handling the negative sign and `"Rp"` prefix explicitly.

| Input | Output |
| ----- | ------ |
| `15000` | `"Rp15.000"` |
| `-15000` | `"-Rp15.000"` |
| `0` | `"Rp0"` |

**Example:**
```swift
let price = 125000
label.text = price.formatRupiah()  // "Rp125.000"
```

---

### formatDecimal

```swift
func formatDecimal() -> String
```

Formats an `Int` as a grouped decimal string using `.` as the thousands separator and `,` as the decimal separator (Indonesian locale conventions), with no fractional digits. Falls back to `"0"` if formatting fails.

| Input | Output |
| ----- | ------ |
| `1000000` | `"1.000.000"` |
| `500` | `"500"` |

**Example:**
```swift
let quantity = 12500
label.text = quantity.formatDecimal()  // "12.500"
```

---

## String Extensions

### strikethrough

```swift
func strikethrough(
    style: NSUnderlineStyle = .single,
    color: UIColor? = nil
) -> NSAttributedString
```

Returns an `NSAttributedString` with a strikethrough style applied to the entire string.

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `style` | `NSUnderlineStyle` | `.single` | Strikethrough line style |
| `color` | `UIColor?` | `nil` | Strikethrough line color; if `nil`, the attribute is omitted and the system default (text color) is used |

**Example:**
```swift
priceLabel.attributedText = "Rp150.000".strikethrough(color: .systemRed)
```

---

*For further customization, you can ask UX Engineer or extend these methods, or add additional functionality as required.*
