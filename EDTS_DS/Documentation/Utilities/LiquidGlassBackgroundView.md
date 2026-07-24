# LiquidGlassBackgroundView

`LiquidGlassBackgroundView` is a decorative background view that produces a "liquid glass" effect: a rounded, blurred material background combined with a soft gradient stroke around its edge. It's designed to be dropped behind other content (e.g. cards, sheets, floating panels) to create a frosted, glass-like surface.

## Preview

| Feature / Variation | Preview |
| -------------------- | ------- |
| **Liquid Glass Background** | ![Liquid Glass Background](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1784621077/liquid_glass_background_view_pdsofc.png) |

## Basic Usage

### 1. Add to Layout

**Swift (Storyboard/XIB):**
```swift
// Add UIView from Interface Builder
// Set Custom Class to LiquidGlassBackgroundView in Identity Inspector
```

**Swift (Programmatic):**
```swift
let glassBackground = LiquidGlassBackgroundView(frame: .zero)
view.addSubview(glassBackground)
```

### 2. Use Behind Content

```swift
// Typically placed behind other content as a background layer
let card = UIView()
let glassBackground = LiquidGlassBackgroundView(frame: .zero)

card.insertSubview(glassBackground, at: 0)
glassBackground.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    glassBackground.leadingAnchor.constraint(equalTo: card.leadingAnchor),
    glassBackground.trailingAnchor.constraint(equalTo: card.trailingAnchor),
    glassBackground.topAnchor.constraint(equalTo: card.topAnchor),
    glassBackground.bottomAnchor.constraint(equalTo: card.bottomAnchor)
])
```

## Composition

`LiquidGlassBackgroundView` is composed of three internally-managed layers:

| Layer | Type | Description |
| ----- | ---- | ----------- |
| Blur | `UIVisualEffectView` | Provides the frosted material background using a system blur effect |
| Gradient Border | `CAGradientLayer` + `CAShapeLayer` mask | Draws a soft, horizontally-animated gradient stroke around the rounded edge |

## Blur Behavior

| iOS Version | Blur Style | Blur View Alpha |
| ----------- | ---------- | ---------------- |
| iOS 13.0+ | `.systemUltraThinMaterial` | `0.5` |
| Earlier than iOS 13.0 | `.extraLight` | `0.3` |

The blur view is pinned to all four edges of `LiquidGlassBackgroundView` via Auto Layout and clips to a fixed `8pt` corner radius.

## Properties Reference

`LiquidGlassBackgroundView` does not currently expose any public/`@IBInspectable` configuration properties. All styling — blur style, blur alpha, corner radius (`8pt`), gradient colors, and border width (`2pt`) — is set internally in `setupBlurEffect()`, `setupUI()`, and `setupGradientStroke()`.

---

*For further customization, you can ask UX Engineer or inherit `LiquidGlassBackgroundView` and override its methods, or add additional functionality as required.*
