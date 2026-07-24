# InnerShadow

`InnerShadow` is an `@IBDesignable` container view that renders a configurable inner shadow around its edges, using an even-odd fill rule to mask a shadow layer to the shape of the view's rounded rect.

## Preview

| Feature / Variation | Preview |
| -------------------- | ------- |
| **Inner Shadow (Default)** | ![Inner Shadow](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1784874442/inner_shadow_lufkn5.png) |
| **Rounded Inner Shadow** | ![Rounded Inner Shadow](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1784874442/inner_shadow_circular_vhhhmf.png) |

## Basic Usage

### 1. Add to Layout

**Swift (Storyboard/XIB):**
```swift
// Add UIView from Interface Builder
// Set Custom Class to InnerShadow in Identity Inspector
```

**Swift (Programmatic):**
```swift
let innerShadowView = InnerShadow(frame: .zero)
view.addSubview(innerShadowView)
```

### 2. Configure in Code

```swift
// Configure the inner shadow
innerShadowView.cornerRadius = 12
innerShadowView.shadowColor = .black
innerShadowView.shadowOpacity = 0.15
innerShadowView.shadowRadius = 4
innerShadowView.shadowOffset = CGSize(width: 0, height: 2)
```

## Properties Reference

### General Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `cornerRadius` | `CGFloat` | `0` | Corner radius applied to both the view's clip mask and the inner shadow's rounded rect |

### Shadow Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `shadowColor` | `UIColor` | `EDTSColor.black` | Color of the inner shadow |
| `shadowOpacity` | `Float` | `0.1` | Opacity of the inner shadow |
| `shadowRadius` | `CGFloat` | `2` | Blur radius of the inner shadow |
| `shadowOffset` | `CGSize` | `.zero` | Offset of the inner shadow relative to the view's edge |

All shadow properties are `@IBInspectable`, so they can be configured directly from Interface Builder's Attributes Inspector, and each forwards its value to the internal `InnerShadow` subview on `didSet`.

---

*For further customization, you can ask UX Engineer or inherit `InnerShadow` and override its methods, or add additional functionality as required.*
