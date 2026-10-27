# EDTS_DS Animation

This document covers the collection of animation helpers used across `EDTS_DS` for adding motion and visual feedback to views. It covers three areas: gradient/neon border effects and pulsing glow effects on `UIView`, a reusable "floating away" animation via `AnimationHelper`, and scroll-triggered entrance animations (scale and fade) for `UICollectionView` cells.

## Table of Contents

- [UIView Extensions](#uiview-extensions)
  - [startAnimationGradientBorder / stopAnimationGradientBorder](#startanimationgradientborder--stopanimationgradientborder)
  - [startAnimationNeonPulse / stopAnimationNeonPulse](#startanimationneonpulse--stopanimationneonpulse)
  - [cardSelectedAnimation](#cardselectedanimation)
- [AnimationHelper](#animationhelper)
  - [animateFloating](#animatefloating)
- [Scroll Animations](#scroll-animations)
  - [animateScale](#animatescale)
  - [animateFade](#animatefade)

---

## Preview
| Feature / Variation | Preview |
| -------------------- | ------- |
| **Card Selected Animation** | ![Card Selected Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_200,c_scale,q_auto,f_auto/v1793094259/card_selected_animation_l8fpad.gif) |
| **Gradient Border** | ![Gradient Border](https://res.cloudinary.com/dacnnk5j4/image/upload/w_200,c_scale,q_auto,f_auto/v1784874442/gradient_border_n6tevb.gif) |
| **Neon Pulse** | ![Neon Pulse](https://res.cloudinary.com/dacnnk5j4/image/upload/w_200,c_scale,q_auto,f_auto/v1784874441/neon_pulse_b9fn46.gif) |
| **Floating Animation** | ![Floating Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_200,c_scale,q_auto,f_auto/v1784874441/floating_wf4itq.gif) |
| **Scroll Scale Animation** | ![Scroll Scale Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1784874441/scale_qafcic.gif) |
| **Scroll Fade Animation** | ![Scroll Fade Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1784874442/fade_mludfn.gif) |

---

## UIView Extensions

### startAnimationGradientBorder / stopAnimationGradientBorder

Adds an animated, rotating gradient border around a view by masking a `CAGradientLayer` with a `CAShapeLayer` stroke path, then continuously animating the gradient's `startPoint`/`endPoint` around the corners. `stopAnimationGradientBorder` smoothly fades the border back down to a single solid color before it disappears.

```swift
func startAnimationGradientBorder(
    width: CGFloat = 2,
    colors: [UIColor] = [EDTSColor.white, EDTSColor.blue30],
    duration: TimeInterval = 2.0
)

func stopAnimationGradientBorder(withDuration duration: TimeInterval = 0.5)
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `width` | `CGFloat` | `2` | Stroke width of the border |
| `colors` | `[UIColor]` | `[EDTSColor.white, EDTSColor.blue30]` | Gradient colors used for the border |
| `duration` | `TimeInterval` | `2.0` (start) / `0.5` (stop) | Duration of one full rotation loop (start) or the fade-out transition (stop) |

**Example:**
```swift
cardView.startAnimationGradientBorder(width: 3, colors: [EDTSColor.blue30, EDTSColor.white], duration: 1.5)

// Later, when the loading state ends
cardView.stopAnimationGradientBorder()
```

---

### startAnimationNeonPulse / stopAnimationNeonPulse

Creates a pulsing glow effect by animating the view's `CALayer` shadow radius and opacity back and forth indefinitely, simulating a neon light effect.

```swift
func startAnimationNeonPulse(
    color: CGColor = EDTSColor.blue30.cgColor,
    duration: TimeInterval = 1.0
)

func stopAnimationNeonPulse()
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `color` | `CGColor` | `EDTSColor.blue30.cgColor` | Shadow (glow) color |
| `duration` | `TimeInterval` | `1.0` | Duration of one pulse cycle (radius/opacity animate up then autoreverse back down) |

**Example:**
```swift
notificationDot.startAnimationNeonPulse(color: EDTSColor.errorStrong.cgColor, duration: 1.2)

// Stop pulsing, e.g. once the notification is read
notificationDot.stopAnimationNeonPulse()
```

---

### cardSelectedAnimation

Animates a card-style view between selected and unselected states: the border color transitions, and a colored corner triangle with an icon slides in from (or out to) the top-leading corner.

```swift
func cardSelectedAnimation(
    isSelected: Bool,
    tintColor: UIColor = EDTSColor.blue50,
    unselectedBorderColor: UIColor = EDTSColor.grey30,
    icon: UIImage? = UIImage(named: "ic_check"),
    iconTintColor: UIColor = EDTSColor.white,
    iconSize: CGFloat = 16,
    triangleSize: CGFloat = 32,
    durationAnimation: TimeInterval = 0.25,
    animated: Bool = true
)
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `isSelected` | `Bool` | — | `true` shows the selected state; `false` shows the unselected state |
| `tintColor` | `UIColor` | `EDTSColor.blue50` | Border color when selected, and fill color of the corner triangle |
| `unselectedBorderColor` | `UIColor` | `EDTSColor.grey30` | Border color when unselected |
| `icon` | `UIImage?` | `UIImage(named: "ic_check")` | Icon shown inside the triangle. If `nil` or not found, falls back to the `ic_check` asset in the EDTS_DS bundle. Always rendered as a template image |
| `iconTintColor` | `UIColor` | `EDTSColor.white` | Tint color of the icon |
| `iconSize` | `CGFloat` | `16` | Width and height of the icon |
| `triangleSize` | `CGFloat` | `32` | Width and height of the corner triangle |
| `durationAnimation` | `TimeInterval` | `0.25` | Duration (seconds) of the whole animation — the border color change and the triangle show/hide run in parallel and all use this value |
| `animated` | `Bool` | `true` | `false` applies the state immediately without animation |

**Example:**
```swift
// Select
cardView.cardSelectedAnimation(isSelected: true)

// Deselect
cardView.cardSelectedAnimation(isSelected: false)

// Custom colors and a slower 3-second animation
cardView.cardSelectedAnimation(
    isSelected: true,
    tintColor: EDTSColor.blue50,
    iconTintColor: .white,
    durationAnimation: 3
)
```

**Behavior notes:**
- Sets `layer.masksToBounds = true`, and sets `layer.borderWidth` to `1` if it is currently `0`
- The triangle is created lazily the first time the view is selected and reused afterwards (found through `accessibilityIdentifier` `"cardSelectedAnimation.triangle"`). It is pinned to the top-leading corner with Auto Layout and has user interaction disabled
- Calling with `isSelected: false` before the triangle has ever been created only updates the border and returns
- Selecting fades the triangle in (`curveEaseOut`) while sliding from `(-triangleSize, -triangleSize)` to its place; deselecting does the reverse (`curveEaseIn`) and hides the triangle on completion, but only if the border color is still `unselectedBorderColor` (so a re-selection during the animation is not hidden)
- `tintColor`, `icon`, and `iconTintColor` are re-applied on every call, but `triangleSize` and `iconSize` are only used when the triangle is first created — changing them on later calls has no effect on the existing triangle

---

## AnimationHelper

A small class wrapping a single composite "floating away" animation — commonly used for effects like a "+1" or reward icon drifting upward, scaling, and fading out before being dismissed.

```swift
public class AnimationHelper {
    public init()
    
    public func animateFloating(
        view: UIView,
        distance: CGFloat,
        duration: TimeInterval,
        onEnd: @escaping () -> Void
    )
}
```

### animateFloating

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| `view` | `UIView` | The view to animate |
| `distance` | `CGFloat` | Vertical distance (in points) the view floats upward, measured from its current `center.y` |
| `duration` | `TimeInterval` | Base duration used to derive the timing of all three concurrent animations |
| `onEnd` | `@escaping () -> Void` | Called once the animation sequence fully completes |

**Example:**
```swift
let helper = AnimationHelper()

helper.animateFloating(view: rewardBadge, distance: 80, duration: 1.0) {
    rewardBadge.removeFromSuperview()
}
```

---

## Scroll Animations

Free functions (not extensions) intended to be called from a `UIScrollViewDelegate`'s `scrollViewDidScroll` to animate `UICollectionView` cells into view as they first become visible. Both functions share module-level state (`lastContentOffset`, `visibleCellsBeforeScroll`) to track which cells have already been animated and the scroll direction.

### animateScale

```swift
public func animateScale(_ collectionView: UICollectionView, _ scrollView: UIScrollView)
```

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| `collectionView` | `UICollectionView` | The collection view whose visible cells should be animated |
| `scrollView` | `UIScrollView` | The scroll view being observed (typically the same instance as `collectionView`) |

**Example:**
```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    animateScale(myCollectionView, scrollView)
}
```

---

### animateFade

```swift
public func animateFade(_ collectionView: UICollectionView, _ scrollView: UIScrollView)
```

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| `collectionView` | `UICollectionView` | The collection view whose visible cells should be animated |
| `scrollView` | `UIScrollView` | The scroll view being observed (typically the same instance as `collectionView`) |

**Example:**
```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    animateFade(myCollectionView, scrollView)
}
```

---

*For further customization, you can ask UX Engineer or extend these methods, or add additional functionality as required.*
